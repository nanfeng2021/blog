---
layout: page
sidebar: true
page: true
---

<script setup>
import { ref } from 'vue'

const title = '概念名称'
const category = 'history' // history, stage-X, topics, resources
const content = ref(`
## 概述

这里是概念的详细介绍内容...

## 核心知识点

- 知识点 1
- 知识点 2
- 知识点 3

## 学习资源

### 视频教程
- [资源链接 1](url)
- [资源链接 2](url)

### 文档教程
- [官方文档](url)
- [社区教程](url)

### 实践项目
- [项目 1](url)
- [项目 2](url)

## 相关概念

- [[相关概念 1]](/ai-learning/...)
- [[相关概念 2]](/ai-learning/...)

## 下一步学习

完成这个概念后，建议继续学习：
1. [下一个概念](/ai-learning/...)
2. [进阶主题](/ai-learning/...)
`)
</script>

<div class="learning-content">
  <div class="content-header">
    <span class="category-badge">{{ category }}</span>
    <h1>{{ title }}</h1>
    <p class="description">概念描述</p>
  </div>

  <div class="content-body" v-html="content"></div>

  <div class="content-navigation">
    <div class="nav-card prev">
      <span class="nav-label">上一个</span>
      <a href="/ai-learning-roadmap" class="nav-link">← 返回路线图</a>
    </div>
    <div class="nav-card next">
      <span class="nav-label">下一个</span>
      <a href="/ai-learning-roadmap" class="nav-link">继续学习 →</a>
    </div>
  </div>
</div>

<style scoped>
.learning-content {
  max-width: 900px;
  margin: 0 auto;
  padding: 2rem;
}

.content-header {
  margin-bottom: 2rem;
  padding-bottom: 1.5rem;
  border-bottom: 2px solid #e5e7eb;
}

.category-badge {
  display: inline-block;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 0.25rem 0.75rem;
  border-radius: 15px;
  font-size: 0.85rem;
  margin-bottom: 1rem;
  text-transform: uppercase;
}

.content-header h1 {
  font-size: 2.5rem;
  margin-bottom: 0.75rem;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.description {
  font-size: 1.1rem;
  color: #666;
  line-height: 1.6;
}

.content-body {
  line-height: 1.8;
  color: #374151;
}

.content-body h2 {
  color: #667eea;
  margin-top: 2rem;
  margin-bottom: 1rem;
}

.content-body ul {
  margin: 1rem 0;
  padding-left: 1.5rem;
}

.content-body li {
  margin: 0.5rem 0;
}

.content-body a {
  color: #667eea;
  text-decoration: none;
  transition: color 0.2s;
}

.content-body a:hover {
  color: #764ba2;
  text-decoration: underline;
}

.content-navigation {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1.5rem;
  margin-top: 3rem;
  padding-top: 2rem;
  border-top: 2px solid #e5e7eb;
}

.nav-card {
  background: white;
  border: 2px solid #e5e7eb;
  border-radius: 12px;
  padding: 1.5rem;
  transition: all 0.3s ease;
}

.nav-card:hover {
  border-color: #667eea;
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.2);
  transform: translateY(-2px);
}

.nav-label {
  display: block;
  font-size: 0.85rem;
  color: #6b7280;
  margin-bottom: 0.5rem;
}

.nav-link {
  display: block;
  font-size: 1.1rem;
  font-weight: 600;
  color: #667eea;
  text-decoration: none;
  transition: color 0.2s;
}

.nav-link:hover {
  color: #764ba2;
}

@media (max-width: 768px) {
  .learning-content {
    padding: 1rem;
  }

  .content-header h1 {
    font-size: 1.8rem;
  }

  .content-navigation {
    grid-template-columns: 1fr;
  }
}
</style>
