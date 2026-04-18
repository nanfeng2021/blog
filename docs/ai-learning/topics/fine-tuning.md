---
layout: page
title: 微调
description: 在预训练模型基础上适配下游任务的训练方法
sidebar: true
page: true
---

<div class="learning-content">
  <div class="content-header">
    <span class="category-badge">核心技术 · LLM</span>
    <h1>🔧 微调 (Fine-tuning)</h1>
    <p class="description">在预训练大语言模型的基础上，使用特定任务数据进行进一步训练，使模型适配下游应用</p>
  </div>

  <div class="content-body">

## 概述

**微调**（Fine-tuning）是迁移学习的关键步骤，通过在预训练模型基础上使用少量标注数据进行训练，使通用模型适配特定任务。

## 微调方法对比

### 1. 全量微调 (Full Fine-tuning)

```python
from transformers import AutoModelForSequenceClassification, TrainingArguments

model = AutoModelForSequenceClassification.from_pretrained(
    "bert-base-uncased", 
    num_labels=2
)

# 更新所有参数
for param in model.parameters():
    param.requires_grad = True

training_args = TrainingArguments(
    output_dir="./full-ft",
    per_device_train_batch_size=16,
    num_train_epochs=3,
    learning_rate=2e-5,
)
```

**特点**:
- ✅ 性能最好
- ❌ 显存需求高
- ❌ 每个任务一个模型

### 2. LoRA (Low-Rank Adaptation)

```python
from peft import LoraConfig, get_peft_model

# LoRA 配置
lora_config = LoraConfig(
    r=8,                    # 秩
    lora_alpha=32,          # 缩放因子
    target_modules=["q_proj", "v_proj"],  # 目标模块
    lora_dropout=0.1,
    bias="none",
)

# 应用 LoRA
model = get_peft_model(model, lora_config)
model.print_trainable_parameters()
# trainable params: 0.1% of total
```

**特点**:
- ✅ 参数量减少 1000 倍
- ✅ 多个任务共享基座
- ✅ 性能接近全量微调

### 3. QLoRA (Quantized LoRA)

```python
from transformers import BitsAndBytesConfig
from peft import prepare_model_for_kbit_training

# 4bit 量化
bnb_config = BitsAndBytesConfig(
    load_in_4bit=True,
    bnb_4bit_quant_type="nf4",
    bnb_4bit_compute_dtype=torch.float16,
)

model = AutoModelForCausalLM.from_pretrained(
    "meta-llama/Llama-2-7b",
    quantization_config=bnb_config,
    device_map="auto"
)

model = prepare_model_for_kbit_training(model)
```

**特点**:
- ✅ 显存需求降低 4 倍
- ✅ 可在单卡上微调大模型
- ✅ 性能损失极小

### 4. P-Tuning / Prompt Tuning

```python
from peft import PromptTuningConfig, TaskType

peft_config = PromptTuningConfig(
    task_type=TaskType.CAUSAL_LM,
    num_virtual_tokens=8,
    prompt_tuning_init="TEXT",
    prompt_tuning_init_text="分类任务：",
)

model = get_peft_model(model, peft_config)
```

**特点**:
- ✅ 只训练 prompt 参数
- ✅ 超轻量级
- ⚠️ 性能略低

## 微调流程

```python
from datasets import load_dataset
from transformers import AutoTokenizer, DataCollatorWithPadding

# 1. 准备数据
dataset = load_dataset("imdb")
tokenizer = AutoTokenizer.from_pretrained("bert-base-uncased")

def tokenize_function(examples):
    return tokenizer(examples["text"], truncation=True, max_length=512)

tokenized_datasets = dataset.map(tokenize_function, batched=True)

# 2. 数据整理
data_collator = DataCollatorWithPadding(tokenizer=tokenizer)

# 3. 加载模型
model = AutoModelForSequenceClassification.from_pretrained(
    "bert-base-uncased", 
    num_labels=2
)

# 4. 训练配置
training_args = TrainingArguments(
    output_dir="./results",
    evaluation_strategy="epoch",
    save_strategy="epoch",
    logging_steps=100,
    per_device_train_batch_size=32,
    learning_rate=2e-5,
    num_train_epochs=3,
    weight_decay=0.01,
)

# 5. 训练
trainer = Trainer(
    model=model,
    args=training_args,
    train_dataset=tokenized_datasets["train"],
    eval_dataset=tokenized_datasets["test"],
    data_collator=data_collator,
)

trainer.train()

# 6. 评估
metrics = trainer.evaluate()
print(f"准确率：{metrics['eval_accuracy']:.2%}")
```

## 最佳实践

### 1. 学习率选择

```python
# 不同方法的推荐学习率
lr_full_ft = 2e-5      # 全量微调
lr_lora = 1e-4         # LoRA
lr_qlora = 2e-4        # QLoRA
lr_prompt = 1e-3       # Prompt Tuning
```

### 2. 防止过拟合

```python
training_args = TrainingArguments(
    ...
    weight_decay=0.01,           # L2 正则
    warmup_ratio=0.03,           # 学习率预热
    gradient_accumulation_steps=4,  # 梯度累积
    max_grad_norm=1.0,           # 梯度裁剪
)
```

### 3. 高效训练技巧

```python
# 混合精度训练
training_args.fp16 = True

# 梯度检查点（节省显存）
model.gradient_checkpointing_enable()

# FlashAttention 加速
attn_implementation="flash_attention_2"
```

## 应用场景

### 1. 文本分类

```python
model = AutoModelForSequenceClassification.from_pretrained(
    "bert-base-uncased", 
    num_labels=num_classes
)
```

### 2. 问答系统

```python
model = AutoModelForQuestionAnswering.from_pretrained(
    "bert-base-uncased"
)
```

### 3. 文本生成

```python
model = AutoModelForCausalLM.from_pretrained(
    "gpt2",
    finetuning_task="text_generation"
)
```

### 4. 指令微调

```python
# Alpaca 格式
instruction = "解释量子力学"
input_text = ""
output = "量子力学是描述微观物质..."

prompt = f"""Below is an instruction that describes a task. Write a response that appropriately completes the request.

### Instruction:
{instruction}

### Input:
{input_text}

### Response:
{output}"""
```

## 挑战与解决方案

### ⚠️ 灾难性遗忘

**问题**: 微调后失去通用能力

**解决**:
- 混合训练数据（通用 + 特定）
- 弹性权重巩固 (EWC)
- 渐进式微调

### ⚠️ 数据不足

**解决**:
- 数据增强
- 少样本学习 (Few-shot)
- 提示工程替代微调

### ⚠️ 计算资源限制

**解决**:
- QLoRA 量化微调
- 梯度累积
- 模型并行

## 前沿发展

### 1. 指令微调 (Instruction Tuning)

- **FLAN**: 多任务指令微调
- **Alpaca**: 低成本指令跟随
- **Vicuna**: 开源聊天模型

### 2. 人类对齐 (Alignment)

- **RLHF**: 基于人类反馈的强化学习
- **DPO**: 直接偏好优化
- **Constitutional AI**: 原则驱动对齐

### 3. 高效微调

- **AdaLoRA**: 自适应秩分配
- **DoRA**: 权重分解
- **PiSSA**: 主成分初始化

## 学习资源

### 📺 教程
- [Hugging Face 微调指南](https://huggingface.co/docs/transformers/training)
- [PEFT 官方文档](https://huggingface.co/docs/peft)

### 💻 实践
- [LLaMA-Factory](https://github.com/hiyouga/LLaMA-Factory)
- [Axolotl](https://github.com/OpenAccess-AI-Collective/axolotl)

## 相关概念

- [[预训练]](/ai-learning/topics/pretraining) - 第一阶段训练
- [[推理优化]](/ai-learning/topics/inference-optimization) - 部署加速
- [[LoRA]](/ai-learning/topics/lora) - 高效微调技术
- [[LLM]](/ai-learning/topics/llm) - 大语言模型

## 下一步学习

1. **[预训练](/ai-learning/topics/pretraining)** - 理解基础
2. **[LoRA](/ai-learning/topics/lora)** - 高效方法
3. **[推理优化](/ai-learning/topics/inference-optimization)** - 部署应用

  </div>

  <div class="content-navigation">
    <div class="nav-card prev">
      <span class="nav-label">上一个</span>
      <a href="/ai-learning/topics/pretraining" class="nav-link">← 预训练</a>
    </div>
    <div class="nav-card next">
      <span class="nav-label">下一个</span>
      <a href="/ai-learning/topics/inference-optimization" class="nav-link">推理优化 →</a>
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
