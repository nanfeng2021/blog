---
layout: page
title: AI 学习中心
description: 从路线图到详细教程的完整学习平台
sidebar: false
page: true
---

<div class="learning-hub">
  <div class="hub-header">
    <h1>🎓 AI 学习中心</h1>
    <p class="subtitle">点击路线图上的任意标签，开始你的 AI 学习之旅</p>
  </div>

  <div class="quick-start">
    <h2>🚀 快速开始</h2>
    <div class="start-buttons">
      <a href="/ai-learning-roadmap" class="start-btn primary">
        🗺️ 查看学习路线图
      </a>
      <a href="/ai-learning/history/turing-test" class="start-btn secondary">
        📖 查看示例教程
      </a>
      <a href="/posts/" class="start-btn alt">
        📝 返回博客文章
      </a>
    </div>
  </div>
</div>

<style scoped>
.learning-hub {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
}

.hub-header {
  text-align: center;
  margin-bottom: 3rem;
}

.hub-header h1 {
  font-size: 2.5rem;
  margin-bottom: 1rem;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.subtitle {
  font-size: 1.2rem;
  color: #666;
}

.quick-start {
  text-align: center;
  padding: 3rem;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 16px;
  color: white;
}

.quick-start h2 {
  font-size: 2rem;
  margin-bottom: 2rem;
  color: white;
}

.start-buttons {
  display: flex;
  gap: 1rem;
  justify-content: center;
  flex-wrap: wrap;
}

.start-btn {
  display: inline-block;
  padding: 1rem 2rem;
  border-radius: 12px;
  font-weight: 600;
  text-decoration: none;
  transition: all 0.3s ease;
  font-size: 1rem;
}

.start-btn.primary {
  background: white;
  color: #667eea;
}

.start-btn.primary:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 20px rgba(255, 255, 255, 0.3);
}

.start-btn.secondary {
  background: rgba(255, 255, 255, 0.2);
  color: white;
  border: 2px solid rgba(255, 255, 255, 0.5);
}

.start-btn.secondary:hover {
  background: rgba(255, 255, 255, 0.3);
  transform: translateY(-4px);
}

.start-btn.alt {
  background: transparent;
  color: white;
  border: 2px solid white;
}

.start-btn.alt:hover {
  background: white;
  color: #667eea;
  transform: translateY(-4px);
}

@media (max-width: 768px) {
  .start-buttons {
    flex-direction: column;
  }

  .start-btn {
    width: 100%;
    text-align: center;
  }
}
</style>
