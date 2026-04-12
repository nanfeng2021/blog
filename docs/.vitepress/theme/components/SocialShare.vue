<template>
  <div class="social-share">
    <h3 class="share-title">分享到</h3>
    
    <div class="share-buttons">
      <!-- 复制链接 -->
      <button @click="copyLink" class="share-btn copy" title="复制链接">
        <span class="icon">📋</span>
      </button>
      
      <!-- 微信 - 显示二维码 -->
      <div class="share-item wechat" @mouseenter="generateWeChatQR">
        <button class="share-btn" title="微信扫码分享">
          <span class="icon">💚</span>
        </button>
        <div class="qr-popup">
          <div class="qr-code" ref="qrCode"></div>
          <p>扫码分享</p>
        </div>
      </div>
      
      <!-- 微博 -->
      <a 
        :href="weiboUrl" 
        target="_blank" 
        rel="noopener noreferrer"
        class="share-btn weibo"
        title="分享到微博"
      >
        <span class="icon">❤️</span>
      </a>
      
      <!-- Twitter -->
      <a 
        :href="twitterUrl" 
        target="_blank" 
        rel="noopener noreferrer"
        class="share-btn twitter"
        title="分享到 Twitter"
      >
        <span class="icon">🐦</span>
      </a>
      
      <!-- LinkedIn -->
      <a 
        :href="linkedInUrl" 
        target="_blank" 
        rel="noopener noreferrer"
        class="share-btn linkedin"
        title="分享到 LinkedIn"
      >
        <span class="icon">💼</span>
      </a>
    </div>
    
    <!-- 复制成功提示 -->
    <transition name="fade">
      <div v-if="showCopyTip" class="copy-tip">
        ✅ 已复制
      </div>
    </transition>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useData, useRoute } from 'vitepress'

const route = useRoute()
const { page } = useData()
const qrCode = ref(null)
const showCopyTip = ref(false)

// 当前页面信息
const pageTitle = computed(() => page.value.title || '南风的博客')
const pageUrl = computed(() => `https://ainanfeng.cn${route.path}`)

// 分享链接生成
const weiboUrl = computed(() => {
  const url = encodeURIComponent(pageUrl.value)
  const title = encodeURIComponent(pageTitle.value)
  return `https://service.weibo.com/share/share.php?url=${url}&title=${title}`
})

const twitterUrl = computed(() => {
  const url = encodeURIComponent(pageUrl.value)
  const title = encodeURIComponent(pageTitle.value)
  return `https://twitter.com/intent/tweet?url=${url}&text=${title}`
})

const linkedInUrl = computed(() => {
  const url = encodeURIComponent(pageUrl.value)
  return `https://www.linkedin.com/sharing/share-offsite/?url=${url}`
})

// 复制链接
const copyLink = async () => {
  try {
    await navigator.clipboard.writeText(pageUrl.value)
    showCopyTip.value = true
    setTimeout(() => {
      showCopyTip.value = false
    }, 2000)
  } catch (err) {
    const success = prompt('请复制链接:', pageUrl.value)
    if (success !== null) {
      showCopyTip.value = true
      setTimeout(() => {
        showCopyTip.value = false
      }, 2000)
    }
  }
}

// 生成微信二维码
const generateWeChatQR = () => {
  if (qrCode.value && !qrCode.value.innerHTML) {
    const qrApi = `https://api.qrserver.com/v1/create-qr-code/?size=180x180&data=${encodeURIComponent(pageUrl.value)}`
    qrCode.value.innerHTML = `<img src="${qrApi}" alt="二维码" style="width:180px;height:180px;display:block;" loading="lazy" />`
  }
}
</script>

<style scoped>
.social-share {
  margin-top: 2rem;
  padding: 1.5rem 0;
  border-top: 1px solid var(--vp-c-divider);
}

.share-title {
  font-size: 0.9rem;
  font-weight: 600;
  color: var(--vp-c-text-2);
  margin-bottom: 1rem;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.share-buttons {
  display: flex;
  gap: 0.5rem;
  flex-wrap: wrap;
}

.share-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 40px;
  height: 40px;
  border-radius: 8px;
  font-size: 1.25rem;
  transition: all 0.2s ease;
  cursor: pointer;
  border: 1px solid transparent;
  padding: 0;
  background: var(--vp-c-bg-alt);
}

.share-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0,0,0,0.15);
}

/* 复制按钮 */
.share-btn.copy {
  background: var(--vp-c-bg-alt);
  border-color: var(--vp-c-divider);
}

.share-btn.copy:hover {
  background: var(--vp-c-brand);
  border-color: var(--vp-c-brand);
}

/* 微信按钮 */
.share-btn.wechat {
  background: #07c160;
}

.share-btn.wechat:hover {
  background: #06ad56;
}

/* 微信二维码弹窗 */
.share-item.wechat {
  position: relative;
}

.qr-popup {
  position: absolute;
  top: calc(100% + 10px);
  left: 50%;
  transform: translateX(-50%);
  background: white;
  padding: 12px;
  border-radius: 12px;
  box-shadow: 0 8px 30px rgba(0,0,0,0.2);
  opacity: 0;
  visibility: hidden;
  transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
  z-index: 100;
  text-align: center;
  min-width: 200px;
}

.share-item.wechat:hover .qr-popup {
  opacity: 1;
  visibility: visible;
  transform: translateX(-50%) translateY(-5px);
}

.qr-code {
  min-width: 180px;
  min-height: 180px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f5f5f5;
  border-radius: 8px;
}

.qr-popup p {
  margin: 8px 0 0 0;
  font-size: 0.75rem;
  color: #666;
  font-weight: 500;
}

/* 微博按钮 */
.share-btn.weibo {
  background: #e6162d;
}

.share-btn.weibo:hover {
  background: #cf1428;
}

/* Twitter 按钮 */
.share-btn.twitter {
  background: #1da1f2;
}

.share-btn.twitter:hover {
  background: #1a91da;
}

/* LinkedIn 按钮 */
.share-btn.linkedin {
  background: #0077b5;
}

.share-btn.linkedin:hover {
  background: #00669e;
}

/* 复制成功提示 */
.copy-tip {
  position: fixed;
  bottom: 2rem;
  left: 50%;
  transform: translateX(-50%);
  background: var(--vp-c-brand);
  color: white;
  padding: 0.6rem 1.2rem;
  border-radius: 8px;
  font-size: 0.85rem;
  font-weight: 500;
  box-shadow: 0 4px 20px rgba(0,0,0,0.15);
  z-index: 1000;
}

/* 淡入淡出动画 */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

/* 移动端适配 */
@media (max-width: 768px) {
  .share-buttons {
    gap: 0.4rem;
  }
  
  .share-btn {
    width: 36px;
    height: 36px;
    font-size: 1.1rem;
  }
  
  .qr-popup {
    left: 0;
    transform: none;
    min-width: 180px;
  }
  
  .share-item.wechat:hover .qr-popup {
    transform: translateY(-5px);
  }
}

/* 暗黑模式适配 */
html.dark .qr-popup {
  background: #1a1a2e;
  border: 1px solid var(--vp-c-divider);
}

html.dark .qr-code {
  background: #2a2a3e;
}

html.dark .qr-popup p {
  color: #aaa;
}
</style>
