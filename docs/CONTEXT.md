# AI Spec Coding 体系

演示"领域语言 + 决策记录"协作开发的项目。内核致敬 [mattpocock/skills](https://github.com/mattpocock/skills)，做中文学习化封装。

## Language

**Spec Coding**:
先写结构化文档规范、再让 AI 据此理解与执行的开发方式。
_Avoid_: 文档驱动开发, 规范编程

**技能 (Skill)**:
`.claude/skills/` 下的可执行指令，用户输入 `/名称` 触发。
_Avoid_: 命令, 插件, 脚本

**CONTEXT.md**:
领域术语表（glossary）。只放项目特有术语与用词取舍，绝不放实现细节。
_Avoid_: 规范文档, 说明书, spec

**ADR**:
架构决策记录。仅当"难逆 + 反直觉 + 真权衡"三条同时成立才记，默认 1-3 句。
_Avoid_: 设计文档, 会议纪要

**模块文档**:
`docs/modules/XXX.md`，仅为复杂或安全敏感模块编写的详细规范。
_Avoid_: 用 "spec" 泛指

**漂移 (Drift)**:
文档与代码不一致的状态。首选内联更新避免、`/spec-check` 检测、`/spec-sync` 兜底追平。
_Avoid_: 过时, 脱节

## Relationships

- 一个项目一个根 **CONTEXT.md**；多上下文时用 `CONTEXT-MAP.md` 指向各自的 CONTEXT.md。
- **ADR** 记"为什么"，**CONTEXT.md** 记"叫什么"，**模块文档** 记"怎么做"。
- `/grill-with-docs` 在拷问中**内联**更新 **CONTEXT.md** 与 **ADR**；`/spec-sync` 仅作事后兜底。
