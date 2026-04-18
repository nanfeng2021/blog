---
layout: page
title: 奖励建模
description: 学习人类偏好以指导 AI 对齐的技术
sidebar: true
page: true
---

<div class="learning-content">
  <div class="content-header">
    <span class="category-badge">强化学习 · 对齐</span>
    <h1>🎯 奖励建模 (Reward Modeling)</h1>
    <p class="description">通过训练模型来预测人类偏好，为强化学习提供奖励信号，实现 AI 与人类价值观的对齐</p>
  </div>

  <div class="content-body">

## 概述

**奖励建模**（Reward Modeling）是 RLHF 的关键步骤，通过训练一个模型来预测人类对不同输出的偏好排序，从而替代人工标注奖励。

## 核心方法

### 配对比较数据收集

```python
# 收集人类偏好数据
preference_data = [
    {
        "prompt": "写一首关于春天的诗",
        "response_A": "春天来了，花儿开了...",  # 模型生成
        "response_B": "春风拂面，万物复苏...",  # 模型生成
        "preferred": "B"  # 人类选择
    },
    # ... 数千个样本
]
```

### Bradley-Terry 模型

```python
import torch.nn as nn
import torch.nn.functional as F

class RewardModel(nn.Module):
    def __init__(self, base_model):
        super().__init__()
        self.base = base_model
        self.value_head = nn.Linear(base_model.config.hidden_size, 1)
    
    def forward(self, input_ids, attention_mask):
        outputs = self.base(input_ids, attention_mask=attention_mask)
        last_hidden = outputs.last_hidden_state
        
        # 使用 EOS token 的表示
        eos_indices = attention_mask.sum(dim=1) - 1
        eos_features = last_hidden[torch.arange(len(input_ids)), eos_indices]
        
        reward = self.value_head(eos_features).squeeze(-1)
        return reward

def reward_loss(reward_model, chosen_ids, rejected_ids):
    """Bradley-Terry 损失"""
    reward_chosen = reward_model(chosen_ids)
    reward_rejected = reward_model(rejected_ids)
    
    # P(chosen > rejected) = sigmoid(r_chosen - r_rejected)
    loss = -F.logsigmoid(reward_chosen - reward_rejected).mean()
    
    return loss
```

## 训练流程

### Step 1: 收集偏好数据

```python
def collect_preferences(model, prompts, n_comparisons=1000):
    """生成配对并收集人类标注"""
    dataset = []
    
    for prompt in prompts:
        # 生成多个响应
        responses = model.generate(prompt, num_return_sequences=4)
        
        # 创建配对
        pairs = [(responses[i], responses[j]) 
                for i in range(len(responses)) 
                for j in range(i+1, len(responses))]
        
        # 人类标注（或已有数据集）
        for resp_a, resp_b in pairs:
            preferred = human_annotate(prompt, resp_a, resp_b)
            dataset.append({
                "prompt": prompt,
                "chosen": preferred,
                "rejected": resp_b if preferred == resp_a else resp_a
            })
    
    return dataset
```

### Step 2: 训练奖励模型

```python
from transformers import AutoModelForSequenceClassification

# 初始化奖励模型
reward_model = AutoModelForSequenceClassification.from_pretrained(
    "bert-base-uncased",
    num_labels=1
)

# 训练循环
for epoch in range(n_epochs):
    for batch in preference_dataloader:
        chosen_ids = batch["chosen_input_ids"]
        rejected_ids = batch["rejected_input_ids"]
        
        reward_chosen = reward_model(chosen_ids).logits.squeeze()
        reward_rejected = reward_model(rejected_ids).logits.squeeze()
        
        loss = -F.logsigmoid(reward_chosen - reward_rejected).mean()
        
        loss.backward()
        optimizer.step()
```

### Step 3: 验证奖励模型

```python
def evaluate_reward_model(reward_model, test_dataset):
    """在测试集上评估准确率"""
    correct = 0
    
    with torch.no_grad():
        for sample in test_dataset:
            r_chosen = reward_model(sample["chosen_ids"]).logits
            r_rejected = reward_model(sample["rejected_ids"]).logits
            
            predicted = "chosen" if r_chosen > r_rejected else "rejected"
            if predicted == sample["preferred"]:
                correct += 1
    
    accuracy = correct / len(test_dataset)
    print(f"奖励模型准确率：{accuracy:.2%}")
    return accuracy
```

## 应用场景

### 1. RLHF 奖励信号

```python
# PPO 训练中使用奖励模型
def compute_rewards(reward_model, prompts, responses):
    rewards = []
    
    for prompt, response in zip(prompts, responses):
        full_text = prompt + response
        input_ids = tokenizer.encode(full_text, return_tensors='pt')
        
        reward = reward_model(input_ids).logits.squeeze()
        rewards.append(reward.item())
    
    return torch.tensor(rewards)
```

### 2. 最佳响应选择

```python
def select_best_response(reward_model, prompt, candidates):
    """选择得分最高的响应"""
    scores = []
    
    for candidate in candidates:
        full_text = prompt + candidate
        input_ids = tokenizer.encode(full_text, return_tensors='pt')
        score = reward_model(input_ids).logits.squeeze().item()
        scores.append(score)
    
    best_idx = scores.index(max(scores))
    return candidates[best_idx]
```

### 3. 内容过滤

```python
def filter_harmful_content(reward_model, text, threshold=0.5):
    """检测有害内容"""
    input_ids = tokenizer.encode(text, return_tensors='pt')
    reward = reward_model(input_ids).logits.squeeze().item()
    
    # 低奖励可能表示有害内容
    is_safe = reward > threshold
    return is_safe, reward
```

## 挑战与解决方案

### ⚠️ 奖励黑客（Reward Hacking）

**问题**: 模型学会欺骗奖励模型而非真正对齐  
**解决**: 
- 多奖励模型集成
- 正则化防止过拟合
- 持续收集新数据

### ⚠️ 分布外泛化

**问题**: 对训练数据外的输入预测不准  
**解决**:
- 多样化训练数据
- 不确定性估计
- 主动学习新样本

### ⚠️ 标注一致性

**问题**: 不同标注者偏好不一致  
**解决**:
- 多标注者投票
- 标注者质量筛选
- 明确标注指南

## 前沿发展

### 1. 宪法 AI

```python
# 基于原则的自我批评
constitutional_principles = [
    "不伤害人类",
    "诚实回答问题",
    "尊重用户隐私"
]

def constitutional_critique(response, principles):
    critiques = []
    for principle in principles:
        critique = llm(f"这个响应是否违反'{principle}'? {response}")
        critiques.append(critique)
    return critiques
```

### 2. 递归奖励建模

```python
# 分层奖励建模
def recursive_reward(text, depth=0):
    if depth >= max_depth:
        return base_reward_model(text)
    
    # 分解为子问题
    subquestions = decompose(text)
    sub_rewards = [recursive_reward(q, depth+1) for q in subquestions]
    
    return aggregate(sub_rewards)
```

### 3. 人类反馈学习

```python
# 在线学习人类偏好
def online_update(reward_model, new_feedback):
    # 增量更新模型
    reward_model.update(new_feedback, learning_rate=0.01)
    
    # 监控性能漂移
    if performance_drop > threshold:
        trigger_full_retrain()
```

## 学习资源

- [InstructGPT 论文](https://arxiv.org/abs/2203.02155)
- [RLHF 教程](https://huggingface.co/blog/rlhf)
- [Anthropic 宪法 AI](https://www.anthropic.com/index/constitutional-ai)

## 相关概念

- [[PPO]](/ai-learning/topics/ppo) - 强化学习算法
- [[价值对齐]](/ai-learning/topics/value-alignment) - 对齐目标
- [[RLHF]](/ai-learning/resources/rlhf-guide) - 完整流程

## 下一步学习

1. **[PPO](/ai-learning/topics/ppo)** - 优化算法
2. **[价值对齐](/ai-learning/topics/value-alignment)** - 理论框架
3. **[RLHF 实战](/ai-learning/resources/rlhf-guide)** - 完整项目

  </div>

  <div class="content-navigation">
    <div class="nav-card prev">
      <span class="nav-label">上一个</span>
      <a href="/ai-learning/topics/distillation" class="nav-link">← 蒸馏</a>
    </div>
    <div class="nav-card next">
      <span class="nav-label">下一个</span>
      <a href="/ai-learning/topics/ppo" class="nav-link">PPO →</a>
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
