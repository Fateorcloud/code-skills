# code-skills

AI 编程技能库。**真相源只有一份**——本仓库的 `skills/`，用 Windows junction 链接到各 agent 的技能目录，一致性由文件系统保证，不靠人工同步。

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

共 **17** 个技能。作用域 `global` = 装进 `~/.claude/skills` 与 `~/.codex/skills`；`project` = 按需装进单个项目。

### `spec-docs` — 文档体系：术语表 + 决策记录 + 规范同步

| 技能 | 作用域 | 目标 | 说明 |
|------|--------|------|------|
| `/adr` | global | claude, codex | 记录一条架构决策。仅当决策"难逆 + 反直觉 + 真权衡"三条同时成立才值得记，默认 1-3 句话。用户做了重大技术/架构决策时使用。 |
| `/spec-check` | global | claude, codex | 体检文档体系，找出过时、缺失、矛盾的地方。当用户说"检查文档""文档健康度""审查 spec"时使用。只读不改，输出一份问题清单。 |
| `/spec-init` | global | claude, codex | 为新项目初始化**轻量**文档骨架（CONTEXT.md 术语表 + docs/adr/ 决策记录 + CLAUDE.md 或 AGENTS.md）。当用户说"初始化 spec""搭建文档体系""新项目开始"时使用。若要的是冻结模块/接口/状态归属那套重架构文档，用 /project-architecture-first。 |
| `/spec-sync` | global | claude, codex | 文档漂移后的兜底追平工具。首选是开发/拷问时内联更新（见 /grill-with-docs）；当你没内联、代码已先行、文档落后了，用本技能把文档追平。 |

### `thinking` — 想清楚：拷问方案、原型验证

| 技能 | 作用域 | 目标 | 说明 |
|------|--------|------|------|
| `/grill-me` | global | claude, codex | 就一个计划或设计反复盘问用户，沿决策树逐个解决依赖，直到达成共识。用户想压测方案、想"被拷问"、说"grill me"时使用。 |
| `/grill-with-docs` | global | claude, codex | 一边拷问方案、一边对照项目既有领域模型与已记录的决策，磨锐术语，并在决策定型的当下内联更新文档（CONTEXT.md、ADR）。用户想用项目自己的语言和已记录决策来压测方案时使用。 |
| `/prototype` | global | claude, codex | 做一个用完就扔的原型来回答某个设计问题——状态模型/业务逻辑用可运行的终端程序验，界面则做几版差异明显的 UI 切换着看。当用户想验证数据模型或状态机是否顺手、想先看看界面长什么样、说"做个原型""让我玩玩""试几个方案"时使用。 |

### `coding` — 写码方法论

| 技能 | 作用域 | 目标 | 说明 |
|------|--------|------|------|
| `/tdd` | global | claude, codex | 测试驱动开发：红-绿-重构循环，一次交付一个垂直切片。当用户想测试先行地做功能或修 bug、提到"TDD""红绿重构""先写测试"、或要集成测试时使用。 |

### `architecture` — 架构设计与重构

| 技能 | 作用域 | 目标 | 说明 |
|------|--------|------|------|
| `/codebase-design` | global | claude, codex | 设计深模块的共同词汇：小接口、干净接缝、能透过接口测试。当用户要设计或改进模块接口、找加深机会、决定接缝画在哪、让代码更可测更易被 AI 导航，或别的技能需要"深模块"这套术语时使用。只提供设计词汇与判据；要扫描整个代码库出改进报告用 /improve-codebase-architecture。 |
| `/improve-codebase-architecture` | global | claude, codex | 扫描代码库找"加深模块"的机会，出一份可视化 HTML 报告，然后就你挑中的那条逐一拷问。当用户想改进架构、找重构机会、合并耦合过紧的模块、让代码更可测更易被 AI 导航时使用。这是针对**既有**代码库的改进；动手前先冻结架构用 /project-architecture-first，只要设计词汇用 /codebase-design。 |
| `/project-architecture-first` | project | claude, codex | 动手写代码前先冻结架构：定义模块边界、接口契约、状态归属、测试检查点与变更报告，让每一步可审查、可执行、可回滚，也便于 AI 接力。当用户要启动中大型项目、做重写/重构/迁移、重组仓库、拆分模块、定义接口、规划实施步骤、管理共享状态，或提出含糊的大需求时使用。产出的是**架构冻结文档**（PROJECT_ARCHITECTURE / MODULES / INTERFACES / STATE_MODEL / TEST_PLAN）；若只想建术语表和决策记录那套轻量骨架，用 /spec-init。 |

### `vcs` — 版本控制与仓库工程化

| 技能 | 作用域 | 目标 | 说明 |
|------|--------|------|------|
| `/git-guardrails-claude-code` | global | claude, codex | 给 Claude Code 装 hook，在危险 git 命令（push、reset --hard、clean、branch -D 等）执行前就拦下来。当用户想防止破坏性 git 操作、加 git 安全钩子、拦截 git push/reset 时使用。 |
| `/git-push` | global | claude, codex | 通过 SSH 向 GitHub 推送时的准备、验证与排障。当用户要首次推送仓库、检查 git 全局身份、生成或校验 SSH 密钥、在 GitHub 绑定公钥、确认 remote 是否为 SSH、或说"推上去""push 一下""推不上去""认证失败"时使用。 |
| `/setup-pre-commit` | global | claude, codex | 在当前仓库配置 Husky pre-commit 钩子：lint-staged（Prettier）+ 类型检查 + 测试。当用户想加 pre-commit 钩子、装 Husky、配 lint-staged、或想在提交时自动跑格式化/类型检查/测试时使用。面向 JS/TS 仓库。 |

### `continuity` — 跨会话记忆接力

| 技能 | 作用域 | 目标 | 说明 |
|------|--------|------|------|
| `/mem-load` | global | claude, codex | 新对话开工时，读取本项目 .agent-memory/ 里其它进程归档的对话记忆并接手。当用户说"新对话接手""继续上次""读取记忆""load 归档""换个进程继续做"时使用。 |
| `/mem-save` | global | claude, codex | 压缩/总结当前对话并归档进本项目 .agent-memory/，供其它进程的新对话接手。当用户说"压缩""总结存档""归档这段对话""要开新对话接力""token 太高了存一下"时使用。 |

### `writing` — 文字打磨

| 技能 | 作用域 | 目标 | 说明 |
|------|--------|------|------|
| `/avoid-ai-writing` | global | claude, codex | 审查并改写文稿，去掉 AI 腔（"AI-isms"）。当用户说"去掉 AI 味""这段太像 AI 写的""润色一下别那么机械""检查一下 AI 痕迹""让它读起来像人写的"时使用。支持只检测不改、就地改文件、指定语气（随意/正式/技术/亲切/直白），以及反复迭代到收敛。 |
<!-- END:SKILLS -->

## 技能放在哪一层

三层，判据明确，**别把项目专属的东西放进公共库**——它会在每个项目里占用模型的选择空间。

| 层 | 判据 | 落地 | 版本控制 |
|---|---|---|---|
| **全局** | 任何项目都可能用到 | registry `scope: global` → junction 进 `~/.claude/skills` + `~/.codex/skills` | 本仓库 |
| **项目·借用** | 跨项目可复用，但不想全局占选择空间 | registry `scope: project` → junction 进 `<项目>/.claude/skills/`，并由 `install.ps1` 在项目 `.gitignore` 维护托管块 | 本仓库 |
| **项目·土生** | 写死了该项目的路径、仓库名或领域术语，别处无意义 | 真实目录直接放 `<项目>/.claude/skills/`，随项目仓库一起提交 | 项目自己 |

**一句话判据：技能里出现了某项目专有的路径、仓库名或领域词 → 土生，不进本库。**

例：`ai-architect-lab-git-records` 写死 `D:\pbzhang\ai_api`（已下沉）、`volans-notes-*` 绑定 Volans 站点的 `/architecture/`、`/deployment/` 路径（已下沉）——都属土生，活在各自项目里。

**晋升路径**：项目土生技能日后发现通用 → 移进本库 `skills/` → registry 加一行 → junction 回项目原位。项目侧用法不变，源已进库，其它项目立刻可借。

> Claude Code 原生支持目录作用域技能：项目 `.claude/skills/` 里的同名技能会被注册成 `<目录>:<技能名>`，并在改动该目录下文件时优先于全局同名技能。项目层不需要额外机制。

## 常用命令

```powershell
.\install.ps1 -Check                        # 体检：谁是 junction、谁还是拷贝、谁漂了
.\install.ps1 -Scope global                 # 全局装/重装
.\install.ps1 -Sync                         # git pull + 补新增 junction + 清死链
.\install.ps1 -Scope global -Only adr       # 只装某一个
.\install.ps1 -Scope project -Path E:\proj -Category spec-docs    # 给项目按分类装
.\install.ps1 -Scope global -Only adr -Uninstall                 # 摘掉（只删链接，源安全）
.\tools\gen-readme.ps1                      # 从 registry 重新生成上面的技能总表
.\tools\gen-readme.ps1 -Check               # 校验 README 是否已同步（CI 用）
```

## 加一个技能

**记一条命令就够：**

```powershell
.\add.ps1
```

它会问你两三个问题（叫什么 / 放哪一层 / 归哪类），然后自动建目录、写 `registry.json`、junction 到各 agent、刷新上面的技能总表。**你不需要手改任何配置文件。**

想省一步就把名字或路径直接跟上：

```powershell
.\add.ps1 my-skill            # 自己新写一个
.\add.ps1 D:\Downloads\cool   # 下载来的（是路径就自动识别为导入）
```

之后**只剩一件事**：把 `SKILL.md` 的 `description` 写准。它是模型选对技能的唯一依据：

> 做什么 + 何时用（含用户会说的字面触发词）+ 与哪个技能易混就写明何时**不**用、该用哪个

改完直接生效，不用重装（junction 写穿）。

> 导入时会问来源，填了就记进 `registry.json` 的 `source`。跳过也行，但以后你就查不到它哪来的了——这正是历史遗留技能说不清出处的原因。

<details>
<summary>脚本化用法（不想被问，直接给全参数）</summary>

```powershell
.\tools\add-skill.ps1 -Name my-skill -Category vcs
.\tools\add-skill.ps1 -Import D:\Downloads\cool -Category thinking -Source https://github.com/x/y
.\tools\add-skill.ps1 -Name deploy-thing -Project E:\Code_file\my-proj
```
</details>

## 仓库结构

```
skills/            17 个技能，平铺（agent 的技能目录本身是平的，不认嵌套）
registry.json      清单：归类 / 作用域 / 分发目标 / 来源
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
- **Cursor 有意不接入**——它用 `~/.cursor/skills-cursor` 并自带 `.sync-manifest.json` 托管同步，硬链进去可能被它的托管逻辑清理。Cursor 侧的技能由它自己管，不纳入本库。
- `toolkit/` 模板与各 `SKILL.md` 内联的格式要点是**两处**，改模板要记得同步技能。

## 第三方来源与许可

本库部分技能来自开源项目，均保留原作者署名。`registry.json` 的 `source` 字段逐条记录出处、上游 commit 与本地改动范围。

| 上游 | 许可 | 本库技能 | 本地改动 |
|---|---|---|---|
| [mattpocock/skills](https://github.com/mattpocock/skills) | MIT | `tdd` `prototype` `codebase-design` `improve-codebase-architecture` `git-guardrails-claude-code` `setup-pre-commit` | **仅 `description` 中文化，正文原样**，便于日后与上游 diff / merge |
| 同上 | MIT | `grill-me` `grill-with-docs` | 中文改写（含正文）|
| [conorbronsdon/avoid-ai-writing](https://github.com/conorbronsdon/avoid-ai-writing) | MIT | `avoid-ai-writing` | 仅 `description` 中文化 |

**同步上游**：`git clone --depth 1 https://github.com/mattpocock/skills`，把对应目录覆盖到 `skills/<name>/`，再重写一遍 `description`。正文保持英文正是为了让这一步只有一行冲突。

已知本地偏离：`tdd/refactoring.md` 是上游已删除但本地保留的重构清单；`improve-codebase-architecture` 移除了上游的 `disable-model-invocation: true`。

---

内核致敬 [mattpocock/skills](https://github.com/mattpocock/skills)，本库做中文化 + 学习化封装。
