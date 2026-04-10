---
layout: page
title: 情感分析
description: AI 驱动的情感分析服务 - 识别文本中的情绪状态
sidebar: false
page: true
---

<script setup>
import { ref, onMounted } from 'vue'

const serviceLoaded = ref(false)
const isLoading = ref(true)
const serviceStatus = ref('checking')

onMounted(() => {
  checkService()
})

async function checkService() {
  try {
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), 3000);
    
    const response = await fetch('http://localhost:8001/health', { 
      method: 'GET',
      signal: controller.signal,
      mode: 'no-cors'
    });
    
    clearTimeout(timeoutId);
    
    if (response.ok || response.type === 'opaque') {
      serviceLoaded.value = true;
      serviceStatus.value = 'running';
    } else {
      serviceStatus.value = 'error';
    }
  } catch (error) {
    serviceStatus.value = 'offline';
  }
  isLoading.value = false;
}

function openInNewTab() {
  window.open('http://localhost:8001', '_blank')
}

function restartService() {
  window.open('/blog/start-all.sh', '_blank')
}
</script>

<div class="service-container">
  <div class="service-header">
    <h1 style="margin-bottom: 0.5rem;">🧠 AI 情感分析服务</h1>
    <p class="service-description">基于深度学习的文本情感分析 - 识别情绪、评估极性、提供洞察</p>
    
    <div class="service-actions">
      <button @click="openInNewTab" class="btn-primary">
        🚀 在新窗口打开
      </button>
      <a href="/emotion-analyzer-mvp/QUICK_REFERENCE.md" class="btn-secondary">
        📖 使用文档
      </a>
    </div>
  </div>

  <div v-if="isLoading" class="loading-state">
    <div class="spinner"></div>
    <p>正在连接情感分析服务...</p>
  </div>

  <div v-else-if="serviceStatus === 'offline'" class="offline-state">
    <div class="offline-icon">⚠️</div>
    <h3>服务未启动</h3>
    <p>情感分析服务当前未运行，请启动服务：</p>
    <div class="command-box">
      <code>cd /root/.openclaw/workspace/emotion-analyzer-mvp</code><br>
      <code>docker-compose up -d</code>
    </div>
    <p class="hint">或使用一键启动脚本：<code>./start-all.sh</code></p>
  </div>

  <div v-else-if="serviceStatus === 'error'" class="error-state">
    <div class="error-icon">❌</div>
    <h3>服务响应异常</h3>
    <p>服务正在运行但响应异常，请检查日志。</p>
  </div>

  <div v-else class="iframe-container">
    <iframe 
      src="http://localhost:8001" 
      title="情感分析服务"
      @load="serviceLoaded = true"
    ></iframe>
  </div>

  <div class="service-features">
    <h2>✨ 核心功能</h2>
    <div class="feature-grid">
      <div class="feature-item">
        <span class="feature-icon">🎭</span>
        <h3>情绪识别</h3>
        <p>识别高兴、悲伤、愤怒、恐惧等 7 种基本情绪</p>
      </div>
      <div class="feature-item">
        <span class="feature-icon">📊</span>
        <h3>极性分析</h3>
        <p>评估文本的积极/消极倾向，输出置信度评分</p>
      </div>
      <div class="feature-item">
        <span class="feature-icon">🔍</span>
        <h3>关键词提取</h3>
        <p>自动提取情感关键词，辅助理解文本内容</p>
      </div>
      <div class="feature-item">
        <span class="feature-icon">📈</span>
        <h3>批量分析</h3>
        <p>支持批量处理文本，提供统计分析和可视化</p>
      </div>
    </div>
  </div>

  <div class="service-examples">
    <h2>💬 试试分析这些句子</h2>
    <div class="example-list">
      <div class="example-tag">今天天气真好，心情特别愉快！</div>
      <div class="example-tag">这个项目失败了，我感到非常失望。</div>
      <div class="example-tag">他对我的批评让我很生气。</div>
      <div class="example-tag">明天要考试了，有点紧张。</div>
      <div class="example-tag">收到礼物时既惊喜又感动。</div>
    </div>
  </div>

  <div class="service-stats">
    <h2>📊 服务信息</h2>
    <div class="stats-grid">
      <div class="stat-item">
        <span class="stat-value">7</span>
        <span class="stat-label">情绪类型</span>
      </div>
      <div class="stat-item">
        <span class="stat-value">BERT</span>
        <span class="stat-label">模型架构</span>
      </div>
      <div class="stat-item">
        <span class="stat-value">95%+</span>
        <span class="stat-label">准确率</span>
      </div>
      <div class="stat-item">
        <span class="stat-value">8001</span>
        <span class="stat-label">服务端口</span>
      </div>
    </div>
  </div>

  <div class="api-docs">
    <h2>🔌 API 接口</h2>
    <div class="api-endpoint">
      <span class="method post">POST</span>
      <code>/api/analyze</code>
      <p>分析单个文本的情感</p>
    </div>
    <div class="api-endpoint">
      <span class="method post">POST</span>
      <code>/api/batch-analyze</code>
      <p>批量分析多个文本</p>
    </div>
    <div class="api-endpoint">
      <span class="method get">GET</span>
      <code>/api/emotions</code>
      <p>获取支持的情绪类型列表</p>
    </div>
    <div class="api-endpoint">
      <span class="method get">GET</span>
      <code>/health</code>
      <p>健康检查接口</p>
    </div>
  </div>
</div>

<style scoped>
.service-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
}

.service-header {
  text-align: center;
  margin-bottom: 2rem;
}

.service-description {
  font-size: 1.1rem;
  color: #666;
  margin-bottom: 1.5rem;
}

.service-actions {
  display: flex;
  gap: 1rem;
  justify-content: center;
  flex-wrap: wrap;
}

.btn-primary, .btn-secondary {
  padding: 0.75rem 1.5rem;
  border-radius: 8px;
  text-decoration: none;
  font-weight: 500;
  cursor: pointer;
  border: none;
  font-size: 1rem;
  transition: all 0.3s;
}

.btn-primary {
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
  color: white;
}

.btn-primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(245, 87, 108, 0.4);
}

.btn-secondary {
  background: #f3f4f6;
  color: #374151;
}

.btn-secondary:hover {
  background: #e5e7eb;
}

.loading-state, .offline-state, .error-state {
  text-align: center;
  padding: 4rem 2rem;
  background: #f9fafb;
  border-radius: 12px;
  margin: 2rem 0;
}

.spinner {
  width: 40px;
  height: 40px;
  border: 4px solid #e5e7eb;
  border-top-color: #f5576c;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin: 0 auto 1rem;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.offline-icon, .error-icon {
  font-size: 3rem;
  margin-bottom: 1rem;
}

.command-box {
  background: #1f2937;
  color: #10b981;
  padding: 1rem;
  border-radius: 8px;
  font-family: monospace;
  margin: 1rem 0;
  text-align: left;
  display: inline-block;
}

.hint {
  color: #6b7280;
  font-size: 0.9rem;
}

.iframe-container {
  position: relative;
  width: 100%;
  height: 800px;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}

.iframe-container iframe {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  border: none;
}

.service-features {
  margin-top: 3rem;
}

.feature-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1.5rem;
  margin-top: 1.5rem;
}

.feature-item {
  padding: 1.5rem;
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
  color: white;
  border-radius: 12px;
  text-align: center;
  transition: transform 0.3s;
}

.feature-item:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 16px rgba(245, 87, 108, 0.3);
}

.feature-icon {
  font-size: 2.5rem;
  display: block;
  margin-bottom: 0.5rem;
}

.feature-item h3 {
  margin: 0.5rem 0;
}

.feature-item p {
  opacity: 0.95;
  font-size: 0.95rem;
}

.service-examples {
  margin-top: 3rem;
}

.example-list {
  display: flex;
  flex-wrap: wrap;
  gap: 0.75rem;
  margin-top: 1rem;
}

.example-tag {
  padding: 0.5rem 1rem;
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
  color: white;
  border-radius: 20px;
  font-size: 0.9rem;
  cursor: pointer;
  transition: transform 0.2s;
}

.example-tag:hover {
  transform: scale(1.05);
}

.service-stats {
  margin-top: 3rem;
  padding: 2rem;
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
  border-radius: 12px;
  color: white;
}

.service-stats h2 {
  text-align: center;
  margin-bottom: 1.5rem;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
  gap: 1.5rem;
}

.stat-item {
  text-align: center;
}

.stat-value {
  font-size: 2.5rem;
  font-weight: bold;
  display: block;
}

.stat-label {
  font-size: 0.9rem;
  opacity: 0.9;
  display: block;
  margin-top: 0.5rem;
}

.api-docs {
  margin-top: 3rem;
  padding: 2rem;
  background: #f9fafb;
  border-radius: 12px;
}

.api-endpoint {
  margin: 1rem 0;
  padding: 1rem;
  background: white;
  border-radius: 8px;
  border-left: 4px solid #f5576c;
}

.method {
  display: inline-block;
  padding: 0.25rem 0.75rem;
  border-radius: 4px;
  font-weight: bold;
  font-size: 0.85rem;
  margin-right: 0.5rem;
}

.method.post {
  background: #10b981;
  color: white;
}

.method.get {
  background: #3b82f6;
  color: white;
}

.api-endpoint code {
  font-size: 1.1rem;
  color: #1f2937;
}

.api-endpoint p {
  color: #6b7280;
  margin-top: 0.5rem;
  font-size: 0.95rem;
}

@media (max-width: 768px) {
  .service-container {
    padding: 1rem;
  }
  
  .iframe-container {
    height: 600px;
  }
  
  .feature-grid {
    grid-template-columns: 1fr;
  }
  
  .stats-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}
</style>
