---
layout: page
title: PyTorch/TensorFlow
description: 深度学习框架对比与入门
sidebar: true
page: true
---

<div class="learning-content">
<div class="content-header">
<span class="category-badge">学习资源 · 框架教程</span>
<h1>🔥 PyTorch / TensorFlow</h1>
<p class="description">两大主流深度学习框架对比学习与实战指南</p>
</div>
<div class="content-body">

## 框架概述

**PyTorch** 和 **TensorFlow** 是目前最流行的两个深度学习框架，各有优势。

## PyTorch 特点

- **优点**: Pythonic、动态图、易调试
- **适用**: 研究、原型开发、教学
- **生态**: torchvision、torchaudio、transformers

## TensorFlow 特点

- **优点**: 生产部署、静态图优化、移动端支持
- **适用**: 大规模部署、边缘计算
- **生态**: Keras、TFX、TensorBoard

## 学习建议

1. 先学一个框架（推荐 PyTorch）
2. 理解核心概念（张量、自动微分）
3. 完成官方教程项目
4. 再学习另一个框架

## 相关资源

- 前置：[吴恩达 ML](/ai-learning/resources/andrew-ng-ml)
- 后续：[CS231n](/ai-learning/resources/cs231n)、[CS224n](/ai-learning/resources/cs224n)
- 实战：[LLM 实战项目](/ai-learning/resources/llm-projects)

</div>
<div class="content-navigation">
<div class="nav-card prev">
<span class="nav-label">上一个</span>
<a href="/ai-learning/resources/scikit-learn-tutorial" class="nav-link">← scikit-learn</a>
</div>
<div class="nav-card next">
<span class="nav-label">下一个</span>
<a href="/ai-learning/resources/llm-projects" class="nav-link">LLM 实战项目 →</a>
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
