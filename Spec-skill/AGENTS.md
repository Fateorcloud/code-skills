# AGENTS.md — 通用 AI 协作入口

> **本文件面向各类 AI 编码工具**（OpenAI Codex、Cursor、Cline、Gemini CLI 等）。
> 协作总纲的**真相源是 [CLAUDE.md](CLAUDE.md)**（Claude Code 的原生入口）。二者同源：
> Claude Code 自动读 `CLAUDE.md`，其它 agent 读本文件。**更新规范时请同步两者**（或用脚本生成，见文末）。
>
> ⚠️ 各工具的入口约定与命令语法迭代很快，本文涉及的具体机制**以官方最新文档为准**。

---

## 这是什么项目

一套演示 **Spec Coding（规范驱动开发）** 的 AI 协作文档体系：用结构化文档（领域术语表 + 架构决策 + 模块规范）让 AI 高效理解并执行开发任务。内核致敬 [mattpocock/skills](https://github.com/mattpocock/skills)，做中文学习化封装。

## 第一步：请先读这两份

1. **[CLAUDE.md](CLAUDE.md)** —— 完整的文档导航（P0/P1/P2）、AI 协作规范、冲突解决规则。**这是本仓库的协作总纲，务必通读。**
2. **[CONTEXT.md](CONTEXT.md)** —— 本项目领域术语字典（有主见的术语表，每词带 `_Avoid_` 用词取舍）。动手前先对齐术语。

> 读 CLAUDE.md 时你会看到 `.claude/skills/` 和 `/技能名` 之类写法——那是 Claude Code 专有的触发机制。在你（非 Claude Code 工具）这里如何使用，见下一节。

## 技能：跨工具如何使用

本项目的 6 个「技能」原生绑定 Claude Code（用户输入 `/技能名` 触发、按描述自动路由）。**其它工具没有等价的自动触发**，但技能正文是纯提示词，你可以把对应的 `SKILL.md` 当作工作流提示词**手动套用**：

| 技能 | 作用 | 源文件（当提示词读） |
|------|------|---------------------|
| spec-init | 新项目生成 CLAUDE.md / CONTEXT.md / 首个 ADR | `.claude/skills/spec-init/SKILL.md` |
| grill-me | 就方案反复拷问、不写文档 | `.claude/skills/grill-me/SKILL.md` |
| grill-with-docs | 拷问 + 内联更新 CONTEXT.md / ADR（首选） | `.claude/skills/grill-with-docs/SKILL.md` |
| adr | 记一条架构决策（难逆+反直觉+真权衡才记） | `.claude/skills/adr/SKILL.md` |
| spec-sync | 文档漂移后兜底追平 | `.claude/skills/spec-sync/SKILL.md` |
| spec-check | 只读体检文档体系 | `.claude/skills/spec-check/SKILL.md` |

**用法示例**（在 Codex / Cursor 等里直接说）：

> “请阅读 `.claude/skills/grill-with-docs/SKILL.md`，按其中的流程拷问我这个方案，并在术语定型时内联更新 `CONTEXT.md`。”

**想做成各工具的原生命令**（可选，语法以官方最新为准）：

- **Codex** —— 把技能正文存为 `~/.codex/prompts/<名>.md`，用 `/<名>` 触发；项目入口读 `AGENTS.md`（即本文件）。
- **Cursor** —— 转成 `.cursor/rules/<名>.mdc`（Project Rule）。
- **Gemini CLI** —— 转成 `.gemini/commands/<名>.toml`；项目入口读 `GEMINI.md`。

## 文档地图（完整表见 [CLAUDE.md](CLAUDE.md)）

| 位置 | 内容 |
|------|------|
| `CONTEXT.md` | 领域术语字典（必读） |
| `使用方案.md` | 工具清单 + 使用指南（日常一页够用） |
| `docs/ARCHITECTURE.md` | 系统架构与技术栈 |
| `docs/DEVELOPMENT_GUIDE.md` | 开发规范、工作流、代码风格 |
| `docs/PROJECT_STATUS.md` | 当前进度、待办、已知问题（每日更新） |
| `docs/adr/` | 架构决策记录（为什么这么做） |
| `docs/modules/` | 复杂/敏感模块的详细规范（按需，如 `AUTH.md`） |

**冲突解决**：优先级高的文档优先（P0 > P1 > P2）；更新时间新的优先；CLAUDE.md 标注的权威文档优先。

## 协作流程（通用）

1. 读本文件 → 读 `CLAUDE.md` + `CONTEXT.md`，对齐术语与规范。
2. 按任务类型定位对应 P0/P1 文档，严格遵循。
3. 复杂/安全敏感模块（认证/支付/隐私）：若有 `docs/modules/XXX.md` 则**严格按其实现**；否则按 `CONTEXT.md` 术语灵活实现。
4. 做了「难逆 + 反直觉 + 真权衡」的决策 → 在 `docs/adr/` 记一条（极简 1-3 句）。
5. 完成后更新 `docs/PROJECT_STATUS.md`。

## 开发规范速查（权威见 [CLAUDE.md](CLAUDE.md) / [DEVELOPMENT_GUIDE.md](docs/DEVELOPMENT_GUIDE.md)）

- **语言**：Python 3.11+；格式化 Black + isort；类型检查 `mypy --strict`。
- **Git**：主分支 `main`（受保护）；功能分支 `feature/{模块}-{功能}`；提交格式 `type(scope): description`。
- **测试**：`pytest tests/`；单测覆盖率 ≥ 80%；新功能必须有测试。

## 双入口如何不漂移

本文件与 `CLAUDE.md` 在导航/规范上有重叠。为避免**文档漂移**（本项目核心关注点，见 `CONTEXT.md` 的「漂移」词条）：

- **真相源**：协作总纲以 `CLAUDE.md` 为准；本文件只做「通用入口 + 跨工具翻译」，尽量**指向而非复制**。
- 若要把技能/文档批量分发成各工具格式，扩展 `toolkit/spec-init.sh` 加一个 export 步骤（**单一真相源 + 适配导出**）。
- 改了规范，记得两边同步；可定期用 `/spec-check` 的思路体检一致性。

---

**最后更新：** 2026-06-25 · 与 [CLAUDE.md](CLAUDE.md) 同源
