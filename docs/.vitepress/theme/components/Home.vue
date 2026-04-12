<script setup>
import { computed } from 'vue'
import { useData } from 'vitepress'

const { theme, frontmatter, site } = useData()

// 从配置中获取首页数据
const heroText = computed(() => frontmatter.value.heroText || site.value.title)
const heroTagline = computed(() => frontmatter.value.heroTagline || site.value.description)
const heroActions = computed(() => frontmatter.value.heroActions || [
  { text: '开始阅读', link: '/posts/', theme: 'brand' },
  { text: '关于我', link: '/about', theme: 'alt' }
])

const features = computed(() => frontmatter.value.features || [
  {
    icon: '🤖',
    title: 'AI 与大模型',
    details: '探索人工智能前沿技术，分享大模型应用实践与开发教程'
  },
  {
    icon: '💻',
    title: '编程实践',
    details: '记录编程学习之路，分享项目经验、代码技巧与最佳实践'
  },
  {
    icon: '📝',
    title: '生活感悟',
    details: '工作之余的思考，生活点滴记录，保持对世界的好奇心'
  }
])
</script>

<template>
  <div class="custom-home">
    <!-- Hero 区域 -->
    <section class="hero-section">
      <div class="hero-content">
        <h1 class="hero-title">{{ heroText }}</h1>
        <p class="hero-tagline">{{ heroTagline }}</p>
        
        <div class="hero-actions">
          <a 
            v-for="(action, index) in heroActions" 
            :key="index"
            :href="action.link"
            :class="['hero-button', action.theme || 'brand']"
          >
            {{ action.text }}
          </a>
        </div>
      </div>
      
      <div class="hero-decoration">
        <div class="decoration-circle circle-1"></div>
        <div class="decoration-circle circle-2"></div>
        <div class="decoration-circle circle-3"></div>
      </div>
    </section>
    
    <!-- 特性展示区域 -->
    <section class="features-section">
      <div class="features-container">
        <div 
          v-for="(feature, index) in features" 
          :key="index"
          class="feature-card"
          :style="{ animationDelay: `${index * 0.1}s` }"
        >
          <div class="feature-icon">{{ feature.icon }}</div>
          <h3 class="feature-title">{{ feature.title }}</h3>
          <p class="feature-details">{{ feature.details }}</p>
        </div>
      </div>
    </section>
    
    <!-- 最新文章（可选） -->
    <section v-if="frontmatter.showRecentPosts" class="recent-posts-section">
      <h2 class="section-title">最新文章</h2>
      <div class="posts-grid">
        <slot name="recent-posts">
          <p class="placeholder-text">文章列表将在后续版本中添加...</p>
        </slot>
      </div>
    </section>
  </div>
</template>

<style scoped>
/* Hero 区域 */
.hero-section {
  position: relative;
  min-height: 500px;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 4rem 2rem;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  overflow: hidden;
}

.hero-content {
  text-align: center;
  z-index: 1;
  max-width: 800px;
}

.hero-title {
  font-size: 3.5rem;
  font-weight: 800;
  color: white;
  margin-bottom: 1rem;
  letter-spacing: -0.02em;
  text-shadow: 0 2px 10px rgba(0,0,0,0.1);
  animation: fadeInUp 0.8s ease-out;
}

.hero-tagline {
  font-size: 1.5rem;
  color: rgba(255,255,255,0.95);
  margin-bottom: 2.5rem;
  font-weight: 400;
  line-height: 1.6;
  animation: fadeInUp 0.8s ease-out 0.2s backwards;
}

.hero-actions {
  display: flex;
  gap: 1rem;
  justify-content: center;
  flex-wrap: wrap;
  animation: fadeInUp 0.8s ease-out 0.4s backwards;
}

.hero-button {
  padding: 0.875rem 2rem;
  border-radius: 8px;
  font-weight: 600;
  font-size: 1rem;
  text-decoration: none;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  display: inline-block;
}

.hero-button.brand {
  background: white;
  color: #667eea;
  box-shadow: 0 4px 14px rgba(255,255,255,0.3);
}

.hero-button.brand:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(255,255,255,0.4);
}

.hero-button.alt {
  background: rgba(255,255,255,0.1);
  color: white;
  border: 2px solid rgba(255,255,255,0.5);
  backdrop-filter: blur(10px);
}

.hero-button.alt:hover {
  background: rgba(255,255,255,0.2);
  border-color: rgba(255,255,255,0.8);
}

/* 装饰元素 */
.hero-decoration {
  position: absolute;
  inset: 0;
  pointer-events: none;
  overflow: hidden;
}

.decoration-circle {
  position: absolute;
  border-radius: 50%;
  background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
}

.circle-1 {
  width: 600px;
  height: 600px;
  top: -200px;
  right: -100px;
}

.circle-2 {
  width: 400px;
  height: 400px;
  bottom: -100px;
  left: -50px;
}

.circle-3 {
  width: 300px;
  height: 300px;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}

/* 特性展示区域 */
.features-section {
  padding: 5rem 2rem;
  background: var(--vp-c-bg);
}

.features-container {
  max-width: 1200px;
  margin: 0 auto;
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 2rem;
}

.feature-card {
  background: var(--vp-c-bg-elv);
  border: 1px solid var(--vp-c-divider);
  border-radius: 12px;
  padding: 2rem;
  text-align: center;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  opacity: 0;
  animation: fadeInUp 0.6s ease-out forwards;
}

.feature-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 12px 40px rgba(0,0,0,0.1);
  border-color: var(--vp-c-brand-light);
}

.feature-icon {
  font-size: 3rem;
  margin-bottom: 1rem;
  display: block;
}

.feature-title {
  font-size: 1.5rem;
  font-weight: 600;
  color: var(--vp-c-text-1);
  margin-bottom: 0.75rem;
}

.feature-details {
  color: var(--vp-c-text-2);
  line-height: 1.6;
  font-size: 1rem;
}

/* 最新文章区域 */
.recent-posts-section {
  padding: 5rem 2rem;
  background: var(--vp-c-bg-alt);
}

.section-title {
  font-size: 2rem;
  font-weight: 700;
  text-align: center;
  margin-bottom: 3rem;
  color: var(--vp-c-text-1);
}

.posts-grid {
  max-width: 1000px;
  margin: 0 auto;
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 1.5rem;
}

.placeholder-text {
  text-align: center;
  color: var(--vp-c-text-2);
  grid-column: 1 / -1;
  padding: 3rem;
}

/* 动画 */
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* 响应式 */
@media (max-width: 768px) {
  .hero-title {
    font-size: 2.5rem;
  }
  
  .hero-tagline {
    font-size: 1.125rem;
  }
  
  .hero-actions {
    flex-direction: column;
    align-items: center;
  }
  
  .hero-button {
    width: 100%;
    max-width: 280px;
    text-align: center;
  }
  
  .features-container {
    grid-template-columns: 1fr;
  }
  
  .posts-grid {
    grid-template-columns: 1fr;
  }
}
</style>
