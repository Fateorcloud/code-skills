# session-memory — 多进程开发的对话记忆接力

> 多个开发对话在**同一个项目**上并行（多开 / 多进程），彼此上下文不互通；对话越长、token 越贵。
> 这对技能让你把一段快聊爆的对话**压成高密度归档**，换个全新（便宜的）对话**接手继续**——不必重放整段历史。

---

## 两个技能

| 技能 | 干什么 |
|------|--------|
| `/mem-save` | 把**当前对话**压成一份可接手的归档，存进项目 `.agent-memory/` |
| `/mem-load` | 新对话开工时，**先读索引、按需加载**相关归档，接手继续 |

> 省 token 的核心：新对话只读一份精炼归档，不重放整段历史。

---

## 装进哪 / 全局

Claude Code 和 Codex 用**同一种 `SKILL.md` 格式**，装法一样，只是目录不同：

```bash
# Claude Code 全局（所有项目通用）
cp -r session-memory/.claude/skills/.  ~/.claude/skills/

# Codex 全局（同一批 SKILL.md）
cp -r session-memory/.claude/skills/.  ~/.codex/skills/

# 或仅当前项目（Claude）
cp -r session-memory/.claude/skills/.  <your-project>/.claude/skills/
```

> **技能装在哪≠归档存在哪。** 技能可以装全局，但**归档永远落在“你当时所在项目”的 `.agent-memory/`**（项目本地、默认 gitignore，不污染仓库历史）。

## 换工具 / 跨工具（重要）

`.agent-memory/` **只是项目目录里的普通文件夹**，不绑定任何工具的运行时。谁在这个项目目录里干活，谁就能读写它：

- 用 Claude `/mem-save` 存的归档，换 **Codex** 打开**同一个项目**、`/mem-load` 就能接手——因为读的是同一批磁盘文件。
- **Cursor** 没有全局 prompt 目录，但同样能用：把技能放进项目 `.cursor/rules/`，或直接说「读 `.claude/skills/mem-save/SKILL.md` 照着做」。归档照样落 `.agent-memory/`、照样共享。

一句话：**技能要在每个工具各装一份（数据的“读写手”），归档只有一份、随项目走、所有工具共享（数据本身）。**

> 归档目录特意用**工具中立**的 `.agent-memory/`，不带任何工具前缀——Claude / Codex / Cursor 读写它毫无区别，换工具不用改名。

---

## 日常就转这一个圈

```
对话变长 / 要收尾 ─▶ /mem-save（压缩存档）─▶ /clear 或另开一个 claude 进程
                                                    │
                                    /mem-load（读索引·按需接手）─▶ 继续干
                                                    │
                                          做出新进展 ─▶ /mem-save 更新同一归档
```

---

## 约定（`.agent-memory/`，技能首次运行时懒创建）

| 文件 | 作用 |
|------|------|
| `<slug>.md` | 一个对话一份归档（slug 多用 git 分支名或任务主题） |
| `INDEX.md` | 一行一条摘要，`/mem-load` 先读它再按需加载 |
| `.gitignore` | 内容 `*` + `!.gitignore`，让记忆本地私有、不入库 |

---

## 一份归档长什么样

```md
---
slug: refactor-auth
branch: refactor-auth
status: active
updated: 2026-07-01
---

# 把登录改成 JWT

## 目标
用 JWT 替换 session 登录，兼容旧 cookie 一个版本。

## 关键决策
- 用 RS256 非 HS256 → 网关只需公钥验签，不碰私钥。

## 现状
- 已完成：签发/验签中间件；已验证可用：本地登录换 token 通过。
- 进行中：旧 cookie 兼容层。

## 改动文件
- `src/auth/jwt.ts:12` — 签发
- `src/middleware/auth.ts:40` — 验签

## 下一步
1. 写 cookie→token 兼容层
2. 前端存 token 改 httpOnly

## 坑 / 待解决
- refresh token 轮换还没做，先留 TODO。

## 导航指针（让新对话别重读全部）
- 入口：`src/auth/jwt.ts`   相关：`src/middleware/auth.ts`
```

---

**来自** [Fateorcloud/code-skills](https://github.com/Fateorcloud/code-skills) 的 `session-memory/`
