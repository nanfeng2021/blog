import { defineConfig } from 'vitepress'

// 配置版本号，用于强制刷新缓存
const CONFIG_VERSION = '20260412-0953'

export default defineConfig({
  title: "南风的博客",
  description: "南风的博客 - 专注于 AI 技术、编程实践与生活感悟的个人博客。分享深度学习、大模型应用、开发教程等高质量内容，记录技术成长之路。",
  
  // 忽略死链检查（外部链接和本地服务链接）
  ignoreDeadLinks: true,
  
  // 基础路径配置（支持灰度环境）
  base: process.env.VITEPRESS_BASE || '/',
  
  // 添加版本标记到 head
  head: [
    ['meta', { name: 'config-version', content: CONFIG_VERSION }],
    ['link', { rel: 'icon', href: '/logo.png' }],
    
    // SEO Meta 标签
    ['meta', { name: 'keywords', content: '南风，博客，AI 技术，编程，深度学习，大模型，教程，生活感悟' }],
    ['meta', { name: 'author', content: '南风' }],
    ['meta', { name: 'robots', content: 'index, follow' }],
    
    // Open Graph 标签（社交媒体分享优化）
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
    
    // 其他 SEO 优化
    ['meta', { name: 'theme-color', content: '#3B82F6' }],
    ['meta', { name: 'color-scheme', content: 'light dark' }],
    ['meta', { name: 'supported-color-schemes', content: 'light dark' }],
    
    // 📊 Umami 统计代码
    [
      'script',
      { 
        async: '', 
        defer: '', 
        'data-website-id': '9e8a9e8d-51e0-4f3c-80c0-27721b1b62a1',
        src: 'https://cloud.umami.is/script.js'
      }
    ]
  ],
  
  // 启用暗色模式
  appearance: 'dark',
  
  themeConfig: {
    // 🔍 站内搜索配置
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
        
        // 搜索高级选项
        miniSearch: {
          options: {
            fields: ['title', 'titles', 'content'],
            storeFields: ['title', 'titles'],
            searchOptions: {
              fuzzy: 0.2,
              prefix: true,
              boost: { title: 4, content: 2, titles: 1 }
            }
          }
        }
      }
    },
    
    // 顶部导航
    nav: [
      { text: '首页', link: '/' },
      { 
        text: '文章', 
        link: '/posts/',
        items: [
          { text: '📚 所有文章', link: '/posts/' },
          { text: '🗺️ AI 学习路线图', link: '/ai-learning-roadmap' },
          { text: '🎓 AI 学习中心', link: '/ai-learning/' }
        ]
      },
      { text: '🤖 AI 与大模型', link: '/ai-projects' },
      { text: '关于', link: '/about' }
    ],

    // 侧边栏
    sidebar: [
      {
        text: '最新文章',
        items: [
          { text: '🎉 博客改造全记录', link: '/posts/blog-transformation' },
          { text: 'AI 发展简史', link: '/posts/ai-history' },
          { text: '欢迎来到我的博客', link: '/posts/welcome' }
        ]
      },
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
    },
    
    // 🗨️ 评论系统配置（Giscus）
    // 在文章页面底部显示评论，需要在主题组件中添加
  }
})
