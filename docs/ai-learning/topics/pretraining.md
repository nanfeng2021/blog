---
layout: page
title: 预训练
description: 大语言模型的核心训练阶段，学习通用语言表示
sidebar: true
page: true
---

<div class="learning-content">
  <div class="content-header">
    <span class="category-badge">核心技术 · LLM</span>
    <h1>📚 预训练 (Pretraining)</h1>
    <p class="description">大语言模型的第一阶段训练，通过在海量无标注数据上学习，获得通用的语言理解和生成能力</p>
  </div>

  <div class="content-body">

## 概述

**预训练**（Pretraining）是大语言模型训练的第一个阶段，模型在大规模无标注文本数据上进行自监督学习，学习语言的统计规律和知识表示。

## 核心概念

### 自监督学习

```python
# 掩码语言建模示例（BERT）
输入："The [MASK] sat on the mat"
目标："cat"

# 自回归语言建模示例（GPT）
输入："The cat"
目标："sat"
```

### 训练目标

**1. 因果语言建模（Causal LM）**
```python
# GPT 系列使用
loss = -log P(x_t | x_1, x_2, ..., x_{t-1})
```

**2. 掩码语言建模（Masked LM）**
```python
# BERT 使用
loss = -log P(x_masked | context)
```

**3. 填充式语言建模**
```python
# T5 使用
输入："translate English to French: How are you?"
目标："Comment allez-vous?"
```

## 预训练流程

```python
from transformers import AutoModelForCausalLM, AutoTokenizer, TrainingArguments

# 1. 准备数据
tokenizer = AutoTokenizer.from_pretrained("gpt2")
train_data = load_dataset("wikipedia", "20220301.en")

# 2. 分词
def tokenize_function(examples):
    return tokenizer(examples["text"], truncation=True, max_length=512)

tokenized_datasets = train_data.map(tokenize_function, batched=True)

# 3. 加载模型
model = AutoModelForCausalLM.from_pretrained("gpt2")

# 4. 训练配置
training_args = TrainingArguments(
    output_dir="./pretrained-model",
    per_device_train_batch_size=32,
    num_train_epochs=10,
    learning_rate=5e-5,
    fp16=True,  # 混合精度训练
)

# 5. 开始预训练
trainer = Trainer(
    model=model,
    args=training_args,
    train_dataset=tokenized_datasets["train"],
)

trainer.train()
```

## 关键要素

### 1. 数据规模

| 模型 | 训练数据量 | Token 数量 |
|------|-----------|-----------|
| BERT | Wikipedia + BooksCorpus | 3.3B |
| GPT-3 | CommonCrawl + WebText | 300B+ |
| LLaMA | 公开数据集 | 1.4T |
| PaLM | 多源数据 | 780B |

### 2. 计算资源

```python
# 分布式训练配置
deepspeed_config = {
    "zero_optimization": {
        "stage": 3,  # ZeRO-3 优化
    },
    "fp16": {
        "enabled": True
    },
    "gradient_accumulation_steps": 8
}
```

### 3. 模型架构

- **Transformer Decoder-only**: GPT 系列
- **Transformer Encoder-only**: BERT 系列
- **Encoder-Decoder**: T5、BART

## 挑战与解决方案

### ⚠️ 计算成本高

**解决方案**:
- 混合精度训练 (FP16/BF16)
- 梯度检查点
- 模型并行 + 数据并行
- FlashAttention 加速

### ⚠️ 数据质量参差不齐

**解决方案**:
- 严格的数据清洗
- 去重处理
- 毒性内容过滤
- 质量评分筛选

### ⚠️ 灾难性遗忘

**解决方案**:
- 课程学习
- 增量预训练
- 回放缓冲区

## 预训练 vs 微调

| 阶段 | 数据 | 任务 | 目标 |
|------|------|------|------|
| **预训练** | 海量无标注 | 语言建模 | 学习通用表示 |
| **微调** | 少量标注 | 下游任务 | 适配特定应用 |

## 前沿发展

### 1. 高效预训练

- **Chinchilla 定律**: 最优的模型大小与训练数据比例
- **MoE (Mixture of Experts)**: 稀疏激活，提升效率

### 2. 多模态预训练

- **CLIP**: 图文对比学习
- **Flamingo**: 视觉 - 语言模型
- **ImageBind**: 六模态统一表示

### 3. 持续预训练

- 领域适应
- 知识更新
- 多语言扩展

## 学习资源

### 📺 教程
- [Hugging Face 预训练指南](https://huggingface.co/docs/transformers/training)
- [Stanford CS324 - 大模型课程](https://stanford-cs324.github.io/winter2022/)

### 💻 实践
- [Megatron-LM](https://github.com/NVIDIA/Megatron-LM)
- [DeepSpeed](https://www.deepspeed.ai/)
- [ColossalAI](https://colossalai.org/)

## 相关概念

- [[微调]](/ai-learning/topics/fine-tuning) - 第二阶段训练
- [[推理优化]](/ai-learning/topics/inference-optimization) - 部署加速
- [[LLM]](/ai-learning/topics/llm) - 大语言模型
- [[Transformer]](/ai-learning/topics/transformer) - 基础架构

## 下一步学习

1. **[微调](/ai-learning/topics/fine-tuning)** - 下游任务适配
2. **[推理优化](/ai-learning/topics/inference-optimization)** - 高效部署
3. **[LLM](/ai-learning/topics/llm)** - 完整知识体系

  </div>

  <div class="content-navigation">
    <div class="nav-card prev">
      <span class="nav-label">上一个</span>
      <a href="/ai-learning/topics/llm" class="nav-link">← LLM</a>
    </div>
    <div class="nav-card next">
      <span class="nav-label">下一个</span>
      <a href="/ai-learning/topics/fine-tuning" class="nav-link">微调 →</a>
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
