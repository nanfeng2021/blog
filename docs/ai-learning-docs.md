---
layout: page
title: AI 学习文档索引
description: 所有 AI 学习教程的完整列表
sidebar: true
page: true
---

<div class="doc-index">
  <div class="index-header">
    <h1>📚 AI 学习文档索引</h1>
    <p class="subtitle">从基础到前沿，完整的 AI 学习教程集合</p>
  </div>

  <div class="stats-bar">
    <div class="stat-item">
      <span class="stat-number">{{ totalTutorials }}</span>
      <span class="stat-label">篇教程</span>
    </div>
    <div class="stat-item">
      <span class="stat-number">{{ totalHistory }}</span>
      <span class="stat-label">篇历史</span>
    </div>
    <div class="stat-item">
      <span class="stat-number">{{ totalTopics }}</span>
      <span class="stat-label">篇技术</span>
    </div>
    <div class="stat-item">
      <span class="stat-number">{{ lastUpdated }}</span>
      <span class="stat-label">最后更新</span>
    </div>
  </div>

  <div class="category-section">
    <h2>📜 AI 历史系列</h2>
    <div class="doc-grid">
      <a v-for="doc in historyDocs" :key="doc.path" :href="doc.path" class="doc-card">
        <div class="doc-icon">{{ doc.icon }}</div>
        <div class="doc-content">
          <h3>{{ doc.title }}</h3>
          <p>{{ doc.description }}</p>
          <div class="doc-meta">
            <span class="tag">{{ doc.category }}</span>
            <span class="date">{{ doc.date }}</span>
          </div>
        </div>
      </a>
    </div>
  </div>

  <div class="category-section">
    <h2>🔧 核心技术系列</h2>
    <div class="doc-grid">
      <a v-for="doc in topicDocs" :key="doc.path" :href="doc.path" class="doc-card">
        <div class="doc-icon">{{ doc.icon }}</div>
        <div class="doc-content">
          <h3>{{ doc.title }}</h3>
          <p>{{ doc.description }}</p>
          <div class="doc-meta">
            <span class="tag">{{ doc.category }}</span>
            <span class="date">{{ doc.date }}</span>
          </div>
        </div>
      </a>
    </div>
  </div>

  <div class="quick-links">
    <h2>🚀 快速入口</h2>
    <div class="link-grid">
      <a href="/ai-learning-roadmap" class="quick-link primary">
        <span class="icon">🗺️</span>
        <span>查看学习路线图</span>
      </a>
      <a href="/ai-learning/" class="quick-link secondary">
        <span class="icon">🎓</span>
        <span>AI 学习中心首页</span>
      </a>
      <a href="/posts/" class="quick-link alt">
        <span class="icon">📝</span>
        <span>返回博客文章</span>
      </a>
    </div>
  </div>
</div>

<script setup>
import { ref, computed } from 'vue'

const historyDocs = [
  { 
    path: '/ai-learning/history/turing-test', 
    icon: '🧪',
    title: '图灵测试', 
    description: '机器智能的判定标准，AI 领域的奠基性思想实验',
    category: '1950s',
    date: '2026-04-14'
  },
  { 
    path: '/ai-learning/history/dartmouth-conference', 
    icon: '🎯',
    title: '达特茅斯会议', 
    description: '1956 年，"人工智能"概念正式诞生的历史性会议',
    category: '1956',
    date: '2026-04-14'
  },
  { 
    path: '/ai-learning/history/perceptron', 
    icon: '🧠',
    title: '感知机', 
    description: '第一个神经网络模型，现代深度学习的鼻祖',
    category: '1957',
    date: '2026-04-14'
  },
  { 
    path: '/ai-learning/history/symbolism', 
    icon: '🔣',
    title: '符号主义', 
    description: '早期 AI 的主流范式，基于符号操作和逻辑推理',
    category: '核心范式',
    date: '2026-04-14'
  },
  { 
    path: '/ai-learning/history/connectionism', 
    icon: '🕸️',
    title: '连接主义', 
    description: '基于神经网络和并行分布处理的 AI 范式',
    category: '核心范式',
    date: '2026-04-14'
  },
  { 
    path: '/ai-learning/history/backpropagation', 
    icon: '🔄',
    title: '反向传播算法', 
    description: '神经网络的训练基石，让深度学习成为可能',
    category: '核心算法',
    date: '2026-04-14'
  }
]

const topicDocs = [
  { 
    path: '/ai-learning/topics/deep-learning', 
    icon: '🧠',
    title: '深度学习', 
    description: '基于多层神经网络的表示学习方法',
    category: '基础',
    date: '2026-04-14'
  },
  { 
    path: '/ai-learning/topics/cnn', 
    icon: '👁️',
    title: '卷积神经网络', 
    description: '计算机视觉的核心技术，受生物视觉皮层启发',
    category: '视觉',
    date: '2026-04-14'
  },
  { 
    path: '/ai-learning/topics/rnn-lstm', 
    icon: '🔁',
    title: 'RNN 与 LSTM', 
    description: '序列建模的经典方法，处理时间序列和自然语言',
    category: '序列',
    date: '2026-04-14'
  },
  { 
    path: '/ai-learning/topics/transformer', 
    icon: '⚡',
    title: 'Transformer 架构', 
    description: '2017 年，"Attention is All You Need"引发的革命',
    category: '架构',
    date: '2026-04-14'
  },
  { 
    path: '/ai-learning/topics/attention-mechanism', 
    icon: '🎯',
    title: '注意力机制', 
    description: '让 AI 学会聚焦关键信息，Transformer 的核心技术',
    category: '基础组件',
    date: '2026-04-14'
  },
  { 
    path: '/ai-learning/topics/bert', 
    icon: '🤖',
    title: 'BERT', 
    description: '双向编码器表示模型，NLP 领域的里程碑',
    category: 'NLP',
    date: '2026-04-14'
  },
  { 
    path: '/ai-learning/topics/gpt', 
    icon: '✨',
    title: 'GPT 系列', 
    description: '生成式预训练 Transformer，从 GPT-1 到 GPT-4',
    category: '生成式 AI',
    date: '2026-04-14'
  },
  { 
    path: '/ai-learning/topics/llm', 
    icon: '🤖',
    title: '大语言模型', 
    description: '参数规模超千亿的语言模型，开启 AI 新纪元',
    category: '前沿',
    date: '2026-04-14'
  }
]

const totalTutorials = 17
const totalHistory = 6
const totalTopics = 9
const lastUpdated = '2026-04-15'
</script>

<style scoped>
.doc-index {
  max-width: 1400px;
  margin: 0 auto;
  padding: 2rem;
}

.index-header {
  text-align: center;
  margin-bottom: 2rem;
}

.index-header h1 {
  font-size: 2.5rem;
  margin-bottom: 0.5rem;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.subtitle {
  font-size: 1.1rem;
  color: #666;
}

.stats-bar {
  display: flex;
  justify-content: center;
  gap: 3rem;
  margin-bottom: 3rem;
  padding: 1.5rem;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 12px;
  color: white;
}

.stat-item {
  text-align: center;
}

.stat-number {
  display: block;
  font-size: 2rem;
  font-weight: bold;
}

.stat-label {
  font-size: 0.9rem;
  opacity: 0.9;
}

.category-section {
  margin-bottom: 3rem;
}

.category-section h2 {
  font-size: 2rem;
  margin-bottom: 1.5rem;
  color: #667eea;
}

.doc-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
  gap: 1.5rem;
}

.doc-card {
  display: flex;
  gap: 1rem;
  padding: 1.5rem;
  background: white;
  border: 2px solid #e5e7eb;
  border-radius: 12px;
  text-decoration: none;
  transition: all 0.3s ease;
}

.doc-card:hover {
  border-color: #667eea;
  box-shadow: 0 8px 20px rgba(102, 126, 234, 0.15);
  transform: translateY(-4px);
}

.doc-icon {
  font-size: 2.5rem;
  flex-shrink: 0;
}

.doc-content {
  flex: 1;
  min-width: 0;
}

.doc-content h3 {
  margin: 0 0 0.5rem 0;
  font-size: 1.2rem;
  color: #667eea;
}

.doc-content p {
  margin: 0 0 1rem 0;
  font-size: 0.9rem;
  color: #666;
  line-height: 1.5;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.doc-meta {
  display: flex;
  gap: 0.5rem;
  align-items: center;
}

.tag {
  display: inline-block;
  padding: 0.25rem 0.75rem;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border-radius: 12px;
  font-size: 0.75rem;
  font-weight: 600;
}

.date {
  font-size: 0.8rem;
  color: #9ca3af;
}

.quick-links {
  margin-top: 3rem;
  padding: 2rem;
  background: #f9fafb;
  border-radius: 12px;
}

.quick-links h2 {
  text-align: center;
  margin-bottom: 1.5rem;
  color: #667eea;
}

.link-grid {
  display: flex;
  gap: 1rem;
  justify-content: center;
  flex-wrap: wrap;
}

.quick-link {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 1rem 2rem;
  border-radius: 12px;
  text-decoration: none;
  font-weight: 600;
  transition: all 0.3s ease;
}

.quick-link.primary {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}

.quick-link.primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
}

.quick-link.secondary {
  background: white;
  color: #667eea;
  border: 2px solid #667eea;
}

.quick-link.secondary:hover {
  background: #667eea;
  color: white;
}

.quick-link.alt {
  background: transparent;
  color: #666;
  border: 2px solid #d1d5db;
}

.quick-link.alt:hover {
  border-color: #667eea;
  color: #667eea;
}

.quick-link .icon {
  font-size: 1.5rem;
}

@media (max-width: 768px) {
  .doc-index {
    padding: 1rem;
  }

  .index-header h1 {
    font-size: 1.8rem;
  }

  .stats-bar {
    flex-wrap: wrap;
    gap: 1.5rem;
  }

  .doc-grid {
    grid-template-columns: 1fr;
  }

  .link-grid {
    flex-direction: column;
  }

  .quick-link {
    width: 100%;
    justify-content: center;
  }
}
</style>
