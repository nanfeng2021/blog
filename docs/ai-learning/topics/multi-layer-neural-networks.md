---
layout: page
title: 多层神经网络
description: 包含多个隐藏层的神经网络架构
sidebar: true
page: true
---

<div class="learning-content">
  <div class="content-header">
    <span class="category-badge">核心技术 · 深度学习基础</span>
    <h1>🧠 多层神经网络</h1>
    <p class="description">包含输入层、多个隐藏层和输出层的神经网络，是深度学习的基础架构</p>
  </div>

  <div class="content-body">

## 概述

**多层神经网络**（Multi-Layer Neural Networks）是指包含两个或更多隐藏层的人工神经网络，能够学习复杂的非线性映射。

## 网络结构

```
输入层 → 隐藏层 1 → 隐藏层 2 → ... → 输出层
   ↓          ↓           ↓              ↓
 x₁, x₂     h₁¹, h₂¹    h₁², h₂²       y₁, y₂
```

## Python 实现

```python
import numpy as np

class MultiLayerPerceptron:
    def __init__(self, layer_sizes):
        """初始化网络"""
        self.weights = []
        self.biases = []
        
        for i in range(len(layer_sizes) - 1):
            w = np.random.randn(layer_sizes[i], layer_sizes[i+1]) * 0.1
            b = np.zeros((1, layer_sizes[i+1]))
            self.weights.append(w)
            self.biases.append(b)
    
    def relu(self, x):
        return np.maximum(0, x)
    
    def relu_derivative(self, x):
        return (x > 0).astype(float)
    
    def forward(self, X):
        """前向传播"""
        self.activations = [X]
        self.z_values = []
        
        for W, b in zip(self.weights, self.biases):
            z = self.activations[-1] @ W + b
            self.z_values.append(z)
            
            # 隐藏层用 ReLU，输出层用线性激活
            if len(self.z_values) < len(self.weights):
                a = self.relu(z)
            else:
                a = z
            
            self.activations.append(a)
        
        return self.activations[-1]
    
    def backward(self, y, lr=0.01):
        """反向传播"""
        m = y.shape[0]
        
        # 输出层误差
        delta = (self.activations[-1] - y)
        
        for l in range(len(self.weights) - 1, -1, -1):
            # 计算梯度
            dW = self.activations[l].T @ delta / m
            db = np.sum(delta, axis=0, keepdims=True) / m
            
            # 更新参数
            self.weights[l] -= lr * dW
            self.biases[l] -= lr * db
            
            # 传播误差到下一层
            if l > 0:
                delta = (delta @ self.weights[l].T) * self.relu_derivative(self.z_values[l-1])
    
    def fit(self, X, y, epochs=1000, lr=0.01):
        """训练网络"""
        for epoch in range(epochs):
            output = self.forward(X)
            self.backward(y, lr)
            
            if epoch % 100 == 0:
                loss = np.mean((output - y) ** 2)
                print(f"Epoch {epoch}, Loss: {loss:.4f}")

# 使用示例
mlp = MultiLayerPerceptron([2, 8, 8, 1])

X = np.array([[0, 0], [0, 1], [1, 0], [1, 1]])
y = np.array([[0], [1], [1], [0]])  # XOR

mlp.fit(X, y, epochs=1000, lr=0.1)

predictions = mlp.forward(X)
print(f"预测：{predictions.round(2)}")
```

## 关键组件

### 1. 激活函数

```python
# Sigmoid
def sigmoid(x):
    return 1 / (1 + np.exp(-x))

# ReLU (最常用)
def relu(x):
    return np.maximum(0, x)

# Leaky ReLU
def leaky_relu(x, alpha=0.01):
    return np.where(x > 0, x, alpha * x)

# Tanh
def tanh(x):
    return np.tanh(x)
```

### 2. 损失函数

```python
# 均方误差（回归）
def mse_loss(y_pred, y_true):
    return np.mean((y_pred - y_true) ** 2)

# 交叉熵（分类）
def cross_entropy_loss(y_pred, y_true):
    epsilon = 1e-15
    y_pred = np.clip(y_pred, epsilon, 1 - epsilon)
    return -np.mean(y_true * np.log(y_pred))
```

### 3. 优化器

```python
# SGD
def sgd_update(params, grads, lr):
    return params - lr * grads

# Adam
class Adam:
    def __init__(self, lr=0.001, beta1=0.9, beta2=0.999):
        self.lr = lr
        self.beta1 = beta1
        self.beta2 = beta2
        self.m = None
        self.v = None
        self.t = 0
    
    def update(self, params, grads):
        self.t += 1
        if self.m is None:
            self.m = [np.zeros_like(p) for p in params]
            self.v = [np.zeros_like(p) for p in params]
        
        updated = []
        for i, (p, g) in enumerate(zip(params, grads)):
            self.m[i] = self.beta1 * self.m[i] + (1 - self.beta1) * g
            self.v[i] = self.beta2 * self.v[i] + (1 - self.beta2) * (g ** 2)
            
            m_hat = self.m[i] / (1 - self.beta1 ** self.t)
            v_hat = self.v[i] / (1 - self.beta2 ** self.t)
            
            p_new = p - self.lr * m_hat / (np.sqrt(v_hat) + 1e-8)
            updated.append(p_new)
        
        return updated
```

## 应用挑战

⚠️ **梯度消失**: 深层网络梯度难以传递  
⚠️ **过拟合**: 参数过多导致泛化差  
⚠️ **局部最优**: 非凸优化问题

## 解决方案

✅ **Batch Normalization**: 加速训练，缓解梯度消失  
✅ **Dropout**: 随机失活神经元，防止过拟合  
✅ **残差连接**: ResNet 解决退化问题

## 相关概念

- [[反向传播算法]](/ai-learning/history/backpropagation) - 训练方法
- [[深度学习]](/ai-learning/topics/deep-learning) - 更深层网络
- [[CNN]](/ai-learning/topics/cnn) - 卷积神经网络

## 下一步学习

1. **[反向传播算法](/ai-learning/history/backpropagation)** - 深入理解
2. **[CNN](/ai-learning/topics/cnn)** - 卷积神经网络
3. **[深度学习](/ai-learning/topics/deep-learning)** - 高级主题

  </div>

  <div class="content-navigation">
    <div class="nav-card prev">
      <span class="nav-label">上一个</span>
      <a href="/ai-learning/topics/kernel-methods" class="nav-link">← 核方法</a>
    </div>
    <div class="nav-card next">
      <span class="nav-label">下一个</span>
      <a href="/ai-learning/topics/deep-learning" class="nav-link">深度学习 →</a>
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
