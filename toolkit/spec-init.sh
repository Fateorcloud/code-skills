#!/usr/bin/env bash
# spec-init.sh — 一键为新项目搭建 Spec Coding 骨架
# 用法：在目标项目根目录运行
#   bash /path/to/AI_Spec/toolkit/spec-init.sh
set -euo pipefail

TOOLKIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "→ 创建目录结构..."
mkdir -p docs/adr docs/modules .claude/skills

echo "→ 复制核心文件..."
[ -f CLAUDE.md ]   || cp "$TOOLKIT_DIR/CLAUDE.template.md"  CLAUDE.md
[ -f CONTEXT.md ]  || cp "$TOOLKIT_DIR/CONTEXT.template.md" CONTEXT.md
[ -f docs/adr/001-tech-stack.md ] || cp "$TOOLKIT_DIR/ADR.template.md" docs/adr/001-tech-stack.md

echo "→ 复制技能（spec-init / grill-me / adr / spec-sync / spec-check）..."
cp -rn "$TOOLKIT_DIR/../.claude/skills/." .claude/skills/ 2>/dev/null || true

echo ""
echo "✅ 完成。下一步："
echo "   1. 编辑 CLAUDE.md 填项目名和技术栈"
echo "   2. 对 AI 说：/grill-me  让它盘问你、生成 CONTEXT.md"
echo "   3. 对 AI 说：/adr      记录技术选型"
echo ""
echo "日常：普通功能让 AI 读 CONTEXT.md；复杂模块写 docs/modules/XXX.md；改完代码用 /spec-sync。"
