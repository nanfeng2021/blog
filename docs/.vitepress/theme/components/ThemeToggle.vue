<template>
  <button 
    class="theme-toggle" 
    @click="toggleTheme" 
    :title="isDark ? '切换到亮色模式' : '切换到暗色模式'"
    aria-label="切换主题"
  >
    <span class="icon sun" :class="{ active: !isDark }">☀️</span>
    <span class="icon moon" :class="{ active: isDark }">🌙</span>
  </button>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue'

const isDark = ref(false)

// 初始化主题
onMounted(() => {
  // 检查 localStorage
  const savedTheme = localStorage.getItem('theme')
  
  if (savedTheme) {
    isDark.value = savedTheme === 'dark'
  } else {
    // 检测系统偏好
    isDark.value = window.matchMedia('(prefers-color-scheme: dark)').matches
  }
  
  applyTheme(isDark.value)
})

// 应用主题
function applyTheme(dark) {
  if (dark) {
    document.documentElement.classList.add('dark')
  } else {
    document.documentElement.classList.remove('dark')
  }
}

// 切换主题
function toggleTheme() {
  isDark.value = !isDark.value
  applyTheme(isDark.value)
  localStorage.setItem('theme', isDark.value ? 'dark' : 'light')
}

// 监听系统主题变化
watch(isDark, (newVal) => {
  applyTheme(newVal)
})
</script>

<style scoped>
.theme-toggle {
  background: transparent;
  border: none;
  cursor: pointer;
  padding: 0.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: transform 0.2s ease;
  position: relative;
  width: 40px;
  height: 40px;
}

.theme-toggle:hover {
  transform: rotate(15deg);
}

.icon {
  position: absolute;
  font-size: 1.25rem;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  opacity: 0;
  transform: scale(0.5) rotate(-90deg);
}

.icon.active {
  opacity: 1;
  transform: scale(1) rotate(0deg);
}

.sun {
  color: #f59e0b;
}

.moon {
  color: #6366f1;
}

/* 暗色模式下的按钮样式 */
.dark .theme-toggle:hover {
  transform: rotate(-15deg);
}
</style>
