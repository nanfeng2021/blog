---
layout: page
title: 推理优化
description: 大语言模型高效部署与加速技术
sidebar: true
page: true
---

<div class="learning-content">
  <div class="content-header">
    <span class="category-badge">核心技术 · 部署</span>
    <h1>⚡ 推理优化 (Inference Optimization)</h1>
    <p class="description">大语言模型部署时的性能优化技术，包括量化、剪枝、蒸馏、批处理等方法</p>
  </div>

  <div class="content-body">

## 概述

**推理优化**（Inference Optimization）是指在大语言模型部署阶段，通过多种技术手段降低延迟、减少资源消耗、提升吞吐量的过程。

## 核心优化技术

### 1. 量化 (Quantization)

将模型参数从 FP32 转换为低精度表示：

```python
# PTQ - 训练后量化
from transformers import AutoModelForCausalLM, BitsAndBytesConfig

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

# QAT - 量化感知训练
model.qconfig = torch.quantization.get_default_qat_qconfig('fbgemm')
torch.quantization.prepare_qat(model, inplace=True)
```

**效果**:
- INT8: 2 倍加速，50% 显存节省
- INT4: 3 倍加速，75% 显存节省

### 2. 剪枝 (Pruning)

移除不重要的权重或神经元：

```python
from transformers import BertForSequenceClassification

model = BertForSequenceClassification.from_pretrained("bert-base-uncased")

# 结构化剪枝
from transformers import pruning_head

# 移除注意力头
prune_heads = {0: [0, 1], 1: [2, 3]}
model.prune_heads(prune_heads)

# 非结构化剪枝
import torch.nn.utils.prune as prune

prune.l1_unstructured(model.linear, name='weight', amount=0.3)
```

### 3. 知识蒸馏 (Distillation)

用大模型（教师）训练小模型（学生）：

```python
class DistillationLoss(nn.Module):
    def __init__(self, student, teacher, alpha=0.7, temperature=4):
        super().__init__()
        self.student = student
        self.teacher = teacher
        self.alpha = alpha
        self.temperature = temperature
        
    def forward(self, inputs, labels):
        # 教师输出（无梯度）
        with torch.no_grad():
            teacher_logits = self.teacher(inputs)
        
        # 学生输出
        student_logits = self.student(inputs)
        
        # 蒸馏损失
        distill_loss = nn.KLDivLoss()(
            F.log_softmax(student_logits / self.temperature, dim=1),
            F.softmax(teacher_logits / self.temperature, dim=1)
        ) * (self.temperature ** 2)
        
        # 真实标签损失
        ce_loss = nn.CrossEntropyLoss()(student_logits, labels)
        
        return self.alpha * distill_loss + (1 - self.alpha) * ce_loss
```

### 4. 批处理优化 (Batching)

```python
# 动态批处理
class DynamicBatcher:
    def __init__(self, max_batch_size=32, max_wait_ms=100):
        self.max_batch_size = max_batch_size
        self.max_wait_ms = max_wait_ms
        self.queue = []
    
    async def add_request(self, request):
        self.queue.append(request)
        
        if len(self.queue) >= self.max_batch_size:
            return await self.process_batch()
        
        # 等待更多请求
        await asyncio.sleep(self.max_wait_ms / 1000)
        return await self.process_batch()
    
    async def process_batch(self):
        if not self.queue:
            return []
        
        batch = self.queue[:self.max_batch_size]
        self.queue = self.queue[self.max_batch_size:]
        
        # 批量推理
        results = await model.generate(batch)
        return results
```

### 5. KV Cache 优化

```python
# 缓存 Key-Value 状态
past_key_values = None

for i in range(sequence_length):
    outputs = model(
        input_ids[:, i:i+1],
        past_key_values=past_key_values,
        use_cache=True
    )
    
    # 更新缓存
    past_key_values = outputs.past_key_values
    
    # 生成下一个 token
    next_token = outputs.logits[:, -1].argmax(dim=-1)
```

**效果**: 推理速度提升 5-10 倍

### 6. FlashAttention

```python
from flash_attn import flash_attn_func

# 标准 Attention: O(N²) 内存
# FlashAttention: O(N) 内存

qkv = torch.randn(bsz, seq_len, 3, n_heads, head_dim).cuda()
q, k, v = qkv.unbind(2)

output = flash_attn_func(q, k, v, dropout_p=0.0, softmax_scale=None)
```

**效果**: 
- 显存减少 3 倍
- 速度提升 2-3 倍

## 推理引擎对比

| 引擎 | 特点 | 适用场景 |
|------|------|----------|
| **vLLM** | PagedAttention, 高吞吐 | 在线服务 |
| **TGI** | 连续批处理 | 生产部署 |
| **TensorRT-LLM** | NVIDIA 优化 | GPU 加速 |
| **ONNX Runtime** | 跨平台 | CPU/GPU 通用 |
| **llama.cpp** | CPU 推理 | 本地部署 |

## 实战：构建高效推理服务

```python
from vllm import LLM, SamplingParams

# 初始化模型
llm = LLM(
    model="meta-llama/Llama-2-7b-chat-hf",
    tensor_parallel_size=1,
    gpu_memory_utilization=0.9,
    max_num_batched_tokens=4096,
)

# 采样配置
sampling_params = SamplingParams(
    temperature=0.7,
    top_p=0.9,
    max_tokens=512,
    stop=["</s>", "User:"],
)

# 批量推理
prompts = [
    "什么是人工智能？",
    "如何学习 Python？",
    "解释量子力学",
]

outputs = llm.generate(prompts, sampling_params)

for output in outputs:
    print(output.outputs[0].text)
```

## 性能指标

### 关键指标

```python
# 延迟 (Latency)
latency = (end_time - start_time) * 1000  # ms

# 吞吐量 (Throughput)
throughput = num_requests / total_time  # requests/s

# Token 生成速度
token_speed = num_tokens / generation_time  # tokens/s

# 首 token 延迟
time_to_first_token = first_token_time - request_time
```

### 基准测试

```python
import time

def benchmark(model, prompts, num_runs=10):
    latencies = []
    token_counts = []
    
    for _ in range(num_runs):
        start = time.time()
        output = model.generate(prompts)
        end = time.time()
        
        latencies.append((end - start) * 1000)
        token_counts.append(len(output[0].tokens))
    
    return {
        'avg_latency': np.mean(latencies),
        'p99_latency': np.percentile(latencies, 99),
        'tokens_per_sec': sum(token_counts) / sum(latencies) * 1000
    }
```

## 优化策略选择

### 根据场景选择

| 场景 | 推荐方案 |
|------|----------|
| **实时对话** | KV Cache + 批处理 |
| **离线批处理** | 量化 + 多 GPU |
| **边缘设备** | 量化 + 剪枝 + 蒸馏 |
| **高并发服务** | vLLM + 动态批处理 |

## 前沿发展

### 1. 投机采样 (Speculative Decoding)

```python
# 用小模型快速生成草稿
draft_tokens = draft_model.generate(input_ids, num_tokens=5)

# 用大模型验证
verified_tokens = large_model.verify(draft_tokens)
```

**效果**: 2-4 倍加速

### 2. 混合精度推理

```python
# 不同层使用不同精度
for layer in model.layers:
    if layer.is_critical:
        layer.to(torch.float16)
    else:
        layer.to(torch.int8)
```

### 3. 稀疏激活

```python
# MoE - Mixture of Experts
class MoELayer(nn.Module):
    def __init__(self, num_experts=8, top_k=2):
        self.experts = nn.ModuleList([Expert() for _ in range(num_experts)])
        self.gate = nn.Linear(hidden_dim, num_experts)
        self.top_k = top_k
    
    def forward(self, x):
        gate_scores = self.gate(x).softmax(dim=-1)
        top_k_scores, top_k_indices = gate_scores.topk(self.top_k)
        
        # 只激活 top-k 专家
        output = sum(
            self.experts[i](x) * score 
            for i, score in zip(top_k_indices, top_k_scores)
        )
        
        return output
```

## 学习资源

### 📺 教程
- [vLLM 官方文档](https://docs.vllm.ai/)
- [Hugging Face 推理指南](https://huggingface.co/docs/transformers/perf_infer)

### 💻 工具
- [vLLM](https://github.com/vllm-project/vllm)
- [Text Generation Inference](https://github.com/huggingface/text-generation-inference)
- [TensorRT-LLM](https://github.com/NVIDIA/TensorRT-LLM)

## 相关概念

- [[预训练]](/ai-learning/topics/pretraining) - 模型训练
- [[微调]](/ai-learning/topics/fine-tuning) - 任务适配
- [[量化]](/ai-learning/topics/quantization) - 压缩技术
- [[LLM]](/ai-learning/topics/llm) - 大语言模型

## 下一步学习

1. **[量化](/ai-learning/topics/quantization)** - 深入压缩
2. **[vLLM 实战](/ai-learning/resources/vllm-guide)** - 部署实践
3. **[MoE 架构](/ai-learning/topics/moe)** - 稀疏激活

  </div>

  <div class="content-navigation">
    <div class="nav-card prev">
      <span class="nav-label">上一个</span>
      <a href="/ai-learning/topics/fine-tuning" class="nav-link">← 微调</a>
    </div>
    <div class="nav-card next">
      <span class="nav-label">下一个</span>
      <a href="/ai-learning/topics/llm" class="nav-link">返回 LLM →</a>
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
