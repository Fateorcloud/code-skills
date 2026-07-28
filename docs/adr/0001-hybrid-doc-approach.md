# 采用 mattpocock/skills 的文档内核，做中文学习化封装

**Status:** accepted

需要一套 AI 协作文档体系。我们直接采用 mattpocock/skills 已验证的结构——`CONTEXT.md` 作有主见的术语表、`docs/adr/` 记决策、grill 系列技能驱动——而非另起炉灶；在其上做中文化、学习化（决策树、一页指南）与生命周期补全（`spec-init` 脚手架、`spec-check` 漂移审计）。

## Considered Options

- **从零自创一套** —— 否决：重复造轮子，且大概率不如他成熟。
- **纯翻译照搬整个 repo** —— 否决：他的是英文个人工具箱（含 `personal/`、`in-progress/`），默认读者是专家，不服务中文学习者。
- **吸收内核 + 微调封装**（采纳）—— 兼得成熟内核与目标受众贴合。

## Consequences

- 我们**不声称"比他更优"**，只声称"服务他没服务的中文学习场景"。诚实定位是这条决策的前提。
- 必须配 `/grill-with-docs`（内联更新）+ `/spec-check`（审计）防漂移，否则封装会退化成半旧文档。
- 重叠技能须持续对齐他的上游更新，避免分叉劣化。
