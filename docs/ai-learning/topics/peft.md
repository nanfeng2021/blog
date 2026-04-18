---
layout: page
title: PEFT
description: 参数高效微调技术，用极少参数适配大模型
sidebar: true
page: true
---

<div class="learning-content">
  <div class="content-header">
    <span class="category-badge">高效微调 · LLM</span>
    <h1>🎯 PEFT (Parameter-Efficient Fine-Tuning)</h1>
    <p class="description">通过冻结大部分预训练参数，仅微调少量参数来适配下游任务，大幅降低计算成本和存储需求</p>
  </div>

  <div class="content-body">

## 概述

**PEFT**（Parameter-Efficient Fine-Tuning）是一类高效微调技术的总称，通过在预训练模型中添加少量可训练参数或调整部分参数，实现对新任务的快速适配。

## 核心方法

### 1. LoRA (Low-Rank Adaptation)

```python
from peft import LoraConfig, get_peft_model

# LoRA 配置
lora_config = LoraConfig(
    r=8,              # 低秩矩阵的秩
    lora_alpha=32,    # 缩放因子
    target_modules=["q_proj", "v_proj"],  # 目标模块
    lora_dropout=0.1,
    bias="none",
    task_type="CAUSAL_LM"
)

# 应用 LoRA
model = AutoModelForCausalLM.from_pretrained("bert-base-uncased")
lora_model = get_peft_model(model, lora_config)
lora_model.print_trainable_parameters()
# trainable params: 0.1% of total
```

### 2. Prefix Tuning

```python
from peft import PrefixTuningConfig

prefix_config = PrefixTuningConfig(
    peft_type="PREFIX_TUNING",
    task_type="CAUSAL_LM",
    num_virtual_tokens=20,  # 虚拟 token 数量
    encoder_hidden_size=512
)

model = get_peft_model(base_model, prefix_config)
```

### 3. P-Tuning v2

```python
from peft import PromptEncoderConfig

prompt_config = PromptEncoderConfig(
    peft_type="P_TUNING",
    task_type="SEQ_2_SEQ_LM",
    num_virtual_tokens=20,
    encoder_reparameterization_type="MLP",
    encoder_hidden_size=512
)
```

### 4. Adapter

```python
from peft import AdapterConfig

adapter_config = AdapterConfig(
    peft_type="ADAPTER",
    task_type="CAUSAL_LM",
    inference_mode=False,
    reduction_factor=16,  # 瓶颈维度
    adapter_initializer_range=0.0002
)
```

## 方法对比

| 方法 | 可训练参数 | 推理延迟 | 适用场景 |
|------|-----------|---------|---------|
| **LoRA** | 0.1-1% | 无增加 | 通用首选 |
| **Prefix Tuning** | 0.01-0.1% | 轻微增加 | 生成任务 |
| **P-Tuning v2** | 0.01-0.1% | 无增加 | 理解任务 |
| **Adapter** | 1-5% | 轻微增加 | 多任务学习 |
| **全量微调** | 100% | 无增加 | 数据充足 |

## 实战示例

### LoRA 微调 LLM

```python
from transformers import AutoTokenizer, AutoModelForCausalLM, TrainingArguments
from peft import LoraConfig, get_peft_model, prepare_model_for_kbit_training
from trl import SFTTrainer

# 加载模型
model_name = "meta-llama/Llama-2-7b-hf"
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = AutoModelForCausalLM.from_pretrained(
    model_name,
    load_in_4bit=True,  # 4bit 量化
    device_map="auto"
)

# 准备模型
model = prepare_model_for_kbit_training(model)

# 配置 LoRA
peft_config = LoraConfig(
    r=16,
    lora_alpha=32,
    lora_dropout=0.05,
    bias="none",
    task_type="CAUSAL_LM",
    target_modules=["q_proj", "k_proj", "v_proj", "o_proj"]
)

model = get_peft_model(model, peft_config)

# 训练配置
training_args = TrainingArguments(
    output_dir="./lora_output",
    per_device_train_batch_size=4,
    gradient_accumulation_steps=4,
    learning_rate=2e-4,
    num_train_epochs=3,
    fp16=True
)

trainer = SFTTrainer(
    model=model,
    args=training_args,
    train_dataset=train_dataset,
    tokenizer=tokenizer,
    dataset_text_field="text"
)

trainer.train()

# 保存 LoRA 权重
model.save_pretrained("./lora_adapter")
```

### 多任务适配

```python
# 为不同任务训练多个 LoRA 适配器
tasks = ["summarization", "translation", "qa"]

for task in tasks:
    # 加载基础模型
    model = AutoModelForCausalLM.from_pretrained("llama-2-7b")
    
    # 添加 LoRA
    lora_config = LoraConfig(task_type=task.upper())
    model = get_peft_model(model, lora_config)
    
    # 训练
    train_model(model, task_datasets[task])
    
    # 保存适配器
    model.save_pretrained(f"./adapters/{task}")

# 推理时动态加载适配器
model.load_adapter("./adapters/summarization", adapter_name="summary")
model.set_adapter("summary")
summary_result = model.generate(input_ids)

model.load_adapter("./adapters/translation", adapter_name="translate")
model.set_adapter("translate")
translation_result = model.generate(input_ids)
```

## 优势分析

### ✅ 存储效率

```
全量微调 BERT: 440MB × N 个任务
LoRA 微调：440MB (基础) + 4MB × N 个适配器

100 个任务节省：44GB → 4.4GB (90% 节省)
```

### ✅ 计算效率

```
全量微调 A100: 8 小时
LoRA 微调 A100: 1 小时 (8x 加速)

显存占用：48GB → 16GB
```

### ✅ 灾难性遗忘缓解

- 冻结预训练知识
- 仅学习任务特定适配
- 多任务性能更稳定

## 进阶技巧

### 秩的选择

```python
# 小数据集：低秩即可
r = 4   # < 1000 样本
r = 8   # 1000-10000 样本
r = 16  # > 10000 样本

# 复杂任务需要更高秩
simple_task = ["情感分析", "分类"]
complex_task = ["代码生成", "创意写作"]
```

### 目标模块选择

```python
# Transformer 各模块的重要性
attention_modules = ["q_proj", "v_proj", "k_proj", "o_proj"]
mlp_modules = ["gate_proj", "up_proj", "down_proj"]

# 最佳实践：只调 attention
target_modules = ["q_proj", "v_proj"]

# 追求极致效果：全调
target_modules = ["q_proj", "k_proj", "v_proj", "o_proj", 
                  "gate_proj", "up_proj", "down_proj"]
```

### 合并适配器

```python
from peft import PeftModel

# 加载基础模型和适配器
base_model = AutoModelForCausalLM.from_pretrained("llama-2-7b")
peft_model = PeftModel.from_pretrained(base_model, "./lora_adapter")

# 合并权重（推理优化）
merged_model = peft_model.merge_and_unload()
merged_model.save_pretrained("./merged_model")
# 现在是一个独立模型，无需 PEFT 库
```

## 应用场景

### 1. 领域适配

```python
# 医疗领域
medical_lora = train_lora(
    base_model="llama-2-7b",
    dataset="medical_qa",
    save_path="./medical_adapter"
)

# 法律领域
legal_lora = train_lora(
    base_model="llama-2-7b",
    dataset="legal_docs",
    save_path="./legal_adapter"
)
```

### 2. 个性化定制

```python
# 为每个用户训练个性化适配器
user_adapters = {}
for user in users:
    adapter = train_on_user_data(user.conversations)
    user_adapters[user.id] = adapter

# 推理时加载对应用户的适配器
def respond(user_id, query):
    model.load_adapter(user_adapters[user_id])
    return model.generate(query)
```

### 3. 持续学习

```python
# 顺序学习多个任务，不遗忘旧知识
for task in new_tasks:
    # 加载上一个适配器
    if prev_adapter:
        model.load_adapter(prev_adapter)
    
    # 训练新适配器
    new_adapter = train_lora(model, task_data)
    model.save_pretrained(new_adapter.path)
    
    prev_adapter = new_adapter
```

## 学习资源

- [PEFT 官方文档](https://huggingface.co/docs/peft)
- [LoRA 论文](https://arxiv.org/abs/2106.09685)
- [HuggingFace PEFT 教程](https://huggingface.co/blog/peft)

## 相关概念

- [[量化]](/ai-learning/topics/quantization) - 模型压缩
- [[蒸馏]](/ai-learning/topics/distillation) - 知识迁移
- [[微调]](/ai-learning/topics/fine-tuning) - 全量微调

## 下一步学习

1. **[量化](/ai-learning/topics/quantization)** - 进一步压缩
2. **[蒸馏](/ai-learning/topics/distillation)** - 模型缩小
3. **[LLM 实战](/ai-learning/resources/llm-projects)** - 完整项目

  </div>

  <div class="content-navigation">
    <div class="nav-card prev">
      <span class="nav-label">上一个</span>
      <a href="/ai-learning/topics/fine-tuning" class="nav-link">← 微调</a>
    </div>
    <div class="nav-card next">
      <span class="nav-label">下一个</span>
      <a href="/ai-learning/topics/quantization" class="nav-link">量化 →</a>
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
