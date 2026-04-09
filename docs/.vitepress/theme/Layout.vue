<script setup>
import DefaultTheme from 'vitepress/theme'
import { useRoute } from 'vitepress'
import { ref, onMounted, watch } from 'vue'
import ReadingProgress from './components/ReadingProgress.vue'
import SocialShare from './components/SocialShare.vue'

const route = useRoute()
const isInPostsPage = ref(false)
const commentsLoaded = ref(false)

// 加载 Utterances 评论
const loadComments = () => {
  if (commentsLoaded.value) return
  
  const container = document.getElementById('utterances-container')
  if (!container) return
  
  container.innerHTML = ''
  
  const script = document.createElement('script')
  script.src = 'https://utteranc.es/client.js'
  script.setAttribute('repo', 'nanfeng2021/ai-learning-journey')
  script.setAttribute('issue-term', 'pathname')
  script.setAttribute('theme', 'preferred-color-scheme')
  script.setAttribute('crossorigin', 'anonymous')
  script.async = true
  
  container.appendChild(script)
  commentsLoaded.value = true
}

onMounted(() => {
  isInPostsPage.value = route.path.startsWith('/posts/')
  if (isInPostsPage.value) {
    setTimeout(loadComments, 300)
  }
})

watch(() => route.path, () => {
  isInPostsPage.value = route.path.startsWith('/posts/')
  commentsLoaded.value = false
  if (isInPostsPage.value) {
    setTimeout(loadComments, 300)
  }
})
</script>

<template>
  <div class="layout-wrapper">
    <!-- 阅读进度条 -->
    <ReadingProgress />
    
    <!-- 默认主题布局 -->
    <DefaultTheme.Layout>
      <!-- 文章底部：分享 + 评论 -->
      <template #doc-after>
        <div v-if="isInPostsPage" class="article-footer">
          <!-- 分享按钮 -->
          <SocialShare />
          
          <!-- 评论区 -->
          <div class="comments-section">
            <h3 class="comments-title">💬 评论</h3>
            <div id="utterances-container"></div>
          </div>
        </div>
      </template>
    </DefaultTheme.Layout>
  </div>
</template>

<style scoped>
.layout-wrapper {
  position: relative;
}

.article-footer {
  margin-top: 2rem;
}

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
</style>
