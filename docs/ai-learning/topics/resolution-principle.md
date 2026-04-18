---
layout: page
title: 归结原理
description: 自动定理证明的核心算法
sidebar: true
page: true
---

<div class="learning-content">
  <div class="content-header">
    <span class="category-badge">核心技术 · 推理方法</span>
    <h1>📐 归结原理</h1>
    <p class="description">John Alan Robinson 于 1965 年提出的自动定理证明算法</p>
  </div>

  <div class="content-body">

## 概述

**归结原理**（Resolution Principle）是一种机械化的逻辑推理方法，是自动定理证明和逻辑编程的基础。

## 基本原理

```
核心思想：反证法
1. 将前提转换为子句形式
2. 添加结论的否定
3. 不断归结直到推出空子句（矛盾）

示例：
前提：P → Q, P
结论：Q

步骤：
1. 转换：¬P ∨ Q, P, ¬Q
2. 归结：(¬P ∨ Q) + P → Q
3. 归结：Q + ¬Q → □ (矛盾)
4. 得证！
```

## Python 实现

```python
def resolve(clause1, clause2):
    """归结两个子句"""
    for lit1 in clause1:
        neg = -lit1 if lit1 > 0 else abs(lit1)
        if neg in clause2:
            result = list(set(clause1) | set(clause2))
            result.remove(lit1)
            result.remove(neg)
            return result
    return None

def resolution_proof(clauses, goal):
    """归结证明"""
    clauses.append([-goal])  # 添加结论的否定
    
    while True:
        new_clauses = []
        for i in range(len(clauses)):
            for j in range(i+1, len(clauses)):
                resolvent = resolve(clauses[i], clauses[j])
                if resolvent and not resolvent:
                    return True  # 空子句，证明成功
                if resolvent and resolvent not in clauses:
                    new_clauses.append(resolvent)
        
        if not new_clauses:
            return False  # 无法继续
        
        clauses.extend(new_clauses)
```

## 应用

- **Prolog 语言**: 基于归结原理
- **模型检测**: 硬件验证
- **SAT 求解器**: 组合优化

## 相关概念

- [[逻辑推理]](/ai-learning/topics/logic-reasoning) - 基础理论
- [[知识表示]](/ai-learning/topics/knowledge-representation) - 形式化方法

## 下一步学习

1. **[逻辑推理](/ai-learning/topics/logic-reasoning)** - 深入理解
2. **[Prolog 编程](/ai-learning/resources/prolog-guide)** - 实践应用

  </div>

  <div class="content-navigation">
    <div class="nav-card prev">
      <span class="nav-label">上一个</span>
      <a href="/ai-learning/topics/knowledge-engineering" class="nav-link">← 知识工程</a>
    </div>
    <div class="nav-card next">
      <span class="nav-label">下一个</span>
      <a href="/ai-learning/topics/statistical-learning" class="nav-link">统计学习 →</a>
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
