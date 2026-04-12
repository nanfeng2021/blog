# 🗨️ Giscus 评论系统配置指南

## 📋 你的仓库信息

**仓库**: nanfeng2021/ai-learning-journey  
**仓库 ID**: 1192532523 (已获取)  
**状态**: ✅ Discussions 已启用

---

## 🚀 获取 Giscus 配置参数

### 步骤 1: 访问 Giscus 配置工具

打开：https://giscus.app/zh-CN

### 步骤 2: 填写配置表单

按以下内容填写：

```
Repository（仓库）: nanfeng2021/ai-learning-journey
```

点击 **"在此仓库上运行 Giscus"** 按钮。

如果提示权限问题，请授权 Giscus GitHub App。

### 步骤 3: 选择分类

在 "Discussion category" 下拉菜单中选择：
```
Announcements（公告）
```

然后点击 **"Get"** 按钮获取分类 ID。

### 步骤 4: 复制配置参数

Giscus 会生成一段代码，类似这样：

```html
<script src="https://giscus.app/client.js"
        data-repo="nanfeng2021/ai-learning-journey"
        data-repo-id="R_kgDOJxxxxx"  
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

**你需要复制这两个值**:
1. `data-repo-id` - 例如：`R_kgDOJxxxxx`
2. `data-category-id` - 例如：`DIC_kwDOxxxxxx`

---

## 📝 或者手动获取（如果自动获取失败）

### 方法 A: 通过 GitHub API

```bash
# 获取仓库 ID
curl -s https://api.github.com/repos/nanfeng2021/ai-learning-journey | grep '"id"'

# 获取分类 ID（需要先创建一个 Announcements 讨论）
# 访问：https://github.com/nanfeng2021/ai-learning-journey/discussions/categories/announcements
# 然后查看页面源码或使用浏览器开发者工具
```

### 方法 B: 直接在浏览器控制台获取

1. 打开：https://github.com/nanfeng2021/ai-learning-journey/discussions
2. 按 `F12` 打开开发者工具
3. 切换到 **Console** 标签
4. 粘贴以下代码并回车：

```javascript
// 获取仓库信息
fetch('https://api.github.com/repos/nanfeng2021/ai-learning-journey')
  .then(r => r.json())
  .then(data => {
    console.log('Repository ID:', data.node_id)
  })

// 获取分类信息（需要先有 Announcements 分类的讨论）
// 访问 discussions 页面后，在 Elements 中找到 category 的 data-id 属性
```

---

## ⚙️ 配置到博客

获取到参数后，编辑文件：

```bash
nano /root/.openclaw/workspace/blog/docs/.vitepress/theme/components/GiscusComment.vue
```

找到这两行：

```vue
data-repo-id="R_kgDOxxxxxx"  
data-category-id="DIC_kwDOxxxxxx"
```

替换为你从 giscus.app 获取的真实值！

---

## ✅ 验证

重新构建并部署：

```bash
cd /root/.openclaw/workspace/blog
npm run build
sudo cp -r docs/.vitepress/dist/* /var/www/ainanfeng.cn/
```

然后访问任意文章页面：
- https://ainanfeng.cn/posts/blog-transformation
- 滚动到底部
- 应该看到评论框！

---

## 💡 常见问题

### Q: 看不到 "在此仓库上运行 Giscus" 按钮？
A: 确保你已登录 GitHub，并且是该仓库的管理员。

### Q: 没有 Announcements 分类？
A: 在 Discussions 页面 → Categories → 添加 "Announcements" 分类。

### Q: 评论框不显示？
A: 
1. 检查浏览器控制台（F12）是否有错误
2. 确认 repo-id 和 category-id 正确
3. 清除浏览器缓存

---

## 🎯 快速测试

配置完成后：

1. 访问文章页面
2. 用 GitHub 账号登录评论框
3. 发布第一条评论："测试评论系统！🎉"
4. 在 GitHub Discussions 中应该能看到这条评论

---

_最后更新：2026-04-02_  
_仓库：nanfeng2021/ai-learning-journey_
