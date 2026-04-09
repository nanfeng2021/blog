---
layout: page
title: AI 俄罗斯方块
description: AI 驱动的俄罗斯方块游戏 - 观看 AI 自动玩游戏或自己挑战
sidebar: false
page: true
---

<script setup>
import { ref, onMounted } from 'vue'

const gameLoaded = ref(false)
const isLoading = ref(true)
const serviceStatus = ref('checking')

onMounted(() => {
  checkService()
})

async function checkService() {
  try {
    const response = await fetch('http://localhost:5000/health', { method: 'GET' })
    if (response.ok) {
      serviceLoaded.value = true
      serviceStatus.value = 'running'
    } else {
      serviceStatus.value = 'error'
    }
  } catch (error) {
    serviceStatus.value = 'offline'
  }
  isLoading.value = false
}

function openInNewTab() {
  window.open('http://localhost:5000', '_blank')
}
</script>

<div class="game-container">
  <div class="game-header">
    <h1 style="margin-bottom: 0.5rem;">🎮 AI 俄罗斯方块</h1>
    <p class="game-description">经典游戏的 AI 演绎 - 观看智能算法如何玩转俄罗斯方块</p>
    
    <div class="game-actions">
      <button @click="openInNewTab" class="btn-primary">
        🚀 在新窗口打开
      </button>
      <a href="/ai-tetris/docs/README.md" class="btn-secondary">
        📖 使用文档
      </a>
    </div>
  </div>

  <div v-if="isLoading" class="loading-state">
    <div class="spinner"></div>
    <p>正在连接游戏服务...</p>
  </div>

  <div v-else-if="serviceStatus === 'offline'" class="offline-state">
    <div class="offline-icon">⚠️</div>
    <h3>游戏服务未启动</h3>
    <p>俄罗斯方块游戏服务当前未运行，请启动服务：</p>
    <div class="command-box">
      <code>cd /root/.openclaw/workspace/ai-tetris</code><br>
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
      src="http://localhost:5000" 
      title="AI 俄罗斯方块"
      @load="gameLoaded = true"
    ></iframe>
  </div>

  <div class="game-features">
    <h2>✨ 游戏特色</h2>
    <div class="feature-grid">
      <div class="feature-item">
        <span class="feature-icon">🤖</span>
        <h3>AI 自动游戏</h3>
        <p>观看 AI 算法自动玩游戏，学习最优策略</p>
      </div>
      <div class="feature-item">
        <span class="feature-icon">🎯</span>
        <h3>人机对战</h3>
        <p>与 AI 同场竞技，挑战自己的极限</p>
      </div>
      <div class="feature-item">
        <span class="feature-icon">📊</span>
        <h3>实时统计</h3>
        <p>查看得分、消除行数、游戏时长等数据</p>
      </div>
      <div class="feature-item">
        <span class="feature-icon">🏆</span>
        <h3>排行榜</h3>
        <p>记录最高分，与自己和他人比拼</p>
      </div>
    </div>
  </div>

  <div class="game-modes">
    <h2>🎮 游戏模式</h2>
    <div class="mode-list">
      <div class="mode-card">
        <span class="mode-icon">👤</span>
        <h3>手动模式</h3>
        <p>自己控制方块，享受经典游戏体验</p>
        <ul>
          <li>键盘控制方向</li>
          <li>支持加速下落</li>
          <li>实时预览下一个方块</li>
        </ul>
      </div>
      <div class="mode-card">
        <span class="mode-icon">🤖</span>
        <h3>AI 托管</h3>
        <p>让 AI 自动玩游戏，学习高级技巧</p>
        <ul>
          <li>基于强化学习</li>
          <li>实时决策分析</li>
          <li>最优路径规划</li>
        </ul>
      </div>
      <div class="mode-card">
        <span class="mode-icon">⚡</span>
        <h3>极速模式</h3>
        <p>挑战反应速度，获得更高分数</p>
        <ul>
          <li>更快的下落速度</li>
          <li>更高的得分倍率</li>
          <li>适合高手挑战</li>
        </ul>
      </div>
    </div>
  </div>

  <div class="game-controls">
    <h2>🎹 操作说明</h2>
    <div class="controls-grid">
      <div class="control-item">
        <kbd>←</kbd> <kbd>→</kbd>
        <span>左右移动</span>
      </div>
      <div class="control-item">
        <kbd>↑</kbd>
        <span>旋转方块</span>
      </div>
      <div class="control-item">
        <kbd>↓</kbd>
        <span>加速下落</span>
      </div>
      <div class="control-item">
        <kbd>Space</kbd>
        <span>直接掉落</span>
      </div>
      <div class="control-item">
        <kbd>P</kbd>
        <span>暂停游戏</span>
      </div>
      <div class="control-item">
        <kbd>R</kbd>
        <span>重新开始</span>
      </div>
    </div>
  </div>

  <div class="game-stats">
    <h2>📊 游戏信息</h2>
    <div class="stats-grid">
      <div class="stat-item">
        <span class="stat-value">7</span>
        <span class="stat-label">方块类型</span>
      </div>
      <div class="stat-item">
        <span class="stat-value">AI</span>
        <span class="stat-label">强化学习</span>
      </div>
      <div class="stat-item">
        <span class="stat-value">∞</span>
        <span class="stat-label">无限关卡</span>
      </div>
      <div class="stat-item">
        <span class="stat-value">5000</span>
        <span class="stat-label">服务端口</span>
      </div>
    </div>
  </div>

  <div class="ai-info">
    <h2>🧠 AI 算法</h2>
    <div class="ai-content">
      <p>本游戏使用 <strong>强化学习（Reinforcement Learning）</strong> 训练 AI：</p>
      <ul>
        <li><strong>状态空间：</strong> 当前棋盘布局 + 下一个方块</li>
        <li><strong>动作空间：</strong> 移动、旋转、加速</li>
        <li><strong>奖励函数：</strong> 消除行数、平整度、空洞数</li>
        <li><strong>训练方法：</strong> Q-Learning / Deep Q-Network</li>
      </ul>
      <p>AI 经过数千局自我对弈，学会了：</p>
      <ul>
        <li>优先消除多行</li>
        <li>保持表面平整</li>
        <li>避免产生空洞</li>
        <li>预留关键位置</li>
      </ul>
    </div>
  </div>
</div>

<style scoped>
.game-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
}

.game-header {
  text-align: center;
  margin-bottom: 2rem;
}

.game-description {
  font-size: 1.1rem;
  color: #666;
  margin-bottom: 1.5rem;
}

.game-actions {
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
  border-top-color: #667eea;
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

.game-features {
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
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border-radius: 12px;
  text-align: center;
  transition: transform 0.3s;
}

.feature-item:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 16px rgba(102, 126, 234, 0.3);
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

.game-modes {
  margin-top: 3rem;
}

.mode-list {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 1.5rem;
  margin-top: 1.5rem;
}

.mode-card {
  padding: 1.5rem;
  background: white;
  border: 2px solid #e5e7eb;
  border-radius: 12px;
  transition: all 0.3s;
}

.mode-card:hover {
  border-color: #667eea;
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.2);
}

.mode-icon {
  font-size: 3rem;
  display: block;
  margin-bottom: 1rem;
}

.mode-card h3 {
  margin: 0.5rem 0;
  color: #1f2937;
}

.mode-card p {
  color: #6b7280;
  margin-bottom: 1rem;
}

.mode-card ul {
  color: #4b5563;
  padding-left: 1.25rem;
}

.mode-card li {
  margin: 0.5rem 0;
}

.game-controls {
  margin-top: 3rem;
  padding: 2rem;
  background: #f9fafb;
  border-radius: 12px;
}

.controls-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
  gap: 1rem;
  margin-top: 1rem;
}

.control-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.75rem;
  background: white;
  border-radius: 8px;
}

kbd {
  display: inline-block;
  padding: 0.25rem 0.5rem;
  background: #e5e7eb;
  border: 1px solid #d1d5db;
  border-radius: 4px;
  font-family: monospace;
  font-size: 0.85rem;
  font-weight: bold;
}

.control-item span {
  color: #4b5563;
  font-size: 0.95rem;
}

.game-stats {
  margin-top: 3rem;
  padding: 2rem;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 12px;
  color: white;
}

.game-stats h2 {
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

.ai-info {
  margin-top: 3rem;
  padding: 2rem;
  background: white;
  border: 2px solid #e5e7eb;
  border-radius: 12px;
}

.ai-info h2 {
  color: #1f2937;
  margin-bottom: 1rem;
}

.ai-content {
  color: #4b5563;
  line-height: 1.8;
}

.ai-content ul {
  padding-left: 1.5rem;
  margin: 1rem 0;
}

.ai-content li {
  margin: 0.5rem 0;
}

.ai-content strong {
  color: #1f2937;
}

@media (max-width: 768px) {
  .game-container {
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
  
  .mode-list {
    grid-template-columns: 1fr;
  }
}
</style>
