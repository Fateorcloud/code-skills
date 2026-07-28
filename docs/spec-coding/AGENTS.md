# AGENTS.md — 通用 AI 协作入口

> **本文件面向各类 AI 编码工具**（OpenAI Codex、Cursor、Cline、Gemini CLI 等）。
> 协作总纲的**真相源是 [CLAUDE.md](CLAUDE.md)**（Claude Code 的原生入口）。二者同源：
> Claude Code 自动读 `CLAUDE.md`，其它 agent 读本文件。**更新规范时请同步两者。**
>
> ⚠️ 各工具的入口约定与命令语法迭代很快，本文涉及的具体机制**以官方最新文档为准**。

---

## 这是什么

**Spec Coding（规范驱动开发）工具箱**：用结构化文档（术语表 + 决策记录 + 模块规范）让 AI 高效理解并执行开发任务。内核致敬 [mattpocock/skills](https://github.com/mattpocock/skills)，做中文学习化封装。

## 第一步：请先读这两份

1. **[CLAUDE.md](CLAUDE.md)** —— 导航 + 在本仓库协作的规矩。
2. **[CONTEXT.md](CONTEXT.md)** —— 领域术语字典（有主见，每词带 `_Avoid_`）。动手前先对齐术语。

> 读 CLAUDE.md 时你会看到 `.claude/skills/` 和 `/技能名`——那是 Claude Code 专有的触发机制。在你（非 Claude Code 工具）这里如何用，见下一节。

## 技能：跨工具如何使用

6 个「技能」原生绑定 Claude Code（`/技能名` 触发、按描述自动路由）。**其它工具没有等价的自动触发**，但技能正文是纯提示词，把对应的 `SKILL.md` 当工作流提示词**手动套用**即可：

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

- **Codex** —— 技能正文存为 `~/.codex/prompts/<名>.md`，用 `/<名>` 触发；项目入口读 `AGENTS.md`（即本文件）。
- **Cursor** —— 转成 `.cursor/rules/<名>.mdc`（Project Rule）。
- **Gemini CLI** —— 转成 `.gemini/commands/<名>.toml`；项目入口读 `GEMINI.md`。

## 文档地图

| 位置 | 内容 |
|------|------|
| `使用方案.md` | 工具清单 + 何时用哪个（日常一页够用） |
| `CONTEXT.md` | 领域术语字典（必读） |
| `toolkit/` | 4 个模板 + `spec-init.sh` 脚手架 |
| `docs/adr/` | 架构决策记录（为什么这么做） |

## 协作流程（通用）

1. 读本文件 → 读 `CLAUDE.md` + `CONTEXT.md`，对齐术语与规矩。
2. 改技能 / 模板直接编辑 `.claude/skills/` 或 `toolkit/`。
3. 复杂/安全敏感模块（认证/支付/隐私）：写 `docs/modules/XXX.md` 让 AI 严格实现；否则按 `CONTEXT.md` 术语灵活实现。
4. 做了「难逆 + 反直觉 + 真权衡」的决策 → 在 `docs/adr/` 记一条（极简 1-3 句）。

## 双入口如何不漂移

本文件与 `CLAUDE.md` 在导航上有重叠。为避免**文档漂移**（本工具箱核心关注点，见 `CONTEXT.md` 的「漂移」词条）：

- **真相源**：以 `CLAUDE.md` 为准；本文件只做「通用入口 + 跨工具翻译」，尽量**指向而非复制**。
- 改了规范两边同步；可定期用 `/spec-check` 的思路体检一致性。

---

**最后更新：** 2026-06-27 · 与 [CLAUDE.md](CLAUDE.md) 同源
