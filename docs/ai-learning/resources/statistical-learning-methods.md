---
layout: page
title: 统计学习方法
description: 李航《统计学习方法》- 机器学习经典教材
sidebar: true
page: true
---

<div class="learning-content">
  <div class="content-header">
    <span class="category-badge">学习资源 · 经典书籍</span>
    <h1>📊 统计学习方法</h1>
    <p class="description">李航著《统计学习方法》- 机器学习领域最经典的中文教材之一</p>
  </div>
  <div class="content-body">

## 书籍概述

**《统计学习方法》** 是李航研究员的经典著作，系统讲解统计学习的理论基础和核心算法。

### 基本信息

- **作者**: 李航（中国科学院）
- **出版社**: 清华大学出版社
- **版次**: 第 2 版（2019 年）
- **难度**: 四星

## 核心内容

### 监督学习

感知机、K 近邻、朴素贝叶斯、决策树、逻辑回归、SVM、提升方法、EM 算法

### 无监督学习

聚类分析、SVD、PCA、LSA、PLSA、MCMC、LDA、PageRank

## 代码示例

使用 scikit-learn 实现 SVM 分类器，调用 fit 方法训练，predict 方法预测。

## 学习建议

1. 先读第一版 - 理论基础更清晰
2. 配合代码实践 - 每个算法都实现一遍
3. 做课后习题 - 巩固理解

## 相关资源

- 前置：[吴恩达 ML 课程](/ai-learning/resources/andrew-ng-ml)
- 后续：[CS224n](/ai-learning/resources/cs224n)、[CS231n](/ai-learning/resources/cs231n)
- 实战：[scikit-learn](/ai-learning/resources/scikit-learn-tutorial)

</div>

<div class="content-navigation">
    <div class="nav-card prev">
      <span class="nav-label">上一个</span>
      <a href="/ai-learning/resources/andrew-ng-ml" class="nav-link">← 吴恩达 ML 课程</a>
    </div>
    <div class="nav-card next">
      <span class="nav-label">下一个</span>
      <a href="/ai-learning/resources/scikit-learn-tutorial" class="nav-link">scikit-learn 实战 →</a>
    </div>
  </div>
</div>

<style scoped>
.learning-content { max-width: 900px; margin: 0 auto; padding: 2rem; }
.content-header { margin-bottom: 2rem; padding-bottom: 1.5rem; border-bottom: 2px solid #e5e7eb; }
.category-badge { display: inline-block; background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); color: white; padding: 0.25rem 0.75rem; border-radius: 15px; font-size: 0.85rem; margin-bottom: 1rem; text-transform: uppercase; }
.content-header h1 { font-size: 2.5rem; margin-bottom: 0.75rem; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }
.description { font-size: 1.1rem; color: #666; line-height: 1.6; }
.content-body { line-height: 1.8; color: #374151; }
.content-body h2 { color: #667eea; margin-top: 2rem; margin-bottom: 1rem; font-size: 1.5rem; }
.content-body h3 { color: #764ba2; margin-top: 1.5rem; margin-bottom: 0.75rem; font-size: 1.2rem; }
.content-body ul { margin: 1rem 0; padding-left: 1.5rem; }
.content-body li { margin: 0.5rem 0; line-height: 1.6; }
.content-body a { color: #667eea; text-decoration: none; transition: color 0.2s; font-weight: 500; }
.content-body a:hover { color: #764ba2; text-decoration: underline; }
.content-body strong { color: #1f2937; font-weight: 600; }
.content-body pre { background: #1f2937; color: #f3f4f6; padding: 1.5rem; border-radius: 8px; overflow-x: auto; margin: 1.5rem 0; font-family: 'JetBrains Mono', monospace; font-size: 0.9em; line-height: 1.6; }
.content-body code { font-family: 'JetBrains Mono', monospace; }
.content-navigation { display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; margin-top: 3rem; padding-top: 2rem; border-top: 2px solid #e5e7eb; }
.nav-card { background: white; border: 2px solid #e5e7eb; border-radius: 12px; padding: 1.5rem; transition: all 0.3s ease; }
.nav-card:hover { border-color: #f093fb; box-shadow: 0 4px 12px rgba(240, 147, 251, 0.2); transform: translateY(-2px); }
.nav-label { display: block; font-size: 0.85rem; color: #6b7280; margin-bottom: 0.5rem; }
.nav-link { display: block; font-size: 1.1rem; font-weight: 600; color: #667eea; text-decoration: none; transition: color 0.2s; }
.nav-link:hover { color: #764ba2; }
@media (max-width: 768px) { .learning-content { padding: 1rem; } .content-header h1 { font-size: 1.8rem; } .content-navigation { grid-template-columns: 1fr; } }
</style>
