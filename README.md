# code-skills

Austin W / CARROT 的 AI 编程技能库。**真相源只有一份**——本仓库的 `skills/`，用 Windows junction 链接到各 agent 的技能目录，一致性由文件系统保证，不靠人工同步。

设计依据见 [ADR 0004](docs/adr/0004-single-source-junction.md)。

## 快速开始

```powershell
git clone git@github.com:Fateorcloud/code-skills.git E:\Code_file\code-skills
cd E:\Code_file\code-skills
.\install.ps1 -Scope global     # 装进 ~/.claude/skills 与 ~/.codex/skills
.\install.ps1 -Check            # 验收
```

junction 对目录**免管理员权限**，不需要开发者模式。装完之后改 `skills/` 里任一文件，各 agent 立即生效（写穿），无需重启。

## 技能总表

<!-- BEGIN:SKILLS -->
> 本节由 `tools/gen-readme.ps1` 从 `registry.json` 生成，请勿手改。

共 **10** 个技能。作用域 `global` = 装进 `~/.claude/skills` 与 `~/.codex/skills`；`project` = 按需装进单个项目。

### `docs-spec` — 文档体系：术语表 + 决策记录 + 规范同步

| 技能 | 作用域 | 目标 | 说明 |
|------|--------|------|------|
| `/adr` | global | claude, codex | 记录一条架构决策。仅当决策"难逆 + 反直觉 + 真权衡"三条同时成立才值得记，默认 1-3 句话。用户做了重大技术/架构决策时使用。 |
| `/spec-check` | global | claude, codex | 体检文档体系，找出过时、缺失、矛盾的地方。当用户说"检查文档""文档健康度""审查 spec"时使用。只读不改，输出一份问题清单。 |
| `/spec-init` | global | claude, codex | 为新项目初始化文档骨架（CONTEXT.md + docs/adr/ + CLAUDE.md 或 AGENTS.md）。当用户说"初始化 spec""搭建文档体系""新项目开始"时使用。 |
| `/spec-sync` | global | claude, codex | 文档漂移后的兜底追平工具。首选是开发/拷问时内联更新（见 /grill-with-docs）；当你没内联、代码已先行、文档落后了，用本技能把文档追平。 |

### `thinking` — 方案压测：拷问、决策树推进

| 技能 | 作用域 | 目标 | 说明 |
|------|--------|------|------|
| `/grill-me` | global | claude, codex | 就一个计划或设计反复盘问用户，沿决策树逐个解决依赖，直到达成共识。用户想压测方案、想"被拷问"、说"grill me"时使用。 |
| `/grill-with-docs` | global | claude, codex | 一边拷问方案、一边对照项目既有领域模型与已记录的决策，磨锐术语，并在决策定型的当下内联更新文档（CONTEXT.md、ADR）。用户想用项目自己的语言和已记录决策来压测方案时使用。 |

### `continuity` — 跨进程对话记忆接力

| 技能 | 作用域 | 目标 | 说明 |
|------|--------|------|------|
| `/mem-load` | global | claude, codex | 新对话开工时，读取本项目 .agent-memory/ 里其它进程归档的对话记忆并接手。当用户说"新对话接手""继续上次""读取记忆""load 归档""换个进程继续做"时使用。 |
| `/mem-save` | global | claude, codex | 压缩/总结当前对话并归档进本项目 .agent-memory/，供其它进程的新对话接手。当用户说"压缩""总结存档""归档这段对话""要开新对话接力""token 太高了存一下"时使用。 |

### `vcs` — 版本控制与推送

| 技能 | 作用域 | 目标 | 说明 |
|------|--------|------|------|
| `/git-push` | global | claude, codex | Use this skill when preparing, verifying, or troubleshooting Git pushes to GitHub over SSH, especially for first-time repository push setup, global Git identity checks, SSH key creation or validation, GitHub SSH key binding, remote URL checks, commit readiness, and safe push commands. |

### `architecture` — 架构先行的项目脚手架

| 技能 | 作用域 | 目标 | 说明 |
|------|--------|------|------|
| `/project-architecture-first` | project | claude, codex | use this skill when acting as codex or a coding agent for medium or large software projects, rewrites, refactors, migrations, documentation-heavy builds, or ambiguous feature requests. triggers include requests to start a project, reorganize a repository, split modules, define interfaces, plan implementation, manage shared state, write project docs, or make multi-step code changes. enforce architecture-first planning before implementation: define modules, interfaces, state ownership, test checkpoints, and change reports so each step is reviewable, executable, reversible, and easy for ai agents to continue. |
<!-- END:SKILLS -->

## 技能放在哪一层

三层，判据明确，**别把项目专属的东西放进公共库**——它会在每个项目里占用模型的选择空间。

| 层 | 判据 | 落地 | 版本控制 |
|---|---|---|---|
| **全局** | 任何项目都可能用到 | registry `scope: global` → junction 进 `~/.claude/skills` + `~/.codex/skills` | 本仓库 |
| **项目·借用** | 跨项目可复用，但不想全局占选择空间 | registry `scope: project` → junction 进 `<项目>/.claude/skills/`，并由 `install.ps1` 在项目 `.gitignore` 维护托管块 | 本仓库 |
| **项目·土生** | 写死了该项目的路径、仓库名或领域术语，别处无意义 | 真实目录直接放 `<项目>/.claude/skills/`，随项目仓库一起提交 | 项目自己 |

**一句话判据：技能里出现了某项目专有的路径、仓库名或领域词 → 土生，不进本库。**

例：`ai-architect-lab-git-records` 写死 `D:\pbzhang\ai_api`、`scts-ai-rate-revision` 绑定特定期刊——都属土生，应活在各自项目里。

**晋升路径**：项目土生技能日后发现通用 → 移进本库 `skills/` → registry 加一行 → junction 回项目原位。项目侧用法不变，源已进库，其它项目立刻可借。

> Claude Code 原生支持目录作用域技能：项目 `.claude/skills/` 里的同名技能会被注册成 `<目录>:<技能名>`，并在改动该目录下文件时优先于全局同名技能。项目层不需要额外机制。

## 常用命令

```powershell
.\install.ps1 -Check                        # 体检：谁是 junction、谁还是拷贝、谁漂了
.\install.ps1 -Scope global                 # 全局装/重装
.\install.ps1 -Sync                         # git pull + 补新增 junction + 清死链
.\install.ps1 -Scope global -Only adr       # 只装某一个
.\install.ps1 -Scope project -Path E:\proj -Category docs-spec   # 给项目按分类装
.\install.ps1 -Scope global -Only adr -Uninstall                 # 摘掉（只删链接，源安全）
.\tools\gen-readme.ps1                      # 从 registry 重新生成上面的技能总表
.\tools\gen-readme.ps1 -Check               # 校验 README 是否已同步（CI 用）
```

## 加一个技能

1. `skills/<name>/SKILL.md`——frontmatter 必须有 `name` 和 `description`。
2. `description` 写「做什么 + 何时用（含字面触发词）」，与既有技能重叠时补一句何时**不**用、该用哪个。这是模型选对技能的唯一依据。
3. `registry.json` 加一条：`category` / `scope` / `targets`。
4. `.\install.ps1 -Scope global` + `.\tools\gen-readme.ps1`。

## 仓库结构

```
skills/            10 个技能，平铺（agent 的技能目录本身是平的，不认嵌套）
registry.json      清单：归类 / 作用域 / 分发目标
install.ps1        junction 分发器
tools/             README 生成器等
toolkit/           给人用的模板（技能已不依赖，见 toolkit/README.md）
docs/
  CONTEXT.md       本工具箱的领域术语
  adr/             架构决策（0004 取代 0003）
  spec-coding/     Spec Coding 那套的使用指南
  session-memory.md
```

## 已知边界

- junction 是 **Windows 专有**。上 macOS / Linux 需给 `install.ps1` 补 symlink 分支。
- git 把 junction 当**真实目录**（记为 `100644`，非 symlink 的 `120000`），所以项目侧安装必须 gitignore 借用来的技能，否则内容会被复制进项目仓库。`install.ps1` 自动维护这个块。
- 递归删除工具可能穿透 junction 删到源。本脚本删链接用 `Directory.Delete($p, $false)`，安全；但别用别的工具递归删 `~/.claude/skills/<name>`。
- **Cursor 未接入**——它有自己的 `.sync-manifest.json` 托管逻辑，硬链进去可能被清理。
- `toolkit/` 模板与各 `SKILL.md` 内联的格式要点是**两处**，改模板要记得同步技能。

---

内核致敬 [mattpocock/skills](https://github.com/mattpocock/skills)，本库做中文化 + 学习化封装。
