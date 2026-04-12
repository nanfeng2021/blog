# 📊 接入 Umami 统计分析

## 📋 为什么选择 Umami？

- ✅ **隐私友好**: 不收集个人信息，符合 GDPR
- ✅ **自托管**: 数据完全掌控在自己手中
- ✅ **轻量**: 脚本仅 2KB，不影响页面加载
- ✅ **美观**: 界面简洁直观
- ✅ **免费**: 开源软件，无费用

### 替代方案：Google Analytics 4
如果你更熟悉 GA4，也可以使用（但隐私性较差）。

---

## 🚀 方案 A: 使用 Umami Cloud（推荐，最简单）

### 步骤 1: 注册 Umami Cloud

1. 访问 https://cloud.umami.is/
2. 点击 **Get Started** 或 **Sign Up**
3. 用 GitHub/Google 账号登录
4. 创建账户

### 步骤 2: 添加网站

1. 登录后进入 Dashboard
2. 点击 **Add Website**
3. 填写信息：
   ```
   网站名称：南风的博客
   域名：ainanfeng.cn
   ```
4. 点击 **Save**

### 步骤 3: 获取追踪代码

保存后，你会看到一个 **Tracking Code**：

```html
<script 
  async 
  defer 
  data-website-id="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" 
  src="https://analytics.umami.is/script.js"
></script>
```

复制这段代码，记下你的 `data-website-id`。

---

## 🚀 方案 B: 自托管 Umami（高级玩家）

### 前置要求

- Docker 已安装
- 有可用的数据库（PostgreSQL/MySQL）
- 有子域名（如 `analytics.ainanfeng.cn`）

### 步骤 1: 准备数据库

```bash
# 创建 PostgreSQL 容器
docker run -d \
  --name umami-db \
  -e POSTGRES_DB=umami \
  -e POSTGRES_USER=umami \
  -e POSTGRES_PASSWORD=your_password \
  -v umami-db-data:/var/lib/postgresql/data \
  postgres:15-alpine
```

### 步骤 2: 运行 Umami

```bash
docker run -d \
  --name umami \
  --link umami-db:db \
  -e DATABASE_URL=postgresql://umami:your_password@db:5432/umami \
  -e DATABASE_TYPE=postgresql \
  -e APP_SECRET=your_secret_key_random_string \
  -p 3000:3000 \
  ghcr.io/umami-software/umami:postgresql-latest
```

### 步骤 3: 初始化

1. 访问 `http://your-server-ip:3000`
2. 默认登录：
   - 用户名：`admin`
   - 密码：`umami`
3. **立即修改密码！**

### 步骤 4: 配置 Nginx 反向代理（可选）

```nginx
server {
    listen 443 ssl;
    server_name analytics.ainanfeng.cn;

    ssl_certificate /etc/letsencrypt/live/ainanfeng.cn/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/ainanfeng.cn/privkey.pem;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

---

## 🚀 步骤 3: 添加到 VitePress

### 方式 A: 直接添加到 index.html（简单）

创建 `/root/.openclaw/workspace/blog/docs/index.html`:

```html
<!DOCTYPE html>
<html lang="zh-CN">
  <head>
    <meta charset="UTF-8" />
    <title>南风的博客</title>
    
    <!-- Umami 统计代码 -->
    <script 
      async 
      defer 
      data-website-id="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" 
      src="https://analytics.umami.is/script.js"
    ></script>
  </head>
  <body>
    <div id="app"></div>
    <script type="module" src="/@vite/client"></script>
    <script type="module" src="/main.ts"></script>
  </body>
</html>
```

⚠️ **注意**: VitePress 通常不需要自定义 index.html，推荐用下面的方式 B。

### 方式 B: 通过 VitePress 配置注入（推荐）

编辑 `/root/.openclaw/workspace/blog/docs/.vitepress/config.js`：

```javascript
import { defineConfig } from 'vitepress'

export default defineConfig({
  title: "南风的博客",
  description: "南风的博客 - 专注于 AI 技术、编程实践与生活感悟的个人博客...",
  
  head: [
    ['link', { rel: 'icon', href: '/logo.png' }],
    
    // SEO Meta 标签（保留现有配置）
    ['meta', { name: 'keywords', content: '南风，博客，AI 技术，编程，深度学习，大模型，教程，生活感悟' }],
    ['meta', { name: 'author', content: '南风' }],
    ['meta', { name: 'robots', content: 'index, follow' }],
    
    // Open Graph 标签
    ['meta', { property: 'og:title', content: '南风的博客 - 记录生活与技术' }],
    ['meta', { property: 'og:description', content: '专注于 AI 技术、编程实践与生活感悟的个人博客' }],
    ['meta', { property: 'og:image', content: 'https://ainanfeng.cn/og-image.png' }],
    ['meta', { property: 'og:url', content: 'https://ainanfeng.cn' }],
    ['meta', { property: 'og:type', content: 'website' }],
    
    // Twitter Card
    ['meta', { name: 'twitter:card', content: 'summary_large_image' }],
    ['meta', { name: 'twitter:title', content: '南风的博客' }],
    ['meta', { name: 'twitter:description', content: '专注于 AI 技术、编程实践与生活感悟的个人博客' }],
    ['meta', { name: 'twitter:image', content: 'https://ainanfeng.cn/og-image.png' }],
    
    // 主题色
    ['meta', { name: 'theme-color', content: '#3B82F6' }],
    
    // 📊 Umami 统计代码
    [
      'script',
      { 
        async: '', 
        defer: '', 
        'data-website-id': 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
        src: 'https://analytics.umami.is/script.js'
      }
    ]
  ],
  
  themeConfig: {
    // ... 其他配置保持不变
  }
})
```

⚠️ **重要**: 将 `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` 替换为你的真实 website ID。

---

## 🚀 步骤 4: 高级配置（可选）

### 追踪特定事件

在组件中添加事件追踪：

```javascript
// 在 Vue 组件中
const trackEvent = (eventName, eventData = {}) => {
  if (window.umami) {
    window.umami.track(eventName, eventData)
  }
}

// 示例：追踪按钮点击
<button @click="trackEvent('download_click', { file: 'resume.pdf' })">
  下载简历
</button>

// 示例：追踪外部链接点击
<a 
  href="https://github.com/nanfeng2021" 
  @click="trackEvent('external_link', { url: 'github' })"
>
  GitHub
</a>
```

### 排除特定页面

在某些页面的 frontmatter 中添加：

```yaml
---
title: 隐私政策
analytics: false  # 不追踪此页面
---
```

然后在 config.js 中处理：

```javascript
head: [
  [
    'script',
    {
      defer: '',
      src: 'https://analytics.umami.is/script.js',
      'data-website-id': 'xxx',
      'data-do-not-track': 'true' // 可以通过 JS 动态控制
    }
  ]
]
```

### 自定义域名（避免广告拦截）

如果你自托管 Umami，可以使用自定义域名：

```javascript
['script', {
  async: '',
  defer: '',
  'data-website-id': 'xxx',
  src: 'https://analytics.ainanfeng.cn/script.js' // 你的域名
}]
```

---

## 🚀 步骤 5: 验证和测试

### 1. 实时查看数据

1. 重新构建并部署博客：
```bash
cd /root/.openclaw/workspace/blog
npm run build
```

2. 访问你的博客：https://ainanfeng.cn
3. 刷新几次页面
4. 回到 Umami Dashboard，应该能看到实时访问数据！

### 2. 检查追踪是否正常

打开浏览器开发者工具（F12），查看：

```javascript
// 控制台输入
console.log(window.umami)
// 应该输出 Umami 对象
```

检查网络请求：
- Network 面板搜索 `script.js` 或 `collect`
- 应该看到向 Umami 服务器的请求

### 3. 测试事件追踪

```javascript
// 控制台手动触发事件
window.umami.track('test_event', { message: 'Hello Umami!' })
```

---

## ✅ 验证清单

- [ ] Umami 账户已注册
- [ ] 网站已添加到 Umami Dashboard
- [ ] 获得了 website ID
- [ ] 追踪代码已添加到 config.js
- [ ] 重新构建了博客
- [ ] 访问博客后能在 Umami 看到数据
- [ ] 实时访客数正常显示
- [ ] 页面浏览量统计准确

---

## 📊 你可以看到的数据

Umami Dashboard 提供以下数据：

### 概览
- 📈 页面浏览量（PV）
- 👥 独立访客（UV）
- ⏱️ 平均停留时间
- 📉 跳出率

### 详细分析
- 🌍 访客地理位置
- 💻 设备类型（桌面/移动/平板）
- 🖥️ 浏览器分布
- 🔗 引荐来源
- 📱 操作系统
- 📄 热门页面
- 🔍 搜索关键词（如果集成）

### 实时数据
- 👀 当前在线人数
- 📍 实时位置地图
- 📄 正在浏览的页面

---

## 💡 高级技巧

### 1. 分享公开报表

Umami 支持生成公开分享的报表链接：
1. 在 Dashboard 选择网站
2. 点击右上角 **Share**
3. 生成公开链接
4. 可以嵌入到"关于"页面展示访问量！

### 2. 设置目标转化

追踪特定行为（如订阅、下载）：
```javascript
window.umami.track('newsletter_signup', { source: 'footer' })
```

### 3. 导出数据

Umami 支持导出 CSV 数据：
- Dashboard → Settings → Export Data
- 可用于深度分析或备份

### 4. 多网站管理

如果你有多个项目，可以在一个 Umami 账户管理所有网站统计。

---

## ⚠️ 常见问题

### Q: 数据不更新？
A: Umami 有几分钟延迟，等待 5-10 分钟再查看。

### Q: 被广告拦截器屏蔽？
A: 使用自定义域名或考虑 Fathom Analytics（付费）。

### Q: 如何删除测试数据？
A: 在 Dashboard → Settings → Reset Website 重置数据。

### Q: 能追踪登录用户吗？
A: 可以！使用 `umami.identify()` API（需注意隐私政策）。

---

## 🎯 下一步

统计分析完成后，继续：
1. ✅ 集成评论系统
2. ✅ 启用站内搜索
3. ✅ 接入统计分析 ← 你在这里
4. ⏭️ 美化设计

---

## 🔗 相关资源

- Umami 官网：https://umami.is/
- Umami 文档：https://umami.is/docs/
- Umami Cloud：https://cloud.umami.is/
- GitHub: https://github.com/umami-software/umami

---

**预计用时**: 30 分钟  
**难度**: ⭐⭐☆☆☆  
**费用**: 免费（Cloud 版有免费额度，自托管完全免费）
