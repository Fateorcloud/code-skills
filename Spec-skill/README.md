# Spec-skill — 让 AI 像「懂行的老员工」进你的项目

> 一套 **Spec Coding(规范驱动开发)** 工具箱:用结构化文档(术语表 + 决策记录 + 模块规范)让 AI 高效理解并执行开发任务。
> **6 个技能 + 4 模板 + 通用入口**,任意项目、任意 AI 工具(Claude Code / Codex / Cursor)开箱即用。
> 内核致敬 [mattpocock/skills](https://github.com/mattpocock/skills),做中文学习化封装。

---

## 30 秒看懂:箱子里只有三类东西

| 类别 | 是什么 | 在哪 | 角色 |
|------|--------|------|------|
| **① 文档** | AI 读的「外脑」(产物) | `CONTEXT.md`、`docs/adr/`、`docs/modules/` | 让 AI 不用问就懂项目 |
| **② 技能** | 你和 AI 协作的固定套路 | `.claude/skills/`(6 个) | 驱动你产出/维护①号文档 |
| **③ 模板** | ① 的空白起点 | `toolkit/`(4 模板 + `spec-init.sh`) | 新项目 5 分钟起步 |

> 黄金三分法:`CONTEXT.md` 记 **「叫什么」**、`docs/adr/` 记 **「为什么」**、`docs/modules/` 记 **「怎么做」**。

---

## 一、装进你自己的项目

```bash
# 1. 拿到工具箱
gh repo clone Fateorcloud/code-skills

# 2. 在你的项目根目录执行（SRC 按实际路径改）
SRC=../code-skills/Spec-skill
cp -r "$SRC/.claude/skills"  .claude/   # 6 个技能（Claude Code 用）
cp -r "$SRC/toolkit"         .          # 模板 + 脚手架
cp    "$SRC/AGENTS.md"       .          # 通用入口（Codex/Cursor 等用）
```

全新项目想一键起步:`bash toolkit/spec-init.sh`(把目录+模板+技能拷进当前项目)。

---

## 二、三个工具怎么用(核心)

**记住一句话就通了:**

> 技能 = 一个写好套路的 `SKILL.md`。**Claude Code 能 `/技能名` 直接召唤;Codex / Cursor 不认这个召唤,但都会读文件——所以你让它「读那个 SKILL.md,照着做」。** 效果一样,只多说半句话。

| 工具 | 怎么召唤一个技能 |
|------|----------------|
| **Claude Code** | 直接打 `/grill-with-docs` |
| **Cursor** | 「读 `.claude/skills/grill-with-docs/SKILL.md`,按它的流程拷问我」 |
| **Codex** | 同上那句(Codex 会自动先读 `AGENTS.md` 懂项目规矩) |

> 想在 Codex/Cursor 里也做成 `/` 原生命令?把技能正文转成 `~/.codex/prompts/<名>.md` 或 `.cursor/rules/<名>.mdc` 即可。

---

## 三、日常就转这一个圈

```
新项目 ─▶ spec-init(搭骨架)
              │
现有项目 ─▶ spec-check(体检) ─▶ spec-sync(追平)
              │
              ▼
        ┌──────────────────────────────┐
        │ grill-with-docs 拷问+沉淀术语  │ ◀── 日常主循环
        │   ↓ 按 CONTEXT.md 术语写代码   │
        │   ↓ 难逆决策? ────────→ adr    │
        │   ↓ 复杂/敏感模块? → 写 module │
        └──────────────────────────────┘
```

### 6 个技能速查

| 阶段 | 技能 | 干什么 |
|------|------|--------|
| 开局 | `spec-init` | 生成 CLAUDE.md / CONTEXT.md / 首个 ADR |
| 想透 | `grill-me` | 纯拷问方案,**不写文档** |
| 想透+沉淀 | `grill-with-docs` ⭐ | 边拷问边内联更新 CONTEXT.md / ADR(**首选**) |
| 沉淀 | `adr` | 记一条难逆决策(三铁律才记) |
| 维护 | `spec-check` | 只读体检,找过时/矛盾/死链 |
| 维护 | `spec-sync` | 文档漂移后兜底追平 |

---

## 四、5 分钟实战:`grill-with-docs` 长什么样

> **你**:`/grill-with-docs` 我想做个记账 App。
>
> **AI**:**第 1 问**——你说的「账户」指登录身份,还是资金来源(银行卡/支付宝)?我推荐后者命名 `Wallet`,前者留给 `User`。认吗?
>
> **你**:认,但我习惯叫「钱包」。
>
> **AI**:(术语定型 → **当场写 `CONTEXT.md`**)
> ```md
> ## Wallet（钱包）
> 一个资金来源：银行卡 / 支付宝 / 现金，余额随交易增减。
> _Avoid_: 账户（与登录账号 User 混淆）
> ```
> **第 2 问**——金额怎么存?我推荐用整数「分」,不用浮点(`0.1+0.2≠0.3`,钱会算不准)。⚠️ 这条 **难逆 + 反直觉 + 真权衡**,该记 ADR,落一条吗?
>
> **你**:落。
>
> **AI**:(**当场建 `docs/adr/0001-money-as-cents.md`**,1-3 句写完)

**你一行文档没手写**——技能逼你想清楚,文档是它顺手内联写的。这就是它和「手写一大堆 spec」的本质区别。

---

## 五、五条铁律(全部吸收自 mattpocock 的实践)

1. **CONTEXT.md 只是术语表** —— 只放项目特有术语,绝不放实现细节。
2. **术语要有主见** —— 一个概念选一个最佳词,其余进 `_Avoid_`,全项目统一。
3. **ADR 默认 1-3 句** —— 难逆 + 反直觉 + 真权衡,三条同时成立才记。
4. **内联更新 > 事后同步** —— 开发/拷问时当场更文档,`spec-sync` 只是兜底。
5. **从 3 个文件起步,懒创建** —— 只给复杂/敏感模块写详细 spec。

---

## 想深入

- [`使用方案.md`](使用方案.md) —— 工具清单 + 何时用哪个(一页纸)
- [`AGENTS.md`](AGENTS.md) —— 给任意 AI 工具的通用入口
- [`.claude/skills/`](.claude/skills) —— 6 个技能源码,可直接编辑
- [`docs/adr/`](docs/adr) —— 这套体系自身的架构决策

---

**最后更新:** 2026-06-27 · 来自 [Fateorcloud/code-skills](https://github.com/Fateorcloud/code-skills) 的 `Spec-skill/`
