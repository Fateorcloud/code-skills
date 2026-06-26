# AI Spec Coding 完整体系

**版本：** v1.0 混合方案  
**最后更新：** 2026-06-15

---

## 🎯 这是什么？

一套结合 **mattpocock/skills** 和 **Spec Coding** 优势的 AI 协作开发体系。

**核心理念：**
- 用精简的术语定义（CONTEXT.md）实现快速开发
- 用详细的模块规范（modules/）保证关键功能质量
- 用架构决策记录（ADR）沉淀技术决策

---

## 📚 文档导航

### 🚀 快速开始（新项目）

| 文档 | 用途 | 优先级 |
|------|------|--------|
| [NEW_PROJECT_GUIDE.md](./NEW_PROJECT_GUIDE.md) | **新项目 5 分钟启动指南** | ⭐⭐⭐⭐⭐ |
| [STARTUP_TEMPLATE.md](./STARTUP_TEMPLATE.md) | 三个核心文件的模板 | ⭐⭐⭐⭐⭐ |
| [QUICK_REFERENCE.md](./QUICK_REFERENCE.md) | 日常开发速查卡 | ⭐⭐⭐⭐ |

### 📖 深入理解

| 文档 | 用途 |
|------|------|
| [HYBRID_APPROACH.md](./HYBRID_APPROACH.md) | 混合方案详解 |
| [HOW_TO_USE.md](./docs/HOW_TO_USE.md) | Spec Coding 完整实战指南 |

### 📦 示例模板

| 文档 | 说明 |
|------|------|
| [CLAUDE.md](./CLAUDE.md) | AI 入口文档示例 |
| [DEVELOPMENT_GUIDE.md](./docs/DEVELOPMENT_GUIDE.md) | 开发规范模板 |
| [ARCHITECTURE.md](./docs/ARCHITECTURE.md) | 架构文档模板 |
| [modules/AUTH.md](./docs/modules/AUTH.md) | 模块规范示例 |

---

## ⚡ 3 步开始使用

### 1. 创建文件结构

```bash
cd your-project
touch CLAUDE.md CONTEXT.md
mkdir -p docs/adr docs/modules
```

### 2. 复制模板

从 [STARTUP_TEMPLATE.md](./STARTUP_TEMPLATE.md) 复制三个模板文件。

### 3. 让 AI 初始化

```
"我要开始一个新项目：[描述]

请使用 /grill-me 理解需求，然后生成：
1. CONTEXT.md（领域术语）
2. CLAUDE.md（AI 入口文档）
3. docs/adr/001-initial-setup.md（技术选型）

参考 STARTUP_TEMPLATE.md 的格式。"
```

---

## 🎯 核心文件说明

### 必须文件（3 个）

```
CLAUDE.md      - 告诉 AI 如何理解项目
CONTEXT.md     - 定义领域术语
docs/adr/      - 记录架构决策
```

### 可选文件（按需添加）

```
docs/modules/  - 复杂模块的详细规范
```

---

## 💡 使用场景

### 快速开发（用 CONTEXT.md）

```
"使用 CONTEXT.md 的术语，实现用户列表 API"
```

### 严格规范（用模块文档）

```
"严格按照 docs/modules/AUTH.md 实现登录功能"
```

### 增量更新（用技能）

```
"使用 /grill-with-docs 来理解这个功能并更新 CONTEXT.md"
```

---

## 🏆 混合方案优势

| 场景 | 方法 | 优势 |
|------|------|------|
| 项目启动 | mattpocock 风格 | 灵活、快速 |
| 快速迭代 | CONTEXT.md | 术语统一 |
| 复杂模块 | Spec Coding | 严格规范 |
| 架构决策 | ADR | 知识沉淀 |

---

## 📖 推荐阅读顺序

1. ✅ [NEW_PROJECT_GUIDE.md](./NEW_PROJECT_GUIDE.md) - 了解如何启动
2. ✅ [QUICK_REFERENCE.md](./QUICK_REFERENCE.md) - 日常开发速查
3. ✅ [HYBRID_APPROACH.md](./HYBRID_APPROACH.md) - 理解混合方案
4. 📚 [HOW_TO_USE.md](./docs/HOW_TO_USE.md) - 深入学习 Spec Coding

---

## 🆘 常见问题

**Q: 和 mattpocock/skills 有什么区别？**  
A: 我们结合了两者：用他的精简风格做日常开发，用详细 spec 保证关键模块质量。

**Q: 必须创建所有模块文档吗？**  
A: 不需要！只对复杂/敏感模块创建详细文档，简单功能只用 CONTEXT.md。

**Q: 如何维护文档？**  
A: 使用 /grill-with-docs 自动更新 CONTEXT.md，代码变更时同步更新模块文档。

---

## 🚀 立即开始

```bash
# 进入你的项目
cd your-project

# 创建文件
touch CLAUDE.md CONTEXT.md
mkdir -p docs/adr docs/modules

# 然后向 AI 发送 NEW_PROJECT_GUIDE.md 中的初始化指令
```

**祝开发愉快！** 🎉
