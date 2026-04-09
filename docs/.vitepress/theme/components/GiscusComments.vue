<script setup>
import { onMounted, watch, ref } from 'vue'
import { useRoute } from 'vitepress'

const route = useRoute()
const utterancesLoaded = ref(false)

onMounted(() => {
  if (route.path.startsWith('/posts/')) {
    setTimeout(loadUtterances, 300)
  }
})

watch(() => route.path, () => {
  utterancesLoaded.value = false
  if (route.path.startsWith('/posts/')) {
    setTimeout(loadUtterances, 300)
  }
})

const loadUtterances = () => {
  if (utterancesLoaded.value) return
  
  const container = document.getElementById('utterances-container')
  if (!container) return
  
  // 清理旧的
  container.innerHTML = ''
  
  // 创建 script
  const script = document.createElement('script')
  script.src = 'https://utteranc.es/client.js'
  script.setAttribute('repo', 'nanfeng2021/ai-learning-journey')
  script.setAttribute('issue-term', 'pathname')
  script.setAttribute('theme', 'github-light')
  script.setAttribute('crossorigin', 'anonymous')
  script.async = true
  
  container.appendChild(script)
  utterancesLoaded.value = true
}
</script>

<template>
  <div class="comments-section">
    <h3 class="comments-title">💬 评论</h3>
    <div id="utterances-container"></div>
  </div>
</template>

<style scoped>
.comments-section {
  margin-top: 3rem;
  padding-top: 2rem;
  border-top: 1px solid var(--vp-c-divider);
}

.comments-title {
  font-size: 1.25rem;
  font-weight: 600;
  color: var(--vp-c-text-1);
  margin-bottom: 1.5rem;
}

html.dark .comments-section {
  border-top-color: var(--vp-c-divider-dark);
}

#utterances-container {
  min-height: 200px;
}
</style>
