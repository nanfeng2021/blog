# 🗨️ 集成 Giscus 评论系统

## 📋 前置要求

- ✅ 你有 GitHub 账号
- ✅ 你的博客代码在 GitHub 仓库中（`nanfeng2021/nanfeng2021.github.io`）

---

## 🚀 步骤 1: 启用 GitHub Discussions

1. 访问你的仓库：https://github.com/nanfeng2021/nanfeng2021.github.io
2. 点击 **Settings**（设置）
3. 滚动到 **Features** 部分
4. 勾选 ✅ **Discussions**
5. 点击 **Save**

---

## 🚀 步骤 2: 配置 Giscus

1. 访问 Giscus 官网：https://giscus.app/zh-CN
2. 按以下步骤操作：

### 填写配置表单

```
仓库：nanfeng2021/nanfeng2021.github.io
仓库 ID: （自动生成，点击"获取"）
分类：Announcements（公告）
分类 ID: （自动生成）
讨论权限：任何人可以创建讨论 ✓
```

### 高级配置（推荐）

```
主题：preferred_color_scheme（自动跟随明暗模式）✓
语言：zh-CN（中文）✓
反应：启用 ✓
元数据：不发送 ✓
输入框位置：底部 ✓
```

### 获取代码

向下滚动到 **"添加此代码到你的网站"**，复制 `<script>` 标签中的内容。

格式类似：
```html
<script src="https://giscus.app/client.js"
        data-repo="nanfeng2021/nanfeng2021.github.io"
        data-repo-id="R_kgDOxxxxxx"
        data-category="Announcements"
        data-category-id="DIC_kwDOxxxxxx"
        data-mapping="pathname"
        data-strict="0"
        data-reactions-enabled="1"
        data-emit-metadata="0"
        data-input-position="bottom"
        data-theme="preferred_color_scheme"
        data-lang="zh-CN"
        crossorigin="anonymous"
        async>
</script>
```

---

## 🚀 步骤 3: 添加到 VitePress 主题

### 方式 A: 全局评论（所有页面显示）

创建自定义布局组件：

```bash
mkdir -p /root/.openclaw/workspace/blog/docs/.vitepress/theme/components
```

创建文件 `/root/.openclaw/workspace/blog/docs/.vitepress/theme/components/Giscus.vue`:

```vue
<template>
  <div class="giscus-container">
    <component :is="'script'" 
      src="https://giscus.app/client.js"
      data-repo="nanfeng2021/nanfeng2021.github.io"
      data-repo-id="R_kgDOxxxxxx"
      data-category="Announcements"
      data-category-id="DIC_kwDOxxxxxx"
      data-mapping="pathname"
      data-strict="0"
      data-reactions-enabled="1"
      data-emit-metadata="0"
      data-input-position="bottom"
      data-theme="preferred_color_scheme"
      data-lang="zh-CN"
      crossorigin="anonymous"
      async
    />
  </div>
</template>

<script setup>
// Giscus 会自动加载
</script>

<style scoped>
.giscus-container {
  margin-top: 3rem;
  padding-top: 2rem;
  border-top: 1px solid var(--vp-c-divider);
}
</style>
```

⚠️ **注意**: 将 `data-repo-id` 和 `data-category-id` 替换为你从 giscus.app 获取的真实值。

### 方式 B: 仅文章页面显示评论（推荐）

编辑 `/root/.openclaw/workspace/blog/docs/.vitepress/theme/Layout.vue`:

```vue
<script setup>
import DefaultTheme from 'vitepress/theme'
import { useData, useRoute } from 'vitepress'
import { computed, watch, nextTick } from 'vue'

const { theme, frontmatter } = useData()
const route = useRoute()

const showComments = computed(() => {
  // 仅在文章页面显示评论
  return route.path.startsWith('/posts/') && frontmatter.value.comment !== false
})

// 路由变化时重新加载 Giscus
watch(
  () => route.path,
  () => {
    nextTick(() => {
      const iframe = document.querySelector('iframe.giscus-frame')
      if (iframe) {
        iframe.remove()
      }
    })
  }
)
</script>

<template>
  <DefaultTheme.Layout>
    <template #doc-after>
      <ClientOnly>
        <div v-if="showComments" class="giscus-wrapper">
          <script 
            src="https://giscus.app/client.js"
            data-repo="nanfeng2021/nanfeng2021.github.io"
            data-repo-id="R_kgDOxxxxxx"
            data-category="Announcements"
            data-category-id="DIC_kwDOxxxxxx"
            data-mapping="pathname"
            data-strict="0"
            data-reactions-enabled="1"
            data-emit-metadata="0"
            data-input-position="bottom"
            data-theme="preferred_color_scheme"
            data-lang="zh-CN"
            crossorigin="anonymous"
            async
          />
        </div>
      </ClientOnly>
    </template>
  </DefaultTheme.Layout>
</template>

<style>
.giscus-wrapper {
  margin-top: 3rem;
  padding: 2rem 0;
  border-top: 1px solid var(--vp-c-divider);
}

/* 暗黑模式适配 */
html.dark .giscus-wrapper {
  border-top-color: var(--vp-c-divider-dark);
}
</style>
```

---

## 🚀 步骤 4: 自定义主题（可选）

如果你想自定义 Giscus 的颜色方案，可以在 giscus.app 上选择：

- **light**: 浅色主题
- **dark**: 深色主题  
- **preferred_color_scheme**: 自动跟随系统（推荐）
- **transparent_dark**: 透明深色背景

也可以自定义 CSS 变量：

```css
:root {
  --giscus-body-color: #333;
  --giscus-border-color: #e1e4e8;
  --giscus-header-text-color: #0366d6;
  --giscus-input-bg-color: #fff;
  --giscus-btn-primary-color: #0366d6;
}

html.dark {
  --giscus-body-color: #c9d1d9;
  --giscus-border-color: #30363d;
  --giscus-header-text-color: #58a6ff;
  --giscus-input-bg-color: #0d1117;
  --giscus-btn-primary-color: #238636;
}
```

---

## 🚀 步骤 5: 测试评论

1. 重新构建博客：
```bash
cd /root/.openclaw/workspace/blog
npm run build
```

2. 访问任意文章页面（如 `/posts/welcome`）
3. 滚动到文章底部，应该看到评论框
4. 用 GitHub 账号登录并发布第一条评论！

---

## ✅ 验证清单

- [ ] GitHub Discussions 已启用
- [ ] Giscus 配置完成并获取了 repo-id 和 category-id
- [ ] 代码已添加到 VitePress 主题
- [ ] 重新构建了博客
- [ ] 文章页面底部显示评论框
- [ ] 可以成功发表评论
- [ ] 明暗模式切换正常

---

## 💡 高级用法

### 在特定页面禁用评论

在文章的 frontmatter 中添加：
```yaml
---
title: 文章标题
comment: false  # 禁用评论
---
```

### 评论通知

Giscus 支持多种通知方式：
- GitHub 通知（默认）
- 邮件通知（需要在 GitHub 设置）
- RSS Feed: `https://giscus.app/api/rss?repo=xxx`

### 管理评论

所有评论都在 GitHub Discussions 中管理：
- 访问：https://github.com/nanfeng2021/nanfeng2021.github.io/discussions
- 可以删除、编辑、置顶评论

---

## ⚠️ 常见问题

### Q: 评论框不显示？
A: 检查浏览器控制台是否有错误，确认 repo-id 和 category-id 正确。

### Q: 如何删除不当评论？
A: 在 GitHub Discussions 中删除对应讨论。

### Q: 可以自定义样式吗？
A: 可以！通过 CSS 覆盖 `.giscus-frame` 的样式。

---

## 🎯 下一步

评论系统集成完成后，继续：
1. ✅ 集成评论系统 ← 你在这里
2. ⏭️ 启用站内搜索
3. ⏭️ 接入统计分析
4. ⏭️ 美化设计

---

**预计用时**: 45 分钟  
**难度**: ⭐⭐⭐☆☆  
**依赖**: GitHub 账号 + 仓库
