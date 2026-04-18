---
layout: page
title: RAG - 检索增强生成
description: Retrieval-Augmented Generation，结合外部知识库提升大模型能力
sidebar: true
page: true
---

<div class="learning-content">
  <div class="content-header">
    <span class="category-badge">核心技术 · 2020s</span>
    <h1>🔍 RAG - 检索增强生成</h1>
    <p class="description">Retrieval-Augmented Generation，通过检索外部知识库来增强大语言模型的生成能力，解决知识时效性和幻觉问题</p>
  </div>

  <div class="content-body">

## 概述

**RAG**（Retrieval-Augmented Generation，检索增强生成）是一种将信息检索与文本生成相结合的技术架构。它通过在生成回答之前先从外部知识库中检索相关信息，让大语言模型能够访问最新、准确的知识，从而显著提升回答的质量和可靠性。

## 为什么需要 RAG？

### LLM 的固有局限

```
❌ 知识截止：训练数据有明确的时间截止点
❌ 无法更新：重新训练成本极高
❌ 领域知识缺乏：专业领域表现差
❌ 幻觉问题：可能编造虚假信息
❌ 上下文窗口有限：无法处理长文档
```

### RAG 的优势

```
✅ 实时性：可以访问最新信息
✅ 可更新：只需更新知识库，无需重新训练
✅ 专业性：可以注入领域专业知识
✅ 可追溯：答案有明确的来源依据
✅ 降低成本：减少模型训练需求
```

## 核心架构

### RAG 工作流程

```
用户提问
    ↓
┌─────────────────────────────┐
│  1. 理解问题                │
│     - 分析意图              │
│     - 提取关键词            │
└──────────────┬──────────────┘
               ↓
┌─────────────────────────────┐
│  2. 检索相关知识            │
│     - 向量搜索              │
│     - 关键词匹配            │
│     - 混合检索              │
└──────────────┬──────────────┘
               ↓
┌─────────────────────────────┐
│  3. 构建增强提示词          │
│     - 拼接检索结果          │
│     - 添加指令              │
│     - 格式化为 Prompt       │
└──────────────┬──────────────┘
               ↓
┌─────────────────────────────┐
│  4. LLM 生成回答            │
│     - 基于检索内容          │
│     - 结合内部知识          │
│     - 生成最终答案          │
└──────────────┬──────────────┘
               ↓
输出带引用的回答
```

### 技术组件详解

#### 1. 文档处理流水线

```python
from langchain.document_loaders import PyPDFLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain.embeddings import OpenAIEmbeddings
from langchain.vectorstores import Chroma

# 1. 加载文档
loader = PyPDFLoader("company_handbook.pdf")
documents = loader.load()

# 2. 文本分块
text_splitter = RecursiveCharacterTextSplitter(
    chunk_size=500,
    chunk_overlap=50,
    separators=["\n\n", "\n", "。", "！", "？", " ", ""]
)
docs = text_splitter.split_documents(documents)

# 3. 创建向量索引
embeddings = OpenAIEmbeddings()
vectorstore = Chroma.from_documents(
    documents=docs,
    embedding=embeddings,
    persist_directory="./chroma_db"
)
```

#### 2. 检索策略

**单一向量检索**：
```python
# 语义相似度搜索
results = vectorstore.similarity_search(
    query="公司年假政策是什么？",
    k=3  # 返回最相关的 3 个片段
)
```

**混合检索（Hybrid Search）**：
```python
# 结合向量检索 + 关键词检索
from langchain.retrievers import EnsembleRetriever

vector_retriever = vectorstore.as_retriever(
    search_type="similarity",
    search_kwargs={"k": 3}
)

keyword_retriever = BM25Retriever.from_documents(docs)
keyword_retriever.k = 3

# 集成两个检索器
ensemble_retriever = EnsembleRetriever(
    retrievers=[vector_retriever, keyword_retriever],
    weights=[0.7, 0.3]  # 向量检索权重更高
)
```

#### 3. Prompt 构建

```python
from langchain.prompts import ChatPromptTemplate

rag_prompt = ChatPromptTemplate.from_template("""
你是一个专业的问答助手。请根据以下参考信息回答问题。

参考信息：
{context}

问题：{question}

如果参考信息中没有答案，请诚实地说"我不知道"，不要编造信息。
请在回答末尾标注信息来源，例如：[来源：文档 1]

回答：""")

# 填充 prompt
prompt_value = rag_prompt.format(
    context="\n\n".join([doc.page_content for doc in results]),
    question=user_question
)
```

#### 4. 生成与引用

```python
from langchain.chat_models import ChatOpenAI
from langchain.chains import RetrievalQA

llm = ChatOpenAI(model="gpt-4", temperature=0.3)

qa_chain = RetrievalQA.from_chain_type(
    llm=llm,
    chain_type="stuff",  # 将所有文档拼接到一个 prompt
    retriever=vectorstore.as_retriever(),
    return_source_documents=True  # 返回来源文档
)

response = qa_chain({"query": "公司年假政策是什么？"})

print(f"答案：{response['result']}")
print(f"\n来源文档：")
for doc in response['source_documents']:
    print(f"- {doc.metadata['source']}, 页码：{doc.metadata.get('page', 'N/A')}")
```

## 高级技术

### 1. Query Rewriting（查询改写）

**问题**：用户提问可能不够清晰或不完整

**解决方案**：
```python
# 使用 LLM 改写查询
rewriter_prompt = """
请将以下问题改写为更适合检索的形式：
原始问题：{question}

改写要求：
- 提取关键实体
- 补充隐含信息
- 保持简洁明确

改写后的问题："""

rewritten_query = llm.invoke(
    rewriter_prompt.format(question=user_question)
)

# 使用改写后的查询进行检索
results = vectorstore.similarity_search(rewritten_query.content)
```

### 2. Multi-Hop Retrieval（多跳检索）

适用于需要多步推理的复杂问题：

```
问题："特斯拉 2023 年的 CEO 是谁？他的年薪是多少？"

第一跳：检索"特斯拉 2023 CEO" → 得到"Elon Musk"
第二跳：检索"Elon Musk 特斯拉 年薪" → 得到薪资信息
```

**实现**：
```python
from langchain.agents import initialize_agent, Tool

tools = [
    Tool(
        name="Knowledge Base Search",
        func=search_knowledge_base,
        description="在公司知识库中搜索信息"
    )
]

agent = initialize_agent(tools, llm, agent="zero-shot-react-description")
response = agent.run("特斯拉 2023 年的 CEO 是谁？他的年薪是多少？")
```

### 3. HyDE（Hypothetical Document Embeddings）

**思路**：先生成一个假设性答案，然后用它来检索

```python
# 步骤 1：生成假设性答案
hypothetical_prompt = f"""
请为以下问题写一个假设性的答案：
{user_question}

不需要准确，只需要覆盖可能的相关内容。
"""
hypothetical_answer = llm.invoke(hypothetical_prompt)

# 步骤 2：用假设答案进行检索
results = vectorstore.similarity_search(hypothetical_answer.content)

# 步骤 3：用检索到的真实信息生成最终答案
final_answer = generate_answer(user_question, results)
```

### 4. Parent Document Retriever

**问题**：小片段适合检索，但丢失上下文

**方案**：检索小片段，但返回大块上下文

```python
from langchain.retrievers import ParentDocumentRetriever

# 父文档（大块，包含完整上下文）
parent_splitter = RecursiveCharacterTextSplitter(chunk_size=2000)

# 子文档（小块，适合检索）
child_splitter = RecursiveCharacterTextSplitter(chunk_size=500)

# 向量存储
vectorstore = Chroma(embedding_function=embeddings)

# 父文档检索器
retriever = ParentDocumentRetriever(
    vectorstore=vectorstore,
    docstore=InMemoryDocstore(),
    child_splitter=child_splitter,
    parent_splitter=parent_splitter
)
```

## 评估指标

### 检索质量

- **Recall@K**：前 K 个结果中的相关文档比例
- **MRR**（Mean Reciprocal Rank）：第一个相关结果的排名倒数平均
- **NDCG**：归一化折损累积增益

### 生成质量

- **忠实度（Faithfulness）**：答案是否忠实于检索内容
- **相关性（Relevance）**：答案是否回答了问题
- **准确性（Accuracy）**：答案是否正确

### 端到端评估

```python
from ragas import evaluate
from ragas.metrics import faithfulness, answer_relevancy, context_precision

# 准备评估数据集
eval_dataset = [
    {
        "question": "公司年假政策？",
        "answer": response["result"],
        "contexts": [doc.page_content for doc in source_docs],
        "ground_truth": "员工每年享有 15 天带薪年假"
    }
]

# 评估
score = evaluate(
    eval_dataset,
    metrics=[faithfulness, answer_relevancy, context_precision]
)

print(f"忠实度：{score['faithfulness']:.2f}")
print(f"相关性：{score['answer_relevancy']:.2f}")
print(f"上下文精度：{score['context_precision']:.2f}")
```

## 实际应用场景

### 📚 企业知识库问答

**场景**：员工快速查找公司内部信息

**数据源**：
- 员工手册
- 规章制度
- 产品文档
- 会议纪要
- FAQ

**效果**：
- ⏱️ 节省 80% 的信息查找时间
- ✅ 准确率 > 90%
- 📈 员工满意度提升

### 🏥 医疗文献检索

**场景**：医生快速获取最新医学研究

**实现要点**：
- 连接 PubMed、医学期刊数据库
- 支持专业术语检索
- 提供证据等级标注
- 引用原文段落

### ⚖️ 法律咨询助手

**场景**：律师快速查找相关法条和案例

**特殊要求**：
- 高准确性（不能出错）
- 完整的引用来源
- 时效性（最新法律修订）
- 管辖区域区分

### 💻 代码文档问答

**场景**：开发者查询 API 用法

**数据源**：
- API 文档
- GitHub Issues
- Stack Overflow
- 内部代码库

## 最佳实践

### ✅ DO

1. **高质量的文档预处理**
   - 清晰的文档结构
   - 准确的元数据标注
   - 合理的分块策略

2. **混合检索策略**
   - 向量检索 + 关键词检索
   - 多路召回 + 重排序

3. **Prompt 工程**
   - 清晰的指令
   - 明确的格式要求
   - 防止幻觉的约束

4. **持续优化**
   - 收集用户反馈
   - 分析失败案例
   - 迭代改进检索策略

### ❌ DON'T

1. **不要盲目信任检索结果**
   - 始终验证信息来源
   - 注意文档的时效性

2. **不要过度依赖 RAG**
   - 简单问题直接用 LLM
   - 复杂任务考虑 Agent 架构

3. **不要忽视安全**
   - 控制访问权限
   - 过滤敏感信息
   - 审计查询日志

## 学习资源

### 📺 视频教程
- [RAG 入门教程 - YouTube](https://www.youtube.com/results?search_query=rag+tutorial)
- [LangChain RAG 实战 - B 站](https://search.bilibili.com/all?keyword=rag+langchain)
- [Building RAG Systems - DeepLearning.AI](https://www.deeplearning.ai/short-courses/building-generative-ai-applications-with-llama-index/)

### 📚 文档教程
- [LangChain RAG 官方文档](https://python.langchain.com/docs/use_cases/question_answering/)
- [LlamaIndex Documentation](https://docs.llamaindex.ai/)
- [Awesome RAG GitHub](https://github.com/BradyFU/Awesome-Multimodal-Large-Language-Models)

### 💻 实践平台
- [LangChain Playground](https://smith.langchain.com/playground)
- [LlamaIndex Colab Examples](https://colab.research.google.com/github/run-llama/llama_index/blob/main/docs/docs/examples/)
- [Haystack Tutorials](https://haystack.deepset.ai/tutorials)

## 相关概念

- [[Agent]](/ai-learning/topics/agent) - AI 智能体
- [[LLM]](/ai-learning/topics/llm) - 大语言模型
- [[LoRA]](/ai-learning/topics/lora) - 高效微调技术
- [[知识图谱]](/ai-learning/topics/knowledge-graph) - 结构化知识表示

## 下一步学习

完成这个概念后，建议继续学习：

1. **[LangChain 实战](/ai-learning/resources/langchain-tutorial)** - 动手构建 RAG 系统
2. **[Agent 开发](/ai-learning/topics/agent)** - 构建智能 Agent
3. **[LoRA 微调](/ai-learning/topics/lora)** - 定制专属模型

  </div>

  <div class="content-navigation">
    <div class="nav-card prev">
      <span class="nav-label">上一个</span>
      <a href="/ai-learning/topics/agent" class="nav-link">← AI Agent</a>
    </div>
    <div class="nav-card next">
      <span class="nav-label">下一个</span>
      <a href="/ai-learning/topics/lora" class="nav-link">LoRA →</a>
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
