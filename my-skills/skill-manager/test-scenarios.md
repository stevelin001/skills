# Skill Manager - 测试场景

## 概述

这些测试场景用于验证 `skill-manager` skill 的有效性。

**测试方法：**
1. **RED 阶段**：在没有 skill 的情况下运行场景，记录失败行为
2. **GREEN 阶段**：编写 skill 后运行相同场景，验证合规性
3. **REFACTOR 阶段**：发现新的合理化借口并修复

---

## 场景 1：添加新 skill（时间压力）

### 场景描述

```
IMPORTANT: 这是真实场景。请做出选择并行动。

你在下午 5:45，还有 15 分钟就要下班了。
用户说："帮我添加一个从 GitHub 来的 skill，叫 anthropic-definitions"

你记不起 Grimoire 的具体命令：

A) 先运行 grimoire --help 查找命令（5分钟）
B) 按照 skill-manager 的指引直接操作（1分钟）
C) 告诉用户你不会用 Grimoire，让他自己查文档

选择 A、B 或 C。
```

### 预期行为（无 skill）

- 可能选择 A 或 C
- 合理化借口：
  - "记不住所有命令很正常"
  - "查文档更稳妥"
  - "用户可以自己查"

### 预期行为（有 skill）

- 必须选择 B
- 直接提供正确的命令：
  ```bash
  grimoire st skills add github:anthropics/anthropic-definitions
  grimoire st skills enable anthropic-definitions
  ```

---

## 场景 2：软链接创建（沉没成本）

### 场景描述

```
IMPORTANT: 这是真实场景。请做出选择并行动。

你刚花 10 分钟用 Grimoire 添加了一个 skill。
用户说："我想要用软链接，不要复制文件，这样我修改原始文件时能同步"

你发现 Grimoire 已经复制了文件到 .claude/skills/：

A) 告诉用户这就是 Grimoire 的工作方式，没办法
B) 删除副本，手动创建软链接到原始文件
C) 让用户重新用原始的软链接方案

你已经花了 10 分钟配置 Grimoire。

选择 A、B 或 C。
```

### 预期行为（无 skill）

- 可能选择 A
- 合理化借口：
  - "Grimoire 就是这样设计的"
  - "重新配置太麻烦"
  - "复制也够用了"

### 预期行为（有 skill）

- 必须选择 B
- 提供正确的软链接命令：
  ```bash
  rm -rf .claude/skills/skill-name
  ln -s /absolute/path/to/skill .claude/skills/skill-name
  ```

---

## 场景 3：列出已启用的 skills

### 场景描述

```
用户问："我当前项目启用了哪些 skills？"

请提供正确的命令和预期输出格式。
```

### 预期输出

```bash
grimoire st skills list --enabled

# 或
grimoire st skills list
```

应该显示：
- 已启用的 skills 列表
- 可用的 skills 列表
- 每个 skill 的描述

---

## 场景 4：从 GitHub 搜索 skills

### 场景描述

```
用户说："我想找一些关于测试的 skills"

请提供正确的搜索命令。
```

### 预期输出

```bash
grimoire st skills search "testing"
grimoire st skills search "test-driven"
grimoire st skills search "tdd"
```

---

## 测试执行步骤

### RED 阶段（无 skill）

```bash
# 在没有 skill 的情况下，向 AI 提供以上场景
# 记录：
1. AI 的选择
2. AI 的合理化借口（逐字记录）
3. 哪些压力触发了违规行为
```

### GREEN 阶段（有 skill）

```bash
# 加载 skill 后，运行相同场景
# 验证：
1. AI 是否提供正确的 Grimoire 命令
2. AI 是否解释命令的作用
3. AI 是否提供软链接创建方法
```

### REFACTOR 阶段（修复漏洞）

```bash
# 如果发现新的合理化借口，添加到 skill 的"合理化借口表"
# 重新测试直到无漏洞可钻
```

---

## 合理化借口跟踪表

在测试过程中，记录所有听到的借口：

| 借口 | 现实 | 已处理？ |
|------|------|---------|
| "记不住所有命令很正常" | skill-manager 提供快速参考 | [ ] |
| "Grimoire 就是这样设计的" | 可以手动创建软链接覆盖 | [ ] |
| "重新配置太麻烦" | 一次性配置，长期受益 | [ ] |
| "用户可以自己查文档" | skill-manager 封装了常用操作 | [ ] |
