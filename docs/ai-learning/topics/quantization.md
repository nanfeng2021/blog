---
layout: page
title: 量化
description: 降低模型精度以减少存储和计算成本的技术
sidebar: true
page: true
---

<div class="learning-content">
  <div class="content-header">
    <span class="category-badge">高效微调 · LLM</span>
    <h1>📉 量化 (Quantization)</h1>
    <p class="description">将模型权重和激活从高精度（FP32）转换为低精度（INT8/INT4），大幅减少显存占用和推理延迟</p>
  </div>

  <div class="content-body">

## 概述

**量化**（Quantization）通过降低数值表示的精度来压缩模型，在保持性能基本不变的情况下，显著减少存储需求和计算资源消耗。

## 量化级别

### FP32 → FP16

```python
# 半精度转换
model = AutoModel.from_pretrained("bert-base")
model.half()  # FP32 → FP16

# 存储节省：50%
# 速度提升：2-3x (Tensor Core)
```

### FP16 → INT8

```python
from transformers import BitsAndBytesConfig

# 8bit 量化配置
bnb_config = BitsAndBytesConfig(
    load_in_8bit=True,
    llm_int8_threshold=6.0,
    llm_int8_has_fp16_weight=False
)

model = AutoModelForCausalLM.from_pretrained(
    "llama-2-7b",
    quantization_config=bnb_config,
    device_map="auto"
)

# 存储节省：75% (vs FP32)
# 速度提升：2-4x
```

### FP16 → INT4

```python
# 4bit 量化配置
bnb_config = BitsAndBytesConfig(
    load_in_4bit=True,
    bnb_4bit_quant_type="nf4",      # 正态分布优化
    bnb_4bit_compute_dtype=torch.float16,
    bnb_4bit_use_double_quant=True   # 双重量化
)

model = AutoModelForCausalLM.from_pretrained(
    "llama-2-7b",
    quantization_config=bnb_config,
    device_map="auto"
)

# 存储节省：87.5% (vs FP32)
# 7B 模型仅需 ~4GB 显存
```

## 量化方法

### 训练后量化（PTQ）

```python
from transformers import GPTQConfig

# GPTQ 量化（无需训练）
gptq_config = GPTQConfig(
    bits=4,
    group_size=128,
    dataset="c4",
    tokenizer=tokenizer
)

model = AutoModelForCausalLM.from_pretrained(
    "mistral-7b",
    quantization_config=gptq_config,
    device_map="auto"
)
```

### 量化感知训练（QAT）

```python
import torch.quantization as quantization

# 准备量化
model.qconfig = quantization.get_default_qat_qconfig('fbgemm')
model_prepared = quantization.prepare_qat(model, inplace=False)

# 量化感知训练
train(model_prepared, train_loader)

# 转换量化模型
model_quantized = quantization.convert(model_prepared, inplace=False)
```

### AWQ（Activation-aware Weight Quantization）

```python
from autoawq import AutoAWQForCausalLM

# AWQ 量化（保留重要权重精度）
quant_config = {
    "zero_point": True,
    "q_group_size": 128,
    "w_bit": 4,
    "version": "GEMM"
}

model = AutoAWQForCausalLM.from_pretrained("llama-2-7b")
model.quantize(tokenizer, quant_config)
model.save_quantized("./llama-2-7b-awq-4bit")
```

## 实战示例

### QLoRA：4bit + LoRA

```python
from peft import LoraConfig, prepare_model_for_kbit_training
from transformers import BitsAndBytesConfig

# 4bit 基础量化
bnb_config = BitsAndBytesConfig(
    load_in_4bit=True,
    bnb_4bit_quant_type="nf4",
    bnb_4bit_compute_dtype=torch.bfloat16,
    bnb_4bit_use_double_quant=True
)

model = AutoModelForCausalLM.from_pretrained(
    "llama-2-7b-hf",
    quantization_config=bnb_config,
    device_map="auto"
)

# 准备 k-bit 训练
model = prepare_model_for_kbit_training(model)

# 添加 LoRA 适配器
peft_config = LoraConfig(
    r=16,
    lora_alpha=32,
    target_modules=["q_proj", "v_proj"],
    lora_dropout=0.05
)

model = get_peft_model(model, peft_config)

# 现在可以在单卡上微调 7B 模型！
trainer.train()
```

### GGUF 格式量化

```bash
# 使用 llama.cpp 量化
# 转换为 GGUF 格式
python convert.py --outfile llama-2-7b.gguf models/llama-2-7b/

# 执行量化
./quantize llama-2-7b.gguf llama-2-7b-q4_k_m.gguf q4_k_m

# 运行量化后的模型
./main -m llama-2-7b-q4_k_m.gguf -p "Hello" -n 128
```

### vLLM 量化推理

```python
from vllm import LLM, SamplingParams

# 加载量化模型
llm = LLM(
    model="TheBloke/Llama-2-7B-GPTQ",
    quantization="gptq",
    tensor_parallel_size=1
)

sampling_params = SamplingParams(
    temperature=0.7,
    max_tokens=256
)

outputs = llm.generate(prompts, sampling_params)
```

## 量化方案对比

| 方案 | 精度 | 显存 (7B) | 速度 | 质量损失 |
|------|------|----------|------|---------|
| **FP32** | 32bit | 28GB | 1x | 无 |
| **FP16** | 16bit | 14GB | 2-3x | 可忽略 |
| **INT8** | 8bit | 7GB | 3-4x | < 1% |
| **INT4 (NF4)** | 4bit | 4GB | 4-6x | 1-3% |
| **GPTQ-4bit** | 4bit | 4GB | 5-7x | 2-4% |
| **GGUF-Q4_K_M** | 4bit | 4GB | 8-10x | 3-5% |

## 量化技巧

### 选择合适的粒度

```python
# group_size 越小，精度越高，但压缩率越低
group_size = 128  # 平衡点
group_size = 64   # 更高精度
group_size = -1   # per-channel，最高精度
```

### 混合精度策略

```python
# 关键层保持 FP16，其他层 INT4
keep_layers = ["lm_head", "embed_tokens"]

for name, module in model.named_modules():
    if any(layer in name for layer in keep_layers):
        module.to(torch.float16)  # 保持高精度
    else:
        module.to(torch.int4)     # 量化
```

### 校准数据集选择

```python
# PTQ 需要代表性校准数据
calibration_data = [
    "样本 1...",
    "样本 2...",
    ...  # 128-512 个样本
]

# 应覆盖目标领域的典型输入
```

## 应用场景

### 1. 边缘部署

```python
# 树莓派上运行量化模型
# 4bit 量化后，7B 模型可在 8GB RAM 设备运行
model_path = "./llama-2-7b-q4_k_m.gguf"
# 使用 llama.cpp 推理
```

### 2. 大规模服务

```python
# 单卡多模型服务
# A100 80GB 可同时运行：
# FP16: 5 个 7B 模型
# INT4: 18 个 7B 模型 (3.6x 提升)
```

### 3. 实时应用

```python
# 低延迟场景
# INT8 量化可将延迟从 100ms 降至 25ms
# 适合在线客服、实时翻译
```

## 前沿发展

### 1. 极低比特量化

- INT2 / INT1 研究
- 二值网络
- 三元权重

### 2. 动态量化

- 运行时自适应调整精度
- 根据输入复杂度分配资源

### 3. 硬件协同设计

- NPUs 原生支持 INT4
- 专用量化加速单元

## 学习资源

- [BitsAndBytes 文档](https://github.com/TimDettmers/bitsandbytes)
- [llama.cpp](https://github.com/ggerganov/llama.cpp)
- [GPTQ 论文](https://arxiv.org/abs/2210.17323)

## 相关概念

- [[PEFT]](/ai-learning/topics/peft) - 参数高效微调
- [[蒸馏]](/ai-learning/topics/distillation) - 知识迁移
- [[推理优化]](/ai-learning/topics/inference-optimization) - 性能优化

## 下一步学习

1. **[蒸馏](/ai-learning/topics/distillation)** - 模型压缩
2. **[PEFT](/ai-learning/topics/peft)** - 高效微调
3. **[推理优化](/ai-learning/topics/inference-optimization)** - 部署实践

  </div>

  <div class="content-navigation">
    <div class="nav-card prev">
      <span class="nav-label">上一个</span>
      <a href="/ai-learning/topics/peft" class="nav-link">← PEFT</a>
    </div>
    <div class="nav-card next">
      <span class="nav-label">下一个</span>
      <a href="/ai-learning/topics/distillation" class="nav-link">蒸馏 →</a>
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
