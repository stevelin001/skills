#!/usr/bin/env bash
# Skills Sync Script - 从共享仓库同步到各个 AI 工具

SOURCE_DIR="/Users/bluesky/workspace/skills"

# 定义要同步的 skills（手动维护）
SKILLS=(
    "daily-record"
    "prompt-quality-checker"
    "skill-manager"
)

# 定义各 AI 工具的 skills 目录
# 取消注释以启用相应的工具
TARGETS=(
    "$HOME/.claude/skills"      # Claude Code
    # "$HOME/.codex/skills"       # Codex（取消注释以启用）
    # "$HOME/.cursor/skills"      # Cursor（取消注释以启用）
    # "$HOME/.gemini/skills"      # Gemini（取消注释以启用）
)

echo "=== Skills Sync Script ==="
echo ""

cd "$SOURCE_DIR" || exit 1

echo "源仓库: $SOURCE_DIR"
echo "分支: $(git branch --show-current)"
echo "最后提交: $(git log -1 --oneline)"
echo ""

# 同步到每个工具
for target_path in "${TARGETS[@]}"; do
    # 展开波浪号
    target="${target_path/#\~/$HOME}"

    if [ ! -d "$target" ]; then
        echo "⚠️  跳过: $target (目录不存在)"
        echo ""
        continue
    fi

    echo "📦 同步到: $target"

    for skill in "${SKILLS[@]}"; do
        if [ ! -d "$SOURCE_DIR/$skill" ]; then
            echo "  ⚠️  跳过: $skill (源目录不存在)"
            continue
        fi

        echo "  - $skill"
        rm -rf "$target/$skill"
        cp -r "$SOURCE_DIR/$skill" "$target/"
    done

    echo "  ✅ 完成同步到 $target"
    echo ""
done

echo "=== 同步完成 ==="
echo ""
echo "💡 提示:"
echo "  - 修改 skill 后，运行此脚本同步到所有工具"
echo "  - 要添加新 skill，在 SKILLS 数组中添加名称"
echo "  - 要添加新工具，在 TARGETS 数组中取消注释"
