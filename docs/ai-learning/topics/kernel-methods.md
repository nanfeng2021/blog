---
layout: page
title: 核方法
description: 将线性方法扩展到非线形的数学技巧
sidebar: true
page: true
---

<div class="learning-content">
  <div class="content-header">
    <span class="category-badge">核心技术 · 数学方法</span>
    <h1>⚛️ 核方法</h1>
    <p class="description">通过核函数将数据映射到高维空间，使线性方法能够处理非线性问题</p>
  </div>

  <div class="content-body">

## 概述

**核方法**（Kernel Methods）是一类基于核函数的机器学习算法，核心思想是将低维非线性问题映射到高维空间变为线性问题。

## 核函数

### 常见核函数

```python
import numpy as np

# 线性核
def linear_kernel(x, y):
    return np.dot(x, y)

# 多项式核
def polynomial_kernel(x, y, degree=3):
    return (np.dot(x, y) + 1) ** degree

# RBF 核（高斯核）
def rbf_kernel(x, y, gamma=0.1):
    diff = x - y
    return np.exp(-gamma * np.dot(diff, diff))

# Sigmoid 核
def sigmoid_kernel(x, y, alpha=0.001, beta=0):
    return np.tanh(alpha * np.dot(x, y) + beta)
```

### 核技巧

```python
# 无需显式计算高维映射
# K(x, y) = φ(x)·φ(y)

from sklearn.svm import SVC

# 使用 RBF 核的 SVM
svm = SVC(kernel='rbf', gamma='scale')
svm.fit(X_train, y_train)

# 等价于在高维空间中训练线性 SVM
# 但计算效率更高！
```

## 应用

### 1. 支持向量机（SVM）

```python
from sklearn.svm import SVC

svm = SVC(kernel='rbf', C=1.0, gamma='scale')
svm.fit(X, y)
predictions = svm.predict(X_test)
```

### 2. 核 PCA

```python
from sklearn.decomposition import KernelPCA

kpca = KernelPCA(n_components=2, kernel='rbf')
X_transformed = kpca.fit_transform(X)
```

### 3. 高斯过程

```python
from sklearn.gaussian_process import GaussianProcessClassifier

gp = GaussianProcessClassifier(kernel='rbf')
gp.fit(X_train, y_train)
```

## 优势与挑战

✅ **优势**:
- 可以处理任意复杂的非线性问题
- 理论上保证全局最优解
- 适用于小样本学习

⚠️ **挑战**:
- 核函数选择困难
- 计算复杂度 O(n²) 或 O(n³)
- 难以解释模型

## 相关概念

- [[统计学习]](/ai-learning/topics/statistical-learning) - 理论基础
- [[SVM]](/ai-learning/topics/svm) - 典型应用
- [[深度学习]](/ai-learning/topics/deep-learning) - 对比方法

## 下一步学习

1. **[统计学习](/ai-learning/topics/statistical-learning)** - 理论背景
2. **[支持向量机](/ai-learning/topics/svm)** - 深入应用

  </div>

  <div class="content-navigation">
    <div class="nav-card prev">
      <span class="nav-label">上一个</span>
      <a href="/ai-learning/topics/statistical-learning" class="nav-link">← 统计学习</a>
    </div>
    <div class="nav-card next">
      <span class="nav-label">下一个</span>
      <a href="/ai-learning/topics/multi-layer-neural-networks" class="nav-link">多层神经网络 →</a>
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
