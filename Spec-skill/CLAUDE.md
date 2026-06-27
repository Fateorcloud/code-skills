# AI Spec Coding 工具箱（开发源）

这是 **Spec Coding（规范驱动开发）工具箱**的开发仓库：一套让 AI 通过结构化文档（术语表 + 决策记录 + 模块规范）高效理解并执行开发任务的「技能 + 模板 + 文档约定」。

> 已发布到 GitHub [`Fateorcloud/code-skills`](https://github.com/Fateorcloud/code-skills) 的 `Spec-skill/` 子目录，供任意项目取用。
> **非 Claude Code 工具**（Codex / Cursor / Gemini CLI 等）请从 [`AGENTS.md`](AGENTS.md) 进入。

## 📚 导航（就这几样）

| 位置 | 内容 |
|------|------|
| [`使用方案.md`](使用方案.md) | **日常看这一页就够**：6 技能 + 何时用哪个 + 五条铁律 |
| [`CONTEXT.md`](CONTEXT.md) | 本工具箱的领域术语字典 |
| `.claude/skills/` | 6 个技能：`/spec-init` `/grill-me` `/grill-with-docs` `/adr` `/spec-sync` `/spec-check` |
| `toolkit/` | 4 个模板 + `spec-init.sh` 一键脚手架 |
| `docs/adr/` | 这套体系自身的架构决策（`0001`、`0002`） |

## 🤖 在本仓库协作的规矩

1. **先读** `使用方案.md` + `CONTEXT.md`，对齐用词。
2. **改技能 / 模板**直接编辑 `.claude/skills/` 或 `toolkit/`。
3. **做了难逆 + 反直觉 + 真权衡的决策** → `/adr` 记一条（默认 1-3 句）。
4. **改文档当场内联更新**，别攒着；漂移了用 `/spec-check` 体检、`/spec-sync` 追平。
5. 本仓库是**文档 + 技能**，无代码、无构建、无测试——别套用通用语言的工程规范。

## 内核来源

技能 / 术语表 / ADR 三铁律的内核**致敬 [mattpocock/skills](https://github.com/mattpocock/skills)**，本项目做中文化 + 学习化封装（见 [`docs/adr/0001`](docs/adr/0001-hybrid-doc-approach.md)）。

---

**最后更新：** 2026-06-27 · 维护者：Austin W / CARROT
