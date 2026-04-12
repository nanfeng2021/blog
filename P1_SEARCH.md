# 🔍 启用 VitePress 站内搜索

## 📋 概述

VitePress 内置了强大的本地搜索功能，无需外部服务，基于 Minisearch 实现全文索引。

---

## 🚀 步骤 1: 配置搜索

编辑 `/root/.openclaw/workspace/blog/docs/.vitepress/config.js`：

```javascript
import { defineConfig } from 'vitepress'

export default defineConfig({
  title: "南风的博客",
  description: "南风的博客 - 专注于 AI 技术、编程实践与生活感悟的个人博客...",
  
  head: [
    // ... 现有的 head 配置保持不变
  ],
  
  themeConfig: {
    // 搜索配置
    search: {
      provider: 'local',
      options: {
        locales: {
          root: {
            translations: {
              button: {
                buttonText: '搜索',
                buttonAriaLabel: '搜索文章'
              },
              modal: {
                noResultsText: '无法找到相关结果',
                resetButtonTitle: '清除查询条件',
                footer: {
                  selectText: '选择',
                  navigateText: '切换',
                  closeText: '关闭',
                },
                displayDetails: '显示详细信息',
              }
            }
          }
        },
        
        // 高级选项
        miniSearch: {
          /**
           * @type {Pick<import('minisearch').Options, 'extractField' | 'tokenize' | 'processTerm'>}
           */
          options: {
            fields: ['title', 'titles', 'content'],
            storeFields: ['title', 'titles'],
            searchOptions: {
              fuzzy: 0.2,  // 模糊匹配容错率
              prefix: true, // 前缀匹配
              boost: { title: 4, content: 2, titles: 1 } // 标题权重更高
            }
          }
        },
        
        // 搜索内容裁剪
        _render(src, env, md) {
          const html = md.render(src, env)
          // 限制搜索结果摘要长度
          return html.slice(0, 200)
        }
      }
    },
    
    // 顶部导航
    nav: [
      { text: '首页', link: '/' },
      { text: '文章', link: '/posts/' },
      { text: '关于', link: '/about' }
    ],

    // 侧边栏
    sidebar: [
      {
        text: 'AI 与技术',
        items: [
          { text: 'AI 发展简史', link: '/posts/ai-history' },
          { text: '欢迎来到我的博客', link: '/posts/welcome' }
        ]
      }
    ],

    // 社交链接
    socialLinks: [
      { icon: 'github', link: 'https://github.com/nanfeng2021' }
    ],

    // 页脚
    footer: {
      message: 'Made with ❤️ by 南风',
      copyright: 'Copyright © 2026 南风'
    }
  }
})
```

---

## 🚀 步骤 2: 自定义搜索样式（可选）

创建 `/root/.openclaw/workspace/blog/docs/.vitepress/theme/custom-search.css`:

```css
/* 搜索按钮样式 */
.DocSearch-Button {
  background-color: var(--vp-c-bg-elv);
  border: 1px solid var(--vp-c-divider);
  border-radius: 8px;
  padding: 0 12px;
  height: 36px;
  transition: all 0.3s ease;
}

.DocSearch-Button:hover {
  border-color: var(--vp-c-brand);
  box-shadow: 0 0 0 2px rgba(59, 130, 246, 0.1);
}

.DocSearch-Button-Placeholder {
  color: var(--vp-c-text-2);
  font-size: 14px;
}

.DocSearch-Button-Keys {
  display: flex;
  gap: 4px;
}

.DocSearch-Button-Key {
  background: var(--vp-c-bg-alt);
  border: 1px solid var(--vp-c-divider);
  border-radius: 4px;
  padding: 2px 6px;
  font-size: 12px;
  font-family: monospace;
  color: var(--vp-c-text-2);
}

/* 搜索模态框样式 */
.DocSearch-Modal {
  background: var(--vp-c-bg);
  border-radius: 12px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
}

.DocSearch-Form {
  background: var(--vp-c-bg-elv);
  border-radius: 8px;
  border: 1px solid var(--vp-c-divider);
}

.DocSearch-Input {
  color: var(--vp-c-text-1);
  font-size: 16px;
}

.DocSearch-Hit-source {
  color: var(--vp-c-brand);
  font-weight: 600;
}

.DocSearch-Hit-title {
  color: var(--vp-c-text-1);
}

.DocSearch-Hit-path {
  color: var(--vp-c-text-2);
}

.DocSearch-Hit[aria-selected='true'] .DocSearch-Hit-title {
  color: var(--vp-c-white);
}

/* 暗黑模式适配 */
html.dark .DocSearch-Modal {
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.4);
}

html.dark .DocSearch-Hit[aria-selected='true'] {
  background: var(--vp-c-brand);
}
```

然后在 `.vitepress/theme/index.js` 中引入：

```javascript
import DefaultTheme from 'vitepress/theme'
import './custom-search.css'

export default DefaultTheme
```

---

## 🚀 步骤 3: 优化搜索内容

### 排除不需要搜索的页面

在 frontmatter 中添加 `search: false`:

```yaml
---
title: 关于我
search: false  # 不出现在搜索结果中
---
```

### 自定义搜索权重

在 frontmatter 中设置：

```yaml
---
title: 重要教程
searchRank: 10  # 更高的排名（默认 1）
---
```

### 添加搜索关键词

```yaml
---
title: AI 发展简史
keywords: [人工智能，历史，机器学习，深度学习]  # 额外搜索词
---
```

---

## 🚀 步骤 4: 快捷键支持

VitePress 搜索默认支持以下快捷键：

- `Ctrl + K` / `Cmd + K`: 打开搜索
- `Esc`: 关闭搜索
- `↑` `↓`: 上下选择
- `Enter`: 打开选中项
- `Tab`: 切换到下一个结果组

这些快捷键已经内置，无需额外配置！

---

## 🚀 步骤 5: 测试搜索

1. 重新构建博客：
```bash
cd /root/.openclaw/workspace/blog
npm run build
```

2. 访问博客首页
3. 按 `Ctrl + K` (或 `Cmd + K`) 打开搜索
4. 输入关键词如 "AI"、"欢迎" 等
5. 查看搜索结果是否正确显示

---

## ✅ 验证清单

- [ ] 搜索配置已添加到 config.js
- [ ] 导航栏显示搜索图标/按钮
- [ ] 按 `Ctrl + K` 可以打开搜索框
- [ ] 输入关键词能显示正确结果
- [ ] 搜索结果包含标题和摘要
- [ ] 点击结果能正确跳转
- [ ] 明暗模式切换正常
- [ ] 移动端显示正常

---

## 💡 高级技巧

### 1. 搜索特定分类

用户可以通过前缀搜索特定分类：
```
category:AI   # 搜索 AI 分类下的内容
tag:教程      # 搜索标签为"教程"的内容
```

### 2. 多语言搜索

如果你的博客有多语言版本：

```javascript
search: {
  provider: 'local',
  options: {
    locales: {
      root: {
        // 中文配置
        translations: { /* ... */ }
      },
      en: {
        // 英文配置
        translations: {
          button: {
            buttonText: 'Search',
            buttonAriaLabel: 'Search docs'
          },
          modal: {
            noResultsText: 'No results found',
            // ...
          }
        }
      }
    }
  }
}
```

### 3. 搜索结果分组

按内容类型分组显示：

```javascript
miniSearch: {
  options: {
    processTerm: (term) => {
      // 自定义分词逻辑
      return term.toLowerCase()
    }
  }
}
```

---

## ⚠️ 常见问题

### Q: 搜索不到新文章？
A: 重新构建博客，搜索索引会在构建时更新。

### Q: 搜索结果太多？
A: 调整 `miniSearch.searchOptions.boost` 权重，或增加内容过滤。

### Q: 搜索性能慢？
A: 如果文章很多（>1000 篇），考虑使用 Algolia 搜索。

### Q: 如何禁用搜索快捷键？
A: 在 CSS 中添加：
```css
.DocSearch-Button-Key {
  display: none;
}
```

---

## 🎯 下一步

搜索功能完成后，继续：
1. ✅ 集成评论系统
2. ✅ 启用站内搜索 ← 你在这里
3. ⏭️ 接入统计分析
4. ⏭️ 美化设计

---

**预计用时**: 30 分钟  
**难度**: ⭐⭐☆☆☆  
**依赖**: 无
