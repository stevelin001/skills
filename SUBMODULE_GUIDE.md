# Skills 管理系统 v2

统一的 AI agent skills 管理仓库，支持自己开发的和从 GitHub 获取的 skills。

## 架构设计

```
┌─────────────────────────────────────────────────────────────┐
│  共享仓库（Submodule 管理器）                                │
│  /Users/bluesky/workspace/skills/                           │
│  ├── .gitmodules           # Submodule 配置                 │
│  ├── skill-manager/         # 自己开发的 (submodule)        │
│  ├── prompt-quality-checker/ # 自己开发的 (submodule)       │
│  ├── writing-skills/       # 从 Anthropic fork (submodule) │
│  └── sync-skills.sh         # 同步脚本                       │
└─────────────────────────────────────────────────────────────┘
                          │
           ┌───────────────┼───────────────┐
           ▼               ▼               ▼
    ┌──────────┐    ┌──────────┐    ┌──────────┐
    │ 自己的  │    │ 自己的  │    │ Fork的  │
    │ GitHub  │    │ GitHub  │    │ GitHub  │
    │ 仓库    │    │ 仓库    │    │ 上游   │
    └──────────┘    └──────────┘    └──────────┘
           │               │               │
           └───────────────┴───────────────┘
                           │
                    git submodule update
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│  各 AI 工具的 skills 目录（复制的副本）                         │
│  ~/.claude/skills/          # Claude Code                   │
│  ~/.codex/skills/           # Codex                         │
└─────────────────────────────────────────────────────────────┘
```

## 核心概念

### Submodule vs 复制

| 方案 | 自己开发的 | 别人的 skill | 更新别人代码 | 提交自己修改 |
|------|-----------|-------------|-------------|-------------|
| **复制** | ✅ 可以 | ❌ 困定 | ❌ 需要手动 | ✅ 可以 |
| **Submodule** | ✅ 可以 | ✅ 可以 | ✅ 一键更新 | ✅ 可以 |

### 工作流程

```
1. 别人的 skill 更新了
        │
        ▼
   git pull (在 submodule 中)
        │
        ▼
2. 更新共享仓库
        │
        ▼
   git submodule update
        │
        ▼
3. 同步到 AI 工具
        │
        ▼
   skills-sync
```

## 迁移步骤

### 第一步：将现有 skills 转换为 submodules

```bash
cd /Users/bluesky/workspace/skills

# 移除现有的 skill 目录（但保留 Git 历史）
git rm -rf skill-manager
git rm -rf prompt-quality-checker
git commit -m "Remove skills for submodule migration"

# 添加为 submodules
git submodule add https://github.com/stevelin001/skill-manager.git skill-manager
git submodule add https://github.com/stevelin001/prompt-quality-checker.git prompt-quality-checker

# 提交
git commit -m "Add skills as submodules"
git push
```

### 第二步：从别人的仓库添加 submodule

```bash
# 示例：添加 Anthropic 的 writing-skills
git submodule add https://github.com/anthropics/claude-code-skills.git writing-skills

# 或者 fork 后添加自己的 fork
git submodule add https://github.com/stevelin001/claude-code-skills.git writing-skills
```

### 第三步：更新别人的 skills

```bash
cd ~/workspace/skills/writing-skills
git pull origin master

cd ..
git add writing-skills
git commit -m "Update writing-skills submodule"
git push
```

### 第四步：同步到 AI 工具

```bash
skills-sync  # 自动处理 submodules
```

## Submodule 常用命令

```bash
# 初始化所有 submodules
git submodule update --init --recursive

# 更新所有 submodules 到最新
git submodule update --remote --merge

# 查看 submodule 状态
git submodule status

# 克隆包含 submodules 的仓库
git clone --recurse-submodules https://github.com/stevelin001/skills.git
```

## 目录结构

```
/Users/bluesky/workspace/skills/
├── .git/                    # 主仓库
├── .gitmodules             # Submodule 配置
├── skill-manager/           # Submodule: 自己的 GitHub 仓库
│   ├── .git/               # 独立的 git 仓库
│   └── SKILL.md
├── prompt-quality-checker/  # Submodule: 自己的 GitHub 仓库
│   ├── .git/
│   └── SKILL.md
├── writing-skills/          # Submodule: fork/别人的仓库
│   ├── .git/
│   └── SKILL.md
└── sync-skills.sh
```

## 自己开发的 Skill

### 创建新的 skill submodule

```bash
# 1. 在 GitHub 创建新仓库（例如：my-new-skill）

# 2. 添加为 submodule
cd ~/workspace/skills
git submodule add https://github.com/stevelin001/my-new-skill.git my-new-skill

# 3. 在 submodule 中开发
cd my-new-skill
# 编辑 SKILL.md
git add SKILL.md
git commit -m "Add initial skill"
git push -u origin main

# 4. 更新主仓库
cd ..
git add my-new-skill
git commit -m "Add my-new-skill submodule"
git push
```

### 修改自己的 skill

```bash
cd ~/workspace/skills/my-skill
# 修改文件
git add .
git commit -m "Update skill"
git push

# 更新主仓库中的引用
cd ..
git add my-skill
git commit -m "Update my-skill submodule reference"
git push
```

## 别人的 Skill

### Fork 并添加

```bash
# 1. 在 GitHub fork 别人的仓库

# 2. 添加自己的 fork 作为 submodule
cd ~/workspace/skills
git submodule add https://github.com/stevelin001/original-skill.git original-skill

# 3. 可以修改并 push 到自己的 fork
cd original-skill
# 修改...
git commit -am "My changes"
git push
```

### 跟踪上游更新

```bash
cd ~/workspace/skills/original-skill

# 添加上游仓库
git remote add upstream https://github.com/original-author/original-skill.git

# 获取上游更新
git fetch upstream

# 合并上游更新
git merge upstream/main
# 或使用 rebase
git rebase upstream/main

# 推送到自己的 fork
git push origin main
```

## 同步脚本更新

`sync-skills.sh` 现在需要处理 submodules：

```bash
#!/usr/bin/env bash
# 确保 submodules 是最新的
git submodule update --remote --recursive

# 然后复制到各工具目录
...
```

## 常见问题

**Q: Submodule 和直接复制有什么区别？**
A:
- 复制：固定版本，无法追踪更新
- Submodule：独立 git 历史，可以独立更新和提交

**Q: 如何在别人的 skill 和自己的修改之间保持平衡？**
A:
- Fork 别人的仓库
- 添加自己的 fork 为 submodule
- 定期 merge 上游更新
- 自己的修改提交到自己的 fork

**Q: Submodule 会不会很复杂？**
A:
- 日常使用：和普通目录一样，直接 cd 进去修改
- 更新时：多一步 `git submodule update`
- 收益：可以追踪上游更新，值得这个复杂度

## 迁移检查清单

- [ ] 将现有 skills 转换为独立的 GitHub 仓库
- [ ] 在主仓库中添加 submodules
- [ ] 更新 sync-skills.sh 支持 submodules
- [ ] 测试更新流程
- [ ] 推送到 GitHub
- [ ] 在其他设备上测试克隆和同步
