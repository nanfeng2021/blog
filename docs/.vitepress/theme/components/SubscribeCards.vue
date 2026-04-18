<template>
  <div class="subscribe-section">
    <div class="subscribe-container">
      <h2>📬 订阅学习计划推送</h2>
      <p class="subtitle">每个工作日早上 8 点，准时推送学习资料到你的邮箱或微信</p>

      <div class="subscribe-cards">
        <div class="plan-card">
          <div class="plan-header">
            <span class="plan-icon">🎯</span>
            <h3>免费计划</h3>
          </div>
          <ul class="plan-features">
            <li>✅ 每日学习任务提醒</li>
            <li>✅ 基础知识资料</li>
            <li>✅ 社区答疑支持</li>
            <li>❌ 一对一指导</li>
            <li>❌ 实战项目代码</li>
          </ul>
          <div class="plan-price">
            <span class="price">¥0</span>
            <span class="period">/月</span>
          </div>
          <button class="subscribe-btn free" @click="showQR('free')">立即订阅</button>
        </div>

        <div class="plan-card highlight">
          <div class="plan-badge">⭐ 推荐</div>
          <div class="plan-header">
            <span class="plan-icon">🚀</span>
            <h3>进阶计划</h3>
          </div>
          <ul class="plan-features">
            <li>✅ 每日学习任务提醒</li>
            <li>✅ 精选深度资料</li>
            <li>✅ 实战项目代码</li>
            <li>✅ 微信群答疑</li>
            <li>✅ 月度直播分享</li>
          </ul>
          <div class="plan-price">
            <span class="price">¥99</span>
            <span class="period">/月</span>
          </div>
          <button class="subscribe-btn pro" @click="showQR('pro')">立即订阅</button>
        </div>

        <div class="plan-card">
          <div class="plan-header">
            <span class="plan-icon">👑</span>
            <h3>VIP 计划</h3>
          </div>
          <ul class="plan-features">
            <li>✅ 所有进阶计划权益</li>
            <li>✅ 一对一学习指导</li>
            <li>✅ 定制化学习路径</li>
            <li>✅ 优先问题解答</li>
            <li>✅ 简历优化建议</li>
          </ul>
          <div class="plan-price">
            <span class="price">¥299</span>
            <span class="period">/月</span>
          </div>
          <button class="subscribe-btn vip" @click="showQR('vip')">立即订阅</button>
        </div>
      </div>

      <!-- 二维码弹窗 -->
      <Transition name="fade">
        <div v-if="qrModalVisible" class="qr-modal" @click="hideQR">
          <div class="qr-content" @click.stop>
            <button class="close-btn" @click="hideQR">×</button>
            <h3 id="qrTitle">扫码支付订阅</h3>
            <div class="qr-grid">
              <div class="qr-item">
                <img src="/wechat-pay.png" alt="微信支付" class="qr-code">
                <p>微信支付</p>
              </div>
              <div class="qr-item">
                <div class="qr-placeholder-box">
                  <span class="placeholder-text">支付宝<br>（请添加支付宝收款码）</span>
                </div>
                <p>支付宝</p>
              </div>
            </div>
            <div class="qr-instructions">
              <p><strong>订阅流程：</strong></p>
              <ol>
                <li>使用微信或支付宝扫码支付</li>
                <li>支付成功后截图保存凭证</li>
                <li>添加客服微信：<code>KFCvMe50xiaxia</code></li>
                <li>发送支付截图，选择接收方式（邮箱/微信）</li>
                <li>客服会在 24 小时内开通订阅服务</li>
              </ol>
            </div>
          </div>
        </div>
      </Transition>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const qrModalVisible = ref(false)
const qrTitle = ref('扫码支付订阅')

// 显示二维码弹窗
const showQR = (planType) => {
  const planNames = {
    'free': '免费计划',
    'pro': '进阶计划（¥99/月）',
    'vip': 'VIP 计划（¥299/月）'
  }
  
  qrTitle.value = `订阅：${planNames[planType]}`
  qrModalVisible.value = true
}

// 隐藏二维码弹窗
const hideQR = () => {
  qrModalVisible.value = false
}
</script>

<style scoped>
.subscribe-section {
  padding: 4rem 2rem;
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
  margin-top: 3rem;
}

.subscribe-container {
  max-width: 1200px;
  margin: 0 auto;
}

.subscribe-container h2 {
  text-align: center;
  color: white;
  font-size: 2.5rem;
  margin-bottom: 0.5rem;
}

.subtitle {
  text-align: center;
  color: rgba(255, 255, 255, 0.9);
  font-size: 1.2rem;
  margin-bottom: 3rem;
}

.subscribe-cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 2rem;
  margin-bottom: 2rem;
}

.plan-card {
  background: white;
  border-radius: 16px;
  padding: 2rem;
  position: relative;
  transition: all 0.3s;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}

.plan-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.2);
}

.plan-card.highlight {
  border: 3px solid #fbbf24;
  transform: scale(1.05);
}

.plan-card.highlight:hover {
  transform: scale(1.05) translateY(-8px);
}

.plan-badge {
  position: absolute;
  top: -12px;
  right: 20px;
  background: linear-gradient(135deg, #fbbf24 0%, #f59e0b 100%);
  color: #78350f;
  padding: 0.5rem 1.5rem;
  border-radius: 20px;
  font-weight: 700;
  font-size: 0.9rem;
  box-shadow: 0 2px 8px rgba(251, 191, 36, 0.4);
}

.plan-header {
  text-align: center;
  margin-bottom: 1.5rem;
}

.plan-icon {
  font-size: 3rem;
  display: block;
  margin-bottom: 0.5rem;
}

.plan-header h3 {
  font-size: 1.8rem;
  color: #1f2937;
  margin: 0;
}

.plan-features {
  list-style: none;
  padding: 0;
  margin: 0 0 1.5rem 0;
}

.plan-features li {
  padding: 0.75rem 0;
  border-bottom: 1px solid #f3f4f6;
  font-size: 1rem;
  color: #4b5563;
}

.plan-features li:last-child {
  border-bottom: none;
}

.plan-price {
  text-align: center;
  margin: 1.5rem 0;
}

.price {
  font-size: 3rem;
  font-weight: 700;
  color: #667eea;
}

.period {
  font-size: 1.2rem;
  color: #9ca3af;
}

.subscribe-btn {
  width: 100%;
  padding: 1rem;
  border: none;
  border-radius: 8px;
  font-size: 1.1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s;
}

.subscribe-btn.free {
  background: linear-gradient(135deg, #10b981 0%, #059669 100%);
  color: white;
}

.subscribe-btn.pro {
  background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
  color: white;
}

.subscribe-btn.vip {
  background: linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%);
  color: white;
}

.subscribe-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
}

.qr-modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.7);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 9999;
  backdrop-filter: blur(4px);
}

.qr-content {
  background: white;
  border-radius: 16px;
  padding: 2.5rem;
  max-width: 600px;
  width: 90%;
  position: relative;
  max-height: 90vh;
  overflow-y: auto;
}

.close-btn {
  position: absolute;
  top: 15px;
  right: 15px;
  background: none;
  border: none;
  font-size: 2rem;
  cursor: pointer;
  color: #9ca3af;
  transition: color 0.2s;
}

.close-btn:hover {
  color: #ef4444;
}

#qrTitle {
  text-align: center;
  color: #1f2937;
  margin-bottom: 1.5rem;
  font-size: 1.8rem;
}

.qr-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 1.5rem;
  margin-bottom: 2rem;
}

.qr-item {
  text-align: center;
}

.qr-code {
  width: 100%;
  max-width: 180px;
  height: auto;
  border: 2px solid #e5e7eb;
  border-radius: 8px;
  padding: 0.5rem;
}

.qr-placeholder-box {
  width: 180px;
  height: 180px;
  margin: 0 auto;
  border: 3px dashed #d1d5db;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f9fafb;
}

.placeholder-text {
  color: #6b7280;
  font-size: 0.95rem;
  text-align: center;
  line-height: 1.6;
}

.qr-item p {
  margin-top: 0.5rem;
  color: #6b7280;
  font-weight: 500;
}

.qr-instructions {
  background: #f9fafb;
  padding: 1.5rem;
  border-radius: 8px;
  border-left: 4px solid #667eea;
}

.qr-instructions p {
  margin-bottom: 0.75rem;
  color: #374151;
}

.qr-instructions ol {
  padding-left: 1.5rem;
  color: #4b5563;
  line-height: 1.8;
}

.qr-instructions code {
  background: #e5e7eb;
  padding: 0.2rem 0.5rem;
  border-radius: 4px;
  font-family: monospace;
  color: #dc2626;
}

/* Fade transition */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

@media (max-width: 768px) {
  .subscribe-section {
    padding: 2rem 1rem;
  }

  .subscribe-container h2 {
    font-size: 1.8rem;
  }

  .subscribe-cards {
    grid-template-columns: 1fr;
  }

  .plan-card.highlight {
    transform: none;
  }

  .plan-card.highlight:hover {
    transform: translateY(-8px);
  }

  .qr-grid {
    grid-template-columns: 1fr;
  }
}
</style>
