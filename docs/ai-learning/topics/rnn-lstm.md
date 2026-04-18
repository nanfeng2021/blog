---
layout: page
title: RNN 与 LSTM
description: 序列建模的经典方法，处理时间序列和自然语言的核心技术
sidebar: true
page: true
---


<div class="learning-content">
    <div class="content-header">
    <span class="category-badge">核心技术</span>
    <h1> RNN 与 LSTM</h1>
    <p class="description">序列建模的经典方法，处理时间序列和自然语言的核心技术</p>
  </div>

  <div class="content-body">


## 概述

**循环神经网络**（Recurrent Neural Network, RNN）是一类专门用于处理序列数据的神经网络，具有记忆能力。**LSTM**（Long Short-Term Memory）是 RNN 的重要变体，解决了长期依赖问题，在语音识别、机器翻译、文本生成等任务中取得了巨大成功。

## 为什么需要 RNN？

### 序列数据的挑战

传统神经网络（如 CNN、全连接网络）的局限：

```
问题 1: 无法处理可变长度输入
  - 图像：固定尺寸（如 224x224）
  - 文本：句子长度不一（5 词 vs 50 词）

问题 2: 无法捕捉时间依赖
  - "我喜欢编程"vs"编程喜欢我"
  - 词序不同，含义完全不同

问题 3: 无法利用上下文信息
  - "他住在法国，会说___"
  - 需要记住"法国"才能填"法语"
```

### RNN 的核心思想

```
RNN: 具有"记忆"的神经网络

在每个时间步 t：
- 接收当前输入 x_t
- 结合之前的隐藏状态 h_{t-1}
- 产生新的隐藏状态 h_t 和输出 y_t

关键：h_t 包含了到时刻 t 为止的所有历史信息
```

## RNN 基础

### 基本结构

```python
# RNN 单元的前向传播
h_t = tanh(W_xh @ x_t + W_hh @ h_{t-1} + b_h)
y_t = W_hy @ h_t + b_y

# 其中：
# - x_t: t 时刻的输入
# - h_t: t 时刻的隐藏状态
# - h_{t-1}: 上一时刻的隐藏状态（记忆）
# - y_t: t 时刻的输出
```

### 展开视图

```
时间展开：

  h_0 → [RNN] → h_1 → [RNN] → h_2 → [RNN] → h_3
         ↓        ↓         ↓         ↓
         x_1      x_2       x_3       x_4
         ↓        ↓         ↓         ↓
         y_1      y_2       y_3       y_4

所有 RNN 单元共享相同的权重 (W_xh, W_hh, W_hy)
```

### 常见架构模式

#### 1. 一对一（标准网络）
```
输入：单张图像
输出：分类标签
应用：ImageNet 分类
```

#### 2. 序列到标签
```
输入：视频帧序列
输出：一个动作类别
应用：动作识别
```

#### 3. 标签到序列
```
输入：图像
输出：描述句子
应用：图像字幕生成
```

#### 4. 序列到序列
```
输入：法语句子
输出：英语句子
应用：机器翻译
```

#### 5. 同步序列
```
输入：视频每帧
输出：每帧的标签
应用：视频分割
```

## LSTM：长短期记忆网络

### RNN 的问题：梯度消失

```
问题：难以学习长期依赖

原因：反向传播时，梯度需要连乘很多时间步
  δ_t = δ_{t+1} · ∂h_{t+1}/∂h_t · ... · ∂h_T/∂h_{T-1}

如果 |∂h/∂h| < 1，连乘后梯度趋近于 0
结果：无法更新早期时间步的权重

例子：
"我在法国长大，...（中间 100 个词）... 所以我会说___"
RNN 很难记住开头的"法国"
```

### LSTM 的核心创新

LSTM 通过**门控机制**控制信息流动：

```
三个门：
1. 遗忘门（Forget Gate）: 决定丢弃什么信息
2. 输入门（Input Gate）: 决定更新什么信息
3. 输出门（Output Gate）: 决定输出什么信息

一个细胞状态（Cell State）: 长期记忆的载体
```

### LSTM 公式详解

```python
# 1. 遗忘门：决定从细胞状态中丢弃什么
f_t = σ(W_f · [h_{t-1}, x_t] + b_f)
# 输出 0-1 之间的值
# 0 = 完全丢弃，1 = 完全保留

# 2. 输入门：决定更新什么信息
i_t = σ(W_i · [h_{t-1}, x_t] + b_i)  # 决定更新哪些位置
C̃_t = tanh(W_C · [h_{t-1}, x_t] + b_C)  # 候选的新信息

# 3. 更新细胞状态
C_t = f_t * C_{t-1} + i_t * C̃_t
# 旧状态 × 遗忘比例 + 新信息 × 输入比例

# 4. 输出门：决定输出什么
o_t = σ(W_o · [h_{t-1}, x_t] + b_o)
h_t = o_t * tanh(C_t)
# 基于细胞状态，过滤后输出
```

### 直观理解

```
细胞状态 C_t 像一条"信息高速公路"

遗忘门：决定让哪些信息继续向前
  - 不重要的信息被丢弃（乘以接近 0 的值）
  - 重要的信息被保留（乘以接近 1 的值）

输入门：决定添加哪些新信息
  - 选择性地写入新信息

输出门：决定读取哪些信息
  - 基于当前细胞状态产生输出

关键优势：
- 梯度可以沿着细胞状态直接传播
- 避免了连乘导致的梯度消失
- 可以学习数百步的长期依赖
```

## GRU：门控循环单元

### 简化版 LSTM

GRU（Gated Recurrent Unit）是 LSTM 的变体：

```
GRU vs LSTM:
- 合并了遗忘门和输入门 → 更新门
- 合并了细胞状态和隐藏状态
- 参数更少，训练更快
- 效果相当，有时更好
```

### GRU 公式

```python
# 更新门：决定更新多少
z_t = σ(W_z · [h_{t-1}, x_t])

# 重置门：决定忘记多少过去
r_t = σ(W_r · [h_{t-1}, x_t])

# 候选激活
h̃_t = tanh(W_h · [r_t * h_{t-1}, x_t])

# 最终输出
h_t = (1 - z_t) * h_{t-1} + z_t * h̃_t
```

## 代码实战

### PyTorch 实现 LSTM

```python
import torch
import torch.nn as nn

class LSTMSentimentClassifier(nn.Module):
    def __init__(self, vocab_size, embed_dim, hidden_dim, num_classes):
        super().__init__()
        
        self.embedding = nn.Embedding(vocab_size, embed_dim)
        
        # LSTM 层
        self.lstm = nn.LSTM(
            input_size=embed_dim,
            hidden_size=hidden_dim,
            num_layers=2,           # 2 层 LSTM
            batch_first=True,       # 输入格式：(batch, seq, feature)
            dropout=0.3,            # Dropout
            bidirectional=False     # 单向 LSTM
        )
        
        # 分类层
        self.fc = nn.Linear(hidden_dim, num_classes)
        self.dropout = nn.Dropout(0.5)
    
    def forward(self, x, lengths=None):
        # x: (batch_size, seq_length)
        embedded = self.embedding(x)  # (batch, seq, embed_dim)
        
        # LSTM 前向传播
        if lengths is not None:
            # 打包变长序列
            packed = nn.utils.rnn.pack_padded_sequence(
                embedded, lengths.cpu(), batch_first=True, enforce_sorted=False
            )
            lstm_out, (hidden, cell) = self.lstm(packed)
        else:
            lstm_out, (hidden, cell) = self.lstm(embedded)
        
        # 使用最后一个隐藏状态进行分类
        # hidden: (num_layers, batch, hidden_dim)
        final_hidden = hidden[-1]  # 取最后一层
        
        out = self.dropout(final_hidden)
        out = self.fc(out)
        
        return out

# 创建模型
model = LSTMSentimentClassifier(
    vocab_size=10000,
    embed_dim=300,
    hidden_dim=256,
    num_classes=2  # 情感二分类
)

print(f"模型参数量：{sum(p.numel() for p in model.parameters()):,}")
```

### 双向 LSTM

```python
# 双向 LSTM：同时考虑过去和未来
lstm = nn.LSTM(
    input_size=300,
    hidden_size=256,
    num_layers=2,
    bidirectional=True,  # 双向
    batch_first=True
)

# 输出维度翻倍（正向 + 反向）
# hidden_state: (num_layers * 2, batch, hidden_size)
```

### 使用预训练词向量

```python
import numpy as np
from gensim.models import KeyedVectors

# 加载预训练的 Word2Vec
word_vectors = KeyedVectors.load_word2vec_format('GoogleNews-vectors-negative300.bin', binary=True)

# 创建嵌入矩阵
vocab_size = len(word_vectors.index_to_key)
embed_dim = 300
embedding_matrix = np.zeros((vocab_size, embed_dim))

for i, word in enumerate(word_vectors.index_to_key):
    embedding_matrix[i] = word_vectors[word]

# 转换为 PyTorch 张量
embedding_tensor = torch.FloatTensor(embedding_matrix)

# 创建不可训练的嵌入层
embedding_layer = nn.Embedding.from_pretrained(
    embedding_tensor,
    freeze=True  # 不更新词向量
)

# 或者创建可训练的嵌入层（微调）
embedding_layer_trainable = nn.Embedding.from_pretrained(
    embedding_tensor,
    freeze=False
)
```

### 完整训练示例

```python
from torch.utils.data import DataLoader, Dataset
import torch.optim as optim

class TextDataset(Dataset):
    def __init__(self, texts, labels, tokenizer, max_len):
        self.texts = texts
        self.labels = labels
        self.tokenizer = tokenizer
        self.max_len = max_len
    
    def __len__(self):
        return len(self.texts)
    
    def __getitem__(self, idx):
        text = self.texts[idx]
        label = self.labels[idx]
        
        # 分词和编码
        encoding = self.tokenizer.encode_plus(
            text,
            max_length=self.max_len,
            padding='max_length',
            truncation=True,
            return_tensors='pt'
        )
        
        return {
            'input_ids': encoding['input_ids'].flatten(),
            'attention_mask': encoding['attention_mask'].flatten(),
            'label': torch.tensor(label, dtype=torch.long)
        }

# 准备数据
train_dataset = TextDataset(train_texts, train_labels, tokenizer, max_len=128)
train_loader = DataLoader(train_dataset, batch_size=32, shuffle=True)

# 创建模型
model = LSTMSentimentClassifier(vocab_size=30522, embed_dim=300, hidden_dim=256, num_classes=2)

# 损失函数和优化器
criterion = nn.CrossEntropyLoss()
optimizer = optim.Adam(model.parameters(), lr=0.001)

# 训练循环
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
model.to(device)

for epoch in range(5):
    model.train()
    total_loss = 0
    
    for batch in train_loader:
        input_ids = batch['input_ids'].to(device)
        attention_mask = batch['attention_mask'].to(device)
        labels = batch['label'].to(device)
        
        optimizer.zero_grad()
        
        # 前向传播
        outputs = model(input_ids)
        loss = criterion(outputs, labels)
        
        # 反向传播
        loss.backward()
        
        # 梯度裁剪（防止梯度爆炸）
        torch.nn.utils.clip_grad_norm_(model.parameters(), max_norm=1.0)
        
        optimizer.step()
        
        total_loss += loss.item()
    
    avg_loss = total_loss / len(train_loader)
    print(f'Epoch {epoch+1}, Loss: {avg_loss:.4f}')
```

## 应用场景

### 1. 自然语言处理

#### 情感分析
```
输入："这部电影太棒了，演员演技在线，剧情精彩"
输出：正面 (95%)
```

#### 机器翻译
```
Encoder: 法语句子 → 上下文向量
Decoder: 上下文向量 → 英语句子

输入："Bonjour, comment allez-vous?"
输出："Hello, how are you?"
```

#### 文本生成
```
输入："从前有座山，"
输出："山里有个庙，庙里有个老和尚在讲故事..."
```

### 2. 语音识别

```
输入：音频频谱序列
输出：文字转录

架构：
- 多层双向 LSTM
- CTC 损失函数
- Beam Search 解码
```

### 3. 时间序列预测

```
输入：过去 30 天的股票价格
输出：未来 7 天的价格预测

应用：
- 股票预测
- 天气预测
- 销量预测
```

### 4. 视频分析

```
输入：视频帧序列
输出：动作分类

应用：
- 行为识别
- 异常检测
- 视频字幕生成
```

## 优缺点对比

### RNN/LSTM的优势

✅ **处理变长序列**
- 无需固定输入长度
- 适合自然语言、时间序列

✅ **捕捉时序依赖**
- 利用上下文信息
- 理解语序和语法

✅ **参数共享**
- 同一模型处理不同位置
- 泛化能力强

✅ **灵活架构**
- 支持多种输入输出模式
- 可与其他网络组合

### 局限性

❌ **训练速度慢**
- 无法并行计算（必须按时间步顺序）
- Transformer 出现后被取代

❌ **长期依赖仍有限**
- 虽然比简单 RNN 好
- 但超过几百步仍困难

❌ **梯度问题**
- 虽然缓解了梯度消失
- 但梯度爆炸仍需处理（梯度裁剪）

❌ **计算效率低**
- 每个时间步都要计算
- GPU 利用率不如 CNN/Transformer

## 与 Transformer 对比

| 特性 | RNN/LSTM | Transformer |
|------|----------|-------------|
| 并行性 | 差（序列依赖） | 优秀（完全并行） |
| 长期依赖 | 中等（~100 步） | 优秀（任意距离） |
| 训练速度 | 慢 | 快 |
| 推理速度 | 慢（自回归） | 快（可并行） |
| 位置信息 | 隐式（时间顺序） | 显式（位置编码） |
| 当前地位 | 逐渐被取代 | 主流架构 |

## 学习资源

### 📺 视频教程
- **[吴恩达 RNN 课程](https://www.coursera.org/learn/nlp-sequence-models)** - 系统性讲解
- **[李宏毅 RNN/LSTM](https://www.youtube.com/results?search_query=李宏毅+RNN)** - 中文详细教程
- **[Stanford CS224n - RNN](https://www.youtube.com/results?search_query=cs224n+rnn)** - 深入理论

### 📚 书籍推荐
- **《深度学习》第 10 章** - Ian Goodfellow（序列建模）
- **《Speech and Language Processing》** - Jurafsky & Martin（NLP 圣经）
- **《Deep Learning with Python》** - François Chollet（实战导向）

### 📄 经典论文
- [Hochreiter & Schmidhuber (1997) - Long Short-Term Memory](https://direct.mit.edu/neco/article-abstract/9/8/1735/6109)
- [Cho et al. (2014) - Learning Phrase Representations using GRU](https://arxiv.org/abs/1406.1078)
- [Graves (2013) - Generating Sequences With Recurrent Neural Networks](https://arxiv.org/abs/1308.0850)

### 💻 实践工具
- **[PyTorch nn.LSTM](https://pytorch.org/docs/stable/generated/torch.nn.LSTM.html)** - 官方文档
- **[TensorFlow Keras LSTM](https://www.tensorflow.org/api_docs/python/tf/keras/layers/LSTM)** - TF 实现
- **[Hugging Face Transformers](https://huggingface.co/transformers/)** - 预训练模型

## 相关概念

- [[反向传播算法]](/ai-learning/history/backpropagation) - 训练基础
- [[注意力机制]](/ai-learning/topics/attention-mechanism) - 解决长期依赖的新方法
- [[Transformer]](/ai-learning/topics/transformer) - 替代 RNN 的新架构
- [[序列到序列]](/ai-learning/tasks/seq2seq) - 重要应用模式

## 下一步学习

完成这个概念后，建议继续学习：

1. **[注意力机制](/ai-learning/topics/attention-mechanism)** - 理解如何聚焦关键信息
2. **[Transformer](/ai-learning/topics/transformer)** - 现代序列建模的主流架构
3. **[序列到序列模型](/ai-learning/tasks/seq2seq)** - 机器翻译等应用


  </div>

  <div class="content-navigation">
    <div class="nav-card prev">
      <span class="nav-label">上一个</span>
      <a href="/ai-learning/topics/cnn" class="nav-link">← CNN</a>
    </div>
    <div class="nav-card next">
      <span class="nav-label">下一个</span>
      <a href="/ai-learning/topics/attention-mechanism" class="nav-link">注意力机制 →</a>
    </div>
  </div>
</div>

<style scoped> .learning-content { max-width: 900px; margin: 0 auto; padding: 2rem; } .content-header { margin-bottom: 2rem; padding-bottom: 1.5rem; border-bottom: 2px solid #e5e7eb; } .category-badge { display: inline-block; background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); color: white; padding: 0.25rem 0.75rem; border-radius: 15px; font-size: 0.85rem; margin-bottom: 1rem; text-transform: uppercase; } .content-header h1 { font-size: 2.5rem; margin-bottom: 0.75rem; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; } .description { font-size: 1.1rem; color: #666; line-height: 1.6; } .content-body { line-height: 1.8; color: #374151; } .content-body h2 { color: #667eea; margin-top: 2rem; margin-bottom: 1rem; font-size: 1.5rem; } .content-body h3 { color: #764ba2; margin-top: 1.5rem; margin-bottom: 0.75rem; font-size: 1.2rem; } .content-body table { width: 100%; border-collapse: collapse; margin: 1.5rem 0; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1); } .content-body th { background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); color: white; padding: 1rem; text-align: left; font-weight: 600; } .content-body td { padding: 0.75rem 1rem; border-bottom: 1px solid #e5e7eb; } .content-body tr:last-child td { border-bottom: none; } .content-body ul { margin: 1rem 0; padding-left: 1.5rem; } .content-body li { margin: 0.5rem 0; line-height: 1.6; } .content-body a { color: #667eea; text-decoration: none; transition: color 0.2s; font-weight: 500; } .content-body a:hover { color: #764ba2; text-decoration: underline; } .content-body strong { color: #1f2937; font-weight: 600; } .content-body pre { background: #1f2937; color: #f3f4f6; padding: 1.5rem; border-radius: 8px; overflow-x: auto; margin: 1.5rem 0; font-family: 'JetBrains Mono', monospace; font-size: 0.9em; line-height: 1.6; } .content-body code { font-family: 'JetBrains Mono', monospace; } .content-body blockquote { border-left: 4px solid #4facfe; padding-left: 1rem; margin: 1.5rem 0; color: #4b5563; font-style: italic; background: #f9fafb; padding: 1rem; border-radius: 0 8px 8px 0; } .content-navigation { display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; margin-top: 3rem; padding-top: 2rem; border-top: 2px solid #e5e7eb; } .nav-card { background: white; border: 2px solid #e5e7eb; border-radius: 12px; padding: 1.5rem; transition: all 0.3s ease; } .nav-card:hover { border-color: #4facfe; box-shadow: 0 4px 12px rgba(79, 172, 254, 0.2); transform: translateY(-2px); } .nav-label { display: block; font-size: 0.85rem; color: #6b7280; margin-bottom: 0.5rem; } .nav-link { display: block; font-size: 1.1rem; font-weight: 600; color: #667eea; text-decoration: none; transition: color 0.2s; } .nav-link:hover { color: #764ba2; } @media (max-width: 768px) { .learning-content { padding: 1rem; } .content-header h1 { font-size: 1.8rem; } .content-navigation { grid-template-columns: 1fr; } } </style>
