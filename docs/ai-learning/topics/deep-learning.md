---
layout: page
title: 深度学习
description: 基于多层神经网络的表示学习方法
sidebar: true
page: true
---


<div class="learning-content">
    <div class="content-header">
    <span class="category-badge">核心技术</span>
    <h1> 深度学习</h1>
    <p class="description">基于多层神经网络的表示学习方法</p>
  </div>

  <div class="content-body">


## 概述

**深度学习**（Deep Learning）是机器学习的一个子领域，核心是使用多层次的神经网络来学习数据的层次化表示。2006 年以来，深度学习在图像识别、语音识别、自然语言处理等领域取得了突破性进展。

## 为什么需要"深度"？

### 层次化特征学习

```
原始输入 → 低级特征 → 中级特征 → 高级特征 → 输出
         (边缘)      (形状)       (物体部件)   (物体)
```

- **浅层网络**：只能学习简单特征
- **深层网络**：可以学习复杂的抽象概念
- **层级结构**：符合人类认知规律

### 表达能力

- 深度网络可以用更少的参数表达复杂函数
- 某些函数需要指数级的浅层神经元才能近似
- 深度 = 更高的表示效率

## 关键技术突破

### 1. 逐层预训练（2006）

Hinton 提出的**深度信念网络**（DBN）训练策略：

```python
# 贪心逐层预训练
for layer in layers:
    train_layer_as_autoencoder(layer)
    freeze_layer(layer)

# 然后用反向传播微调整个网络
fine_tune_entire_network()
```

**意义**：解决了深层网络难以训练的问题

### 2. ReLU 激活函数（2010）

```python
# ReLU vs Sigmoid
def relu(x):
    return max(0, x)

def sigmoid(x):
    return 1 / (1 + math.exp(-x))
```

**优势**：
- ✅ 解决梯度消失问题
- ✅ 计算效率高
- ✅ 稀疏激活

### 3. Dropout 正则化（2012）

```python
# Training with dropout
if training:
    mask = random_binomial(shape=layer.output.shape, p=0.5)
    output = layer.output * mask / 0.5
else:
    output = layer.output
```

**作用**：防止过拟合，提高泛化能力

### 4. Batch Normalization（2015）

```python
# Normalize activations
mean = batch.mean(axis=0)
variance = batch.var(axis=0)
x_norm = (x - mean) / sqrt(variance + epsilon)
output = gamma * x_norm + beta
```

**好处**：
- 加速收敛
- 允许更大的学习率
- 减少对初始化的敏感

### 5. GPU 加速计算

- CUDA 并行计算
- 大规模矩阵运算优化
- 训练速度提升 10-100 倍

## 主流架构

### 卷积神经网络（CNN）

用于图像处理：

```
输入图像 → [Conv→ReLU→Pool]×N → FC → 输出
          ↓
      特征提取器
```

**代表模型**：
- LeNet (1998)
- AlexNet (2012)
- VGG (2014)
- ResNet (2015)
- EfficientNet (2019)

### 循环神经网络（RNN）

用于序列数据：

```
h_t = f(W_xh * x_t + W_hh * h_{t-1} + b)
y_t = g(W_hy * h_t + b_y)
```

**变体**：
- LSTM（长短期记忆）
- GRU（门控循环单元）
- Bidirectional RNN

### Transformer（2017）

基于自注意力机制：

```
Attention(Q, K, V) = softmax(QK^T / √d_k) V
```

**应用**：
- NLP：BERT, GPT
- 视觉：ViT
- 多模态：CLIP

## 代码实战

### PyTorch 训练 CNN

```python
import torch
import torch.nn as nn
import torch.optim as optim
from torchvision import models

# 使用预训练的 ResNet
model = models.resnet18(pretrained=True)

# 修改最后一层以适应你的任务
num_features = model.fc.in_features
model.fc = nn.Linear(num_features, num_classes)

# 定义损失函数和优化器
criterion = nn.CrossEntropyLoss()
optimizer = optim.Adam(model.parameters(), lr=0.001)

# 训练
for epoch in range(num_epochs):
    for inputs, labels in dataloader:
        optimizer.zero_grad()
        outputs = model(inputs)
        loss = criterion(outputs, labels)
        loss.backward()
        optimizer.step()
    
    print(f'Epoch {epoch+1}, Loss: {loss.item():.4f}')
```

### 迁移学习

```python
# 冻结骨干网络
for param in model.backbone.parameters():
    param.requires_grad = False

# 只训练分类头
optimizer = optim.Adam(filter(lambda p: p.requires_grad, 
                               model.parameters()), 
                      lr=0.001)
```

## 学习资源

### 📺 视频教程
- **[深度学习专项课程 - 吴恩达](https://www.coursera.org/specializations/deep-learning)** - 系统学习 DL
- **[Fast.ai](https://course.fast.ai/)** - 实战导向的深度学习课程
- **[Stanford CS231n](http://cs231n.stanford.edu/)** - CNN 与视觉识别

### 📚 书籍推荐
- **《深度学习》**（花书）- Ian Goodfellow 等（圣经级教材）
- **《Deep Learning with Python》** - François Chollet（Keras 作者）
- **《动手学深度学习》** - 李沐等（含代码实践）

### 🛠️ 实践框架
- **[PyTorch](https://pytorch.org/)** - 研究首选，灵活易用
- **[TensorFlow](https://www.tensorflow.org/)** - 工业部署友好
- **[Keras](https://keras.io/)** - 高级 API，快速原型
- **[Hugging Face](https://huggingface.co/)** - 预训练模型库

### 📊 数据集
- **图像**：ImageNet, COCO, CIFAR
- **文本**：WikiText, SQuAD, GLUE
- **语音**：LibriSpeech, Common Voice
- **多模态**：LAION, Conceptual Captions

## 相关概念

- [[卷积神经网络]](/ai-learning/topics/cnn) - 图像处理的核心架构
- [[Transformer]](/ai-learning/topics/transformer) - 革命性的新架构
- [[反向传播算法]](/ai-learning/history/backpropagation) - 训练的基础
- [[连接主义]](/ai-learning/history/connectionism) - 理论基础

## 下一步学习

完成这个概念后，建议继续学习：

1. **[卷积神经网络](/ai-learning/topics/cnn)** - 深入理解 CNN 架构
2. **[Transformer](/ai-learning/topics/transformer)** - 学习最新架构
3. **[大语言模型](/ai-learning/topics/llm)** - 探索前沿应用


  </div>

  <div class="content-navigation">
    <div class="nav-card prev">
      <span class="nav-label">上一个</span>
      <a href="/ai-learning/history/connectionism" class="nav-link">← 连接主义</a>
    </div>
    <div class="nav-card next">
      <span class="nav-label">下一个</span>
      <a href="/ai-learning/topics/cnn" class="nav-link">卷积神经网络 →</a>
    </div>
  </div>
</div>

<style scoped> .learning-content { max-width: 900px; margin: 0 auto; padding: 2rem; } .content-header { margin-bottom: 2rem; padding-bottom: 1.5rem; border-bottom: 2px solid #e5e7eb; } .category-badge { display: inline-block; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 0.25rem 0.75rem; border-radius: 15px; font-size: 0.85rem; margin-bottom: 1rem; text-transform: uppercase; } .content-header h1 { font-size: 2.5rem; margin-bottom: 0.75rem; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; } .description { font-size: 1.1rem; color: #666; line-height: 1.6; } .content-body { line-height: 1.8; color: #374151; } .content-body h2 { color: #667eea; margin-top: 2rem; margin-bottom: 1rem; font-size: 1.5rem; } .content-body h3 { color: #764ba2; margin-top: 1.5rem; margin-bottom: 0.75rem; font-size: 1.2rem; } .content-body ul { margin: 1rem 0; padding-left: 1.5rem; } .content-body li { margin: 0.5rem 0; line-height: 1.6; } .content-body a { color: #667eea; text-decoration: none; transition: color 0.2s; font-weight: 500; } .content-body a:hover { color: #764ba2; text-decoration: underline; } .content-body strong { color: #1f2937; font-weight: 600; } .content-body pre { background: #1f2937; color: #f3f4f6; padding: 1.5rem; border-radius: 8px; overflow-x: auto; margin: 1.5rem 0; font-family: 'JetBrains Mono', monospace; font-size: 0.9em; line-height: 1.6; } .content-body code { font-family: 'JetBrains Mono', monospace; } .content-body blockquote { border-left: 4px solid #667eea; padding-left: 1rem; margin: 1.5rem 0; color: #4b5563; font-style: italic; background: #f9fafb; padding: 1rem; border-radius: 0 8px 8px 0; } .content-navigation { display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; margin-top: 3rem; padding-top: 2rem; border-top: 2px solid #e5e7eb; } .nav-card { background: white; border: 2px solid #e5e7eb; border-radius: 12px; padding: 1.5rem; transition: all 0.3s ease; } .nav-card:hover { border-color: #667eea; box-shadow: 0 4px 12px rgba(102, 126, 234, 0.2); transform: translateY(-2px); } .nav-label { display: block; font-size: 0.85rem; color: #6b7280; margin-bottom: 0.5rem; } .nav-link { display: block; font-size: 1.1rem; font-weight: 600; color: #667eea; text-decoration: none; transition: color 0.2s; } .nav-link:hover { color: #764ba2; } @media (max-width: 768px) { .learning-content { padding: 1rem; } .content-header h1 { font-size: 1.8rem; } .content-navigation { grid-template-columns: 1fr; } } </style>
