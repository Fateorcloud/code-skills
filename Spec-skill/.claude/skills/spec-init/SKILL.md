---
name: spec-init
description: 为新项目初始化文档骨架（CONTEXT.md + docs/adr/ + CLAUDE.md）。当用户说"初始化 spec""搭建文档体系""新项目开始"时使用。
---

# spec-init — 项目文档骨架初始化

为**新项目**搭起可运行的最小骨架。内核沿用 [mattpocock/skills](https://github.com/mattpocock/skills) 的 `CONTEXT.md + docs/adr/` 结构。

## 步骤

### 1. 先提问（最多 5 个，一次问完；用户已给的别重复问）

1. 一句话，这个项目做什么？
2. 核心**领域名词**有哪些？（电商：商品/订单/购物车）
3. 技术栈？不知道就让我推荐。
4. 有**安全敏感**模块吗？（认证/支付/隐私）
5. 团队：个人 / 小团队 / 多人？

### 2. 生成文件（懒创建——只建有内容可写的）

**`CONTEXT.md`** — 按 `toolkit/CONTEXT.template.md` 格式：
- `# 上下文名` + 一两句说明
- `## Language`：每个术语 `**词**:` + 定义（定义"是什么"不是"做什么"，1-2 句）+ `_Avoid_:` 同义词
- **要有主见**：多个词选最佳的，其余进 `_Avoid_`
- **只放项目特有术语**，通用编程概念（超时、错误类型）不收
- `## Relationships`：术语间关系

**`CLAUDE.md`** — 参考 `toolkit/CLAUDE.template.md`：文档体系 + 何时读哪个 + 何时用哪个技能。

**`docs/adr/0001-tech-stack.md`** — **仅当**技术选型满足"难逆 + 反直觉 + 真权衡"才建；格式见 `toolkit/ADR.template.md`（默认 1-3 句，四位数编号）。否则先不建。

### 3. 报告 + 指下一步

告诉用户建了什么；下一步：用 `/grill-with-docs` 边想方案边内联沉淀术语和决策；普通功能让 AI 读 `CONTEXT.md`，复杂/敏感模块再写 `docs/modules/XXX.md`。

## 原则
- 精简起步，3 个文件足矣，别一上来写满模块文档。
- 安全敏感模块先提示、暂不写详细文档。
- 文件已存在则更新，不覆盖用户内容。
