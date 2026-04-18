---
layout: page
title: 蒸馏
description: 知识蒸馏技术，将大模型知识迁移到小模型
sidebar: true
page: true
---

<div class="learning-content">
  <div class="content-header">
    <span class="category-badge">高效微调 · LLM</span>
    <h1>🔮 蒸馏 (Distillation)</h1>
    <p class="description">将大型教师模型的知识压缩到小型学生模型中，在保持性能的同时大幅降低计算成本</p>
  </div>

  <div class="content-body">

## 概述

**知识蒸馏**（Knowledge Distillation）通过让小型学生模型学习大型教师模型的输出分布或中间表示，实现知识的迁移和压缩。

## 核心方法

### 响应蒸馏（Response-based）

```python
import torch.nn.functional as F

def distillation_loss(student_logits, teacher_logits, temperature=2.0):
    """软目标蒸馏"""
    student_soft = F.softmax(student_logits / temperature, dim=-1)
    teacher_soft = F.softmax(teacher_logits / temperature, dim=-1)
    
    # KL 散度损失
    loss = F.kl_div(
        F.log_softmax(student_logits / temperature, dim=-1),
        F.softmax(teacher_logits / temperature, dim=-1),
        reduction='batchmean'
    ) * (temperature ** 2)
    
    return loss
```

### 特征蒸馏（Feature-based）

```python
class FeatureDistillation(nn.Module):
    def __init__(self, student_dim, teacher_dim):
        super().__init__()
        # 投影层对齐维度
        self.project = nn.Linear(student_dim, teacher_dim)
    
    def forward(self, student_features, teacher_features):
        projected = self.project(student_features)
        
        # MSE 损失
        loss = F.mse_loss(projected, teacher_features)
        return loss
```

### 关系蒸馏（Relation-based）

```python
def relation_distillation(student_atts, teacher_atts):
    """学习样本间关系"""
    # 计算注意力矩阵的关系
    student_rel = compute_relation_matrix(student_atts)
    teacher_rel = compute_relation_matrix(teacher_atts)
    
    loss = F.mse_loss(student_rel, teacher_rel)
    return loss
```

## 实战示例

### BERT 蒸馏

```python
from transformers import BertTokenizer, BertForSequenceClassification
from tinybert import TinyBertForSequenceClassification

# 加载教师模型
teacher = BertForSequenceClassification.from_pretrained("bert-base-uncased")
teacher.eval()

# 定义学生模型
student = TinyBertForSequenceClassification(
    num_labels=2,
    hidden_size=384,      # vs 768
    num_hidden_layers=4,  # vs 12
    num_attention_heads=6 # vs 12
)

# 蒸馏训练
for batch in dataloader:
    # 教师前向传播
    with torch.no_grad():
        teacher_outputs = teacher(
            batch['input_ids'],
            attention_mask=batch['attention_mask']
        )
    
    # 学生前向传播
    student_outputs = student(
        batch['input_ids'],
        attention_mask=batch['attention_mask']
    )
    
    # 计算蒸馏损失
    loss = distillation_loss(
        student_outputs.logits,
        teacher_outputs.logits,
        temperature=2.0
    )
    
    # 反向传播
    loss.backward()
    optimizer.step()
```

### GPT 蒸馏

```python
class GPUDistillationTrainer:
    def __init__(self, teacher_model, student_model, tokenizer):
        self.teacher = teacher_model
        self.student = student_model
        self.tokenizer = tokenizer
    
    def train_step(self, texts):
        # 编码输入
        inputs = self.tokenizer(texts, return_tensors='pt', padding=True)
        
        # 教师生成软目标
        with torch.no_grad():
            teacher_logits = self.teacher(**inputs).logits
        
        # 学生预测
        student_logits = self.student(**inputs).logits
        
        # 蒸馏损失 + 真实标签损失
        distill_loss = self.kl_div(student_logits, teacher_logits)
        task_loss = self.cross_entropy(student_logits, labels)
        
        total_loss = 0.7 * distill_loss + 0.3 * task_loss
        return total_loss
```

### 自蒸馏（Self-Distillation）

```python
# 同一模型的不同 checkpoint 作为师生
def self_distillation(model_early, model_late, data):
    """用后期模型蒸馏早期模型"""
    with torch.no_grad():
        teacher_output = model_late(data)
    
    student_output = model_early(data)
    loss = distillation_loss(student_output, teacher_output)
    
    return loss
```

## 蒸馏策略对比

| 策略 | 压缩率 | 性能保持 | 训练成本 |
|------|--------|---------|---------|
| **响应蒸馏** | 4-10x | 95-98% | 低 |
| **特征蒸馏** | 4-10x | 96-99% | 中 |
| **关系蒸馏** | 4-10x | 97-99% | 高 |
| **组合蒸馏** | 4-10x | 98-99% | 高 |

## 进阶技巧

### 渐进式蒸馏

```python
# 逐层蒸馏
def progressive_distillation(teacher, student, n_stages=3):
    for stage in range(n_stages):
        # 冻结已蒸馏层
        freeze_layers(student, up_to=stage)
        
        # 蒸馏当前层
        train_layer(student.layers[stage], 
                   teacher.layers[stage])
        
        # 解冻下一层
        unfreeze_layers(student, from_=stage+1)
```

### 多教师蒸馏

```python
def multi_teacher_distillation(teachers, student, data):
    """集成多个教师的知识"""
    ensemble_logits = 0
    
    for teacher in teachers:
        with torch.no_grad():
            logits = teacher(data)
            ensemble_logits += logits
    
    ensemble_logits /= len(teachers)
    
    student_logits = student(data)
    loss = distillation_loss(student_logits, ensemble_logits)
    
    return loss
```

### 数据增强蒸馏

```python
def augmented_distillation(teacher, student, seed_data):
    """使用合成数据蒸馏"""
    # 生成合成数据
    augmented_data = generate_augmented(seed_data)
    
    # 教师标注
    pseudo_labels = teacher(augmented_data)
    
    # 学生学习
    student.train(augmented_data, pseudo_labels)
```

## 应用场景

### 1. 移动端部署

```python
# 将 BERT-large (1.3GB) 蒸馏为 TinyBERT (14MB)
# 推理速度提升 10x，性能保持 96%

tinybert = TinyBertForSequenceClassification.from_pretrained(
    "huawei-noah/TinyBERT_General_4L_312D"
)
# 可在手机上实时运行
```

### 2. 实时服务

```python
# 将 GPT-3 蒸馏为小型对话模型
# 延迟从 500ms 降至 50ms

distilled_chat = AutoModelForCausalLM.from_pretrained(
    "distilgpt2"  # 82M vs GPT-2 1.5B
)
```

### 3. 边缘 AI

```python
# 在树莓派上运行蒸馏后的视觉模型
# MobileNetV3 ( distilled from ResNet-152)
mobilenet = torch.hub.load('pytorch/vision', 'mobilenet_v3_small')
# 30 FPS on Raspberry Pi 4
```

## 前沿发展

### 1. 无数据蒸馏

```python
# 无需原始训练数据
def data_free_distillation(teacher, student):
    # 生成合成数据
    synthetic_data = generate_from_prior(teacher)
    
    # 标准蒸馏流程
    return distillation(teacher, student, synthetic_data)
```

### 2. 跨模态蒸馏

```python
# 视觉 → 语言知识迁移
def cross_modal_distillation(vit_teacher, bert_student, images, captions):
    # 视觉特征作为教师信号
    visual_features = vit_teacher(images)
    
    # 语言模型学习视觉表示
    text_embeddings = bert_student(captions)
    
    loss = align_embeddings(text_embeddings, visual_features)
    return loss
```

### 3. 自动化蒸馏

```python
# NAS + 蒸馏联合优化
def auto_distillation_search():
    best_arch = None
    best_score = 0
    
    for arch in architecture_space:
        student = create_model(arch)
        distill(teacher, student)
        score = evaluate(student)
        
        if score > best_score:
            best_score = score
            best_arch = arch
    
    return best_arch
```

## 学习资源

- [HuggingFace 蒸馏指南](https://huggingface.co/docs/transformers/training.html)
- [DistilBERT 论文](https://arxiv.org/abs/1910.01108)
- [TinyBERT 论文](https://arxiv.org/abs/1909.10351)

## 相关概念

- [[PEFT]](/ai-learning/topics/peft) - 参数高效微调
- [[量化]](/ai-learning/topics/quantization) - 模型压缩
- [[高效微调]](/ai-learning/topics/efficient-finetuning) - 综合技术

## 下一步学习

1. **[量化](/ai-learning/topics/quantization)** - 进一步压缩
2. **[PEFT](/ai-learning/topics/peft)** - 高效适配
3. **[LLM 实战](/ai-learning/resources/llm-projects)** - 完整项目

  </div>

  <div class="content-navigation">
    <div class="nav-card prev">
      <span class="nav-label">上一个</span>
      <a href="/ai-learning/topics/quantization" class="nav-link">← 量化</a>
    </div>
    <div class="nav-card next">
      <span class="nav-label">下一个</span>
      <a href="/ai-learning/topics/reward-modeling" class="nav-link">奖励建模 →</a>
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
