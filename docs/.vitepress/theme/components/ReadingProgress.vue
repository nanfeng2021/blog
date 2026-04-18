<template>
  <div class="reading-progress" :style="{ width: progress + '%' }"></div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'

const progress = ref(0)

let ticking = false

function updateProgress() {
  if (!ticking) {
    window.requestAnimationFrame(() => {
      const scrollTop = window.scrollY || document.documentElement.scrollTop
      const height = document.documentElement.scrollHeight - document.documentElement.clientHeight
      
      if (height > 0) {
        progress.value = (scrollTop / height) * 100
      } else {
        progress.value = 0
      }
      
      ticking = false
    })
    
    ticking = true
  }
}

onMounted(() => {
  window.addEventListener('scroll', updateProgress, { passive: true })
  updateProgress()
})

onUnmounted(() => {
  window.removeEventListener('scroll', updateProgress)
})
</script>

<style scoped>
.reading-progress {
  position: fixed;
  top: 0;
  left: 0;
  height: 3px;
  background: linear-gradient(90deg, var(--vp-c-brand), var(--vp-c-brand-dark));
  z-index: 10000;
  transition: width 0.1s ease-out;
}

/* 暗色模式 */
.dark .reading-progress {
  background: linear-gradient(90deg, var(--vp-c-brand-light), var(--vp-c-brand));
}
</style>
