# GitHub 仓库设置指南

## 方法一：使用 GitHub CLI（推荐）

1. **登录 GitHub：**
```bash
gh auth login
```

2. **选择登录选项：**
   - `What account do you want to log into?` → `GitHub.com`
   - `What is your preferred protocol for Git operations?` → `HTTPS`
   - `Authenticate your account with GitHub.com via` → `Login with a web browser` (推荐)

3. **创建并推送仓库：**
```bash
cd /Users/bluesky/workspace/skills
gh repo create skills --public --source=. --remote=origin --description="Unified AI agent skills repository"
git push -u origin master
```

---

## 方法二：手动创建

1. **在 GitHub 创建新仓库：**
   - 访问 https://github.com/new
   - 仓库名：`skills`
   - 设置为 Public 或 Private
   - **不要**勾选 "Add a README file"
   - 点击 "Create repository"

2. **添加远程仓库并推送：**
```bash
cd /Users/bluesky/workspace/skills
git remote add origin https://github.com/YOUR_USERNAME/skills.git
git branch -M master
git push -u origin master
```

---

## 创建后

仓库地址将是：`https://github.com/YOUR_USERNAME/skills`

其他设备或用户可以克隆：
```bash
git clone https://github.com/YOUR_USERNAME/skills.git
cd skills
bash sync-skills.sh  # 同步到本地工具
```
