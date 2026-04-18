import { defineConfig } from 'vitepress'

const CONFIG_VERSION = '20260416-gray'

export default defineConfig({
  title: "南风的博客",
  description: "南风的博客 - 灰度测试环境",
  
  // 🚨 灰度测试关键配置
  base: '/gray/',
  
  ignoreDeadLinks: true,
  
  head: [
    ['meta', { name: 'config-version', content: CONFIG_VERSION }],
    ['meta', { name: 'environment', content: 'gray-test' }],
    ['meta', { name: 'robots', content: 'noindex, nofollow' }],
    ['link', { rel: 'icon', href: '/gray/logo.png' }]
  ],
  
  themeConfig: {
    // 顶部提示条
    banner: {
      text: '🧪 灰度测试环境 - 新功能验证中',
      link: '/gray/'
    },
    
    search: {
      provider: 'local',
      options: {
        locales: {
          root: {
            translations: {
              button: { buttonText: '搜索' },
              modal: { noResultsText: '无法找到相关结果' }
            }
          }
        }
      }
    },
    
    nav: [
      { text: '首页', link: '/' },
      { text: '文章', link: '/posts/' },
      { text: '🤖 AI 与大模型', link: '/ai-projects' },
      { text: '关于', link: '/about' }
    ],
    
    socialLinks: [
      { icon: 'github', link: 'https://github.com/nanfeng2021' }
    ],
    
    footer: {
      message: '🧪 Gray Test Environment',
      copyright: 'Copyright © 2026 南风'
    }
  },
  
  // SSR 配置
  ssr: {
    noExternal: ['vitepress']
  },
  
  // Markdown 配置
  markdown: {
    image: {
      lazyLoading: true
    }
  }
})
