<template>
  <div class="giscus-comments" v-if="showComments">
    <div ref="commentsRef"></div>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue'
import { useData } from 'vitepress'

const { isDark } = useData()
const commentsRef = ref(null)
const showComments = ref(false)

// Giscus 配置
const config = {
  src: 'https://giscus.app/client.js',
  'data-repo': 'nanfeng2021/blog',
  'data-repo-id': 'R_kgDOKxqQjA', // 需要替换为实际的 repo ID
  'data-category': 'General',
  'data-category-id': 'DIC_kwDOKxqQjM4Cg8N9', // 需要替换为实际的 category ID
  'data-mapping': 'pathname',
  'data-strict': '0',
  'data-reactions-enabled': '1',
  'data-emit-metadata': '0',
  'data-input-position': 'bottom',
  'data-theme': 'preferred_color_scheme',
  'data-lang': 'zh-CN',
  'crossorigin': 'anonymous',
  'async': true
}

onMounted(() => {
  // 延迟加载评论组件，避免阻塞主内容
  setTimeout(() => {
    loadGiscus()
    showComments.value = true
  }, 1000)
})

// 监听主题变化
watch(isDark, () => {
  sendMessage({ setConfig: { theme: isDark.value ? 'dark' : 'light' } })
})

function loadGiscus() {
  if (!commentsRef.value) return
  
  const script = document.createElement('script')
  script.src = config.src
  script.async = true
  script.crossOrigin = 'anonymous'
  
  // 设置所有 data 属性
  Object.entries(config).forEach(([key, value]) => {
    if (key !== 'src') {
      script.setAttribute(key, value)
    }
  })
  
  commentsRef.value.appendChild(script)
}

function sendMessage(message) {
  const iframe = document.querySelector('iframe.giscus-frame')
  if (!iframe) return
  
  iframe.contentWindow.postMessage({ giscus: message }, 'https://giscus.app')
}
</script>

<style scoped>
.giscus-comments {
  margin-top: 3rem;
  padding-top: 2rem;
  border-top: 1px solid var(--vp-c-divider);
}

/* 暗色模式适配 */
.dark .giscus-comments {
  border-top-color: var(--vp-c-divider-dark);
}
</style>
