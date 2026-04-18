---
layout: page
title: 具身智能
description: 机器人与物理世界交互学习的技术
sidebar: true
page: true
---

<div class="learning-content">
<div class="content-header">
<span class="category-badge">前沿技术 · 机器人 AI</span>
<h1>🤖 具身智能 (Embodied AI)</h1>
<p class="description">让 AI 系统通过身体与物理世界交互，实现感知 - 行动闭环的智能学习</p>
</div>
<div class="content-body">

## 概述

**具身智能**（Embodied AI）强调智能体需要通过身体感知和行动来学习，而非仅从静态数据中学习。

## 核心方向

### 机器人学习

强化学习在机器人控制中的应用、模仿学习、Sim-to-Real迁移

### 仿真环境

MuJoCo、PyBullet、Isaac Gym、Habitat等物理仿真平台

### 端到端控制

从原始传感器输入直接输出控制指令的深度学习方法

## 应用场景

- 家庭服务机器人
- 工业机械臂操作
- 自动驾驶
- 无人机导航

## 相关资源

- 前置：[强化学习](/ai-learning/topics/reinforcement-learning)
- 相关：[多模态](/ai-learning/topics/multimodal)、[Agent](/ai-learning/topics/agent)
- 进阶：[机器人学](https://github.com/robotics)

</div>
<div class="content-navigation">
<div class="nav-card prev">
<span class="nav-label">上一个</span>
<a href="/ai-learning/topics/value-alignment" class="nav-link">← 价值对齐</a>
</div>
<div class="nav-card next">
<span class="nav-label">下一个</span>
<a href="/ai-learning/topics/adversarial-attacks" class="nav-link">对抗攻击 →</a>
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
.content-body ul { margin: 1rem 0; padding-left: 1.5rem; }
.content-body li { margin: 0.5rem 0; line-height: 1.6; }
.content-body a { color: #667eea; text-decoration: none; transition: color 0.2s; font-weight: 500; }
.content-body a:hover { color: #764ba2; text-decoration: underline; }
.content-body strong { color: #1f2937; font-weight: 600; }
.content-navigation { display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; margin-top: 3rem; padding-top: 2rem; border-top: 2px solid #e5e7eb; }
.nav-card { background: white; border: 2px solid #e5e7eb; border-radius: 12px; padding: 1.5rem; transition: all 0.3s ease; }
.nav-card:hover { border-color: #f093fb; box-shadow: 0 4px 12px rgba(240, 147, 251, 0.2); transform: translateY(-2px); }
.nav-label { display: block; font-size: 0.85rem; color: #6b7280; margin-bottom: 0.5rem; }
.nav-link { display: block; font-size: 1.1rem; font-weight: 600; color: #667eea; text-decoration: none; transition: color 0.2s; }
.nav-link:hover { color: #764ba2; }
@media (max-width: 768px) { .learning-content { padding: 1rem; } .content-header h1 { font-size: 1.8rem; } .content-navigation { grid-template-columns: 1fr; } }
</style>
