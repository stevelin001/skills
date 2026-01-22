#!/usr/bin/env bash
# Skills Sync Script - 从共享仓库同步到各个 AI 工具（支持 Submodules）

SOURCE_DIR="/Users/bluesky/workspace/skills"

# 定义要同步的 skills（这些是 submodule 名称）
SKILLS=(
    "daily-record"
    "prompt-quality-checker"
    "skill-manager"
)

# 定义各 AI 工具的 skills 目录
TARGETS=(
    "$HOME/.claude/skills"      # Claude Code
    # "$HOME/.codex/skills"       # Codex（取消注释以启用）
    # "$HOME/.cursor/skills"      # Cursor（取消注释以启用）
    # "$HOME/.gemini/skills"      # Gemini（取消注释以启用）
)

echo "=== Skills Sync Script (Submodule 版) ==="
echo ""

cd "$SOURCE_DIR" || exit 1

echo "源仓库: $SOURCE_DIR"
echo "分支: $(git branch --show-current)"
echo "最后提交: $(git log -1 --oneline)"
echo ""

# 检查并更新 submodules
echo "📦 检查 submodules..."
if [ -f ".gitmodules" ]; then
    echo "  发现 .gitmodules，更新 submodules..."
    git submodule update --remote --recursive
    echo "  ✅ Submodules 已更新"
else
    echo "  ℹ️  没有 .gitmodules，跳过 submodule 更新"
fi
echo ""

# 同步到每个工具
for target_path in "${TARGETS[@]}"; do
    target="${target_path/#\~/$HOME}"

    if [ ! -d "$target" ]; then
        echo "⚠️  跳过: $target (目录不存在)"
        echo ""
        continue
    fi

    echo "📦 同步到: $target"

    for skill in "${SKILLS[@]}"; do
        skill_path="$SOURCE_DIR/$skill"

        if [ ! -d "$skill_path" ]; then
            echo "  ⚠️  跳过: $skill (源目录不存在)"
            continue
        fi

        echo "  - $skill"
        rm -rf "$target/$skill"
        cp -r "$skill_path" "$target/"
    done

    echo "  ✅ 完成同步到 $target"
    echo ""
done

echo "=== 同步完成 ==="
echo ""
echo "💡 提示:"
echo "  - 修改 skill 后，先进入 skill 目录提交："
echo "    cd ~/workspace/skills/skill-name"
echo "    git add . && git commit -m 'Update' && git push"
echo "  - 然后更新主仓库："
echo "    cd ~/workspace/skills"
echo "    git add skill-name && git commit -m 'Update submodule' && git push"
echo "  - 最后运行此脚本同步到所有工具"
echo ""
echo "📚 更多信息: 查看 SUBMODULE_GUIDE.md"
