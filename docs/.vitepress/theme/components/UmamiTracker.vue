<script setup>
import { onMounted } from 'vue'
import { useRoute, useRouter } from 'vitepress'

const route = useRoute()
const router = useRouter()

// 初始化 Umami 追踪
onMounted(() => {
  // 追踪页面浏览
  trackPageView()
  
  // 追踪外部链接点击
  setupExternalLinkTracking()
  
  // 追踪主题切换
  setupThemeTracking()
  
  // 追踪搜索行为
  setupSearchTracking()
})

// 追踪页面浏览
const trackPageView = () => {
  if (window.umami) {
    window.umami.track('page_view', {
      path: route.path,
      title: document.title
    })
  }
}

// 追踪外部链接点击
const setupExternalLinkTracking = () => {
  document.addEventListener('click', (e) => {
    const link = e.target.closest('a')
    if (link && link.href) {
      const url = new URL(link.href)
      if (url.hostname !== window.location.hostname) {
        if (window.umami) {
          window.umami.track('external_link', {
            url: url.hostname,
            fullUrl: link.href,
            text: link.textContent?.trim() || 'Link'
          })
        }
      }
    }
  })
}

// 追踪主题切换
const setupThemeTracking = () => {
  const themeToggle = document.querySelector('.VPSwitchAppearance')
  if (themeToggle) {
    themeToggle.addEventListener('click', () => {
      setTimeout(() => {
        const isDark = document.documentElement.classList.contains('dark')
        if (window.umami) {
          window.umami.track('theme_change', {
            theme: isDark ? 'dark' : 'light'
          })
        }
      }, 100)
    })
  }
}

// 追踪搜索行为
const setupSearchTracking = () => {
  const searchButton = document.querySelector('.DocSearch-Button')
  if (searchButton) {
    searchButton.addEventListener('click', () => {
      if (window.umami) {
        window.umami.track('search_open', {})
      }
    })
  }
  
  // 监听搜索输入（使用事件委托）
  document.addEventListener('keydown', (e) => {
    if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
      e.preventDefault()
      if (window.umami) {
        window.umami.track('search_keyboard', {
          shortcut: 'Ctrl/Cmd+K'
        })
      }
    }
  })
}

// 路由变化时重新追踪页面浏览
router.onAfterRouteChanged = (to) => {
  trackPageView()
}
</script>

<template>
  <!-- 这个组件不需要渲染任何内容，只负责逻辑 -->
</template>

<style scoped>
/* 无样式 */
</style>
