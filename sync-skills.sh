#!/usr/bin/env bash
# Skills Sync Script - 混合架构（自己的 skills + 别人的 submodules）

SOURCE_DIR="/Users/bluesky/workspace/skills"

# 自己的 skills（在 my-skills 目录下）
MY_SKILLS=(
    "my-skills/skill-manager"
    "my-skills/prompt-quality-checker"
    "my-skills/daily-record"
)

# 别人的 skills（作为 submodules，自动更新）
# 可以通过 git submodule update --remote 更新

# 定义各 AI 工具的 skills 目录
TARGETS=(
    "$HOME/.claude/skills"      # Claude Code
    # "$HOME/.codex/skills"       # Codex（取消注释以启用）
    # "$HOME/.cursor/skills"      # Cursor（取消注释以启用）
)

echo "=== Skills Sync Script (混合架构) ==="
echo ""

cd "$SOURCE_DIR" || exit 1

echo "源仓库: $SOURCE_DIR"
echo "分支: $(git branch --show-current)"
echo "最后提交: $(git log -1 --oneline)"
echo ""

# 更新别人的 skills（submodules）
if [ -f ".gitmodules" ]; then
    echo "📦 更新别人的 skills (submodules)..."
    git submodule update --remote --recursive 2>/dev/null || echo "  (没有 submodules)"
    echo "  ✅ Submodules 已更新"
    echo ""
fi

# 同步到每个工具
for target_path in "${TARGETS[@]}"; do
    target="${target_path/#\~/$HOME}"

    if [ ! -d "$target" ]; then
        echo "⚠️  跳过: $target (目录不存在)"
        echo ""
        continue
    fi

    echo "📦 同步到: $target"

    # 复制自己的 skills
    for skill_rel in "${MY_SKILLS[@]}"; do
        skill_name=$(basename "$skill_rel")
        skill_path="$SOURCE_DIR/$skill_rel"

        if [ ! -d "$skill_path" ]; then
            echo "  ⚠️  跳过: $skill_name (源目录不存在)"
            continue
        fi

        echo "  - $skill_name (自己的)"
        rm -rf "$target/$skill_name"
        cp -r "$skill_path" "$target/"
    done

    # 复制别人的 skills（submodules）
    if [ -f ".gitmodules" ]; then
        while IFS= read -r line; do
            if [[ $line =~ path\ =\ (.+) ]]; then
                submodule_path="${BASH_REMATCH[1]}"
                submodule_name=$(basename "$submodule_path")
                echo "  - $submodule_name (别人的)"
                rm -rf "$target/$submodule_name"
                cp -r "$SOURCE_DIR/$submodule_path" "$target/"
            fi
        done < .gitmodules
    fi

    echo "  ✅ 完成同步到 $target"
    echo ""
done

echo "=== 同步完成 ==="
echo ""
echo "💡 架构说明:"
echo "  - 自己的 skills: my-skills/ 目录下，直接修改提交"
echo "  - 别人的 skills: 作为 submodules，可通过 git submodule update 更新"
echo ""
echo "📚 修改自己的 skills:"
echo "  cd ~/workspace/skills/my-skills/your-skill"
echo "  vim SKILL.md"
echo "  cd .. && git add your-skill && git commit -m 'Update' && git push"
echo "  skills-sync"
