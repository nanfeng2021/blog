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

  <div class="features-grid">
    <div class="feature-card">
      <div class="feature-icon">🗺️</div>
      <h3>学习路线图</h3>
      <p>系统化的 AI 学习路径，从基础到前沿技术</p>
      <a href="/ai-learning-roadmap" class="feature-link">查看路线图 →</a>
    </div>

    <div class="feature-card">
      <div class="feature-icon">📚</div>
      <h3>详细教程</h3>
      <p>每个概念都有深入讲解和实践资源</p>
      <a href="/ai-learning/history/turing-test" class="feature-link">示例教程 →</a>
    </div>

    <div class="feature-card">
      <div class="feature-icon">🎯</div>
      <h3>分阶段学习</h3>
      <p>四个阶段，循序渐进掌握 AI 技能</p>
      <ul class="stage-list">
        <li>阶段 1：基础入门</li>
        <li>阶段 2：深度学习核心</li>
        <li>阶段 3：Transformer 与大模型</li>
        <li>阶段 4：前沿技术方向</li>
      </ul>
    </div>

    <div class="feature-card">
      <div class="feature-icon">💡</div>
      <h3>实用资源</h3>
      <p>精选视频教程、文档、实践项目</p>
      <div class="resource-types">
        <span class="type-tag">视频课程</span>
        <span class="type-tag">官方文档</span>
        <span class="type-tag">实战项目</span>
      </div>
    </div>
  </div>

  <div class="how-to-use">
    <h2>📖 如何使用</h2>
    
    <div class="steps">
      <div class="step">
        <div class="step-number">1</div>
        <div class="step-content">
          <h3>浏览路线图</h3>
          <p>访问 <a href="/ai-learning-roadmap">AI 学习计划路线图</a>，了解整体学习框架</p>
        </div>
      </div>

      <div class="step">
        <div class="step-number">2</div>
        <div class="step-content">
          <h3>点击感兴趣的标签</h3>
          <p>路线图上所有带渐变色背景的标签都可以点击，包括：</p>
          <ul>
            <li>🏷️ 历史发展中的<strong>关键概念</strong></li>
            <li>📖 学习阶段中的<strong>推荐资源</strong></li>
            <li>🔥 热门技术方向的<strong>细分领域</strong></li>
          </ul>
        </div>
      </div>

      <div class="step">
        <div class="step-number">3</div>
        <div class="step-content">
          <h3>深入学习</h3>
          <p>每个标签都会跳转到对应的详细教程页面，包含：</p>
          <ul>
            <li>✅ 概念概述与核心知识点</li>
            <li>✅ 学习资源（视频、文档、项目）</li>
            <li>✅ 相关概念链接</li>
            <li>✅ 下一步学习建议</li>
          </ul>
        </div>
      </div>

      <div class="step">
        <div class="step-number">4</div>
        <div class="step-content">
          <h3>按顺序或自由探索</h3>
          <p>你可以：</p>
          <ul>
            <li>按照阶段 1→2→3→4 的顺序系统学习</li>
            <li>根据兴趣自由探索感兴趣的主题</li>
            <li>通过"上一个/下一个"导航连续学习</li>
          </ul>
        </div>
      </div>
    </div>
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

.features-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 2rem;
  margin-bottom: 4rem;
}

.feature-card {
  background: white;
  border-radius: 12px;
  padding: 2rem;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
}

.feature-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 12px 40px rgba(0, 0, 0, 0.15);
}

.feature-icon {
  font-size: 3rem;
  margin-bottom: 1rem;
}

.feature-card h3 {
  color: #667eea;
  margin-bottom: 0.75rem;
}

.feature-card p {
  color: #666;
  line-height: 1.6;
  margin-bottom: 1rem;
}

.feature-link {
  display: inline-block;
  color: #667eea;
  font-weight: 600;
  text-decoration: none;
  transition: all 0.2s;
}

.feature-link:hover {
  color: #764ba2;
  transform: translateX(4px);
}

.stage-list {
  list-style: none;
  padding: 0;
  margin: 1rem 0;
}

.stage-list li {
  padding: 0.5rem 0;
  padding-left: 1.5rem;
  position: relative;
  color: #555;
  border-bottom: 1px solid #f0f0f0;
}

.stage-list li:last-child {
  border-bottom: none;
}

.stage-list li:before {
  content: '✓';
  position: absolute;
  left: 0;
  color: #43e97b;
  font-weight: bold;
}

.resource-types {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
  margin-top: 1rem;
}

.type-tag {
  background: #f0f0f0;
  padding: 0.25rem 0.75rem;
  border-radius: 15px;
  font-size: 0.85rem;
  color: #666;
}

.how-to-use {
  margin-bottom: 4rem;
}

.how-to-use h2 {
  font-size: 2rem;
  text-align: center;
  margin-bottom: 2rem;
  color: #667eea;
}

.steps {
  display: grid;
  gap: 2rem;
}

.step {
  display: flex;
  gap: 1.5rem;
  align-items: flex-start;
}

.step-number {
  flex-shrink: 0;
  width: 50px;
  height: 50px;
  border-radius: 50%;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.5rem;
  font-weight: bold;
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
}

.step-content h3 {
  color: #667eea;
  margin-bottom: 0.5rem;
}

.step-content p {
  color: #555;
  line-height: 1.6;
  margin-bottom: 0.75rem;
}

.step-content ul {
  list-style: none;
  padding: 0;
  margin: 0.5rem 0;
}

.step-content ul li {
  padding: 0.25rem 0;
  padding-left: 1.5rem;
  position: relative;
  color: #666;
}

.step-content ul li:before {
  content: '▸';
  position: absolute;
  left: 0;
  color: #667eea;
}

.step-content a {
  color: #667eea;
  text-decoration: none;
  font-weight: 500;
}

.step-content a:hover {
  text-decoration: underline;
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
  .learning-hub {
    padding: 1rem;
  }

  .hub-header h1 {
    font-size: 1.8rem;
  }

  .features-grid {
    grid-template-columns: 1fr;
  }

  .step {
    flex-direction: column;
    align-items: center;
    text-align: center;
  }

  .start-buttons {
    flex-direction: column;
  }

  .start-btn {
    width: 100%;
    text-align: center;
  }
}
</style>
