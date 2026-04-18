---
layout: page
title: 注意力机制
description: 让 AI 学会聚焦关键信息，Transformer 的核心技术
sidebar: true
page: true
---


<div class="learning-content">
    <div class="content-header">
    <span class="category-badge">核心技术</span>
    <h1> 注意力机制</h1>
    <p class="description">让 AI 学会聚焦关键信息，Transformer 的核心技术</p>
  </div>

  <div class="content-body">


## 概述

**注意力机制**（Attention Mechanism）是一种让模型学会"聚焦"重要信息、忽略无关信息的技术。它源于人类视觉系统的注意力机制，现已成为 Transformer、BERT、GPT 等现代 AI 模型的核心组件。

## 核心思想

### 人类注意力的启发

```
当你阅读这句话时：
- 你的眼睛聚焦在当前词汇上 ✓
- 余光扫过周围的词 ✓
- 大脑自动忽略无关信息 ✓

这就是注意力机制：
- 分配不同的"关注度"给不同信息
- 重要信息：高权重
- 次要信息：低权重
```

### 直观理解

```
传统 RNN/LSTM 的问题：
输入："猫坐在垫子上，因为它很软"
问题："它"指代什么？

RNN：所有词同等对待 → 难以判断
Attention：聚焦"猫"和"垫子" → 根据上下文推断

注意力权重分布：
"它" → "猫" (0.3)
"它" → "垫子" (0.6) ← 更高权重
"它" → "坐" (0.1)

结论："它"指代"垫子"
```

## 数学原理

### Attention 公式

```python
Attention(Q, K, V) = softmax(QK^T / √d_k) V

其中：
- Q (Query): 查询向量 - "我想找什么"
- K (Key): 键向量 - "我有什么"
- V (Value): 值向量 - "实际的内容"
- d_k: 键的维度
- √d_k: 缩放因子，防止梯度消失
```

### 计算步骤

```
Step 1: 计算相似度分数
  score = Q · K^T

Step 2: 缩放
  scaled_score = score / √d_k

Step 3: Softmax 归一化
  attention_weights = softmax(scaled_score)
  # 转换为概率分布，和为 1

Step 4: 加权求和
  output = attention_weights · V
  # 根据权重聚合值向量
```

### 具体示例

```python
# 假设有 3 个词："我", "喜欢", "编程"
# 每个词的 Query, Key, Value 向量维度为 4

Q = [[0.5, 0.3, 0.2, 0.1],   # "我"的查询
     [0.4, 0.6, 0.1, 0.2],   # "喜欢"的查询
     [0.3, 0.2, 0.7, 0.4]]   # "编程"的查询

K = [[0.5, 0.3, 0.2, 0.1],   # "我"的键
     [0.4, 0.6, 0.1, 0.2],   # "喜欢"的键
     [0.3, 0.2, 0.7, 0.4]]   # "编程"的键

V = [[1.0, 0.5, 0.3, 0.2],   # "我"的值
     [0.8, 0.9, 0.4, 0.3],   # "喜欢"的值
     [0.6, 0.7, 0.8, 0.9]]   # "编程"的值

# 计算"喜欢"对其他词的关注度
scores = Q[1] @ K.T  # [0.42, 0.53, 0.38]
scaled = scores / √4  # [0.21, 0.265, 0.19]
weights = softmax(scaled)  # [0.32, 0.36, 0.32]

# 加权求和得到输出
output = weights[0]*V[0] + weights[1]*V[1] + weights[2]*V[2]
       = [0.80, 0.74, 0.52, 0.47]
```

## 主要类型

### 1. Self-Attention（自注意力）

同一个序列内部的注意力：

```
输入："我喜欢编程"

每个词都关注序列中的所有词（包括自己）：
- "我" → 关注 ["我", "喜欢", "编程"]
- "喜欢" → 关注 ["我", "喜欢", "编程"]
- "编程" → 关注 ["我", "喜欢", "编程"]

应用：Transformer Encoder, BERT
```

### 2. Cross-Attention（交叉注意力）

两个不同序列之间的注意力：

```
Encoder-Decoder 架构：
- Decoder 的 Query 来自目标序列
- Encoder 的 Key/Value 来自源序列

应用：机器翻译、图像字幕生成
```

### 3. Multi-Head Attention（多头注意力）

多个注意力头并行工作：

```python
# 单个注意力头
head_1 = Attention(QW₁^Q, KW₁^K, VW₁^V)
head_2 = Attention(QW₂^Q, KW₂^K, VW₂^V)
...
head_h = Attention(QW_h^Q, KW_h^K, VW_h^V)

# 拼接所有头的输出
MultiHead(Q, K, V) = Concat(head_1, ..., head_h) W^O

优势：
- 不同头学习不同的表示子空间
- 一个头关注语法，一个头关注语义
- 增强模型的表达能力
```

### 4. Masked Attention（掩码注意力）

只能关注当前位置之前的词：

```
用于解码器（自回归生成）：

预测第 3 个词时：
- 可以看到：词 1, 词 2, 词 3
- 不能看到：词 4, 词 5, ...

掩码矩阵：
    1  2  3  4  5
1 [ 0 -∞ -∞ -∞ -∞]
2 [ 0  0 -∞ -∞ -∞]
3 [ 0  0  0 -∞ -∞]
4 [ 0  0  0  0 -∞]
5 [ 0  0  0  0  0]

-∞ 经过 softmax 后变为 0
```

## 代码实战

### PyTorch 实现 Self-Attention

```python
import torch
import torch.nn as nn
import math

class SelfAttention(nn.Module):
    def __init__(self, embed_size, heads):
        super().__init__()
        self.embed_size = embed_size
        self.heads = heads
        self.head_dim = embed_size // heads
        
        assert self.head_dim * heads == embed_size
        
        # 线性变换矩阵
        self.values = nn.Linear(embed_size, embed_size)
        self.keys = nn.Linear(embed_size, embed_size)
        self.queries = nn.Linear(embed_size, embed_size)
        self.fc_out = nn.Linear(embed_size, embed_size)
    
    def forward(self, values, keys, query, mask=None):
        N = query.shape[0]  # batch size
        value_len, key_len, query_len = values.shape[1], keys.shape[1], query.shape[1]
        
        # 线性变换
        V = self.values(values)
        K = self.keys(keys)
        Q = self.queries(query)
        
        # 分割成多个头
        V = V.reshape(N, value_len, self.heads, self.head_dim)
        K = K.reshape(N, key_len, self.heads, self.head_dim)
        Q = Q.reshape(N, query_len, self.heads, self.head_dim)
        
        # 转置以便计算
        V = V.transpose(1, 2)
        K = K.transpose(1, 2)
        Q = Q.transpose(1, 2)
        
        # 计算注意力分数
        energy = torch.einsum("nqhd,nkhd->nhqk", [Q, K])
        
        # 缩放
        energy = energy / math.sqrt(self.head_dim)
        
        # 应用掩码（如果有）
        if mask is not None:
            energy = energy.masked_fill(mask == 0, float("-1e20"))
        
        # Softmax 和 Dropout
        attention = torch.softmax(energy, dim=-1)
        
        # 加权求和
        out = torch.einsum("nhql,nlhd->nqhd", [attention, V])
        
        # 合并多头
        out = out.transpose(1, 2).reshape(N, query_len, self.heads * self.head_dim)
        
        # 输出线性变换
        out = self.fc_out(out)
        
        return out

# 使用示例
attention = SelfAttention(embed_size=512, heads=8)
x = torch.randn(32, 100, 512)  # (batch, seq_len, embed)
out = attention(x, x, x)  # Self-attention
print(f"输出形状：{out.shape}")  # (32, 100, 512)
```

### 实现 Multi-Head Attention

```python
class MultiHeadAttention(nn.Module):
    def __init__(self, embed_size, num_heads, dropout=0.1):
        super().__init__()
        self.num_heads = num_heads
        self.embed_size = embed_size
        self.head_dim = embed_size // num_heads
        
        self.q_proj = nn.Linear(embed_size, embed_size)
        self.k_proj = nn.Linear(embed_size, embed_size)
        self.v_proj = nn.Linear(embed_size, embed_size)
        self.out_proj = nn.Linear(embed_size, embed_size)
        
        self.dropout = nn.Dropout(dropout)
        self.scale = math.sqrt(self.head_dim)
    
    def forward(self, query, key, value, mask=None):
        batch_size, seq_len_q = query.shape[:2]
        seq_len_k = key.shape[1]
        
        # 投影并分割多头
        Q = self.q_proj(query).view(batch_size, seq_len_q, self.num_heads, self.head_dim).transpose(1, 2)
        K = self.k_proj(key).view(batch_size, seq_len_k, self.num_heads, self.head_dim).transpose(1, 2)
        V = self.v_proj(value).view(batch_size, seq_len_k, self.num_heads, self.head_dim).transpose(1, 2)
        
        # 计算注意力分数
        scores = torch.matmul(Q, K.transpose(-2, -1)) / self.scale
        
        # 应用掩码
        if mask is not None:
            scores = scores.masked_fill(mask == 0, -1e9)
        
        # 注意力权重
        attn_weights = torch.softmax(scores, dim=-1)
        attn_weights = self.dropout(attn_weights)
        
        # 加权求和
        context = torch.matmul(attn_weights, V)
        
        # 合并多头
        context = context.transpose(1, 2).contiguous().view(batch_size, seq_len_q, self.embed_size)
        
        # 输出投影
        output = self.out_proj(context)
        
        return output, attn_weights

# 可视化注意力权重
model = MultiHeadAttention(embed_size=512, num_heads=8)
query = torch.randn(1, 10, 512)
key = torch.randn(1, 10, 512)
value = torch.randn(1, 10, 512)

output, attn_weights = model(query, key, value)
print(f"注意力权重形状：{attn_weights.shape}")  # (1, 8, 10, 10)
```

### Transformer 中的注意力

```python
import torch.nn.functional as F

class TransformerBlock(nn.Module):
    def __init__(self, embed_size, num_heads, ff_dim, dropout=0.1):
        super().__init__()
        self.attention = MultiHeadAttention(embed_size, num_heads, dropout)
        
        self.norm1 = nn.LayerNorm(embed_size)
        self.norm2 = nn.LayerNorm(embed_size)
        
        self.feed_forward = nn.Sequential(
            nn.Linear(embed_size, ff_dim),
            nn.ReLU(),
            nn.Linear(ff_dim, embed_size)
        )
        
        self.dropout = nn.Dropout(dropout)
    
    def forward(self, x, mask=None):
        # 多头自注意力 + 残差连接
        attn_out, attn_weights = self.attention(x, x, x, mask)
        x = self.norm1(x + self.dropout(attn_out))
        
        # 前馈网络 + 残差连接
        ff_out = self.feed_forward(x)
        x = self.norm2(x + self.dropout(ff_out))
        
        return x, attn_weights

# 创建 Transformer 块
transformer_block = TransformerBlock(
    embed_size=512,
    num_heads=8,
    ff_dim=2048,
    dropout=0.1
)

x = torch.randn(32, 100, 512)
out, attn_weights = transformer_block(x)
print(f"输出：{out.shape}")  # (32, 100, 512)
```

## 应用场景

### 1. 机器翻译

```
源句子（德语）："Ich mag Programmieren"
目标句子（英语）："I like programming"

Self-Attention（Encoder）:
- 每个德语词关注所有德语词
- 捕捉句内依赖关系

Cross-Attention（Decoder）:
- 每个英语词关注所有德语词
- 实现对齐和翻译

示例：
"programming" → 高度关注 "Programmieren"
```

### 2. 文本摘要

```
输入：长文章（1000 词）
输出：摘要（100 词）

注意力机制：
- 识别关键句子和短语
- 忽略冗余信息
- 聚焦核心内容

应用：新闻摘要、论文摘要
```

### 3. 问答系统

```
问题："谁发明了电话？"
段落："亚历山大·贝尔在 1876 年获得了电话专利..."

注意力权重：
- "谁" → 高度关注 "亚历山大·贝尔"
- 其他词权重较低

答案："亚历山大·贝尔"
```

### 4. 图像描述生成

```
输入：图像
输出："一只棕色的狗在草地上奔跑"

Visual Attention:
- 生成"狗"时 → 关注图像中的狗区域
- 生成"草地"时 → 关注草地区域
- 生成"奔跑"时 → 关注动作区域
```

## 优势与局限

### 优势

✅ **捕捉长距离依赖**
- 任意两个位置直接相连
- 路径长度为 O(1)
- 解决 RNN 的梯度消失问题

✅ **并行计算**
- 所有位置同时计算
- GPU 利用率高
- 训练速度快

✅ **可解释性**
- 注意力权重可视化
- 理解模型决策过程
- 调试和分析更简单

✅ **灵活性**
- 适用于各种任务
- 处理变长序列
- 多模态融合

### 局限性

❌ **计算复杂度高**
- 时间复杂度：O(n²)
- 空间复杂度：O(n²)
- 长序列计算成本高

❌ **缺乏位置信息**
- 需要位置编码补充
- 对顺序不敏感

❌ **注意力分散**
- 有时关注无关信息
- 需要训练数据量大

## 改进变体

### 1. Scaled Dot-Product Attention

标准实现，加入缩放因子：

```python
def scaled_dot_product_attention(Q, K, V, mask=None):
    d_k = Q.shape[-1]
    scores = torch.matmul(Q, K.transpose(-2, -1)) / math.sqrt(d_k)
    
    if mask is not None:
        scores = scores.masked_fill(mask == 0, -1e9)
    
    attn_weights = torch.softmax(scores, dim=-1)
    output = torch.matmul(attn_weights, V)
    
    return output, attn_weights
```

### 2. Sparse Attention

减少计算量：

```
局部注意力：只关注邻近的词
滑动窗口：固定大小的上下文窗口
随机注意力：随机选择部分位置

优势：
- 复杂度从 O(n²) 降到 O(n log n) 或 O(n)
- 支持更长序列
```

### 3. Linear Attention

线性复杂度注意力：

```python
# 使用核函数近似 softmax
def linear_attention(Q, K, V):
    # 使用 ReLU 或其他核函数
    Q_hat = torch.relu(Q)
    K_hat = torch.relu(K)
    
    # 改变计算顺序
    KV = torch.matmul(K.transpose(-2, -1), V)
    output = torch.matmul(Q_hat, KV)
    
    return output
```

### 4. Flash Attention

GPU 优化的高效实现：

```
特点：
- IO 感知算法
- 减少 HBM 访问
- 速度提升 2-4 倍
- 内存占用更低

库：https://github.com/Dao-AILab/flash-attention
```

## 学习资源

### 📺 视频教程
- **[李宏毅 Attention 详解](https://www.youtube.com/results?search_query=李宏毅+attention)** - 中文最佳讲解
- **[Stanford CS224n - Attention](https://www.youtube.com/results?search_query=cs224n+attention)** - 深入理论
- **[The Illustrated Transformer](https://www.youtube.com/results?search_query=illustrated+transformer)** - 可视化讲解

### 📚 论文推荐
- **[原始论文]** [Neural Machine Translation by Jointly Learning to Align and Translate](https://arxiv.org/abs/1409.0473) - Bahdanau Attention
- **[Scaled Dot-Product]** [Attention Is All You Need](https://arxiv.org/abs/1706.03762) - Transformer
- **[Survey]** [A Survey on Visual Attention](https://arxiv.org/abs/2006.11017)

### 💻 实践工具
- **[Hugging Face Transformers](https://huggingface.co/transformers/)** - 预训练模型
- **[Flash Attention](https://github.com/Dao-AILab/flash-attention)** - 高效实现
- **[PyTorch nn.MultiheadAttention](https://pytorch.org/docs/stable/generated/torch.nn.MultiheadAttention.html)** - 官方实现

## 相关概念

- [[Transformer]](/ai-learning/topics/transformer) - 基于注意力的架构
- [[BERT]](/ai-learning/topics/bert) - 双向注意力模型
- [[GPT]](/ai-learning/topics/gpt) - 自回归注意力模型
- [[RNN 与 LSTM]](/ai-learning/topics/rnn-lstm) - 被注意力取代的旧架构

## 下一步学习

完成这个概念后，建议继续学习：

1. **[Transformer](/ai-learning/topics/transformer)** - 完整的 Transformer 架构
2. **[BERT](/ai-learning/topics/bert)** - 双向注意力应用
3. **[大语言模型](/ai-learning/topics/llm)** - 注意力的规模化应用


  </div>

  <div class="content-navigation">
    <div class="nav-card prev">
      <span class="nav-label">上一个</span>
      <a href="/ai-learning/topics/rnn-lstm" class="nav-link">← RNN 与 LSTM</a>
    </div>
    <div class="nav-card next">
      <span class="nav-label">下一个</span>
      <a href="/ai-learning/topics/llm" class="nav-link">大语言模型 →</a>
    </div>
  </div>
</div>

<style scoped> .learning-content { max-width: 900px; margin: 0 auto; padding: 2rem; } .content-header { margin-bottom: 2rem; padding-bottom: 1.5rem; border-bottom: 2px solid #e5e7eb; } .category-badge { display: inline-block; background: linear-gradient(135deg, #fa709a 0%, #fee140 100%); color: white; padding: 0.25rem 0.75rem; border-radius: 15px; font-size: 0.85rem; margin-bottom: 1rem; text-transform: uppercase; } .content-header h1 { font-size: 2.5rem; margin-bottom: 0.75rem; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; } .description { font-size: 1.1rem; color: #666; line-height: 1.6; } .content-body { line-height: 1.8; color: #374151; } .content-body h2 { color: #667eea; margin-top: 2rem; margin-bottom: 1rem; font-size: 1.5rem; } .content-body h3 { color: #764ba2; margin-top: 1.5rem; margin-bottom: 0.75rem; font-size: 1.2rem; } .content-body table { width: 100%; border-collapse: collapse; margin: 1.5rem 0; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1); } .content-body th { background: linear-gradient(135deg, #fa709a 0%, #fee140 100%); color: white; padding: 1rem; text-align: left; font-weight: 600; } .content-body td { padding: 0.75rem 1rem; border-bottom: 1px solid #e5e7eb; } .content-body tr:last-child td { border-bottom: none; } .content-body ul { margin: 1rem 0; padding-left: 1.5rem; } .content-body li { margin: 0.5rem 0; line-height: 1.6; } .content-body a { color: #667eea; text-decoration: none; transition: color 0.2s; font-weight: 500; } .content-body a:hover { color: #764ba2; text-decoration: underline; } .content-body strong { color: #1f2937; font-weight: 600; } .content-body pre { background: #1f2937; color: #f3f4f6; padding: 1.5rem; border-radius: 8px; overflow-x: auto; margin: 1.5rem 0; font-family: 'JetBrains Mono', monospace; font-size: 0.9em; line-height: 1.6; } .content-body code { font-family: 'JetBrains Mono', monospace; } .content-body blockquote { border-left: 4px solid #fa709a; padding-left: 1rem; margin: 1.5rem 0; color: #4b5563; font-style: italic; background: #f9fafb; padding: 1rem; border-radius: 0 8px 8px 0; } .content-navigation { display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; margin-top: 3rem; padding-top: 2rem; border-top: 2px solid #e5e7eb; } .nav-card { background: white; border: 2px solid #e5e7eb; border-radius: 12px; padding: 1.5rem; transition: all 0.3s ease; } .nav-card:hover { border-color: #fa709a; box-shadow: 0 4px 12px rgba(250, 112, 154, 0.2); transform: translateY(-2px); } .nav-label { display: block; font-size: 0.85rem; color: #6b7280; margin-bottom: 0.5rem; } .nav-link { display: block; font-size: 1.1rem; font-weight: 600; color: #667eea; text-decoration: none; transition: color 0.2s; } .nav-link:hover { color: #764ba2; } @media (max-width: 768px) { .learning-content { padding: 1rem; } .content-header h1 { font-size: 1.8rem; } .content-navigation { grid-template-columns: 1fr; } } </style>
