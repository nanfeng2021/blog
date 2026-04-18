<script setup>
import DefaultTheme from 'vitepress/theme'
import { useRoute } from 'vitepress'
import { ref, onMounted, watch, computed } from 'vue'
import { useData } from 'vitepress'
import ReadingProgress from './components/ReadingProgress.vue'
import ThemeToggle from './components/ThemeToggle.vue'
import TableOfContents from './components/TableOfContents.vue'
import GiscusComments from './components/GiscusComments.vue'
import SocialShare from './components/SocialShare.vue'

const route = useRoute()
const { page } = useData()
const isInPostsPage = ref(false)
const showTOC = ref(false)

// 检查是否在文章页面
onMounted(() => {
  isInPostsPage.value = route.path.startsWith('/posts/') || 
                        route.path.startsWith('/ai-learning/')
  
  // 检查页面是否有大纲
  showTOC.value = document.querySelectorAll('.vp-doc h2, .vp-doc h3').length > 0
})

watch(() => route.path, () => {
  isInPostsPage.value = route.path.startsWith('/posts/') || 
                        route.path.startsWith('/ai-learning/')
  
  // 重新检查大纲
  setTimeout(() => {
    showTOC.value = document.querySelectorAll('.vp-doc h2, .vp-doc h3').length > 0
  }, 100)
})
</script>

<template>
  <div class="layout-wrapper">
    <!-- 阅读进度条 (所有页面显示) -->
    <ReadingProgress />
    
    <!-- 主题切换按钮 - 集成到导航栏 -->
    <Teleport to=".VPNavBar .content">
      <ThemeToggle />
    </Teleport>
    
    <!-- 默认主题布局 -->
    <DefaultTheme.Layout>
      <!-- 文章右侧目录 -->
      <template #aside-outline-before v-if="showTOC">
        <TableOfContents />
      </template>
      
      <!-- 文章底部：分享 + 评论 -->
      <template #doc-after>
        <div v-if="isInPostsPage" class="article-footer">
          <!-- 分享按钮 -->
          <SocialShare />
          
          <!-- 评论区 -->
          <GiscusComments />
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

/* 调整导航栏布局以容纳主题切换按钮 */
:deep(.VPNavBar .content) {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

/* 移动端适配 */
@media (max-width: 768px) {
  :deep(.VPNavBar .content) {
    justify-content: flex-end;
  }
}
</style>
