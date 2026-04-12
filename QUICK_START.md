# 🚀 快速启动指南

> 如何查看更新后的博客首页

---

## ✅ 服务已启动

博客开发服务器已经在后台运行！

**访问地址**: http://localhost:5173/

---

## 🌐 查看首页更新

### 方式一：浏览器访问（推荐）

在浏览器中打开：
```
http://localhost:5173/
```

你会看到首页新增了 4 个项目卡片：
- 🚨 **摔倒检测系统** - 基于 3D 点云的实时监控系统
- 🧠 **RAG 知识库** - 检索增强生成的 AI 问答系统
- 😊 **情感分析** - 文本情感识别与分析工具
- 🎮 **AI 俄罗斯方块** - AI 智能体自主学习的经典游戏

### 方式二：命令行查看

```bash
# 查看首页 HTML 内容
curl http://localhost:5173/ | grep -o "摔倒检测\|RAG 知识库\|情感分析\|AI 方块"

# 应该能看到输出：
# 摔倒检测系统
# RAG 知识库
# 情感分析
# AI 俄罗斯方块
```

---

## 📱 页面导航

### 顶部导航栏
```
首页 | 文章 | 🚀 项目演示 | 🤖 RAG | 😊 情感分析 | 🎮 AI 方块 | 关于
```

### 主要页面

| 页面 | 路径 | 说明 |
|------|------|------|
| 博客首页 | `/` | 展示所有项目卡片 |
| 项目演示总览 | `/projects` | 详细介绍所有集成的应用 |
| 摔倒检测专题 | `/fall-detection-intro` | 摔倒检测系统详细说明 |
| 文章列表 | `/posts/` | 所有博客文章 |

---

## 🔧 控制服务

### 查看服务状态

```bash
ps aux | grep vitepress | grep -v grep
```

### 停止服务

```bash
pkill -f "vitepress dev"
```

### 重启服务

```bash
cd /root/.openclaw/workspace/blog
npm run dev
```

---

## 🎯 下一步

### 1. 测试所有功能

- [ ] 打开首页，确认项目卡片显示正常
- [ ] 点击"🚀 项目演示"，查看项目总览页
- [ ] 点击各个项目卡片，检查链接跳转
- [ ] 浏览文章列表和关于页面

### 2. 启动后端服务

要实际访问摔倒检测等应用，需要启动对应的服务：

```bash
cd /root/.openclaw/workspace/blog

# 方式一：使用 Docker Compose（如已安装）
docker compose --profile with-rag --profile with-fall-detection up -d

# 方式二：手动启动摔倒检测
cd projects/fall-detection
./start.sh
```

### 3. 生产环境部署

参考 [DEPLOYMENT_GUIDE.md](./DEPLOYMENT_GUIDE.md) 进行完整部署。

---

## 🆘 故障排查

### 问题 1：无法访问 http://localhost:5173/

**解决方案：**
```bash
# 检查端口占用
netstat -tulpn | grep 5173

# 查看日志
tail -f /tmp/blog-dev.log

# 重启服务
pkill -f vitepress
npm run dev
```

### 问题 2：首页没有显示新项目卡片

**解决方案：**
```bash
# 清除浏览器缓存（强制刷新）
# 或访问：http://localhost:5173/?v=20260412

# 检查构建文件
cat docs/index.md | grep "摔倒检测"

# 重新构建
npm run build
```

### 问题 3：链接跳转失败

**解决方案：**
- 确保在开发模式下（`npm run dev`）
- 检查浏览器控制台是否有错误
- 确认 `.vitepress/config.js` 配置正确

---

## 📊 当前状态

| 组件 | 状态 | 端口 |
|------|------|------|
| 博客前端 | ✅ 运行中 | 5173 |
| 摔倒检测 | ⏸️ 未启动 | 8501 |
| RAG 知识库 | ⏸️ 未启动 | 7860 |
| 情感分析 | ⏸️ 未启动 | 8001 |
| AI 俄罗斯方块 | ⏸️ 未启动 | 5000 |

---

**🎉 享受你的全新博客体验！**

有任何问题随时告诉我～ 🐕

*最后更新：2026-04-12 10:06*
