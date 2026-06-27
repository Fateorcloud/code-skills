# 工具箱用「开发源 + 发布镜像」两库，手动同步

**Status:** accepted

工具箱有两个仓库：开发源 `AI_Spec`（本地）和发布镜像 `code-skills/Spec-skill/`（公开）。共享文件（`CLAUDE`/`AGENTS`/`CONTEXT`/`使用方案`/`.claude/skills`/`toolkit`/`docs/adr`）以 `AI_Spec` 为真相源，改完 `cp` 到 clone 再 push 保持逐字一致；**唯一有意分叉的是 `README.md`**——本地是"指向发布版"的指针，公开是面向 clone 用户的实战门面。

## Considered Options

- **单仓库** —— 否决：本地 `AI_Spec` 仍带开发态杂物，不宜直接当公开发布物。
- **export 脚本自动同步**（策略 B）—— 更好但更重，暂缓；手动 `cp` 够用。
- **手动 cp 同步**（采纳）—— 简单；代价是改完两边要记得同步。

## Consequences

- 看到两份 `CLAUDE`/`AGENTS`/`CONTEXT` **别去"修正"成单份**——是有意的镜像，不是 bug。
- `README.md` 两边不同**是有意的**，别强行抹平。
- 漂移风险靠这条约定 +「改完即 `cp`」兜底；真嫌烦就上 export 脚本。
