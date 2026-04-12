<template>
  <div class="reading-progress-bar" :style="{ width: progress + '%' }"></div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'

const progress = ref(0)

const handleScroll = () => {
  const winScroll = document.documentElement.scrollTop
  const height = document.documentElement.scrollHeight - document.documentElement.clientHeight
  const scrolled = (winScroll / height) * 100
  progress.value = scrolled
}

onMounted(() => {
  window.addEventListener('scroll', handleScroll, { passive: true })
  handleScroll() // 初始化
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
})
</script>

<style scoped>
.reading-progress-bar {
  position: fixed;
  top: 0;
  left: 0;
  height: 4px;
  background: linear-gradient(90deg, #3B82F6, #F97316);
  z-index: 9999;
  transition: width 0.1s ease;
  box-shadow: 0 1px 3px rgba(59, 130, 246, 0.3);
}

/* 暗黑模式适配 */
html.dark .reading-progress-bar {
  background: linear-gradient(90deg, #60A5FA, #FB923C);
  box-shadow: 0 1px 3px rgba(96, 165, 250, 0.4);
}
</style>
