---
layout: page
title: 强化学习
description: 通过与环境交互学习最优策略的机器学习范式
sidebar: true
page: true
---

<div class="learning-content">
  <div class="content-header">
    <span class="category-badge">核心技术 · AI 分支</span>
    <h1>🎮 强化学习</h1>
    <p class="description">通过与环境交互、试错学习来最大化累积奖励的机器学习方法，AlphaGo 的核心技术</p>
  </div>

  <div class="content-body">

## 概述

**强化学习**（Reinforcement Learning, RL）是机器学习的一个重要分支，关注智能体如何在与环境的交互中学习最优行为策略。与监督学习不同，强化学习不需要标注数据，而是通过试错和奖励信号来学习。

## 核心概念

### 基本框架

```
智能体（Agent） ←→ 环境（Environment）
    ↓                    ↓
动作（Action）        状态（State）
    ↓                    ↓
    └──── 奖励（Reward）←┘
```

**关键要素**：
- **状态（State, s）**：环境的当前情况
- **动作（Action, a）**：智能体可以执行的行为
- **奖励（Reward, r）**：环境的反馈信号
- **策略（Policy, π）**：状态到动作的映射
- **价值函数（Value Function, V）**：状态的长期期望回报

### Markov 决策过程（MDP）

强化学习的数学框架：

```python
MDP = (S, A, P, R, γ)

其中：
- S: 状态空间
- A: 动作空间
- P(s'|s,a): 状态转移概率
- R(s,a,s'): 奖励函数
- γ: 折扣因子 (0 ≤ γ ≤ 1)

目标：找到最优策略 π* 最大化期望累积奖励
J(π) = E[Σ γ^t * r_t]
```

## 主要算法

### 1. Q-Learning

经典的值迭代算法：

```python
import numpy as np

class QLearning:
    def __init__(self, n_states, n_actions, alpha=0.1, gamma=0.9, epsilon=0.1):
        self.q_table = np.zeros((n_states, n_actions))
        self.alpha = alpha      # 学习率
        self.gamma = gamma      # 折扣因子
        self.epsilon = epsilon  # 探索率
    
    def choose_action(self, state):
        """ε-greedy 策略选择动作"""
        if np.random.random() < self.epsilon:
            return np.random.randint(self.q_table.shape[1])  # 探索
        else:
            return np.argmax(self.q_table[state])  # 利用
    
    def update(self, state, action, reward, next_state):
        """更新 Q 值"""
        best_next_action = np.argmax(self.q_table[next_state])
        
        # Bellman 方程
        td_target = reward + self.gamma * self.q_table[next_state][best_next_action]
        td_error = td_target - self.q_table[state][action]
        
        # 更新 Q 值
        self.q_table[state][action] += self.alpha * td_error

# 使用示例（网格世界）
agent = QLearning(n_states=16, n_actions=4)

for episode in range(1000):
    state = env.reset()
    
    while not done:
        action = agent.choose_action(state)
        next_state, reward, done = env.step(action)
        agent.update(state, action, reward, next_state)
        state = next_state
```

### 2. Deep Q-Network (DQN)

结合深度学习的 Q-Learning：

```python
import torch
import torch.nn as nn
import torch.optim as optim

class DQN(nn.Module):
    def __init__(self, state_dim, action_dim):
        super().__init__()
        self.network = nn.Sequential(
            nn.Linear(state_dim, 128),
            nn.ReLU(),
            nn.Linear(128, 128),
            nn.ReLU(),
            nn.Linear(128, action_dim)
        )
    
    def forward(self, x):
        return self.network(x)

class DQNAgent:
    def __init__(self, state_dim, action_dim):
        self.model = DQN(state_dim, action_dim)
        self.target_model = DQN(state_dim, action_dim)
        self.optimizer = optim.Adam(self.model.parameters(), lr=0.001)
        self.memory = []
        self.gamma = 0.99
    
    def remember(self, state, action, reward, next_state, done):
        self.memory.append((state, action, reward, next_state, done))
    
    def train(self, batch_size=32):
        if len(self.memory) < batch_size:
            return
        
        # 采样 batch
        batch = random.sample(self.memory, batch_size)
        states, actions, rewards, next_states, dones = zip(*batch)
        
        # 计算 TD target
        with torch.no_grad():
            next_q_values = self.target_model(torch.tensor(next_states))
            targets = rewards + self.gamma * next_q_values.max(dim=1)[0] * (1 - torch.tensor(dones))
        
        # 训练
        q_values = self.model(torch.tensor(states))
        loss = nn.MSELoss()(q_values.gather(1, torch.tensor(actions).unsqueeze(1)).squeeze(), targets)
        
        self.optimizer.zero_grad()
        loss.backward()
        self.optimizer.step()
```

### 3. Policy Gradient

直接优化策略的方法：

```python
def policy_gradient_loss(log_probs, returns):
    """策略梯度损失"""
    return -(log_probs * returns).mean()

# REINFORCE 算法
for episode in range(n_episodes):
    trajectory = []
    state = env.reset()
    
    # 收集轨迹
    while not done:
        action, log_prob = agent.select_action(state)
        next_state, reward, done, _ = env.step(action)
        trajectory.append((log_prob, reward))
        state = next_state
    
    # 计算回报
    returns = []
    G = 0
    for _, reward in reversed(trajectory):
        G = reward + gamma * G
        returns.insert(0, G)
    
    returns = torch.tensor(returns)
    returns = (returns - returns.mean()) / (returns.std() + 1e-8)  # 标准化
    
    # 更新策略
    losses = [log_prob * ret for log_prob, ret in trajectory]
    loss = -torch.stack(losses).sum()
    
    optimizer.zero_grad()
    loss.backward()
    optimizer.step()
```

### 4. Actor-Critic

结合值方法和策略方法：

```python
class ActorCritic(nn.Module):
    def __init__(self, state_dim, action_dim):
        super().__init__()
        self.actor = nn.Sequential(
            nn.Linear(state_dim, 128),
            nn.ReLU(),
            nn.Linear(128, action_dim),
            nn.Softmax(dim=-1)
        )
        
        self.critic = nn.Sequential(
            nn.Linear(state_dim, 128),
            nn.ReLU(),
            nn.Linear(128, 1)
        )
    
    def forward(self, x):
        return self.actor(x), self.critic(x)

# A2C 更新
values = critic(states)
advantages = returns - values.detach()

actor_loss = -(log_probs * advantages).mean()
critic_loss = advantages.pow(2).mean()

loss = actor_loss + 0.5 * critic_loss
```

## 经典应用案例

### AlphaGo（2016）

**技术架构**：
```
策略网络（Policy Network）
    ↓
蒙特卡洛树搜索（MCTS）
    ↓
价值网络（Value Network）
    ↓
最终决策
```

**训练过程**：
1. **监督学习**：从人类棋谱学习初始策略
2. **自我对弈**：自己跟自己下棋
3. **强化学习**：通过胜负结果优化策略

### Atari 游戏

**输入**：原始像素（84×84×4 帧）  
**输出**：游戏手柄动作  
**成果**：在多个游戏中达到超越人类的水平

### 机器人控制

```python
# 使用 PPO 训练机器人行走
env = gym.make("Humanoid-v3")
agent = PPOAgent()

for iteration in range(n_iterations):
    # 收集轨迹
    trajectories = agent.collect_trajectories(env)
    
    # 计算优势函数
    advantages = compute_gae(trajectories)
    
    # PPO 更新（多轮）
    for _ in range(ppo_epochs):
        surrogate_loss = compute_ppo_loss(trajectories, advantages)
        value_loss = compute_value_loss(trajectories)
        entropy_bonus = compute_entropy_bonus(trajectories)
        
        loss = surrogate_loss + 0.5 * value_loss - 0.01 * entropy_bonus
        update_agent(loss)
```

## 挑战与发展方向

### 当前挑战

1. **样本效率低**
   - 需要大量交互才能学会
   - 现实世界中成本高昂

2. **奖励设计困难**
   - 奖励函数难以精确指定
   - 可能导致意外行为（奖励黑客）

3. **泛化能力弱**
   - 在新环境中表现差
   - 需要重新训练

### 前沿方向

1. **元强化学习**
   - 学会如何学习
   - 快速适应新任务

2. **多智能体 RL**
   - 协作与竞争
   - 博弈论与 RL 结合

3. **离线 RL**
   - 从静态数据集学习
   - 无需与环境交互

## 学习资源

### 📺 视频教程
- [David Silver RL Course - UCL](https://www.youtube.com/playlist?list=PLzuuYNsE1EZAXYR4FJ75jcJseBmo4KQ9-)
- [李宏毅强化学习 - B 站](https://www.bilibili.com/video/BV1Z94y1a7zL)

### 📚 书籍
- 《Reinforcement Learning: An Introduction》- Sutton & Barto
- 《强化学习导论》- 中文译本

### 💻 实践工具
- [OpenAI Gym](https://gym.openai.com/)
- [Stable Baselines3](https://stable-baselines3.readthedocs.io/)
- [Ray RLlib](https://docs.ray.io/en/latest/rllib/index.html)

## 相关概念

- [[深度学习]](/ai-learning/topics/deep-learning) - DQN 的基础
- [[Agent]](/ai-learning/topics/agent) - 智能体概念
- [[AlphaGo]](/ai-learning/history/alphago) - 经典应用案例

## 下一步学习

1. **[Deep Q-Learning 实战](/ai-learning/resources/dqn-tutorial)** - 动手实现 DQN
2. **[PPO 算法详解](/ai-learning/resources/ppo-guide)** - 现代 RL 核心算法
3. **[多智能体系统](/ai-learning/topics/multi-agent-systems)** - 扩展应用

  </div>

  <div class="content-navigation">
    <div class="nav-card prev">
      <span class="nav-label">上一个</span>
      <a href="/ai-learning/topics/logic-reasoning" class="nav-link">← 逻辑推理</a>
    </div>
    <div class="nav-card next">
      <span class="nav-label">下一个</span>
      <a href="/ai-learning/topics/knowledge-representation" class="nav-link">知识表示 →</a>
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
