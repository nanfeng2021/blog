# 导航栏更新说明

## ✅ 配置已更新

导航栏配置文件 `docs/.vitepress/config.js` 已成功更新，包含所有新服务入口：

```javascript
nav: [
  { text: '首页', link: '/' },
  { text: '文章', link: '/posts/' },
  { text: '🤖 RAG 知识库', link: '/rag' },      // ← 新增
  { text: '🧠 情感分析', link: '/emotion' },    // ← 新增
  { text: '🎮 AI 方块', link: '/tetris' },      // ← 新增
  { text: '关于', link: '/about' }
]
```

## 🔄 为什么看不到更新？

如果你在当前运行的博客中看不到新的导航项，可能是因为：

### 原因 1: 博客服务在更新前启动
**解决方案**: 重启博客服务

```bash
# 1. 停止当前博客服务（按 Ctrl+C）
# 2. 重新启动
cd /root/.openclaw/workspace/blog
npm run dev
```

### 原因 2: 浏览器缓存
**解决方案**: 强制刷新页面

- **Chrome/Edge**: `Ctrl + Shift + R` (Windows) 或 `Cmd + Shift + R` (Mac)
- **Firefox**: `Ctrl + F5` 或 `Cmd + Shift + R`
- **Safari**: `Cmd + Option + E` 然后 `Cmd + R`

### 原因 3: VitePress 开发服务器缓存
**解决方案**: 清除缓存并重启

```bash
cd /root/.openclaw/workspace/blog
rm -rf docs/.vitepress/cache
npm run dev
```

## 🚀 完整重启步骤

### 方式一：使用一键启动脚本（推荐）

```bash
cd /root/.openclaw/workspace/blog
./start-all.sh
```

这会自动启动所有服务并显示访问地址。

### 方式二：手动重启

```bash
# 1. 进入博客目录
cd /root/.openclaw/workspace/blog

# 2. 清除缓存
rm -rf docs/.vitepress/cache

# 3. 启动博客
npm run dev
```

## 📱 验证方法

### 方法 1: 查看页面源代码

1. 打开 http://localhost:5173
2. 右键 → 查看页面源代码
3. 搜索 "RAG 知识库" 或 "情感分析"
4. 如果找到，说明配置已加载

### 方法 2: 直接访问新页面

即使导航栏没显示，也可以直接访问：

- **RAG 知识库**: http://localhost:5173/rag
- **情感分析**: http://localhost:5173/emotion
- **AI 俄罗斯方块**: http://localhost:5173/tetris

如果这些页面能正常访问，说明集成是成功的，只是导航栏显示问题。

### 方法 3: 检查开发者工具

1. 打开浏览器开发者工具（F12）
2. 切换到 Network（网络）标签
3. 刷新页面
4. 查看是否有 `/rag`, `/emotion`, `/tetris` 的请求
5. 如果有，说明路由已注册

## 🎯 预期效果

重启后，导航栏应该显示：

```
┌─────────────────────────────────────────────────────┐
│  南风的博客                              [搜索图标]  │
│                                                      │
│  [首页] [文章] [🤖 RAG 知识库] [🧠 情感分析]        │
│  [🎮 AI 方块] [关于]                    [GitHub]     │
└─────────────────────────────────────────────────────┘
```

## ⚠️ 如果还是看不到

### 检查点 1: 文件是否保存

```bash
# 检查配置文件内容
cat /root/.openclaw/workspace/blog/docs/.vitepress/config.js | grep -A 6 "nav:"
```

应该看到包含 6 个导航项的输出。

### 检查点 2: 博客服务状态

```bash
# 检查端口 5173 是否在监听
netstat -tlnp | grep 5173
# 或
ss -tlnp | grep 5173
```

### 检查点 3: 重新构建

如果是生产环境，需要重新构建：

```bash
cd /root/.openclaw/workspace/blog
npm run build
npm run preview
```

## 📞 仍然有问题？

请提供以下信息：

1. 浏览器类型和版本
2. 访问的 URL
3. 截图（如果可能）
4. 控制台错误信息（F12 → Console）

---

**更新时间**: 2026-04-09  
**维护者**: 旺财 🐕
