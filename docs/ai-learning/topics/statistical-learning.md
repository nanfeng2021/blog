---
layout: page
title: 统计学习
description: 基于统计学和概率论的机器学习方法
sidebar: true
page: true
---

<div class="learning-content">
  <div class="content-header">
    <span class="category-badge">核心技术 · ML 基础</span>
    <h1>📊 统计学习</h1>
    <p class="description">从数据中学习规律和模式的统计学方法，1990s-2000s 的主流 AI 范式</p>
  </div>

  <div class="content-body">

## 概述

**统计学习**（Statistical Learning）是基于统计学、概率论和优化理论的机器学习方法，强调从有限数据中推断总体规律。

## 核心方法

### 1. 监督学习

```python
from sklearn.linear_model import LogisticRegression
from sklearn.svm import SVC

# 逻辑回归
lr = LogisticRegression()
lr.fit(X_train, y_train)

# 支持向量机
svm = SVC(kernel='rbf', C=1.0)
svm.fit(X_train, y_train)
```

### 2. 无监督学习

```python
from sklearn.cluster import KMeans
from sklearn.decomposition import PCA

# K-means 聚类
kmeans = KMeans(n_clusters=5)
labels = kmeans.fit_predict(X)

# PCA 降维
pca = PCA(n_components=2)
X_reduced = pca.fit_transform(X)
```

### 3. 统计推断

```python
import scipy.stats as stats

# 假设检验
t_stat, p_value = stats.ttest_ind(group1, group2)

# 置信区间
mean = np.mean(data)
ci = stats.norm.interval(0.95, loc=mean, scale=np.std(data))
```

## 经典算法

| 算法 | 类型 | 提出者 | 年份 |
|------|------|--------|------|
| 线性回归 | 回归 | Legendre | 1805 |
| 逻辑回归 | 分类 | Cox | 1958 |
| SVM | 分类/回归 | Vapnik | 1995 |
| 决策树 | 分类/回归 | Quinlan | 1986 |
| 随机森林 | 集成 | Breiman | 2001 |

## 理论基础

- **VC 维**: 模型复杂度度量
- **结构风险最小化**: 平衡拟合与泛化
- **交叉验证**: 模型评估方法
- **偏差 - 方差权衡**: 误差分解

## 相关概念

- [[核方法]](/ai-learning/topics/kernel-methods) - 非线性扩展
- [[深度学习]](/ai-learning/topics/deep-learning) - 后续发展
- [[机器学习]](/ai-learning/topics/machine-learning) - 更广泛范畴

## 下一步学习

1. **[核方法](/ai-learning/topics/kernel-methods)** - 非线性技巧
2. **[深度学习](/ai-learning/topics/deep-learning)** - 现代方法

  </div>

  <div class="content-navigation">
    <div class="nav-card prev">
      <span class="nav-label">上一个</span>
      <a href="/ai-learning/topics/resolution-principle" class="nav-link">← 归结原理</a>
    </div>
    <div class="nav-card next">
      <span class="nav-label">下一个</span>
      <a href="/ai-learning/topics/kernel-methods" class="nav-link">核方法 →</a>
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
.content-body ul, .content-body ol { margin: 1rem 0; padding-left: 1.5rem; }
.content-body li { margin: 0.5rem 0; line-height: 1.6; }
.content-body a { color: #667eea; text-decoration: none; transition: color 0.2s; font-weight: 500; }
.content-body a:hover { color: #764ba2; text-decoration: underline; }
.content-body strong { color: #1f2937; font-weight: 600; }
.content-body pre { background: #1f2937; color: #f3f4f6; padding: 1.5rem; border-radius: 8px; overflow-x: auto; margin: 1.5rem 0; font-family: 'JetBrains Mono', monospace; font-size: 0.9em; line-height: 1.6; }
.content-body code { font-family: 'JetBrains Mono', monospace; }
.content-body blockquote { border-left: 4px solid #f093fb; padding-left: 1rem; margin: 1.5rem 0; color: #4b5563; font-style: italic; background: #f9fafb; padding: 1rem; border-radius: 0 8px 8px 0; }
.content-navigation { display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; margin-top: 3rem; padding-top: 2rem; border-top: 2px solid #e5e7eb; }
.nav-card { background: white; border: 2px solid #e5e7eb; border-radius: 12px; padding: 1.5rem; transition: all 0.3s ease; }
.nav-card:hover { border-color: #f093fb; box-shadow: 0 4px 12px rgba(240, 147, 251, 0.2); transform: translateY(-2px); }
.nav-label { display: block; font-size: 0.85rem; color: #6b7280; margin-bottom: 0.5rem; }
.nav-link { display: block; font-size: 1.1rem; font-weight: 600; color: #667eea; text-decoration: none; transition: color 0.2s; }
.nav-link:hover { color: #764ba2; }
@media (max-width: 768px) { .learning-content { padding: 1rem; } .content-header h1 { font-size: 1.8rem; } .content-navigation { grid-template-columns: 1fr; } }
</style>
