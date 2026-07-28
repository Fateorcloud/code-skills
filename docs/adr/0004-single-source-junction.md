# 收归单库单源，用 junction 分发到各 agent

**Status:** accepted（取代 [0003](0003-two-repo-sync.md)）

`code-skills` 成为技能的唯一真相源：`skills/` 平铺全部技能，`registry.json` 声明归类与分发目标，`install.ps1` 用 Windows junction 链接到 `~/.claude/skills`、`~/.codex/skills` 及各项目 `.claude/skills/`。副本从 4 份降到 1 份，一致性由文件系统保证而非人工纪律。

## 为什么推翻 0003

0003 立两库的理由是「本地 `AI_Spec` 带开发态杂物，不宜直接当公开发布物」。2026-07-28 实测：

- **杂物不存在** —— `AI_Spec` 与 `code-skills/Spec-skill/` 6 技能 + 4 文档逐字一致，没有任何多余文件。前提不成立。
- **真相源没有版本控制** —— `AI_Spec` 不是 git 仓库，无历史、无远端、无备份。把真相源放在这里本身就是风险。
- **漏防的那条线才是漏的** —— 两库同步（0003 防的）守住了；但 `AI_Spec` 内部还有第二份 `.agents/skills/`，0003 未提及，`spec-check`、`spec-init` 已与 `.claude/skills/` 分叉。人工 `cp` 只能守住你想着的那条线。

## Considered Options

- **保留两库 + export 脚本**（0003 里记的策略 B）—— 否决：仍需维护同步脚本，且 junction 得从镜像出，多一跳。
- **反转，`AI_Spec` 为源** —— 否决：真相源仍在无历史的本地目录，GitHub 上的库不再是实际使用的那份。
- **合并到 `code-skills`**（采纳）—— 真相源自动获得 git 历史与 GitHub 远端；junction 直接从真相源出，编辑入口与源码入口合一。

## Consequences

- `AI_Spec` 退役为归档备份，不再是真相源；`.agents/skills/` 的 Codex 适配意图改为**把单份技能写成 agent 中立**（`CLAUDE.md / AGENTS.md` 并列），而不是维护两份。
- 0003 说的「看到两份别去修正成单份」**已失效**，看到两份就是 bug。
- junction 是 Windows 专有；未来上 macOS/Linux 需给 `install.ps1` 补 symlink 分支。
- 项目层不必自造：Claude Code 原生支持目录作用域技能（`Spec-skill:adr` 形态），junction 进项目 `.claude/skills/` 即可被识别。
- git 把 junction 当真实目录（实测记为 `100644` 而非 symlink 的 `120000`），**项目仓库必须 gitignore 借用来的技能**，否则内容会被复制进项目仓库。
