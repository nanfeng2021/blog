---
layout: page
title: BERT
description: 双向编码器表示模型，NLP 领域的里程碑式突破
sidebar: true
page: true
---


<div class="learning-content">
    <div class="content-header">
    <span class="category-badge">核心技术</span>
    <h1> BERT</h1>
    <p class="description">双向编码器表示模型，NLP 领域的里程碑式突破</p>
  </div>

  <div class="content-body">


## 概述

**BERT**（Bidirectional Encoder Representations from Transformers）是 Google AI 在 2018 年提出的预训练语言模型，它通过**双向上下文**学习语言的深层表示，在 11 项 NLP 任务上刷新了记录，被誉为"NLP 领域的 ImageNet 时刻"。

## 核心创新

### 双向上下文

传统的语言模型只能从左到右或从右到左单向读取：

```
传统单向：[CLS] 我 喜 欢 编 [MASK] → 预测"程"
BERT 双向：[CLS] 我 [MASK] 欢 编 程 → 预测"喜"（利用左右上下文）
```

**优势**：
- ✅ 更完整的语义理解
- ✅ 捕捉长距离依赖
- ✅ 适合下游任务微调

### Masked Language Model (MLM)

随机掩盖 15% 的词，让模型预测：

```python
# MLM 示例
输入："我 喜欢 编 [MASK] 和 吃 [MASK]"
             ↓              ↓
目标："我 喜欢 编 [程] 和 吃 [饭]"
```

**掩盖策略**：
- 80% 替换为 [MASK]
- 10% 替换为随机词
- 10% 保持不变（但依然预测）

### Next Sentence Prediction (NSP)

判断两个句子是否连续：

```
输入：[CLS] 我 喜欢 编 程 [SEP] 因 为 它 很 有 趣 [SEP]
标签：IsNext

输入：[CLS] 我 喜欢 编 程 [SEP] 今 天 天 气 不 错 [SEP]
标签：NotNext
```

**作用**：学习句子间关系，适合问答、推理任务

## 模型架构

### 基于 Transformer Encoder

```python
BERT 架构：
- 多层 Transformer Encoder（12 层 Base, 24 层 Large）
- 自注意力机制（12/16 个头）
- 位置编码（可学习）
- LayerNorm + Dropout
```

### 模型变体

| 模型 | 层数 | 隐藏层 | 注意力头 | 参数量 |
|------|------|--------|---------|--------|
| BERT-Base | 12 | 768 | 12 | 110M |
| BERT-Large | 24 | 1024 | 16 | 340M |

### 输入表示

```
Token Embedding + Segment Embedding + Position Embedding
       ↓                ↓                  ↓
    词向量           句子 A/B 标识        位置信息
```

特殊标记：
- **[CLS]**: 句首标记，用于分类任务
- **[SEP]**: 句子分隔符
- **[MASK]**: 被掩盖的词

## 预训练过程

### 两阶段预训练

```python
# 阶段 1: 长序列，小 batch
预训练数据：BooksCorpus (800M 词) + Wikipedia (2.5B 词)
序列长度：512
batch size: 256
学习率：1e-4
步数：900K

# 阶段 2: 短序列，大 batch（可选优化）
序列长度：128
batch size: 4096
步数：100K
```

### 计算资源

- **BERT-Base**: 4 个 TPU Pod，4 天
- **BERT-Large**: 16 个 TPU Pod，4 天

## 微调应用

### 常见下游任务

#### 1. 单句/句子对分类
```
输入：[CLS] 这部电影很好看 [SEP]
输出：[CLS] 位置的表示 → Softmax → 情感极性
```

应用：情感分析、垃圾邮件检测

#### 2. 问答任务
```
输入：[CLS] 问题 [SEP] 段落 [SEP]
输出：每个词是答案起始/结束的概率
```

应用：机器阅读理解

#### 3. 命名实体识别
```
输入：[CLS] 乔布斯创立了苹果公司 [SEP]
输出：每个词的 BIO 标签（B-PER, I-PER, O, etc.）
```

#### 4. 文本蕴含
```
输入：[CLS] 前提 [SEP] 假设 [SEP]
输出：蕴含/矛盾/中立
```

### 代码实战

#### 使用 Hugging Face Transformers

```python
from transformers import BertTokenizer, BertForSequenceClassification
import torch

# 加载预训练模型和分词器
tokenizer = BertTokenizer.from_pretrained('bert-base-chinese')
model = BertForSequenceClassification.from_pretrained(
    'bert-base-chinese', 
    num_labels=2  # 二分类
)

# 准备数据
text = "这部电影非常精彩"
inputs = tokenizer(text, return_tensors='pt', padding=True, truncation=True)

# 推理
outputs = model(**inputs)
predictions = torch.softmax(outputs.logits, dim=-1)
print(f"正面概率：{predictions[0][1].item():.2%}")
```

#### 微调示例

```python
from transformers import Trainer, TrainingArguments

training_args = TrainingArguments(
    output_dir='./results',
    num_train_epochs=3,
    per_device_train_batch_size=32,
    learning_rate=2e-5,
    warmup_steps=500,
    weight_decay=0.01,
    logging_dir='./logs',
)

trainer = Trainer(
    model=model,
    args=training_args,
    train_dataset=train_dataset,
    eval_dataset=eval_dataset,
)

trainer.train()
```

## 后续发展与变体

### 改进模型

| 模型 | 改进点 | 效果 |
|------|--------|------|
| RoBERTa | 移除 NSP，动态 masking，更大 batch | 全面超越 BERT |
| ALBERT | 参数共享，因子化嵌入 | 参数量减少 10 倍 |
| DistilBERT | 知识蒸馏 | 速度提升 60%，保留 97% 性能 |
| ELECTRA | 替换词检测代替 MLM | 训练效率更高 |
| Chinese-BERT-wwm | 全词掩码（中文） | 中文任务效果更好 |

### 领域适配

- **BioBERT**: 生物医学领域
- **SciBERT**: 科学论文领域
- **LegalBERT**: 法律文档领域
- **FinBERT**: 金融领域

## 局限性

### 理论局限

❌ **预训练与微调的不一致**
- 预训练时用 [MASK]，微调时没有
- 可能导致分布偏移

❌ **独立性假设**
- MLM 假设被掩盖的词相互独立
- 忽略了词之间的依赖关系

❌ **计算成本高**
- 预训练需要大量计算资源
- 大模型难以在边缘设备部署

### 实践挑战

❌ **长文本处理**
- 最大序列长度 512
- 难以处理长文档

❌ **多语言能力有限**
- 主要训练语料是英文
- 低资源语言效果差

❌ **偏见问题**
- 训练数据中的社会偏见会被学习
- 可能产生歧视性输出

## 学习资源

### 📺 视频教程
- **[李宏毅 BERT 详解](https://www.youtube.com/results?search_query=李宏毅+BERT)** - 中文讲解最清晰
- **[Stanford CS224N - BERT 讲座](https://www.youtube.com/results?search_query=cs224n+bert)** - 深入理论
- **[Hugging Face 课程](https://huggingface.co/course)** - 实战导向

### 📚 论文推荐
- **[原始论文]** [BERT: Pre-training of Deep Bidirectional Transformers](https://arxiv.org/abs/1810.04805)
- **[RoBERTa]** [Robustly Optimized BERT Pretraining Approach](https://arxiv.org/abs/1907.11692)
- **[ALBERT]** [A Lite BERT for Self-supervised Learning](https://arxiv.org/abs/1909.11942)

### 💻 实践工具
- **[Hugging Face Transformers](https://huggingface.co/transformers/)** - 最流行的实现
- **[Google BERT GitHub](https://github.com/google-research/bert)** - 官方实现
- **[Simple Transformers](https://simpletransformers.ai/)** - 简化 API

### 📊 数据集
- **GLUE**: 自然语言理解基准
- **SQuAD**: 问答任务基准
- **CLUE**: 中文语言理解基准

## 相关概念

- [[Transformer]](/ai-learning/topics/transformer) - BERT 的基础架构
- [[GPT]](/ai-learning/topics/gpt) - 自回归预训练模型
- [[注意力机制]](/ai-learning/topics/attention-mechanism) - 核心技术
- [[大语言模型]](/ai-learning/topics/llm) - BERT 的后续发展

## 下一步学习

完成这个概念后，建议继续学习：

1. **[RoBERTa](/ai-learning/topics/roberta)** - BERT 的优化版本
2. **[GPT 系列](/ai-learning/topics/gpt)** - 对比学习不同范式
3. **[大语言模型](/ai-learning/topics/llm)** - 了解最新发展


  </div>

  <div class="content-navigation">
    <div class="nav-card prev">
      <span class="nav-label">上一个</span>
      <a href="/ai-learning/topics/transformer" class="nav-link">← Transformer</a>
    </div>
    <div class="nav-card next">
      <span class="nav-label">下一个</span>
      <a href="/ai-learning/topics/gpt" class="nav-link">GPT 系列 →</a>
    </div>
  </div>
</div>

<style scoped> .learning-content { max-width: 900px; margin: 0 auto; padding: 2rem; } .content-header { margin-bottom: 2rem; padding-bottom: 1.5rem; border-bottom: 2px solid #e5e7eb; } .category-badge { display: inline-block; background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); color: white; padding: 0.25rem 0.75rem; border-radius: 15px; font-size: 0.85rem; margin-bottom: 1rem; text-transform: uppercase; } .content-header h1 { font-size: 2.5rem; margin-bottom: 0.75rem; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; } .description { font-size: 1.1rem; color: #666; line-height: 1.6; } .content-body { line-height: 1.8; color: #374151; } .content-body h2 { color: #667eea; margin-top: 2rem; margin-bottom: 1rem; font-size: 1.5rem; } .content-body h3 { color: #764ba2; margin-top: 1.5rem; margin-bottom: 0.75rem; font-size: 1.2rem; } .content-body table { width: 100%; border-collapse: collapse; margin: 1.5rem 0; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1); } .content-body th { background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); color: white; padding: 1rem; text-align: left; font-weight: 600; } .content-body td { padding: 0.75rem 1rem; border-bottom: 1px solid #e5e7eb; } .content-body tr:last-child td { border-bottom: none; } .content-body ul { margin: 1rem 0; padding-left: 1.5rem; } .content-body li { margin: 0.5rem 0; line-height: 1.6; } .content-body a { color: #667eea; text-decoration: none; transition: color 0.2s; font-weight: 500; } .content-body a:hover { color: #764ba2; text-decoration: underline; } .content-body strong { color: #1f2937; font-weight: 600; } .content-body pre { background: #1f2937; color: #f3f4f6; padding: 1.5rem; border-radius: 8px; overflow-x: auto; margin: 1.5rem 0; font-family: 'JetBrains Mono', monospace; font-size: 0.9em; line-height: 1.6; } .content-body code { font-family: 'JetBrains Mono', monospace; } .content-body blockquote { border-left: 4px solid #4facfe; padding-left: 1rem; margin: 1.5rem 0; color: #4b5563; font-style: italic; background: #f9fafb; padding: 1rem; border-radius: 0 8px 8px 0; } .content-navigation { display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; margin-top: 3rem; padding-top: 2rem; border-top: 2px solid #e5e7eb; } .nav-card { background: white; border: 2px solid #e5e7eb; border-radius: 12px; padding: 1.5rem; transition: all 0.3s ease; } .nav-card:hover { border-color: #4facfe; box-shadow: 0 4px 12px rgba(79, 172, 254, 0.2); transform: translateY(-2px); } .nav-label { display: block; font-size: 0.85rem; color: #6b7280; margin-bottom: 0.5rem; } .nav-link { display: block; font-size: 1.1rem; font-weight: 600; color: #667eea; text-decoration: none; transition: color 0.2s; } .nav-link:hover { color: #764ba2; } @media (max-width: 768px) { .learning-content { padding: 1rem; } .content-header h1 { font-size: 1.8rem; } .content-navigation { grid-template-columns: 1fr; } } </style>
