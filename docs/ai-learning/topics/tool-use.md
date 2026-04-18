---
layout: page
title: 工具调用
description: AI Agent 使用外部工具扩展能力的技术
sidebar: true
page: true
---

<div class="learning-content">
  <div class="content-header">
    <span class="category-badge">核心技术 · AI Agent</span>
    <h1>🔧 工具调用 (Tool Use)</h1>
    <p class="description">AI 智能体通过调用外部 API、函数和服务来扩展自身能力，完成单靠语言模型无法实现的任务</p>
  </div>

  <div class="content-body">

## 概述

**工具调用**（Tool Use）使 LLM 能够突破纯文本限制，通过调用计算器、搜索引擎、数据库等外部工具来执行实际任务。

## 核心架构

### Function Calling

```python
from openai import OpenAI

client = OpenAI()

# 定义可用工具
tools = [
    {
        "type": "function",
        "function": {
            "name": "get_weather",
            "description": "获取指定城市的天气",
            "parameters": {
                "type": "object",
                "properties": {
                    "city": {"type": "string", "description": "城市名"}
                },
                "required": ["city"]
            }
        }
    }
]

# LLM 决定调用哪个工具
response = client.chat.completions.create(
    model="gpt-4",
    messages=[{"role": "user", "content": "北京天气怎么样？"}],
    tools=tools
)

# 解析工具调用
if response.choices[0].message.tool_calls:
    tool_call = response.choices[0].message.tool_calls[0]
    if tool_call.function.name == "get_weather":
        args = json.loads(tool_call.function.arguments)
        weather = get_weather(args["city"])
```

### LangChain Tools

```python
from langchain.agents import load_tools, initialize_agent
from langchain.llms import OpenAI

llm = OpenAI(temperature=0)
tools = load_tools(["serpapi", "llm-math", "wikipedia"], llm=llm)

agent = initialize_agent(tools, llm, agent="zero-shot-react-description")

response = agent.run("谁是美国现任总统？他的年龄乘以 2 是多少？")
# 自动调用：搜索 → 计算 → 返回结果
```

## 工具类型

### 1. 信息检索类

```python
# 搜索引擎
def search_web(query):
    results = serpapi.search(query)
    return results.organic_results[:5]

# 知识库查询
def query_knowledge_base(question):
    embeddings = OpenAIEmbeddings()
    vectorstore = FAISS.load_local("kb_index")
    docs = vectorstore.similarity_search(question)
    return docs
```

### 2. 计算类

```python
# 数学计算
def calculate(expression):
    return eval(expression, {"__builtins__": {}}, safe_math_context)

# 代码执行
def run_python(code):
    result = subprocess.run(
        ["python3", "-c", code],
        capture_output=True,
        text=True
    )
    return result.stdout
```

### 3. 操作类

```python
# 文件操作
def write_file(path, content):
    with open(path, 'w') as f:
        f.write(content)
    return f"已写入 {len(content)} 字节到 {path}"

# API 调用
def send_email(to, subject, body):
    response = requests.post(
        "https://api.sendgrid.com/v3/mail/send",
        json={"personalizations": [{"to": [{"email": to}]}], ...}
    )
    return response.status_code == 202
```

## 实现模式

### ReAct 模式

```python
react_prompt = """
你可以使用以下工具：
- search: 搜索互联网
- calculator: 计算数学表达式
- wikipedia: 查询维基百科

问题：埃隆·马斯克的年龄乘以 2 是多少？

Thought: 我需要先查找埃隆·马斯克的年龄
Action: search[埃隆·马斯克 年龄]
Observation: 52 岁
Thought: 现在需要计算 52 乘以 2
Action: calculator[52 * 2]
Observation: 104
Thought: 我有了答案
Final Answer: 104 岁
"""
```

### 自主工具选择

```python
class ToolUsingAgent:
    def __init__(self, tools):
        self.tools = {tool.name: tool for tool in tools}
    
    def run(self, task):
        # LLM 决定使用哪些工具
        plan = self.llm_generate(f"如何完成任务：{task}\n可用工具：{list(self.tools.keys())}")
        
        # 执行工具调用
        for step in parse_steps(plan):
            if step.tool_name in self.tools:
                result = self.tools[step.tool_name].run(step.args)
                self.memory.append(result)
        
        # 汇总结果
        return self.synthesize_answer(task, self.memory)
```

## 最佳实践

### 工具描述

```python
# ✅ 好的描述
tool_desc = {
    "name": "get_stock_price",
    "description": "获取指定股票的当前价格。适用于查询上市公司股价。",
    "parameters": {
        "symbol": "股票代码，如 AAPL、GOOGL"
    }
}

# ❌ 模糊的描述
tool_desc = {
    "name": "finance_tool",
    "description": "处理金融相关任务"  # 太模糊
}
```

### 错误处理

```python
def safe_tool_call(tool_name, args):
    try:
        result = tools[tool_name].run(**args)
        return {"success": True, "result": result}
    except Exception as e:
        return {
            "success": False, 
            "error": str(e),
            "suggestion": "尝试其他方法或检查输入参数"
        }
```

### 上下文管理

```python
class ToolContext:
    def __init__(self):
        self.history = []
        self.results = {}
    
    def add_call(self, tool_name, args, result):
        self.history.append({
            "tool": tool_name,
            "args": args,
            "result": result,
            "timestamp": datetime.now()
        })
    
    def get_summary(self):
        return "\n".join([
            f"调用了 {h['tool']}: {h['result']}"
            for h in self.history[-5:]  # 最近 5 次调用
        ])
```

## 应用场景

### 1. 研究助手

```
用户：分析 NVIDIA 的竞争优势

Agent:
1. search[NVIDIA 公司简介]
2. search[NVIDIA 主要竞争对手]
3. wikipedia[NVIDIA GPU 技术]
4. calculator[市场份额对比]
5. 综合以上信息生成报告
```

### 2. 数据分析师

```
用户：分析销售数据并找出增长机会

Agent:
1. read_csv[sales_data.csv]
2. python[计算月度增长率]
3. python[识别 Top 产品]
4. visualize[绘制趋势图]
5. 生成分析报告
```

### 3. 自动化工作流

```
用户：每周一早上 9 点发送团队周报

Agent:
1. schedule[每周一 9:00]
2. gather_data[Jira, GitHub, Slack]
3. summarize[本周进展]
4. send_email[团队成员]
```

## 前沿发展

### 1. 工具学习

- 从演示中学习新工具
- 自动发现工具组合
- 工具使用策略优化

### 2. 多工具协作

```python
# 工具链式调用
workflow = SearchTool() >> ExtractTool() >> SummarizeTool()
result = workflow.run("查找最新的 AI 论文并总结")
```

### 3. 自主工具创建

```python
# Agent 根据需求创建临时工具
def create_adhoc_tool(requirement):
    code = llm_generate(f"编写 Python 函数实现：{requirement}")
    return DynamicTool(code)
```

## 学习资源

- [OpenAI Function Calling](https://platform.openai.com/docs/guides/function-calling)
- [LangChain Tools](https://python.langchain.com/docs/modules/agents/tools/)
- [ReAct 论文](https://arxiv.org/abs/2210.03629)

## 相关概念

- [[任务分解]](/ai-learning/topics/task-decomposition) - 规划能力
- [[多 Agent 协作]](/ai-learning/topics/multi-agent-collaboration) - 分布式执行
- [[Agent]](/ai-learning/topics/agent) - 智能体基础

## 下一步学习

1. **[多 Agent 协作](/ai-learning/topics/multi-agent-collaboration)** - 协同工作
2. **[任务分解](/ai-learning/topics/task-decomposition)** - 规划优化
3. **[LangChain 实战](/ai-learning/resources/langchain-guide)** - 工具框架

  </div>

  <div class="content-navigation">
    <div class="nav-card prev">
      <span class="nav-label">上一个</span>
      <a href="/ai-learning/topics/task-decomposition" class="nav-link">← 任务分解</a>
    </div>
    <div class="nav-card next">
      <span class="nav-label">下一个</span>
      <a href="/ai-learning/topics/multi-agent-collaboration" class="nav-link">多 Agent 协作 →</a>
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
