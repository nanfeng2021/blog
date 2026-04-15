#!/bin/bash

# 灰度测试构建脚本
# 用法：./build-gray.sh [feature-name]

FEATURE_NAME=${1:-"new-feature"}
GRAY_DIR="docs/.vitepress/gray"
GRAY_DIST="docs/.vitepress/dist-gray"

echo "🔧 开始构建灰度测试环境..."
echo "📦 功能名称：$FEATURE_NAME"
echo ""

# 创建灰度输出目录
mkdir -p "$GRAY_DIST"

# 修改 VitePress 配置，设置 base 路径为 /gray/
cat > docs/.vitepress/gray/config.js << 'EOF'
import { defineConfig } from 'vitepress'

const CONFIG_VERSION = '20260412-0953'

export default defineConfig({
  title: "南风的博客 - 灰度测试",
  description: "灰度测试版本 - 新功能验证环境",
  
  // 🚨 灰度测试关键配置：base 路径
  base: '/gray/',
  
  ignoreDeadLinks: true,
  
  head: [
    ['meta', { name: 'config-version', content: CONFIG_VERSION }],
    ['meta', { name: 'environment', content: 'gray-test' }],
    ['link', { rel: 'icon', href: '/logo.png' }],
    
    // SEO - 禁止灰度环境被索引
    ['meta', { name: 'robots', content: 'noindex, nofollow' }],
    
    // Umami 统计（可选）
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
  
  themeConfig: {
    // 顶部提示条
    banner: {
      text: '🚧 灰度测试环境 - 新功能验证中',
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
      { text: '关于', link: '/about' },
      { 
        text: '🧪 灰度测试', 
        link: '/gray/ai-learning-roadmap',
        items: [
          { text: '路线图 (Gray)', link: '/gray/ai-learning-roadmap' },
          { text: '订阅页 (Gray)', link: '/gray/subscribe' }
        ]
      }
    ],
    
    socialLinks: [
      { icon: 'github', link: 'https://github.com/nanfeng2021' }
    ],
    
    footer: {
      message: '🧪 Gray Test Environment',
      copyright: 'Copyright © 2026 南风 - 灰度测试版'
    }
  }
})
EOF

echo "✅ 灰度配置文件已创建"
echo ""
echo "📝 使用说明："
echo "1. 将新功能文件复制到 gray/ 目录"
echo "2. 运行：npm run build-gray"
echo "3. 访问：https://ainanfeng.cn/gray/[page]"
echo "4. 测试通过后，再替换生产环境文件"
echo ""
