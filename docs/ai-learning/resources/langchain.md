---
layout: page
title: LangChain
description: LLM 应用开发框架教程
sidebar: true
page: true
---

<div class="learning-content">
<div class="content-header">
<span class="category-badge">学习资源 · 框架教程</span>
<h1>⛓️ LangChain</h1>
<p class="description">LangChain 框架完整教程 - 构建 LLM 应用的强大工具链</p>
</div>
<div class="content-body">

## 框架概述

**LangChain** 是最流行的 LLM 应用开发框架，提供模块化组件和工具链。

## 核心组件

### Prompts

模板管理、动态生成、 Few-shot 示例

### Chains

顺序执行、条件分支、并行处理

### Agents

工具调用、自主决策、多步规划

### Memory

对话历史、上下文管理、状态保持

## 应用场景

- RAG 问答系统
- 智能客服机器人
- 数据分析助手
- 代码生成工具

## 相关资源

- 前置：[LLM 实战项目](/ai-learning/resources/llm-projects)
- 对比：[AutoGen](/ai-learning/resources/autogen)
- 进阶：[最新论文追踪](/ai-learning/resources/latest-papers)

</div>
<div class="content-navigation">
<div class="nav-card prev">
<span class="nav-label">上一个</span>
<a href="/ai-learning/resources/llm-projects" class="nav-link">← LLM 实战项目</a>
</div>
<div class="nav-card next">
<span class="nav-label">下一个</span>
<a href="/ai-learning/resources/autogen" class="nav-link">AutoGen →</a>
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
