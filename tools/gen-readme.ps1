<#
.SYNOPSIS
  从 registry.json + 各 SKILL.md 的 description 生成 README 的技能总表。

.DESCRIPTION
  README 里 <!-- BEGIN:SKILLS --> ... <!-- END:SKILLS --> 之间的内容由本脚本托管，
  手改会被覆盖。加技能只改 registry.json，跑一次本脚本即可追平。

.EXAMPLE
  .\tools\gen-readme.ps1          # 重新生成
  .\tools\gen-readme.ps1 -Check   # 只校验是否已同步（CI 用，不一致则退出码 1）
#>
[CmdletBinding()]
param([switch] $Check)

$ErrorActionPreference = 'Stop'
$RepoRoot   = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$Registry   = Get-Content (Join-Path $RepoRoot 'registry.json') -Raw -Encoding utf8 | ConvertFrom-Json
$ReadmePath = Join-Path $RepoRoot 'README.md'
$SkillsRoot = Join-Path $RepoRoot 'skills'

function Get-Description {
  param([string] $Name)
  $f = Join-Path $SkillsRoot "$Name\SKILL.md"
  if (-not (Test-Path $f)) { return '(SKILL.md 缺失)' }
  $lines = Get-Content $f -Encoding utf8
  $desc = $null
  for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match '^description:\s*(.*)$') {
      $desc = $Matches[1].Trim()
      # 支持 YAML 折叠标量（description: >- 换行续写）
      if ($desc -in @('>-', '>', '|', '|-', '')) {
        $buf = @()
        for ($j = $i + 1; $j -lt $lines.Count; $j++) {
          if ($lines[$j] -match '^\S' -or $lines[$j] -match '^---') { break }
          $buf += $lines[$j].Trim()
        }
        $desc = ($buf -join ' ').Trim()
      }
      break
    }
  }
  if (-not $desc) { return '(无 description)' }
  return ($desc -replace '\|', '\|')
}

$sb = [System.Text.StringBuilder]::new()
$all = @($Registry.skills.PSObject.Properties)
$skillCount = ($all | Measure-Object).Count
$catCount   = ($Registry.categories.PSObject.Properties | Measure-Object).Count
[void]$sb.AppendLine("> 本节由 ``tools/gen-readme.ps1`` 从 ``registry.json`` 生成，请勿手改。")
[void]$sb.AppendLine()
[void]$sb.AppendLine("共 **$skillCount** 个技能。作用域 ``global`` = 装进 ``~/.claude/skills`` 与 ``~/.codex/skills``；``project`` = 按需装进单个项目。")
[void]$sb.AppendLine()

foreach ($catProp in $Registry.categories.PSObject.Properties) {
  $cat  = $catProp.Name
  $mine = $all | Where-Object { $_.Value.category -eq $cat }
  if (-not $mine) { continue }
  [void]$sb.AppendLine("### ``$cat`` — $($catProp.Value)")
  [void]$sb.AppendLine()
  [void]$sb.AppendLine('| 技能 | 作用域 | 目标 | 说明 |')
  [void]$sb.AppendLine('|------|--------|------|------|')
  foreach ($p in ($mine | Sort-Object Name)) {
    $m = $p.Value
    [void]$sb.AppendLine("| ``/$($p.Name)`` | $($m.scope) | $($m.targets -join ', ') | $(Get-Description $p.Name) |")
  }
  [void]$sb.AppendLine()
}

$generated = $sb.ToString().TrimEnd()
$begin = '<!-- BEGIN:SKILLS -->'
$end   = '<!-- END:SKILLS -->'

$readme = Get-Content $ReadmePath -Raw -Encoding utf8
$bi = $readme.IndexOf($begin)
$ei = $readme.IndexOf($end)
if ($bi -lt 0 -or $ei -lt 0) { throw "README.md 里找不到 $begin / $end 标记块" }

$before = $readme.Substring(0, $bi + $begin.Length)
$after  = $readme.Substring($ei)
$new    = "$before`n$generated`n$after"

if ($Check) {
  if (($readme -replace "`r","") -eq ($new -replace "`r","")) {
    Write-Host "README 与 registry 一致。" -ForegroundColor Green
    exit 0
  }
  Write-Host "README 与 registry 不一致——请跑 .\tools\gen-readme.ps1 重新生成。" -ForegroundColor Red
  exit 1
}

[System.IO.File]::WriteAllText($ReadmePath, $new, [System.Text.UTF8Encoding]::new($false))
Write-Host "README 技能总表已更新（$skillCount 个技能，$catCount 个分类）。" -ForegroundColor Green
