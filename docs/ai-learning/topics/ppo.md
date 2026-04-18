---
layout: page
title: PPO
description: 近端策略优化，RLHF 中的核心强化学习算法
sidebar: true
page: true
---

<div class="learning-content">
  <div class="content-header">
    <span class="category-badge">强化学习 · 对齐</span>
    <h1>🔄 PPO (Proximal Policy Optimization)</h1>
    <p class="description">一种稳定、高效的策略梯度算法，通过对策略更新幅度进行约束，实现稳定的强化学习训练</p>
  </div>

  <div class="content-body">

## 概述

**PPO**（Proximal Policy Optimization）是一种流行的策略梯度算法，通过限制每次更新的步长来避免策略崩溃，是 RLHF 中最常用的优化算法。

## 核心思想

### 截断的重要性采样

```python
import torch
import torch.nn as nn

def clipped_surrogate_loss(old_log_probs, new_log_probs, advantages, clip_epsilon=0.2):
    """PPO 截断损失"""
    # 计算比率 r(θ) = π_θ(a|s) / π_θ_old(a|s)
    ratio = torch.exp(new_log_probs - old_log_probs)
    
    # 未截断的损失
    surr1 = ratio * advantages
    
    # 截断的损失
    clipped_ratio = torch.clamp(ratio, 1 - clip_epsilon, 1 + clip_epsilon)
    surr2 = clipped_ratio * advantages
    
    # 取最小值（保守更新）
    loss = -torch.min(surr1, surr2).mean()
    
    return loss
```

### 价值函数损失

```python
def value_function_loss(value_pred, value_target, clip_epsilon=0.2):
    """带截断的价值函数损失"""
    # 预测值与目标的 MSE
    mse_loss = (value_pred - value_target).pow(2).mean()
    
    # 截断的预测值
    value_pred_clipped = value_old + (value_pred - value_old).clamp(-clip_epsilon, clip_epsilon)
    clipped_mse = (value_pred_clipped - value_target).pow(2).mean()
    
    return max(mse_loss, clipped_mse)
```

## PPO 算法流程

### 完整训练循环

```python
class PPOTrainer:
    def __init__(self, actor, critic, optimizer, clip_epsilon=0.2):
        self.actor = actor      # 策略网络
        self.critic = critic    # 价值网络
        self.optimizer = optimizer
        self.clip_epsilon = clip_epsilon
    
    def train_epoch(self, rollout_data, n_epochs=4):
        """一个 PPO 训练 epoch"""
        for _ in range(n_epochs):
            # 计算新策略的对数概率
            new_log_probs = self.actor(rollout_data.states)
            
            # 计算优势函数
            advantages = self.compute_advantages(rollout_data)
            
            # PPO 损失
            policy_loss = clipped_surrogate_loss(
                rollout_data.old_log_probs,
                new_log_probs,
                advantages,
                self.clip_epsilon
            )
            
            # 价值损失
            value_loss = value_function_loss(
                self.critic(rollout_data.states),
                rollout_data.returns
            )
            
            # 熵正则化（鼓励探索）
            entropy = self.compute_entropy(new_log_probs)
            
            # 总损失
            total_loss = policy_loss + 0.5 * value_loss - 0.01 * entropy
            
            # 反向传播
            self.optimizer.zero_grad()
            total_loss.backward()
            nn.utils.clip_grad_norm_(self.actor.parameters(), 0.5)
            self.optimizer.step()
```

### 优势函数计算（GAE）

```python
def compute_gae(rewards, values, dones, gamma=0.99, lam=0.95):
    """广义优势估计"""
    advantages = []
    gae = 0
    
    for t in reversed(range(len(rewards))):
        if t == len(rewards) - 1:
            next_value = 0
        else:
            next_value = values[t + 1]
        
        # TD 误差
        delta = rewards[t] + gamma * next_value * (1 - dones[t]) - values[t]
        
        # 累积优势
        gae = delta + gamma * lam * (1 - dones[t]) * gae
        advantages.insert(0, gae)
    
    returns = [adv + val for adv, val in zip(advantages, values)]
    return torch.tensor(advantages), torch.tensor(returns)
```

## RLHF 中的 PPO

### 完整 RLHF 流程

```python
class RLHFTrainer:
    def __init__(self, policy_model, reward_model, ref_model):
        self.policy = policy_model          # 需要优化的策略
        self.reward_model = reward_model    # 奖励模型
        self.ref_model = ref_model          # 参考模型（SFT 后）
        self.ppo_trainer = PPOTrainer(...)
    
    def generate_rollout(self, prompts):
        """使用当前策略生成响应"""
        responses = []
        log_probs = []
        
        for prompt in prompts:
            response, log_prob = self.policy.generate_with_log_prob(prompt)
            responses.append(response)
            log_probs.append(log_prob)
        
        return responses, log_probs
    
    def compute_rewards(self, prompts, responses):
        """计算奖励（包含 KL 惩罚）"""
        # 奖励模型打分
        rm_rewards = []
        for prompt, response in zip(prompts, responses):
            full_text = prompt + response
            reward = self.reward_model(full_text)
            rm_rewards.append(reward.item())
        
        # KL 散度惩罚（防止偏离参考模型太远）
        kl_penalties = []
        for prompt, response in zip(prompts, responses):
            kl = self.compute_kl(prompt, response)
            kl_penalties.append(kl)
        
        # 最终奖励
        final_rewards = [r - 0.1 * kl for r, kl in zip(rm_rewards, kl_penalties)]
        
        return final_rewards
    
    def train_step(self, prompts):
        """一步 RLHF 训练"""
        # 1. 生成响应
        responses, old_log_probs = self.generate_rollout(prompts)
        
        # 2. 计算奖励
        rewards = self.compute_rewards(prompts, responses)
        
        # 3. PPO 更新
        rollout_data = {
            'states': prompts,
            'actions': responses,
            'old_log_probs': old_log_probs,
            'rewards': rewards
        }
        
        self.ppo_trainer.train_epoch(rollout_data)
```

### KL 散度计算

```python
def compute_kl_divergence(policy_logits, ref_logits):
    """计算策略与参考模型的 KL 散度"""
    policy_probs = F.softmax(policy_logits, dim=-1)
    ref_probs = F.softmax(ref_logits, dim=-1)
    
    kl = (policy_probs * (policy_logits - ref_logits)).sum(dim=-1)
    return kl.mean()
```

## 关键超参数

```python
ppo_config = {
    # PPO 核心参数
    "clip_epsilon": 0.2,       # 截断范围
    "gamma": 0.99,             # 折扣因子
    "lam": 0.95,               # GAE λ
    
    # 训练参数
    "n_epochs": 4,             # 每个 rollout 的 PPO 轮数
    "batch_size": 64,          # 小批量大小
    "lr": 1e-6,                # 学习率
    
    # KL 控制
    "kl_coef": 0.1,            # KL 惩罚系数
    "target_kl": 0.02,         # 目标 KL 散度
    
    # 梯度裁剪
    "max_grad_norm": 0.5,
    
    # 熵正则化
    "entropy_coef": 0.01
}
```

## 应用场景

### 1. 指令微调

```python
# 让模型更好地遵循指令
rlhf_trainer = RLHFTrainer(
    policy_model=sft_model,
    reward_model=preference_rm,
    ref_model=sft_model
)

for batch in instruction_prompts:
    rlhf_trainer.train_step(batch)
```

### 2. 对话优化

```python
# 基于人类反馈优化对话质量
dialogue_rewards = reward_model.evaluate_dialogues(dialogues)
ppo_update(policy, dialogue_rewards)
```

### 3. 内容安全

```python
# 惩罚有害输出
def safety_reward(response):
    if is_harmful(response):
        return -1.0  # 强惩罚
    return reward_model(response)

# 在 PPO 中使用
rewards = [safety_reward(r) for r in responses]
ppo_trainer.update(rewards)
```

## 挑战与解决方案

### ⚠️ 奖励黑客

**问题**: 模型学会欺骗奖励模型  
**解决**: 
- 多奖励模型集成
- 增加 KL 惩罚
- 定期更新奖励模型

### ⚠️ 训练不稳定

**问题**: 策略崩溃或性能下降  
**解决**:
- 减小学习率
- 增加截断范围
- 早停机制

### ⚠️ 高方差

**问题**: 梯度估计方差大  
**解决**:
- 增加 batch size
- 使用 GAE
- 更多 PPO epochs

## 前沿发展

### 1. PPO+KL 自适应

```python
# 动态调整 KL 惩罚系数
def adaptive_kl_coefficient(current_kl, target_kl=0.02):
    if current_kl > target_kl * 2:
        return kl_coef * 2  # 增加惩罚
    elif current_kl < target_kl / 2:
        return kl_coef / 2  # 减少惩罚
    return kl_coef
```

### 2. 分布式 PPO

```python
# 多 GPU 并行采样
def distributed_rollout(num_workers=8):
    rollouts = []
    with ThreadPoolExecutor(max_workers=num_workers) as executor:
        futures = [executor.submit(generate_batch) for _ in range(num_workers)]
        for future in futures:
            rollouts.extend(future.result())
    return rollouts
```

### 3. Offline PPO

```python
# 使用离线数据集训练
def offline_ppo(dataset, behavior_policy):
    # 重要性采样校正
    importance_weights = target_policy / behavior_policy
    
    # 加权 PPO 损失
    weighted_loss = importance_weights * ppo_loss
    return weighted_loss.mean()
```

## 学习资源

- [PPO 原论文](https://arxiv.org/abs/1707.06347)
- [CleanRL PPO 实现](https://github.com/vwxyzjn/cleanrl/blob/master/cleanrl/ppo.py)
- [HuggingFace RLHF 教程](https://huggingface.co/blog/rlhf)

## 相关概念

- [[奖励建模]](/ai-learning/topics/reward-modeling) - 奖励信号
- [[价值对齐]](/ai-learning/topics/value-alignment) - 对齐目标
- [[RLHF]](/ai-learning/resources/rlhf-guide) - 完整流程

## 下一步学习

1. **[价值对齐](/ai-learning/topics/value-alignment)** - 理论框架
2. **[RLHF 实战](/ai-learning/resources/rlhf-guide)** - 完整项目
3. **[Agent 进阶](/ai-learning/resources/agent-advanced)** - 应用扩展

  </div>

  <div class="content-navigation">
    <div class="nav-card prev">
      <span class="nav-label">上一个</span>
      <a href="/ai-learning/topics/reward-modeling" class="nav-link">← 奖励建模</a>
    </div>
    <div class="nav-card next">
      <span class="nav-label">下一个</span>
      <a href="/ai-learning/topics/value-alignment" class="nav-link">价值对齐 →</a>
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
