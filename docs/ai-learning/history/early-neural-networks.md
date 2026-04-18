---
layout: page
title: 早期神经网络
description: 1940s-1950s 神经网络研究的起源与萌芽
sidebar: true
page: true
---

<div class="learning-content">
  <div class="content-header">
    <span class="category-badge">AI 历史 · 1940s-1950s</span>
    <h1>🧠 早期神经网络</h1>
    <p class="description">从 McCulloch-Pitts 神经元到感知机，神经网络的起源与早期探索</p>
  </div>

  <div class="content-body">

## 概述

**早期神经网络**（Early Neural Networks）是指 1940 年代至 1950 年代的神经网络研究，这一时期奠定了连接主义 AI 的理论基础。

## 关键里程碑

### 1. McCulloch-Pitts 神经元（1943）

第一个数学化的神经元模型：

```python
# M-P 神经元实现
def mp_neuron(inputs, weights, threshold):
    """McCulloch-Pitts 神经元"""
    weighted_sum = sum(x * w for x, w in zip(inputs, weights))
    return 1 if weighted_sum >= threshold else 0

# 示例：实现 AND 逻辑门
inputs = [[0, 0], [0, 1], [1, 0], [1, 1]]
weights = [1, 1]
threshold = 2

for x in inputs:
    output = mp_neuron(x, weights, threshold)
    print(f"AND({x}) = {output}")
```

### 2. Hebb 学习规则（1949）

"一起激发的神经元连在一起"：

```python
# Hebbian 学习
def hebbian_learning(pre, post, weight, learning_rate=0.1):
    """Hebb 学习规则"""
    delta = learning_rate * pre * post
    return weight + delta

# 示例
w = 0.5
w_new = hebbian_learning(pre=1, post=1, weight=w)
print(f"新权重：{w_new}")  # 0.6
```

### 3. 感知机（1957）

Frank Rosenblatt 发明第一个可学习的神经网络：

```python
import numpy as np

class Perceptron:
    def __init__(self, input_size, lr=0.1):
        self.weights = np.random.randn(input_size)
        self.bias = np.random.randn()
        self.lr = lr
    
    def predict(self, X):
        return np.where(np.dot(X, self.weights) + self.bias > 0, 1, 0)
    
    def fit(self, X, y, epochs=100):
        for _ in range(epochs):
            for xi, yi in zip(X, y):
                pred = self.predict(xi.reshape(1, -1))[0]
                error = yi - pred
                self.weights += self.lr * error * xi
                self.bias += self.lr * error

# 使用示例
X = np.array([[0, 0], [0, 1], [1, 0], [1, 1]])
y = np.array([0, 0, 0, 1])  # AND 逻辑

perceptron = Perceptron(2)
perceptron.fit(X, y)
print(f"预测：{perceptron.predict(X)}")
```

## 历史意义

- ✅ 证明了神经网络可以学习
- ✅ 启发了后续多层网络研究
- ⚠️ 单层感知机无法解决 XOR 问题（Minsky, 1969）

## 相关概念

- [[感知机]](/ai-learning/history/perceptron) - Rosenblatt 的发明
- [[连接主义]](/ai-learning/history/connectionism) - 理论范式
- [[符号主义]](/ai-learning/history/symbolism) - 对比范式

## 下一步学习

1. **[感知机](/ai-learning/history/perceptron)** - 深入学习
2. **[反向传播算法](/ai-learning/history/backpropagation)** - 多层网络训练

  </div>

  <div class="content-navigation">
    <div class="nav-card prev">
      <span class="nav-label">上一个</span>
      <a href="/ai-learning/history/symbolism" class="nav-link">← 符号主义</a>
    </div>
    <div class="nav-card next">
      <span class="nav-label">下一个</span>
      <a href="/ai-learning/history/dartmouth-conference" class="nav-link">达特茅斯会议 →</a>
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
