# Skills 管理系统

统一的 AI agent skills 管理仓库，支持自己的 skills 和从 GitHub 获取的 skills。

## 架构

```
┌─────────────────────────────────────────────────────────────┐
│  共享 Git 仓库                                                  │
│  /Users/bluesky/workspace/skills/                           │
│                                                              │
│  ├── my-skills/              ← 自己的 skills（普通目录）      │
│  │   ├── skill-manager/                                     │
│  │   ├── prompt-quality-checker/                            │
│  │   └── daily-record/                                      │
│  │                                                          │
│  ├── writing-skills/          ← 别人的 skill（submodule）    │
│  │   └── (来自 Anthropic，可追踪更新)                        │
│  │                                                          │
│  ├── .gitmodules             ← Submodule 配置                │
│  └── sync-skills.sh           ← 同步脚本                      │
└─────────────────────────────────────────────────────────────┘
                          │
                    skills-sync
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│  各 AI 工具的 skills 目录（复制的副本）                         │
│  ~/.claude/skills/          # Claude Code                   │
│  ~/.codex/skills/           # Codex（可选）                   │
│  ~/.cursor/skills/          # Cursor（可选）                  │
└─────────────────────────────────────────────────────────────┘
```

## 设计原则

### 自己的 Skills

放在 `my-skills/` 目录下，直接修改和提交：

```bash
~/workspace/skills/my-skills/
├── skill-manager/
├── prompt-quality-checker/
└── daily-record/
```

**优点：**
- ✅ 集中管理，一个仓库
- ✅ 简单直接，无需 submodule 操作
- ✅ 易于维护和分享

### 别人的 Skills

作为 Git Submodules 添加，可以追踪上游更新：

```bash
~/workspace/skills/writing-skills/  # submodule
```

**优点：**
- ✅ 可获取上游更新
- ✅ 可保留自己的修改（fork 后添加）
- ✅ 独立的版本历史

## 快速开始

### 修改自己的 Skill

```bash
# 1. 编辑
cd ~/workspace/skills/my-skills/skill-manager
vim SKILL.md

# 2. 提交
cd ~/workspace/skills
git add my-skills/skill-manager
git commit -m "Update skill-manager"
git push

# 3. 同步到 AI 工具
skills-sync
```

### 添加别人的 Skill

#### 方式 A：作为 Submodule（推荐，可追踪更新）

```bash
cd ~/workspace/skills

# 添加别人的仓库
git submodule add https://github.com/anthropics/claude-code-skills.git writing-skills

# 或 fork 后添加自己的版本
git submodule add https://github.com/stevelin001/claude-code-skills.git writing-skills

git commit -m "Add writing-skills submodule"
git push
```

#### 方式 B：复制到 my-skills（简单，但无法追踪更新）

```bash
# 1. 复制到 my-skills
cp -r ~/workspace/skills/writing-skills ~/workspace/skills/my-skills/

# 2. 提交
git add my-skills/writing-skills
git commit -m "Add writing-skills (copied)"
git push

# 3. 更新 sync-skills.sh 中的 MY_SKILLS 数组
```

### 更新别人的 Skills（Submodule）

```bash
cd ~/workspace/skills/writing-skills
git pull origin main

cd ..
git add writing-skills
git commit -m "Update writing-skills submodule"
git push

skills-sync
```

## 当前 Skills

### 自己的 Skills (my-skills/)

| Skill | 描述 | 路径 |
|-------|------|------|
| **skill-manager** | Grimoire CLI 封装 | `my-skills/skill-manager/` |
| **prompt-quality-checker** | 提示词质量检查 | `my-skills/prompt-quality-checker/` |
| **daily-record** | 每日会话记录 | `my-skills/daily-record/` |

### 别人的 Skills (Submodules)

| Skill | 来源 | 更新方式 |
|-------|------|---------|
| *待添加* | *GitHub* | `git submodule update --remote` |

## 便捷命令

| 命令 | 说明 |
|------|------|
| `skills-sync` | 同步所有 skills 到各 AI 工具 |
| `git submodule update --remote` | 更新所有别人的 skills |
| `git submodule status` | 查看 submodule 状态 |

## 目录结构

```
~/workspace/skills/
├── .git/                      # 主仓库
├── .gitmodules               # Submodule 配置（如果有）
├── my-skills/                # 自己的 skills
│   ├── skill-manager/
│   ├── prompt-quality-checker/
│   └── daily-record/
├── writing-skills/           # 别人的 skill (submodule)
├── sync-skills.sh
├── README.md
└── GITHUB_SETUP.md
```

## 添加新 Skill

### 自己开发的 Skill

```bash
cd ~/workspace/skills/my-skills
mkdir your-new-skill
# 创建 SKILL.md
cd ..
git add my-skills/your-new-skill
git commit -m "Add your-new-skill"
git push

# 更新 sync-skills.sh 中的 MY_SKILLS 数组
```

### 别人的 Skill

```bash
cd ~/workspace/skills
git submodule add https://github.com/user/repo.git repo-name
git commit -m "Add repo-name submodule"
git push
```

## 工作流程

```
修改自己的 skill:
  编辑 → git commit → git push → skills-sync

更新别人的 skill:
  git pull → git commit → git push → skills-sync

添加新 skill:
  自己的: 放到 my-skills/ → git commit
  别人的: git submodule add → git commit
```

## 常见问题

**Q: 自己的 skills 和别人的 skills 有什么区别？**
A:
- 自己的：放在 `my-skills/`，直接管理，一个仓库搞定
- 别人的：作为 submodules，可追踪上游更新

**Q: 为什么不全部用 submodule？**
A: 自己的 skills 放在一起更简单，不需要分散的管理开销。

**Q: 怎么选择使用哪种方式？**
A:
- 自己开发的 → `my-skills/`
- 需要追踪更新的 → submodule
- 一次性使用的 → 复制到 `my-skills/`

## 在其他设备上使用

```bash
# 克隆主仓库
git clone https://github.com/stevelin001/skills.git ~/workspace/skills
cd ~/workspace/skills

# 初始化 submodules（如果有）
git submodule init
git submodule update

# 设置便捷命令
mkdir -p ~/.local/bin
cat > ~/.local/bin/skills-sync << 'EOF'
#!/bin/bash
~/workspace/skills/sync-skills.sh
EOF
chmod +x ~/.local/bin/skills-sync

# 运行同步
skills-sync
```

## 维护者

@bluesky

## 许可证

MIT
