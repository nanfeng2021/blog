---
layout: page
title: 语义检索
description: 基于向量相似度的智能搜索技术
sidebar: true
page: true
---

<div class="learning-content">
  <div class="content-header">
    <span class="category-badge">核心技术 · RAG</span>
    <h1>🔍 语义检索 (Semantic Search)</h1>
    <p class="description">超越关键词匹配，理解查询和文档的语义含义，实现更精准的搜索结果</p>
  </div>

  <div class="content-body">

## 概述

**语义检索**（Semantic Search）通过理解文本的深层含义而非简单的关键词匹配，实现更智能、更准确的搜索体验。

## 核心原理

### 1. 向量嵌入

```python
from sentence_transformers import SentenceTransformer

model = SentenceTransformer('all-MiniLM-L6-v2')

# 编码查询和文档
query_embedding = model.encode("如何学习 Python？")
doc_embeddings = model.encode([
    "Python 编程入门教程",
    "Java 高级编程指南",
    "数据科学实战"
])

# 计算相似度
from sklearn.metrics.pairwise import cosine_similarity
similarities = cosine_similarity([query_embedding], doc_embeddings)
print(similarities[0])  # [0.85, 0.12, 0.43]
```

### 2. 相似度度量

```python
import numpy as np

def cosine_similarity(a, b):
    return np.dot(a, b) / (np.linalg.norm(a) * np.linalg.norm(b))

def euclidean_distance(a, b):
    return np.linalg.norm(np.array(a) - np.array(b))

def dot_product(a, b):
    return np.dot(a, b)
```

## 完整实现

### 使用 FAISS 构建搜索引擎

```python
import faiss
from sentence_transformers import SentenceTransformer

class SemanticSearchEngine:
    def __init__(self, model_name='all-MiniLM-L6-v2'):
        self.model = SentenceTransformer(model_name)
        self.index = None
        self.documents = []
    
    def add_documents(self, docs):
        """添加文档到索引"""
        self.documents.extend(docs)
        embeddings = self.model.encode(docs)
        
        if self.index is None:
            dim = embeddings.shape[1]
            self.index = faiss.IndexFlatIP(dim)  # 内积相似度
        
        # 归一化后添加
        faiss.normalize_L2(embeddings)
        self.index.add(embeddings.astype('float32'))
    
    def search(self, query, top_k=5):
        """搜索最相关的文档"""
        query_emb = self.model.encode([query])
        faiss.normalize_L2(query_emb)
        
        scores, indices = self.index.search(
            query_emb.astype('float32'), 
            top_k
        )
        
        results = [
            {'doc': self.documents[i], 'score': float(s)}
            for i, s in zip(indices[0], scores[0])
            if i < len(self.documents)
        ]
        
        return results

# 使用示例
engine = SemanticSearchEngine()
engine.add_documents([
    "机器学习算法详解",
    "深度学习入门教程",
    "Python 数据分析实战"
])

results = engine.search("如何学习人工智能？", top_k=2)
for r in results:
    print(f"{r['score']:.2f}: {r['doc']}")
```

## 进阶技术

### 1. 混合搜索（Hybrid Search）

```python
from rank_bm25 import BM25Okapi

class HybridSearch:
    def __init__(self, documents):
        self.semantic_engine = SemanticSearchEngine()
        self.semantic_engine.add_documents(documents)
        
        # BM25 关键词搜索
        tokenized_docs = [doc.split() for doc in documents]
        self.bm25 = BM25Okapi(tokenized_docs)
    
    def search(self, query, top_k=5, alpha=0.5):
        """结合语义和关键词搜索"""
        # 语义搜索分数
        semantic_results = self.semantic_engine.search(query, top_k*2)
        semantic_scores = {r['doc']: r['score'] for r in semantic_results}
        
        # 关键词搜索分数
        bm25_scores = self.bm25.get_scores(query.split())
        
        # 融合分数
        combined = {}
        for i, doc in enumerate(self.semantic_engine.documents):
            sem_score = semantic_scores.get(doc, 0)
            key_score = bm25_scores[i]
            combined[doc] = alpha * sem_score + (1-alpha) * key_score
        
        # 排序返回
        sorted_docs = sorted(combined.items(), key=lambda x: x[1], reverse=True)
        return [{'doc': d, 'score': s} for d, s in sorted_docs[:top_k]]
```

### 2. 多向量检索

```python
# ColBERT 风格：每个 token 一个向量
class MultiVectorSearch:
    def __init__(self):
        self.model = SentenceTransformer('multi-qa-MiniLM-L6-cos-v1')
    
    def encode_document(self, doc):
        """为文档的每个段落生成向量"""
        paragraphs = doc.split('\n\n')
        return self.model.encode(paragraphs)
    
    def max_sim(self, query_emb, doc_embs):
        """最大相似度聚合"""
        similarities = cosine_similarity([query_emb], doc_embs)[0]
        return similarities.max()
```

## 应用场景

### 1. RAG 检索增强

```python
from langchain.vectorstores import FAISS
from langchain.embeddings import OpenAIEmbeddings

embeddings = OpenAIEmbeddings()
vectorstore = FAISS.from_documents(docs, embeddings)

retriever = vectorstore.as_retriever(
    search_type="similarity_score_threshold",
    search_kwargs={"score_threshold": 0.7}
)

relevant_docs = retriever.get_relevant_documents("用户问题")
```

### 2. 问答系统

```python
def semantic_qa(question, knowledge_base):
    # 检索相关上下文
    engine = SemanticSearchEngine()
    engine.add_documents(knowledge_base)
    
    contexts = engine.search(question, top_k=3)
    context_text = "\n".join([c['doc'] for c in contexts])
    
    # 生成答案
    prompt = f"""基于以下信息回答问题:
{context_text}

问题：{question}
答案："""
    
    return llm.generate(prompt)
```

### 3. 推荐系统

```python
def recommend_items(user_history, item_database, top_n=10):
    # 将用户历史编码为用户向量
    user_emb = model.encode(user_history)
    
    # 检索最相似的物品
    item_embs = model.encode(item_database)
    similarities = cosine_similarity([user_emb], item_embs)[0]
    
    top_indices = similarities.argsort()[::-1][:top_n]
    return [item_database[i] for i in top_indices]
```

## 性能优化

### 近似最近邻（ANN）

```python
# HNSW 索引 - 更快但略有精度损失
index = faiss.IndexHNSWFlat(dimension, M=32)
index.add(vectors)

# IVF 索引 - 适合大规模数据
quantizer = faiss.IndexFlatIP(dimension)
index = faiss.IndexIVFFlat(quantizer, dimension, nlist=100)
index.train(vectors)
index.add(vectors)
```

### GPU 加速

```python
res = faiss.StandardGpuResources()
gpu_index = faiss.index_cpu_to_gpu(res, 0, index)
# 速度提升 10-50 倍
```

## 评估指标

```python
def evaluate_search(engine, test_queries, ground_truth):
    """评估搜索质量"""
    mrr = 0  # 平均倒数排名
    ndcg = 0  # 归一化折损累积增益
    
    for i, (query, relevant_docs) in enumerate(zip(test_queries, ground_truth)):
        results = engine.search(query, top_k=10)
        result_docs = [r['doc'] for r in results]
        
        # MRR
        for j, doc in enumerate(result_docs):
            if doc in relevant_docs:
                mrr += 1.0 / (j + 1)
                break
        
        # NDCG
        dcg = sum((2 ** rel - 1) / np.log2(j + 2) 
                  for j, doc in enumerate(result_docs) 
                  if doc in relevant_docs)
        
        idcg = sum(1 / np.log2(j + 2) for j in range(len(relevant_docs)))
        ndcg += dcg / idcg if idcg > 0 else 0
    
    return {'MRR': mrr / len(test_queries), 'NDCG': ndcg / len(test_queries)}
```

## 学习资源

- [Sentence Transformers](https://www.sbert.net/)
- [FAISS 官方文档](https://faiss.ai/)
- [LangChain 检索指南](https://python.langchain.com/docs/modules/data_connection/retrievers/)

## 相关概念

- [[向量数据库]](/ai-learning/topics/vector-database) - 存储基础设施
- [[RAG]](/ai-learning/topics/rag) - 检索增强生成
- [[Embedding]](/ai-learning/topics/embedding) - 向量表示

## 下一步学习

1. **[向量数据库](/ai-learning/topics/vector-database)** - 存储优化
2. **[RAG 实战](/ai-learning/topics/rag)** - 完整应用
3. **[知识图谱](/ai-learning/topics/knowledge-graph)** - 结构化知识

  </div>

  <div class="content-navigation">
    <div class="nav-card prev">
      <span class="nav-label">上一个</span>
      <a href="/ai-learning/topics/vector-database" class="nav-link">← 向量数据库</a>
    </div>
    <div class="nav-card next">
      <span class="nav-label">下一个</span>
      <a href="/ai-learning/topics/knowledge-graph" class="nav-link">知识图谱 →</a>
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
