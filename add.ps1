<#
.SYNOPSIS
  加技能。一条命令，其余问你。

.EXAMPLE
  .\add.ps1                        # 全程问
  .\add.ps1 my-skill               # 自己新写一个
  .\add.ps1 D:\Downloads\cool      # 导入下载来的（是路径就自动识别）
#>
param([Parameter(Position=0)] [string] $NameOrPath)

$ErrorActionPreference = 'Stop'
$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

function Ask-Choice {
  param([string] $Question, [string[]] $Options, [int] $Default = 1)
  Write-Host "`n$Question" -ForegroundColor Cyan
  for ($i = 0; $i -lt $Options.Count; $i++) {
    $mark = if ($i + 1 -eq $Default) { ' (回车默认)' } else { '' }
    Write-Host ("  [{0}] {1}{2}" -f ($i + 1), $Options[$i], $mark)
  }
  $a = Read-Host "选"
  if ([string]::IsNullOrWhiteSpace($a)) { return $Default }
  $n = 0
  if (-not [int]::TryParse($a, [ref]$n) -or $n -lt 1 -or $n -gt $Options.Count) {
    throw "无效选择：$a"
  }
  return $n
}

if (-not $NameOrPath) {
  $NameOrPath = Read-Host "`n技能名（自己新写）或下载来的目录路径"
  if ([string]::IsNullOrWhiteSpace($NameOrPath)) { throw "没给名字或路径" }
}

# 是已存在的目录 -> 导入；否则 -> 新建
$isImport = Test-Path -PathType Container $NameOrPath
$skillName = if ($isImport) { Split-Path -Leaf $NameOrPath } else { $NameOrPath }
Write-Host ("`n{0}：{1}" -f $(if ($isImport) { '导入' } else { '新建' }), $skillName) -ForegroundColor Green

# 放哪一层
$layer = Ask-Choice -Question '放哪一层？' -Default 1 -Options @(
  '全局      —— 每个项目都可能用到',
  '项目专属  —— 写死了某项目的路径/仓库名/领域词，不进公共库',
  '项目借用  —— 通用，但只想装给个别项目'
)

if ($layer -eq 2) {
  $proj = Read-Host "`n项目根目录路径"
  if (-not (Test-Path $proj)) { throw "项目路径不存在：$proj" }
  $args = @{ Project = $proj }
  if ($isImport) { $args.Import = (Resolve-Path $NameOrPath).Path } else { $args.Name = $skillName }
  & (Join-Path $RepoRoot 'tools\add-skill.ps1') @args
  return
}

# 分类
$reg  = Get-Content (Join-Path $RepoRoot 'registry.json') -Raw -Encoding utf8 | ConvertFrom-Json
$cats = @($reg.categories.PSObject.Properties)
$labels = $cats | ForEach-Object { "{0,-14} {1}" -f $_.Name, $_.Value }
$ci = Ask-Choice -Question '归哪个分类？' -Options $labels -Default 1
$category = $cats[$ci - 1].Name

$params = @{ Category = $category; Scope = $(if ($layer -eq 3) { 'project' } else { 'global' }) }
if ($isImport) {
  $params.Import = (Resolve-Path $NameOrPath).Path
  $src = Read-Host "`n来源（GitHub 地址或说明，回车跳过——但以后就查不到它哪来的了）"
  if (-not [string]::IsNullOrWhiteSpace($src)) { $params.Source = $src }
} else {
  $params.Name = $skillName
}

& (Join-Path $RepoRoot 'tools\add-skill.ps1') @params
