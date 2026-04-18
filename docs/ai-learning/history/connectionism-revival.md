---
layout: page
title: 连接主义复兴
description: 1980 年代神经网络的重新崛起
sidebar: true
page: true
---

<div class="learning-content">
  <div class="content-header">
    <span class="category-badge">AI 历史 · 1980s</span>
    <h1>🔥 连接主义复兴</h1>
    <p class="description">反向传播算法的重新发现与多层神经网络的崛起</p>
  </div>

  <div class="content-body">

## 概述

**连接主义复兴**（Connectionism Revival）指 1980 年代神经网络研究的复苏，主要标志是反向传播算法的普及和 PDP 学派的兴起。

## 关键突破

### 1. 反向传播算法（1986）

Rumelhart, Hinton, Williams 重新发现 BP 算法：

```python
import numpy as np

def sigmoid(x):
    return 1 / (1 + np.exp(-x))

def sigmoid_derivative(x):
    return x * (1 - x)

class NeuralNetwork:
    def __init__(self, layers):
        self.weights = [np.random.randn(n, m) for n, m in zip(layers[:-1], layers[1:])]
    
    def forward(self, X):
        self.activations = [X]
        for W in self.weights:
            z = np.dot(self.activations[-1], W)
            a = sigmoid(z)
            self.activations.append(a)
        return self.activations[-1]
    
    def backward(self, y, lr=0.1):
        error = self.activations[-1] - y
        deltas = [error * sigmoid_derivative(self.activations[-1])]
        
        for l in range(len(self.weights) - 1, 0, -1):
            delta = np.dot(deltas[0], self.weights[l].T) * sigmoid_derivative(self.activations[l])
            deltas.insert(0, delta)
        
        for l in range(len(self.weights)):
            self.weights[l] -= lr * np.dot(self.activations[l].T, deltas[l])

# 使用示例
nn = NeuralNetwork([2, 4, 1])
X = np.array([[0, 0], [0, 1], [1, 0], [1, 1]])
y = np.array([[0], [1], [1], [0]])  # XOR

for _ in range(10000):
    nn.forward(X)
    nn.backward(y)

print(f"预测：{nn.forward(X).round(2)}")
```

### 2. PDP 学派

Parallel Distributed Processing 小组成立：
- Rumelhart, McClelland 等学者
- 出版《Parallel Distributed Processing》（1986）
- 推动神经网络研究国际化

## 影响与意义

- ✅ 解决了多层网络训练问题
- ✅ 证明了神经网络可以学习复杂函数
- ⚠️ 仍面临梯度消失、过拟合等挑战

## 相关概念

- [[反向传播算法]](/ai-learning/history/backpropagation) - 核心算法
- [[多层神经网络]](/ai-learning/topics/multi-layer-neural-networks) - 技术基础
- [[深度学习]](/ai-learning/topics/deep-learning) - 后续发展

## 下一步学习

1. **[反向传播算法](/ai-learning/history/backpropagation)** - 深入理解
2. **[多层神经网络](/ai-learning/topics/multi-layer-neural-networks)** - 架构详解

  </div>

  <div class="content-navigation">
    <div class="nav-card prev">
      <span class="nav-label">上一个</span>
      <a href="/ai-learning/history/backpropagation" class="nav-link">← 反向传播算法</a>
    </div>
    <div class="nav-card next">
      <span class="nav-label">下一个</span>
      <a href="/ai-learning/history/expert-systems" class="nav-link">专家系统 →</a>
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
