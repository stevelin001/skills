# Skills 管理系统

统一的 AI agent skills 管理仓库，支持跨多个 AI 工具同步。

## 架构

```
┌─────────────────────────────────────────────────────────────┐
│  共享 Git 仓库（单一数据源）                                  │
│  /Users/bluesky/workspace/skills/                           │
│  ├── daily-record/          # 每日记录                       │
│  ├── prompt-quality-checker/ # 提示词质量检查                │
│  ├── skill-manager/         # Skills 管理器                  │
│  └── sync-skills.sh         # 同步脚本                       │
└─────────────────────────────────────────────────────────────┘
                          │
                    运行 sync-skills.sh
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│  各 AI 工具的 skills 目录（复制的副本）                         │
│  ~/.claude/skills/          # Claude Code                   │
│  ~/.codex/skills/           # Codex                         │
│  ~/.cursor/skills/          # Cursor                        │
│  ~/.gemini/skills/          # Gemini                        │
└─────────────────────────────────────────────────────────────┘
```

## 快速开始

### 1. 修改 Skill

在共享仓库中编辑：

```bash
cd /Users/bluesky/workspace/skills/skill-manager
vim SKILL.md  # 或使用任何编辑器
```

### 2. 提交到 Git

```bash
cd /Users/bluesky/workspace/skills
git add skill-manager/SKILL.md
git commit -m "Update skill-manager"
git push  # 如果配置了远程仓库
```

### 3. 同步到所有工具

```bash
# 方式一：使用脚本
/Users/bluesky/workspace/skills/sync-skills.sh

# 方式二：使用便捷命令
skills-sync
```

## 便捷命令

| 命令 | 说明 |
|------|------|
| `skills-sync` | 同步所有 skills 到各 AI 工具 |
| `cd ~/workspace/skills` | 进入共享仓库 |

## 添加新 Skill

1. **创建 skill 目录：**
```bash
cd /Users/bluesky/workspace/skills
mkdir your-new-skill
```

2. **创建 SKILL.md：**
```markdown
---
name: your-new-skill
description: Use when [specific triggering conditions]
---

# Your Skill Name

## Overview
...
```

3. **更新同步脚本：**
编辑 `sync-skills.sh`，在 `SKILLS` 数组中添加：
```bash
SKILLS=(
    "daily-record"
    "prompt-quality-checker"
    "skill-manager"
    "your-new-skill"  # 添加这里
)
```

4. **提交并同步：**
```bash
git add your-new-skill sync-skills.sh
git commit -m "Add your-new-skill"
skills-sync
```

## 添加新 AI 工具

编辑 `sync-skills.sh`，在 `TARGETS` 数组中取消注释：

```bash
TARGETS=(
    "$HOME/.claude/skills"      # Claude Code
    "$HOME/.codex/skills"       # 取消注释以启用 Codex
    "$HOME/.cursor/skills"      # 取消注释以启用 Cursor
    "$HOME/.gemini/skills"      # 取消注释以启用 Gemini
)
```

## GitHub 设置

首次使用时，需要配置 GitHub 远程仓库。详见 [GITHUB_SETUP.md](GITHUB_SETUP.md)。

## 当前 Skills

| Skill | 描述 |
|-------|------|
| **daily-record** | 每日会话记录和日志 |
| **prompt-quality-checker** | 提示词质量检查和优化 |
| **skill-manager** | Grimoire CLI 封装，管理 AI agent skills |

## 工作流程

```
┌──────────────┐
│ 修改 Skill   │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│ Git 提交     │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│ 运行同步脚本  │
│ skills-sync  │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│ 所有工具已更新│
└──────────────┘
```

## 常见问题

**Q: 为什么需要复制而不是软链接？**
A: Claude Code 在扫描 skills 目录时，软链接可能不被正确识别。复制确保兼容性。

**Q: 修改后忘记同步怎么办？**
A: 所有修改都在共享仓库的 Git 历史中，随时可以重新同步。

**Q: 如何在多台设备上使用？**
A: 克隆 GitHub 仓库，在每台设备上运行 `skills-sync`。

## 维护者

@bluesky

## 许可证

MIT
