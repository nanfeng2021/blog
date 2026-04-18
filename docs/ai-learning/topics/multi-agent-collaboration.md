---
layout: page
title: 多 Agent 协作
description: 多个 AI 智能体协同完成复杂任务的架构与模式
sidebar: true
page: true
---

<div class="learning-content">
  <div class="content-header">
    <span class="category-badge">核心技术 · AI Agent</span>
    <h1>👥 多 Agent 协作 (Multi-Agent Collaboration)</h1>
    <p class="description">多个 AI 智能体通过分工、通信、协调来共同完成单个 Agent 无法处理的复杂任务</p>
  </div>

  <div class="content-body">

## 概述

**多 Agent 协作**（Multi-Agent Collaboration）通过多个 specialized agent 的分工合作，实现比单一 Agent 更强的问题解决能力。

## 协作模式

### 1. 主从模式（Manager-Worker）

```python
from autogen import GroupChat, GroupChatManager

# 定义角色
coder = AssistantAgent(name="Coder", system_message="负责编写代码")
reviewer = AssistantAgent(name="Reviewer", system_message="负责代码审查")
tester = AssistantAgent(name="Tester", system_message="负责测试")

# 群聊配置
groupchat = GroupChat(
    agents=[coder, reviewer, tester],
    messages=[],
    max_round=10
)

manager = GroupChatManager(groupchat=groupchat)

# 执行任务
user_proxy.initiate_chat(
    manager,
    message="开发一个待办事项应用"
)
```

### 2. 平等协作（Peer-to-Peer）

```python
# Agent 之间直接通信
class CollaborativeAgents:
    def __init__(self):
        self.agent_a = Agent("分析师")
        self.agent_b = Agent("作家")
    
    def collaborate(self, task):
        # 轮流发言
        for round in range(max_rounds):
            analysis = self.agent_a.think(task)
            draft = self.agent_b.write(analysis)
            feedback = self.agent_a.review(draft)
            
            if "approved" in feedback:
                return draft
```

### 3. 竞争模式（Competition）

```python
# 多个 Agent 独立解决，投票选择最佳
def competitive_solving(task, n_agents=5):
    solutions = []
    
    for i in range(n_agents):
        agent = Agent(seed=i)
        solution = agent.solve(task)
        solutions.append(solution)
    
    # 投票或 LLM 评判
    best = llm_judge(solutions)
    return best
```

## AutoGen 实战

```python
from autogen import ConversableAgent, UserProxyAgent

# 规划者 Agent
planner = ConversableAgent(
    name="Planner",
    system_message="你负责制定计划。将大任务分解为小步骤。",
    llm_config={"config_list": [{"model": "gpt-4"}]}
)

# 执行者 Agent
executor = ConversableAgent(
    name="Executor",
    system_message="你负责执行具体任务。使用工具完成分配的工作。",
    llm_config={"config_list": [{"model": "gpt-4"}]}
)

# 评审者 Agent
critic = ConversableAgent(
    name="Critic",
    system_message="你负责质量把控。检查输出是否正确、完整。",
    llm_config={"config_list": [{"model": "gpt-4"}]}
)

# 用户代理
user_proxy = UserProxyAgent(
    name="User",
    human_input_mode="ALWAYS"
)

# 注册对话关系
planner.register_reply([ConversableAgent], generate_plan_reply)
executor.register_reply([ConversableAgent], execute_task_reply)
critic.register_reply([ConversableAgent], review_reply)

# 启动协作
user_proxy.initiate_chat(
    planner,
    message="分析特斯拉 2024 年 Q1 财报"
)
```

## 通信机制

### 消息传递

```python
class Message:
    def __init__(self, sender, receiver, content, msg_type="info"):
        self.sender = sender
        self.receiver = receiver
        self.content = content
        self.type = msg_type  # info, request, response
        self.timestamp = datetime.now()

class CommunicationHub:
    def __init__(self):
        self.message_queue = []
        self.subscribers = {}
    
    def send(self, message):
        self.message_queue.append(message)
        # 通知接收者
        if message.receiver in self.subscribers:
            self.subscribers[message.receiver].on_message(message)
    
    def broadcast(self, sender, content):
        for agent in self.subscribers.keys():
            if agent != sender:
                self.send(Message(sender, agent, content))
```

### 共享内存

```python
class SharedBlackboard:
    def __init__(self):
        self.data = {}
        self.lock = threading.Lock()
    
    def write(self, key, value, agent_id):
        with self.lock:
            self.data[key] = {
                "value": value,
                "author": agent_id,
                "timestamp": datetime.now()
            }
    
    def read(self, key):
        return self.data.get(key)
    
    def get_all(self):
        return dict(self.data)
```

## 应用场景

### 1. 软件开发团队

```
产品经理 Agent → 需求分析
架构师 Agent → 系统设计  
程序员 Agent → 代码实现
测试员 Agent → 质量保证
部署工程师 Agent → 上线发布
```

### 2. 研究团队

```
文献检索 Agent → 收集论文
数据分析 Agent → 处理数据
写作 Agent → 撰写报告
审稿 Agent → 质量把关
```

### 3. 客服系统

```
接待 Agent → 初步分流
技术 Agent → 解答技术问题
账单 Agent → 处理支付问题
升级 Agent → 复杂情况人工介入
```

## 挑战与解决方案

### ⚠️ 目标不一致

**问题**: Agent 追求局部最优而非全局最优  
**解决**: 共享奖励函数，全局优化目标

### ⚠️ 通信开销

**问题**: 过多消息导致效率低下  
**解决**: 消息压缩，异步通信

### ⚠️ 责任分散

**问题**: 错误发生时互相推诿  
**解决**: 明确角色职责，追踪贡献度

## 前沿框架

### CrewAI

```python
from crewai import Agent, Task, Crew

researcher = Agent(
    role='高级研究员',
    goal='深入调研主题',
    backstory='你是经验丰富的研究专家',
    verbose=True
)

writer = Agent(
    role='内容作家',
    goal='撰写高质量文章',
    backstory='你是专业的科技作家',
    verbose=True
)

task = Task(
    description='调研 GPT-5 的最新进展并撰写报告',
    agent=researcher,
    expected_output='一篇 3000 字的深度分析报告'
)

crew = Crew(
    agents=[researcher, writer],
    tasks=[task],
    verbose=2
)

result = crew.kickoff()
```

### LangGraph

```python
from langgraph.graph import StateGraph, END

workflow = StateGraph(AgentState)

# 添加节点
workflow.add_node("planner", plan_node)
workflow.add_node("executor", execute_node)
workflow.add_node("reviewer", review_node)

# 定义边
workflow.set_entry_point("planner")
workflow.add_edge("planner", "executor")
workflow.add_edge("executor", "reviewer")
workflow.add_conditional_edges(
    "reviewer",
    lambda x: "executor" if x.needs_revision else END
)

app = workflow.compile()
result = app.invoke({"task": user_task})
```

## 学习资源

- [AutoGen 官方文档](https://microsoft.github.io/autogen/)
- [CrewAI](https://www.crewai.com/)
- [LangGraph](https://langchain-ai.github.io/langgraph/)

## 相关概念

- [[任务分解]](/ai-learning/topics/task-decomposition) - 规划基础
- [[工具调用]](/ai-learning/topics/tool-use) - 执行能力
- [[Agent]](/ai-learning/topics/agent) - 单智能体

## 下一步学习

1. **[CrewAI 实战](/ai-learning/resources/crewai-guide)** - 框架使用
2. **[AutoGen 进阶](/ai-learning/resources/autogen-advanced)** - 高级特性
3. **[分布式 Agent](/ai-learning/topics/distributed-agents)** - 大规模协作

  </div>

  <div class="content-navigation">
    <div class="nav-card prev">
      <span class="nav-label">上一个</span>
      <a href="/ai-learning/topics/tool-use" class="nav-link">← 工具调用</a>
    </div>
    <div class="nav-card next">
      <span class="nav-label">下一个</span>
      <a href="/ai-learning/topics/agent" class="nav-link">返回 Agent →</a>
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
