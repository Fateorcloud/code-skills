<#
.SYNOPSIS
  加技能的唯一入口：新建 / 导入下载的 / 建项目专属。自动处理 registry、安装、README。

.EXAMPLE
  # 自己新写一个全局技能（生成骨架）
  .\tools\add-skill.ps1 -Name my-skill -Category vcs

  # 导入下载来的技能（从任意路径搬进库）
  .\tools\add-skill.ps1 -Import D:\Downloads\cool-skill -Category thinking

  # 项目专属（土生，不进公共库，直接在项目里建）
  .\tools\add-skill.ps1 -Name deploy-thing -Project E:\Code_file\my-proj
#>
[CmdletBinding(DefaultParameterSetName = 'New')]
param(
  [Parameter(ParameterSetName='New',      Mandatory)] [string] $Name,
  [Parameter(ParameterSetName='Import',   Mandatory)] [string] $Import,
  [string] $Category,
  [ValidateSet('global','project')] [string] $Scope = 'global',
  [string[]] $Targets = @('claude','codex'),
  [string] $Project
)

$ErrorActionPreference = 'Stop'
$RepoRoot     = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$SkillsRoot   = Join-Path $RepoRoot 'skills'
$RegistryPath = Join-Path $RepoRoot 'registry.json'

function Read-Frontmatter {
  param([string] $SkillMd)
  $lines = Get-Content $SkillMd -Encoding utf8
  if ($lines[0].Trim() -ne '---') { throw "$SkillMd 开头不是 YAML frontmatter (---)" }
  $fm = @{}
  for ($i = 1; $i -lt $lines.Count; $i++) {
    if ($lines[$i].Trim() -eq '---') { break }
    if ($lines[$i] -match '^(\w+):\s*(.*)$') { $fm[$Matches[1]] = $Matches[2].Trim() }
  }
  return $fm
}

function Save-Registry {
  param($Obj)
  $json = $Obj | ConvertTo-Json -Depth 8
  # PS 5.1 的 ConvertTo-Json 会把中文转成 \uXXXX，转回来
  $json = [regex]::Replace($json, '\\u([0-9a-fA-F]{4})', {
    param($m) [char][int]('0x' + $m.Groups[1].Value)
  })
  [System.IO.File]::WriteAllText($RegistryPath, $json, [System.Text.UTF8Encoding]::new($false))
}

# ─────────────── 项目专属（土生）：不进公共库 ───────────────
if ($Project) {
  if (-not (Test-Path $Project)) { throw "项目路径不存在：$Project" }
  $skillName = if ($Import) { Split-Path -Leaf $Import } else { $Name }
  $dest = Join-Path $Project ".claude\skills\$skillName"
  if (Test-Path $dest) { throw "已存在：$dest" }
  New-Item -ItemType Directory -Force -Path (Split-Path -Parent $dest) | Out-Null

  if ($Import) {
    Copy-Item -Recurse $Import $dest
  } else {
    New-Item -ItemType Directory -Force -Path $dest | Out-Null
    $tpl = @"
---
name: $skillName
description: <做什么> + 当用户说"<触发词1>""<触发词2>"时使用。<与哪个技能易混则写明何时不用它>
---

# $skillName

## 步骤

### 1.

## 原则
-
"@
    [System.IO.File]::WriteAllText((Join-Path $dest 'SKILL.md'), $tpl, [System.Text.UTF8Encoding]::new($false))
  }

  Write-Host "`n项目专属技能已建：$dest" -ForegroundColor Green
  Write-Host "土生技能不进公共库，随项目仓库一起提交即可。" -ForegroundColor DarkGray
  Write-Host "日后发现它通用了 -> 移进 code-skills\skills\ 再跑本脚本的 -Import 晋升。`n" -ForegroundColor DarkGray
  return
}

# ─────────────── 进公共库：新建 或 导入 ───────────────
$skillName = if ($Import) { Split-Path -Leaf $Import } else { $Name }
$dest = Join-Path $SkillsRoot $skillName
if (Test-Path $dest) { throw "技能已存在：$dest" }

if ($Import) {
  if (-not (Test-Path $Import)) { throw "导入源不存在：$Import" }
  if (-not (Test-Path (Join-Path $Import 'SKILL.md'))) { throw "导入源里没有 SKILL.md：$Import" }
  Copy-Item -Recurse $Import $dest
  Write-Host "已导入 -> skills\$skillName" -ForegroundColor Green
} else {
  New-Item -ItemType Directory -Force -Path $dest | Out-Null
  $tpl = @"
---
name: $skillName
description: <做什么> + 当用户说"<触发词1>""<触发词2>"时使用。<与哪个技能易混则写明何时不用它、该用哪个>
---

# $skillName

## 步骤

### 1.

## 原则
-
"@
  [System.IO.File]::WriteAllText((Join-Path $dest 'SKILL.md'), $tpl, [System.Text.UTF8Encoding]::new($false))
  Write-Host "已生成骨架 -> skills\$skillName\SKILL.md" -ForegroundColor Green
}

# 校验 frontmatter
$fm = Read-Frontmatter (Join-Path $dest 'SKILL.md')
if (-not $fm.name)        { Write-Warning "SKILL.md 缺 name" }
elseif ($fm.name -ne $skillName) { Write-Warning "frontmatter name '$($fm.name)' 与目录名 '$skillName' 不一致——agent 以目录名为准，建议改成一致" }
if (-not $fm.description) { Write-Warning "SKILL.md 缺 description——模型将无法判断何时用它" }

# 写 registry
$reg = Get-Content $RegistryPath -Raw -Encoding utf8 | ConvertFrom-Json
if (-not $Category) {
  $cats = $reg.categories.PSObject.Properties.Name
  Write-Host "`n可选分类：$($cats -join ', ')" -ForegroundColor Cyan
  throw "请用 -Category 指定分类（新分类需先在 registry.json 的 categories 里加一条）"
}
if (-not $reg.categories.PSObject.Properties.Name.Contains($Category)) {
  throw "分类 '$Category' 不存在。现有：$($reg.categories.PSObject.Properties.Name -join ', ')"
}

$entry = [ordered]@{ category = $Category; scope = $Scope; targets = $Targets }
$reg.skills | Add-Member -NotePropertyName $skillName -NotePropertyValue ([pscustomobject]$entry) -Force
Save-Registry $reg
Write-Host "registry.json 已加条目：$skillName ($Category / $Scope / $($Targets -join ','))" -ForegroundColor Green

# 安装 + 刷 README
if ($Scope -eq 'global') {
  & (Join-Path $RepoRoot 'install.ps1') -Scope global -Only $skillName | Out-Null
  Write-Host "已 junction 到各 agent 目录" -ForegroundColor Green
} else {
  Write-Host "scope=project：需要时用 install.ps1 -Scope project -Path <项目> -Only $skillName 装" -ForegroundColor DarkGray
}
& (Join-Path $RepoRoot 'tools\gen-readme.ps1') | Out-Null
Write-Host "README 技能总表已刷新" -ForegroundColor Green

Write-Host "`n下一步：编辑 skills\$skillName\SKILL.md，把 description 写准（做什么 + 何时用 + 何时不用）。" -ForegroundColor Cyan
Write-Host "改完直接生效，不用重装。`n" -ForegroundColor DarkGray
