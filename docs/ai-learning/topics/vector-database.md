---
layout: page
title: 向量数据库
description: 高效存储和检索高维向量数据的专用数据库
sidebar: true
page: true
---

<div class="learning-content">
  <div class="content-header">
    <span class="category-badge">核心技术 · RAG</span>
    <h1>🗄️ 向量数据库 (Vector Database)</h1>
    <p class="description">专门用于存储、索引和检索高维向量的数据库系统，是 RAG 和语义搜索的核心基础设施</p>
  </div>

  <div class="content-body">

## 概述

**向量数据库**（Vector Database）是专门为高维向量数据设计的数据库，支持高效的相似性搜索，广泛应用于语义检索、推荐系统、RAG 等场景。

## 核心功能

### 1. 向量索引

```python
from qdrant_client import QdrantClient
from qdrant_client.models import Distance, VectorParams, PointStruct

# 连接数据库
client = QdrantClient(host="localhost", port=6333)

# 创建集合
client.create_collection(
    collection_name="documents",
    vectors_config=VectorParams(size=768, distance=Distance.COSINE)
)

# 插入向量
points = [
    PointStruct(id=1, vector=[0.1]*768, payload={"text": "文档 1"}),
    PointStruct(id=2, vector=[0.2]*768, payload={"text": "文档 2"}),
]

client.upsert(collection_name="documents", points=points)
```

### 2. 相似性搜索

```python
# 向量搜索
results = client.search(
    collection_name="documents",
    query_vector=[0.15]*768,
    limit=5
)

for hit in results:
    print(f"相似度：{hit.score}, 内容：{hit.payload['text']}")
```

## 主流向量数据库

| 数据库 | 特点 | 适用场景 |
|--------|------|----------|
| **Qdrant** | Rust 编写，高性能 | 生产环境 |
| **Pinecone** | 托管服务，易用 | 快速原型 |
| **Milvus** | 功能丰富，可扩展 | 大规模应用 |
| **Weaviate** | 图 + 向量混合 | 知识图谱 |
| **Chroma** | 轻量级，本地优先 | 开发测试 |
| **FAISS** | Facebook 开源，最快 | GPU 加速 |

## FAISS 实战

```python
import faiss
import numpy as np

# 创建索引
dimension = 768
index = faiss.IndexFlatL2(dimension)  # L2 距离

# 添加向量
vectors = np.random.rand(10000, dimension).astype('float32')
index.add(vectors)

# 搜索
query = np.random.rand(1, dimension).astype('float32')
k = 5  # 返回 top-5
distances, indices = index.search(query, k)

print(f"最近邻索引：{indices[0]}")
print(f"距离：{distances[0]}")
```

## 索引类型对比

### 精确搜索

```python
# IndexFlatL2 - 暴力搜索，最准确但慢
index = faiss.IndexFlatL2(dimension)
```

### 近似搜索（ANN）

```python
# IVF - 倒排文件索引
quantizer = faiss.IndexFlatL2(dimension)
index = faiss.IndexIVFFlat(quantizer, dimension, nlist=100)
index.train(vectors)
index.add(vectors)

# HNSW - 层次导航小世界图
index = faiss.IndexHNSWFlat(dimension, 32)
index.add(vectors)
```

## RAG 中的应用

```python
from langchain.vectorstores import Qdrant
from langchain.embeddings import OpenAIEmbeddings

# 创建向量存储
embeddings = OpenAIEmbeddings()
vectorstore = Qdrant.from_documents(
    documents=docs,
    embedding=embeddings,
    url="http://localhost:6333",
    collection_name="rag_docs"
)

# 语义检索
retriever = vectorstore.as_retriever(search_kwargs={"k": 3})
relevant_docs = retriever.get_relevant_documents("用户问题")

# 生成回答
context = "\n".join([doc.page_content for doc in relevant_docs])
answer = llm.generate(f"基于以下信息回答问题:\n{context}\n问题：{question}")
```

## 性能优化

### 量化压缩

```python
# 乘积量化（PQ）
index_pq = faiss.IndexPQ(dimension, m=8, nbits=8)
index_pq.train(vectors)
index_pq.add(vectors)
# 显存减少 8 倍，速度提升 4 倍
```

### GPU 加速

```python
# 移动到 GPU
res = faiss.StandardGpuResources()
gpu_index = faiss.index_cpu_to_gpu(res, 0, index)

# GPU 搜索速度提升 10-50 倍
```

## 学习资源

- [Qdrant 官方文档](https://qdrant.tech/documentation/)
- [FAISS GitHub](https://github.com/facebookresearch/faiss)
- [Milvus 教程](https://milvus.io/docs)

## 相关概念

- [[RAG]](/ai-learning/topics/rag) - 检索增强生成
- [[语义检索]](/ai-learning/topics/semantic-search) - 搜索技术
- [[Embedding]](/ai-learning/topics/embedding) - 向量表示

## 下一步学习

1. **[RAG 实战](/ai-learning/topics/rag)** - 完整流程
2. **[语义检索](/ai-learning/topics/semantic-search)** - 搜索算法
3. **[Embedding 模型](/ai-learning/resources/embedding-models)** - 向量生成

  </div>

  <div class="content-navigation">
    <div class="nav-card prev">
      <span class="nav-label">上一个</span>
      <a href="/ai-learning/topics/rag" class="nav-link">← RAG</a>
    </div>
    <div class="nav-card next">
      <span class="nav-label">下一个</span>
      <a href="/ai-learning/topics/semantic-search" class="nav-link">语义检索 →</a>
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
