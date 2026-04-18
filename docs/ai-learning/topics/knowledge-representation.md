---
layout: page
title: 知识表示
description: AI 中如何形式化地表示知识和信息
sidebar: true
page: true
---

<div class="learning-content">
  <div class="content-header">
    <span class="category-badge">核心技术 · AI 基础</span>
    <h1>📚 知识表示</h1>
    <p class="description">人工智能中如何形式化地表示、组织和利用知识</p>
  </div>

  <div class="content-body">

## 概述

**知识表示**（Knowledge Representation, KR）是 AI 的核心问题之一，研究如何用计算机可处理的形式来表示人类知识。

## 主要方法

### 1. 逻辑表示法

```prolog
% 一阶谓词逻辑示例
human(socrates).
mortal(X) :- human(X).
?- mortal(socrates).  % true
```

### 2. 语义网络

```
[鸟] --is-a--> [动物]
 |             |
has           can
 |             |
 v             v
[翅膀]       [飞]
```

### 3. 框架表示

```python
class Frame:
    def __init__(self, name, slots=None):
        self.name = name
        self.slots = slots or {}

bird = Frame("Bird", {
    "is_a": "Animal",
    "has": ["wings", "feathers"],
    "can": ["fly", "lay_eggs"]
})
```

### 4. 本体论（Ontology）

```python
from rdflib import Graph, Namespace

EX = Namespace("http://example.org/")
g = Graph()

# 定义类层次
g.add((EX.Bird, RDF.subClassOf, EX.Animal))
g.add((EX.Penguin, RDF.subClassOf, EX.Bird))

# 定义属性
g.add((EX.hasWings, RDF.domain, EX.Bird))
```

### 5. 产生式规则

```python
rules = [
    {"IF": ["发烧", "咳嗽"], "THEN": "可能感染"},
    {"IF": ["可能感染", "白细胞高"], "THEN": "细菌感染"}
]
```

## 应用场景

- **专家系统**: MYCIN, DENDRAL
- **知识图谱**: Google Knowledge Graph
- **语义网**: RDF, OWL
- **自然语言理解**: 语义角色标注

## 挑战

⚠️ **框架问题**: 难以表示什么不变  
⚠️ **常识知识**: 日常知识难以形式化  
⚠️ **可扩展性**: 大规模知识库维护困难

## 相关概念

- [[逻辑推理]](/ai-learning/topics/logic-reasoning) - 推理基础
- [[专家系统]](/ai-learning/history/expert-systems) - 应用实例
- [[知识工程]](/ai-learning/topics/knowledge-engineering) - 构建方法

## 下一步学习

1. **[知识工程](/ai-learning/topics/knowledge-engineering)** - 实践方法
2. **[逻辑推理](/ai-learning/topics/logic-reasoning)** - 推理技术

  </div>

  <div class="content-navigation">
    <div class="nav-card prev">
      <span class="nav-label">上一个</span>
      <a href="/ai-learning/topics/logic-reasoning" class="nav-link">← 逻辑推理</a>
    </div>
    <div class="nav-card next">
      <span class="nav-label">下一个</span>
      <a href="/ai-learning/topics/knowledge-engineering" class="nav-link">知识工程 →</a>
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
