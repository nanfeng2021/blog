<template>
  <nav class="table-of-contents" v-if="headers.length > 0">
    <div class="toc-header">
      <span>目录</span>
      <button 
        class="toggle-btn" 
        @click="isCollapsed = !isCollapsed"
        :aria-expanded="!isCollapsed"
      >
        {{ isCollapsed ? '展开' : '收起' }}
      </button>
    </div>
    
    <ul class="toc-list" v-show="!isCollapsed">
      <li 
        v-for="header in headers" 
        :key="header.id"
        :class="['toc-item', `level-${header.level}`, { active: activeId === header.id }]"
      >
        <a 
          :href="`#${header.id}`" 
          @click.prevent="scrollToHeader(header.id)"
        >
          {{ header.text }}
        </a>
        
        <!-- 子标题 -->
        <ul v-if="header.children && header.children.length > 0" class="toc-sublist">
          <li 
            v-for="child in header.children" 
            :key="child.id"
            :class="['toc-subitem', `level-${child.level}`, { active: activeId === child.id }]"
          >
            <a 
              :href="`#${child.id}`" 
              @click.prevent="scrollToHeader(child.id)"
            >
              {{ child.text }}
            </a>
          </li>
        </ul>
      </li>
    </ul>
    
    <!-- 移动端悬浮按钮 -->
    <button 
      class="mobile-toc-toggle" 
      @click="isCollapsed = !isCollapsed"
      :class="{ open: !isCollapsed }"
    >
      📑
    </button>
  </nav>
</template>

<script setup>
import { ref, onMounted, onUnmounted, computed } from 'vue'
import { useData } from 'vitepress'

const { page } = useData()
const headers = ref([])
const activeId = ref('')
const isCollapsed = ref(false)

// 解析页面大纲
onMounted(() => {
  parseHeaders()
  
  // 监听滚动更新活跃章节
  window.addEventListener('scroll', handleScroll, { passive: true })
  handleScroll()
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
})

function parseHeaders() {
  const content = document.querySelector('.vp-doc')
  if (!content) return
  
  const elements = content.querySelectorAll('h2, h3')
  const parsed = []
  let currentH2 = null
  
  elements.forEach(el => {
    const id = el.id
    const text = el.textContent.trim()
    const level = el.tagName.toLowerCase() === 'h2' ? 2 : 3
    
    if (!id || !text) return
    
    const header = { id, text, level, children: [] }
    
    if (level === 2) {
      parsed.push(header)
      currentH2 = header
    } else if (currentH2) {
      currentH2.children.push(header)
    } else {
      parsed.push(header)
    }
  })
  
  headers.value = parsed
}

function handleScroll() {
  const elements = document.querySelectorAll('.vp-doc h2[id], .vp-doc h3[id]')
  let current = ''
  
  const scrollPosition = window.scrollY + 150
  
  elements.forEach(el => {
    const top = el.offsetTop
    if (scrollPosition >= top) {
      current = el.id
    }
  })
  
  activeId.value = current
}

function scrollToHeader(id) {
  const element = document.getElementById(id)
  if (!element) return
  
  const offsetTop = element.offsetTop - 80
  
  window.scrollTo({
    top: offsetTop,
    behavior: 'smooth'
  })
  
  // 更新 URL (不添加历史记录)
  history.replaceState(null, '', `#${id}`)
}
</script>

<style scoped>
.table-of-contents {
  position: sticky;
  top: 80px;
  width: 260px;
  padding: 1rem 0;
  font-size: 0.875rem;
}

.toc-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 0.75rem;
  font-weight: 600;
  color: var(--vp-c-text-1);
}

.toggle-btn {
  background: transparent;
  border: none;
  cursor: pointer;
  color: var(--vp-c-text-2);
  font-size: 0.75rem;
  padding: 0.25rem 0.5rem;
  border-radius: 4px;
  transition: all 0.2s ease;
}

.toggle-btn:hover {
  background: var(--vp-c-bg-soft);
  color: var(--vp-c-text-1);
}

.toc-list {
  list-style: none;
  padding: 0;
  margin: 0;
}

.toc-item {
  margin: 0.5rem 0;
}

.toc-item a {
  display: block;
  color: var(--vp-c-text-2);
  text-decoration: none;
  padding: 0.25rem 0;
  transition: all 0.2s ease;
  border-left: 2px solid transparent;
  padding-left: 0.75rem;
}

.toc-item a:hover {
  color: var(--vp-c-brand);
}

.toc-item.active > a {
  color: var(--vp-c-brand);
  border-left-color: var(--vp-c-brand);
  font-weight: 500;
}

.level-3 {
  padding-left: 1.25rem !important;
  font-size: 0.8125rem;
}

.toc-sublist {
  list-style: none;
  padding: 0;
  margin: 0.25rem 0 0.25rem 0.75rem;
}

.toc-subitem a {
  color: var(--vp-c-text-3);
  font-size: 0.8125rem;
}

.toc-subitem.active a {
  color: var(--vp-c-brand);
}

/* 移动端悬浮按钮 */
.mobile-toc-toggle {
  display: none;
  position: fixed;
  bottom: 20px;
  right: 20px;
  width: 50px;
  height: 50px;
  border-radius: 50%;
  background: var(--vp-c-brand);
  color: white;
  border: none;
  font-size: 1.5rem;
  cursor: pointer;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  z-index: 9999;
  transition: all 0.3s ease;
}

.mobile-toc-toggle.open {
  transform: rotate(90deg);
}

@media (max-width: 960px) {
  .table-of-contents {
    display: none;
  }
  
  .mobile-toc-toggle {
    display: block;
  }
}

/* 暗色模式适配 */
.dark .toc-item a:hover {
  color: var(--vp-c-brand-light);
}

.dark .toc-item.active > a {
  color: var(--vp-c-brand-light);
  border-left-color: var(--vp-c-brand-light);
}
</style>
