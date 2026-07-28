<#
.SYNOPSIS
  code-skills 分发器：用 Windows junction 把 skills/ 链接到各 agent 的技能目录。

.DESCRIPTION
  真相源只有一份：本仓库的 skills/<name>/。
  junction 免管理员权限，且写穿——从任一入口编辑都直接改到源文件。

.EXAMPLE
  .\install.ps1 -Check
  .\install.ps1 -Scope global
  .\install.ps1 -Scope global -Only adr
  .\install.ps1 -Scope project -Path E:\Code_file\my-proj -Category docs-spec
  .\install.ps1 -Sync
#>
[CmdletBinding()]
param(
  [ValidateSet('global','project')] [string] $Scope = 'global',
  [string]   $Path,
  [string]   $Category,
  [string[]] $Only,
  [switch]   $Check,
  [switch]   $Sync,
  [switch]   $Uninstall
)

$ErrorActionPreference = 'Stop'
$RepoRoot    = Split-Path -Parent $MyInvocation.MyCommand.Path
$SkillsRoot  = Join-Path $RepoRoot 'skills'
$RegistryPath = Join-Path $RepoRoot 'registry.json'

if (-not (Test-Path $RegistryPath)) { throw "找不到 registry.json：$RegistryPath" }
$Registry = Get-Content $RegistryPath -Raw -Encoding utf8 | ConvertFrom-Json

$AgentDirs = @{
  claude = Join-Path $env:USERPROFILE '.claude\skills'
  codex  = Join-Path $env:USERPROFILE '.codex\skills'
}

function Get-SelectedSkills {
  param([string] $ForScope)
  $names = $Registry.skills.PSObject.Properties.Name
  $out = @()
  foreach ($n in $names) {
    $meta = $Registry.skills.$n
    if ($Only     -and ($Only -notcontains $n))          { continue }
    if ($Category -and ($meta.category -ne $Category))   { continue }
    if ($ForScope -and ($meta.scope    -ne $ForScope))   { continue }
    $out += [pscustomobject]@{ Name = $n; Meta = $meta }
  }
  return $out
}

function Test-IsJunction {
  param([string] $P)
  if (-not (Test-Path $P)) { return $false }
  $item = Get-Item $P -Force
  return ($item.LinkType -eq 'Junction')
}

function Install-One {
  param([string] $Name, [string] $DestRoot)
  $src  = Join-Path $SkillsRoot $Name
  $dest = Join-Path $DestRoot   $Name
  if (-not (Test-Path $src)) { Write-Warning "  跳过 $Name：源不存在 $src"; return $false }
  New-Item -ItemType Directory -Force -Path $DestRoot | Out-Null

  if (Test-Path $dest) {
    if (Test-IsJunction $dest) {
      # 已是 junction，删链接本身（不递归，避免穿透删源）
      [System.IO.Directory]::Delete($dest, $false)
    } else {
      # 备份必须落在 skills 目录之外，否则 agent 会把 .bak 目录当成一个技能注册
      $bkRoot = Join-Path (Split-Path -Parent $DestRoot) 'skills-replaced'
      New-Item -ItemType Directory -Force -Path $bkRoot | Out-Null
      $bk = Join-Path $bkRoot "$Name-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
      Move-Item $dest $bk
      Write-Host "  原真实目录已移出 -> $bk" -ForegroundColor DarkYellow
    }
  }
  New-Item -ItemType Junction -Path $dest -Target $src | Out-Null
  Write-Host "  + $Name" -ForegroundColor Green
  return $true
}

function Remove-One {
  param([string] $Name, [string] $DestRoot)
  $dest = Join-Path $DestRoot $Name
  if (-not (Test-Path $dest)) { return $false }
  if (Test-IsJunction $dest) {
    [System.IO.Directory]::Delete($dest, $false)   # 只删链接，源安全
    Write-Host "  - $Name" -ForegroundColor DarkGray
    return $true
  }
  Write-Warning "  $Name 是真实目录而非 junction，未删除（请手动确认）"
  return $false
}

function Update-GitignoreBlock {
  param([string] $ProjectPath, [string[]] $SkillNames)
  $gi    = Join-Path $ProjectPath '.gitignore'
  $begin = '# >>> code-skills managed (auto) >>>'
  $end   = '# <<< code-skills managed (auto) <<<'
  $lines = if (Test-Path $gi) { @(Get-Content $gi -Encoding utf8) } else { @() }

  $b = [Array]::IndexOf($lines, $begin)
  $e = [Array]::IndexOf($lines, $end)
  if ($b -ge 0 -and $e -gt $b) {
    $lines = @($lines[0..($b-1)]) + @($lines[($e+1)..($lines.Count-1)])
    $lines = $lines | Where-Object { $_ -ne $null }
  }
  if ($SkillNames.Count -gt 0) {
    $block = @($begin) + ($SkillNames | ForEach-Object { "/.claude/skills/$_/" }) + @($end)
    $lines = @($lines) + $block
  }
  Set-Content -Path $gi -Value $lines -Encoding utf8
  Write-Host "  .gitignore 托管块已更新（$($SkillNames.Count) 条）" -ForegroundColor DarkCyan
}

# ───────────────────────── -Check ─────────────────────────
if ($Check) {
  Write-Host "`n=== code-skills 体检 ===`n" -ForegroundColor Cyan
  $declared = $Registry.skills.PSObject.Properties.Name
  $onDisk   = (Get-ChildItem $SkillsRoot -Directory -EA SilentlyContinue).Name

  $missing = $declared | Where-Object { $onDisk -notcontains $_ }
  $orphan  = $onDisk   | Where-Object { $declared -notcontains $_ }
  if ($missing) { Write-Host "registry 声明但 skills/ 里没有：$($missing -join ', ')" -ForegroundColor Red }
  if ($orphan)  { Write-Host "skills/ 里有但 registry 未声明：$($orphan -join ', ')" -ForegroundColor Yellow }
  if (-not $missing -and -not $orphan) { Write-Host "registry 与 skills/ 一致（$($declared.Count) 个）" -ForegroundColor Green }

  foreach ($agent in $AgentDirs.Keys) {
    $dir = $AgentDirs[$agent]
    Write-Host "`n[$agent] $dir" -ForegroundColor Cyan
    if (-not (Test-Path $dir)) { Write-Host "  目录不存在"; continue }
    foreach ($d in Get-ChildItem $dir -Directory -EA SilentlyContinue) {
      $isOurs = $declared -contains $d.Name
      if (Test-IsJunction $d.FullName) {
        $tgt = (Get-Item $d.FullName -Force).Target
        $ok  = $tgt -and ($tgt -join '') -like "*$($d.Name)*"
        Write-Host ("  {0,-32} junction -> {1}" -f $d.Name, ($tgt -join '')) -ForegroundColor $(if($ok){'Green'}else{'Red'})
      }
      elseif ($isOurs) {
        $src = Join-Path $SkillsRoot "$($d.Name)\SKILL.md"
        $dst = Join-Path $d.FullName 'SKILL.md'
        $same = (Test-Path $src) -and (Test-Path $dst) -and
                ((Get-Content $src -Raw -Encoding utf8) -replace "`r","") -eq ((Get-Content $dst -Raw -Encoding utf8) -replace "`r","")
        $tag = if ($same) { '真实目录（内容一致，可换 junction）' } else { '真实目录（内容已漂移！）' }
        Write-Host ("  {0,-32} {1}" -f $d.Name, $tag) -ForegroundColor $(if($same){'Yellow'}else{'Red'})
      }
      else {
        Write-Host ("  {0,-32} 非本库管理" -f $d.Name) -ForegroundColor DarkGray
      }
    }
  }
  Write-Host ""
  return
}

# ───────────────────────── -Sync ─────────────────────────
if ($Sync) {
  Write-Host "`n=== git pull ===" -ForegroundColor Cyan
  Push-Location $RepoRoot
  try { git pull --ff-only } finally { Pop-Location }
  $Scope = 'global'
}

# ─────────────────────── install / uninstall ───────────────────────
if ($Scope -eq 'project') {
  if (-not $Path) { throw "-Scope project 必须同时给 -Path <项目根目录>" }
  if (-not (Test-Path $Path)) { throw "项目路径不存在：$Path" }
  $destRoot = Join-Path $Path '.claude\skills'
  $sel = Get-SelectedSkills -ForScope $null      # 项目层不按 scope 过滤，按 -Only/-Category 挑
  Write-Host "`n=== 项目安装 -> $destRoot ===" -ForegroundColor Cyan
  $done = @()
  foreach ($s in $sel) {
    if ($Uninstall) { if (Remove-One $s.Name $destRoot) { } }
    else            { if (Install-One $s.Name $destRoot) { $done += $s.Name } }
  }
  Update-GitignoreBlock -ProjectPath $Path -SkillNames $done
  Write-Host ""
  return
}

Write-Host "`n=== 全局安装 ===" -ForegroundColor Cyan
$sel = Get-SelectedSkills -ForScope 'global'
foreach ($agent in $AgentDirs.Keys) {
  $targetSkills = $sel | Where-Object { $_.Meta.targets -contains $agent }
  if (-not $targetSkills) { continue }
  Write-Host "`n[$agent] $($AgentDirs[$agent])" -ForegroundColor Cyan
  foreach ($s in $targetSkills) {
    if ($Uninstall) { Remove-One  $s.Name $AgentDirs[$agent] | Out-Null }
    else            { Install-One $s.Name $AgentDirs[$agent] | Out-Null }
  }
}
Write-Host "`n完成。用 .\install.ps1 -Check 验收。`n" -ForegroundColor Cyan
