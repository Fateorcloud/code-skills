# AGENTS.md 用「薄入口指向 CLAUDE.md」，不复制全文

**Status:** accepted

为让非 Claude Code 工具（Codex / Cursor / Gemini CLI 等）也能用这套文档体系，新增根目录 `AGENTS.md` 作为通用入口。它**只做引导 + 跨工具翻译，指向 `CLAUDE.md` 这个协作总纲真相源**，而非复制 CLAUDE.md 全文——复制会立刻制造两份规范、埋下文档漂移（本项目最核心要防的东西）。

## Considered Options

- **复制 CLAUDE.md 全文进 AGENTS.md** —— 否决：agent 不必跳转，但两份规范必然漂移，违背项目立身之本。
- **薄入口 + 跨工具翻译层**（采纳）—— 真相源唯一；代价是 agent 要多读一跳 `CLAUDE.md`。

## Consequences

- 未来新增工具入口（如 `GEMINI.md`）一律沿用「薄入口」模式，不复制。
- `AGENTS.md` 与 `CLAUDE.md` 仍有少量重叠（简版速查），改规范时两边对一眼；要规模化就上 export 脚本（单一真相源 + 适配导出）。
