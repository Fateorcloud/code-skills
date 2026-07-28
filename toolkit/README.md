# toolkit/ — 给人用的模板，不给技能读

这里的模板是**你起新项目时手工复制**用的，技能不再引用它们。

## 为什么

技能装到 `~/.claude/skills/<name>/` 之后，`toolkit/xxx.template.md` 这种相对路径既指不到技能自己的目录，也指不到你正在干活的项目——两边都不保证存在。模型读不到就会自己即兴发挥格式，模板等于白写。

所以（见 [ADR 0004](../docs/adr/0004-single-source-junction.md) 之后的整理）：**格式要点已内联进各 `SKILL.md`**，技能不依赖外部文件也能产出正确格式；`toolkit/` 只保留给人。

## 内容

| 文件 | 用途 |
|---|---|
| `CONTEXT.template.md` | 术语表模板，含格式规则注释 |
| `CLAUDE.template.md` | 项目 AI 协作指南模板（Codex/Cursor 存成 `AGENTS.md`）|
| `ADR.template.md` | 架构决策模板，含"何时才值得建 ADR"三条 |
| `MODULE.template.md` | 复杂/敏感模块的详细规范模板 |
| `spec-init.sh` | 一键脚手架：把目录 + 模板拷进当前项目 |

## 改这里要注意

模板和 `SKILL.md` 里内联的格式要点现在是**两处**。改了模板的格式规则，记得同步对应技能里的内联描述——`spec-init`、`spec-sync`、`grill-with-docs` 三个涉及 `CONTEXT.md` 格式。
