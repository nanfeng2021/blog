# 🚀 GitHub 推送快速指南

## ✅ 当前状态

- ✅ 本地提交完成（Commit: 8d55298）
- ✅ 包含阅读进度条修复
- ⏳ 待推送到 GitHub

---

## 🔑 推荐方案：配置 SSH 密钥（5 分钟）

### 步骤 1: 生成 SSH 密钥

```bash
ssh-keygen -t ed25519 -C "nanfeng@example.com" -f ~/.ssh/github_ed25519
```

**操作**:
- 按提示输入密码（passphrase），可以直接回车留空
- 会生成两个文件：`~/.ssh/github_ed25519`（私钥）和 `~/.ssh/github_ed25519.pub`（公钥）

### 步骤 2: 查看并复制公钥

```bash
cat ~/.ssh/github_ed25519.pub
```

**输出示例**:
```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... nanfeng@example.com
```

**复制整行内容**（从 `ssh-ed25519` 开始到邮箱结束）。

### 步骤 3: 添加到 GitHub

1. 访问：https://github.com/settings/keys
2. 点击 **"New SSH key"**
3. **Title**: 填写描述，如 "Lighthouse Server"
4. **Key type**: 选择 **"Authentication Key"**（重要！）
5. **Key**: 粘贴刚才复制的公钥内容
6. 点击 **"Add SSH key"**
7. 如果提示确认，输入 GitHub 密码

### 步骤 4: 修改远程仓库为 SSH

```bash
cd /root/.openclaw/workspace/blog
git remote set-url origin git@github.com:nanfeng2021/ai-learning-journey.git
```

验证：
```bash
git remote -v
# 应该显示：
# origin  git@github.com:nanfeng2021/ai-learning-journey.git (fetch)
# origin  git@github.com:nanfeng2021/ai-learning-journey.git (push)
```

### 步骤 5: 首次连接测试

```bash
ssh -T -i ~/.ssh/github_ed25519 git@github.com
```

**第一次会看到**:
```
The authenticity of host 'github.com (...)' can't be established.
Are you sure you want to continue connecting (yes/no/[fingerprint])? 
```

**输入**: `yes`

**成功后显示**:
```
Hi nanfeng2021! You've successfully authenticated, but GitHub does not provide shell access.
```

### 步骤 6: 推送代码

```bash
cd /root/.openclaw/workspace/blog
GIT_SSH_COMMAND="ssh -i ~/.ssh/github_ed25519 -o IdentitiesOnly=yes" git push origin main
```

**成功输出**:
```
Enumerating objects: XX, done.
Counting objects: 100% (XX/XX), done.
Writing objects: 100% (XX/XX), done.
remote: Resolving deltas: 100% (XX/XX), done.
To github.com:nanfeng2021/ai-learning-journey.git
   e8aaffb..8d55298  main -> main
```

---

## 🎯 推送后的操作

### 1. 验证推送成功

访问：https://github.com/nanfeng2021/ai-learning-journey

检查：
- ✅ 最新提交是 "🔧 修复阅读进度条集成问题"
- ✅ 提交时间是刚才
- ✅ 所有文件都存在

### 2. 创建 GitHub Release

1. 访问：https://github.com/nanfeng2021/ai-learning-journey/releases/new
2. 填写：
   ```
   Tag version: v1.0.0
   Target: main
   Release title: 🎉 博客改造 v1.0 - 正式发布！
   ```
3. 复制 `GITHUB_RELEASE.md` 的内容到描述框
4. 点击 **"Publish release"**

### 3. 分享 Release

分享链接到各平台：
- GitHub Profile
- 知乎动态
- 朋友圈
- Twitter / 微博

---

## 💡 快捷命令（以后都用这个）

为了方便，可以设置 Git 使用特定的 SSH 密钥：

```bash
# 编辑 Git 配置
git config core.sshCommand "ssh -i ~/.ssh/github_ed25519 -o IdentitiesOnly=yes"

# 以后直接推送即可
git push origin main
```

---

## ❓ 常见问题

### Q: 权限被拒绝（Permission denied）
**A**: 检查：
1. SSH 密钥是否正确添加到 GitHub
2. Key type 是否选择了 "Authentication Key"
3. 远程仓库 URL 是否是 SSH 格式

### Q: 找不到密钥文件
**A**: 重新生成：
```bash
ls -la ~/.ssh/github_ed25519*
```

### Q: 推送被拒绝
**A**: 如果是首次推送，可能需要：
```bash
git push -u origin main
```

---

## 🎁 一键推送脚本

创建一个便捷脚本：

```bash
cat > ~/push-blog.sh << 'EOF'
#!/bin/bash
cd /root/.openclaw/workspace/blog
echo "🔨 构建中..."
npm run build
echo "📦 部署到服务器..."
sudo cp -r docs/.vitepress/dist/* /var/www/ainanfeng.cn/
echo "💾 提交到 Git..."
git add -A
git commit -m "📝 自动提交 - $(date +%Y-%m-%d)"
echo "🚀 推送到 GitHub..."
GIT_SSH_COMMAND="ssh -i ~/.ssh/github_ed25519 -o IdentitiesOnly=yes" git push origin main
echo "✅ 完成！"
EOF

chmod +x ~/push-blog.sh
```

以后只需运行：
```bash
~/push-blog.sh
```

---

_最后更新：2026-04-02 17:15_  
_状态：⏳ 等待 SSH 配置后推送_
