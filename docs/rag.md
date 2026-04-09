---
layout: page
title: RAG 知识库
description: 基于本地知识库的智能问答系统 - 专注于数控加工与 CAD/CAM 领域
sidebar: false
page: true
---

<script setup>
import { ref, onMounted } from 'vue'

const iframeLoaded = ref(false)
const isLoading = ref(true)

onMounted(() => {
  // 检查 RAG 服务是否可用
  checkRagService()
})

async function checkRagService() {
  try {
    const response = await fetch('http://localhost:7860', { method: 'HEAD' })
    if (response.ok) {
      iframeLoaded.value = true
      isLoading.value = false
    }
  } catch (error) {
    console.log('RAG 服务未启动或无法访问')
    isLoading.value = false
  }
}

function openInNewTab() {
  window.open('http://localhost:7860', '_blank')
}
</script>

<div class="rag-container">
  <div class="rag-header">
    <h1 style="margin-bottom: 0.5rem;">🤖 RAG 知识库查询系统</h1>
    <p class="rag-description">基于本地知识库的智能问答系统 - 专注于数控加工与 CAD/CAM 领域</p>
    
    <div class="rag-actions">
      <button @click="openInNewTab" class="btn-primary">
        🚀 在新窗口打开
      </button>
      <a href="/rag-knowledge-base/QUICKSTART.md" class="btn-secondary">
        📖 使用文档
      </a>
    </div>
  </div>

  <div v-if="isLoading" class="loading-state">
    <div class="spinner"></div>
    <p>正在连接 RAG 知识库服务...</p>
  </div>

  <div v-else-if="!iframeLoaded" class="offline-state">
    <div class="offline-icon">⚠️</div>
    <h3>RAG 服务未启动</h3>
    <p>请先启动 RAG 知识库 Web 服务：</p>
    <div class="command-box">
      <code>cd /root/.openclaw/workspace/rag-knowledge-base</code><br>
      <code>./scripts/start_web.sh</code>
    </div>
    <p class="hint">启动后刷新页面即可访问</p>
  </div>

  <div v-else class="iframe-container">
    <iframe 
      src="http://localhost:7860" 
      title="RAG 知识库查询系统"
      @load="iframeLoaded = true"
    ></iframe>
  </div>

  <div class="rag-features">
    <h2>✨ 功能特性</h2>
    <div class="feature-grid">
      <div class="feature-item">
        <span class="feature-icon">🔍</span>
        <h3>智能问答</h3>
        <p>输入问题，获取基于知识库的专业答案</p>
      </div>
      <div class="feature-item">
        <span class="feature-icon">📊</span>
        <h3>多结果展示</h3>
        <p>显示多个相关文本块及其相似度评分</p>
      </div>
      <div class="feature-item">
        <span class="feature-icon">📑</span>
        <h3>来源追溯</h3>
        <p>每个结果都标注来源文档，方便查证</p>
      </div>
      <div class="feature-item">
        <span class="feature-icon">💡</span>
        <h3>示例问题</h3>
        <p>点击示例快速体验，支持专业术语查询</p>
      </div>
    </div>
  </div>

  <div class="rag-examples">
    <h2>💬 试试问这些问题</h2>
    <div class="example-list">
      <div class="example-tag">二轴车床能加工什么零件？</div>
      <div class="example-tag">G71 外径粗车循环怎么用？</div>
      <div class="example-tag">45 号钢的切削参数是多少？</div>
      <div class="example-tag">数控车床常见刀具类型有哪些？</div>
      <div class="example-tag">CAD 转 G 代码的 AI 方案？</div>
      <div class="example-tag">五轴机床相比三轴的优势？</div>
    </div>
  </div>

  <div class="rag-stats">
    <h2>📊 知识库统计</h2>
    <div class="stats-grid">
      <div class="stat-item">
        <span class="stat-value">3</span>
        <span class="stat-label">核心文档</span>
      </div>
      <div class="stat-item">
        <span class="stat-value">28</span>
        <span class="stat-label">文本块</span>
      </div>
      <div class="stat-item">
        <span class="stat-value">关键词</span>
        <span class="stat-label">检索模式</span>
      </div>
      <div class="stat-item">
        <span class="stat-value">7860</span>
        <span class="stat-label">服务端口</span>
      </div>
    </div>
  </div>
</div>

<style scoped>
.rag-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
}

.rag-header {
  text-align: center;
  margin-bottom: 2rem;
}

.rag-description {
  font-size: 1.1rem;
  color: #666;
  margin-bottom: 1.5rem;
}

.rag-actions {
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
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}

.btn-primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
}

.btn-secondary {
  background: #f3f4f6;
  color: #374151;
}

.btn-secondary:hover {
  background: #e5e7eb;
}

.loading-state, .offline-state {
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
  border-top-color: #667eea;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin: 0 auto 1rem;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}

.offline-icon {
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

.rag-features {
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
  background: #f9fafb;
  border-radius: 12px;
  text-align: center;
  transition: transform 0.3s;
}

.feature-item:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
}

.feature-icon {
  font-size: 2.5rem;
  display: block;
  margin-bottom: 0.5rem;
}

.feature-item h3 {
  margin: 0.5rem 0;
  color: #1f2937;
}

.feature-item p {
  color: #6b7280;
  font-size: 0.95rem;
}

.rag-examples {
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
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border-radius: 20px;
  font-size: 0.9rem;
  cursor: pointer;
  transition: transform 0.2s;
}

.example-tag:hover {
  transform: scale(1.05);
}

.rag-stats {
  margin-top: 3rem;
  padding: 2rem;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 12px;
  color: white;
}

.rag-stats h2 {
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

@media (max-width: 768px) {
  .rag-container {
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
