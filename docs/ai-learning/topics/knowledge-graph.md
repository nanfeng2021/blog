---
layout: page
title: 知识图谱
description: 结构化知识的表示与推理技术
sidebar: true
page: true
---

<div class="learning-content">
  <div class="content-header">
    <span class="category-badge">核心技术 · RAG</span>
    <h1>🕸️ 知识图谱 (Knowledge Graph)</h1>
    <p class="description">以图结构表示实体、概念及其关系，实现知识的结构化存储和智能推理</p>
  </div>

  <div class="content-body">

## 概述

**知识图谱**（Knowledge Graph）是一种结构化的语义知识库，以图的形式描述现实世界中的实体、概念及其相互关系。

## 核心组成

### 1. 基本元素

```
实体（Entity）：具体对象，如"北京"、"马云"
概念（Concept）：抽象类别，如"城市"、"企业家"
关系（Relation）：实体间的联系，如"位于"、"创立"
属性（Property）：实体的特征，如"人口"、"年龄"
```

### 2. RDF 三元组

```turtle
# 示例：马云创立了阿里巴巴
<马云> <创立> <阿里巴巴> .
<阿里巴巴> <总部位于> <杭州> .
<杭州> <是省会> <浙江> .
<浙江> <位于> <中国> .
```

## 构建流程

### 1. 信息抽取

```python
from transformers import pipeline

# 命名实体识别
ner = pipeline("ner", model="dslim/bert-base-NER")
entities = ner("马云于 1999 年在杭州创立了阿里巴巴集团")

# 关系抽取
relation_extractor = pipeline("relation-classification")
relations = relation_extractor(
    text="马云创立了阿里巴巴",
    entities=[("马云", "PERSON"), ("阿里巴巴", "ORG")]
)
```

### 2. 知识融合

```python
# 实体对齐
def entity_alignment(entity1, entity2, kg):
    """判断两个实体是否指向同一对象"""
    # 基于名称相似度
    name_sim = fuzzy_match(entity1.name, entity2.name)
    
    # 基于邻居相似性
    neighbors1 = set(kg.get_neighbors(entity1))
    neighbors2 = set(kg.get_neighbors(entity2))
    neighbor_sim = jaccard(neighbors1, neighbors2)
    
    return name_sim > 0.8 or neighbor_sim > 0.6
```

### 3. 知识存储

```python
from rdflib import Graph, Namespace, Literal

# 创建知识图谱
g = Graph()
EX = Namespace("http://example.org/")

# 添加三元组
g.add((EX.马云, RDF.type, EX.企业家))
g.add((EX.马云, EX.创立, EX.阿里巴巴))
g.add((EX.阿里巴巴, EX.行业, Literal("电子商务")))

# SPARQL 查询
query = """
SELECT ?company WHERE {
    马云 创立 ?company .
}
"""
results = g.query(query)
for row in results:
    print(f"马云创立的公司：{row.company}")
```

## 图数据库

### Neo4j 实战

```python
from neo4j import GraphDatabase

class KnowledgeGraph:
    def __init__(self, uri, user, password):
        self.driver = GraphDatabase.driver(uri, auth=(user, password))
    
    def add_entity(self, entity_id, label, properties):
        """添加实体"""
        with self.driver.session() as session:
            props = ", ".join([f"{k}: '{v}'" for k, v in properties.items()])
            query = f"""
            CREATE (n:{label} {{id: '{entity_id}', {props}}})
            RETURN n
            """
            session.run(query)
    
    def add_relation(self, from_id, rel_type, to_id):
        """添加关系"""
        with self.driver.session() as session:
            query = f"""
            MATCH (a {{id: '{from_id}'}}), (b {{id: '{to_id}'}})
            CREATE (a)-[r:{rel_type}]->(b)
            RETURN r
            """
            session.run(query)
    
    def query_path(self, start_id, end_id, max_depth=3):
        """查询实体间路径"""
        with self.driver.session() as session:
            query = f"""
            MATCH path = shortestPath(
                (start {{id: '{start_id}'}})-[*..{max_depth}]-(end {{id: '{end_id}'}})
            )
            RETURN path
            """
            result = session.run(query)
            return result.single()
```

## 应用场景

### 1. 智能问答

```python
def kb_qa(question, kg):
    """基于知识图谱的问答"""
    # 解析问题
    entities = extract_entities(question)
    relation = extract_relation(question)
    
    # 查询知识图谱
    query = f"""
    MATCH (e1)-[:{relation}]->(e2)
    WHERE e1.id IN {entities}
    RETURN e2
    """
    
    results = kg.query(query)
    return format_answer(results)
```

### 2. 推荐系统

```python
def kg_recommend(user_id, kg, top_k=10):
    """基于知识图谱的推荐"""
    # 查找用户喜欢的实体
    liked_items = kg.query(f"""
        MATCH (user)-[:LIKED]->(item)
        WHERE user.id = '{user_id}'
        RETURN item
    """)
    
    # 查找相似物品
    recommendations = []
    for item in liked_items:
        similar = kg.query(f"""
            MATCH (item)-[:SIMILAR_TO]->(rec)
            RETURN rec LIMIT {top_k}
        """)
        recommendations.extend(similar)
    
    return deduplicate(recommendations)[:top_k]
```

### 3. 事实验证

```python
def fact_check(claim, kg):
    """验证书面声明的真实性"""
    # 解析声明为三元组
    subject, predicate, obj = parse_claim(claim)
    
    # 在 KG 中查询
    exists = kg.query(f"""
        MATCH (s)-[:{predicate}]->(o)
        WHERE s.id = '{subject}' AND o.id = '{obj}'
        RETURN count(*) > 0 as exists
    """)
    
    return exists
```

## 前沿发展

### 1. 神经符号 AI

- 结合神经网络和符号推理
- 可解释性更强
- 少样本学习能力

### 2. 大模型 + KG

- LLM 生成 KG
- KG 增强 LLM 推理
- 减少幻觉

### 3. 动态知识图谱

- 实时更新
- 时序推理
- 事件检测

## 学习资源

- [Neo4j 官方文档](https://neo4j.com/docs/)
- [RDF 规范](https://www.w3.org/RDF/)
- [SPARQL 教程](https://www.w3.org/TR/sparql11-query/)

## 相关概念

- [[向量数据库]](/ai-learning/topics/vector-database) - 非结构化存储
- [[语义检索]](/ai-learning/topics/semantic-search) - 搜索技术
- [[RAG]](/ai-learning/topics/rag) - 检索增强生成

## 下一步学习

1. **[语义检索](/ai-learning/topics/semantic-search)** - 搜索优化
2. **[RAG 实战](/ai-learning/topics/rag)** - 综合应用
3. **[神经符号 AI](/ai-learning/topics/neuro-symbolic)** - 前沿方向

  </div>

  <div class="content-navigation">
    <div class="nav-card prev">
      <span class="nav-label">上一个</span>
      <a href="/ai-learning/topics/semantic-search" class="nav-link">← 语义检索</a>
    </div>
    <div class="nav-card next">
      <span class="nav-label">下一个</span>
      <a href="/ai-learning/topics/rag" class="nav-link">返回 RAG →</a>
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
