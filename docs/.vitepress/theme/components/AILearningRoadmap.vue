<template>
  <div class="roadmap-container">
    <div class="roadmap-header">
      <h1>🎯 AI 学习计划路线图</h1>
      <p class="roadmap-description">从人工智能发展历史到前沿技术的完整学习路径</p>
    </div>

    <div class="timeline-section">
      <h2>📜 AI 发展历程</h2>
      
      <div class="timeline">
        <div class="timeline-item" v-for="(era, index) in timelineData" :key="index" :class="{ highlight: era.highlight }">
          <div class="timeline-year">{{ era.year }}</div>
          <div class="timeline-content">
            <h3>{{ era.title }}</h3>
            <ul>
              <li v-for="(item, i) in era.items" :key="i" v-html="item"></li>
            </ul>
            <div class="key-concepts">
              <span class="concept-tag" v-for="(tag, t) in era.tags" :key="t" @click="navigateToTag(tag, 'history')" style="cursor: pointer;">{{ tag }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="learning-path-section">
      <h2>📚 分阶段学习路线</h2>
      
      <div class="learning-stages">
        <div class="stage-card" v-for="(stage, index) in stages" :key="index" :class="'stage-' + (index + 1)">
          <div class="stage-header">
            <span class="stage-number">阶段 {{ index + 1 }}</span>
            <h3>{{ stage.icon }} {{ stage.title }}</h3>
          </div>
          <div class="stage-content">
            <div v-for="(section, sIndex) in stage.sections" :key="sIndex">
              <h4>{{ section.title }}</h4>
              <ul>
                <li v-for="(item, i) in section.items" :key="i">{{ item }}</li>
              </ul>
            </div>
            <div class="stage-resources">
              <strong>推荐资源：</strong>
              <span class="resource-tag" v-for="(tag, t) in stage.resources" :key="t" @click="navigateToResource(tag)" style="cursor: pointer;">{{ tag }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="hot-topics-section">
      <h2>🔥 当前热门 AI 技术方向</h2>
      
      <div class="topics-grid">
        <div class="topic-card" v-for="(topic, index) in topics" :key="index">
          <div class="topic-icon">{{ topic.icon }}</div>
          <h3>{{ topic.title }}</h3>
          <p>{{ topic.description }}</p>
          <div class="topic-tags">
            <span v-for="(tag, t) in topic.tags" :key="t" @click="navigateToTopic(topic.title + ' - ' + tag)" style="cursor: pointer;">{{ tag }}</span>
          </div>
        </div>
      </div>
    </div>

    <div class="tasks-datasets-section">
      <h2>📋 核心学习任务与数据集</h2>
      
      <div class="tasks-grid">
        <div class="task-category" v-for="(category, index) in categories" :key="index">
          <h3>{{ category.icon }} {{ category.title }}</h3>
          <div class="task-list">
            <div class="task-item" v-for="(task, t) in category.tasks" :key="t">
              <strong>{{ task.name }}:</strong> {{ task.datasets }}
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="tips-section">
      <h2>💡 学习建议与资源</h2>
      
      <div class="tips-grid">
        <div class="tip-card" v-for="(tip, index) in tips" :key="index">
          <h3>{{ tip.icon }} {{ tip.title }}</h3>
          <ul>
            <li v-for="(item, i) in tip.items" :key="i" v-html="item"></li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vitepress'

const router = useRouter()

// 标签到 URL 的映射表
const tagUrlMap = {
  // AI 历史
  '符号主义': '/ai-learning/history/symbolism',
  '连接主义': '/ai-learning/history/connectionism',
  '图灵测试': '/ai-learning/history/turing-test',
  '达特茅斯会议': '/ai-learning/history/dartmouth-conference',
  '感知机': '/ai-learning/history/perceptron',
  '反向传播算法': '/ai-learning/history/backpropagation',
  '专家系统': '/ai-learning/history/expert-systems',
  '深度学习': '/ai-learning/topics/deep-learning',
  '早期神经网络': '/ai-learning/history/early-neural-networks',
  '连接主义复兴': '/ai-learning/history/connectionism-revival',
  
  // 核心技术
  'Transformer': '/ai-learning/topics/transformer',
  'BERT': '/ai-learning/topics/bert',
  'GPT': '/ai-learning/topics/gpt',
  'CNN': '/ai-learning/topics/cnn',
  'RNN/LSTM': '/ai-learning/topics/rnn-lstm',
  '注意力机制': '/ai-learning/topics/attention-mechanism',
  '逻辑推理': '/ai-learning/topics/logic-reasoning',
  '强化学习': '/ai-learning/topics/reinforcement-learning',
  '知识表示': '/ai-learning/topics/knowledge-representation',
  '统计学习': '/ai-learning/topics/statistical-learning',
  '核方法': '/ai-learning/topics/kernel-methods',
  '多层神经网络': '/ai-learning/topics/multi-layer-neural-networks',
  '知识工程': '/ai-learning/topics/knowledge-engineering',
  '归结原理': '/ai-learning/topics/resolution-principle',
  
  // 热门技术
  'LLM': '/ai-learning/topics/llm',
  'AIGC': '/ai-learning/topics/aigc',
  '多模态': '/ai-learning/topics/multimodal',
  'Agent': '/ai-learning/topics/agent',
  'RAG': '/ai-learning/topics/rag',
  'LoRA': '/ai-learning/topics/lora',
  
  // 资源映射（示例）
  '吴恩达 ML 课程': '/ai-learning/resources/andrew-ng-ml',
  'CS231n': '/ai-learning/resources/cs231n',
  'CS224n': '/ai-learning/resources/cs224n',
  'Hugging Face 课程': '/ai-learning/resources/huggingface-course',
  '《统计学习方法》': '/ai-learning/resources/statistical-learning-methods',
  'scikit-learn 实战': '/ai-learning/resources/scikit-learn-tutorial',
  'PyTorch/TensorFlow': '/ai-learning/resources/pytorch-tensorflow',
  '"Attention is All You Need"': '/ai-learning/resources/attention-is-all-you-need',
  'LLM 实战项目': '/ai-learning/resources/llm-projects',
  'LangChain': '/ai-learning/resources/langchain',
  'AutoGen': '/ai-learning/resources/autogen',
  '最新论文追踪': '/ai-learning/resources/latest-papers',
  
  // 细分技术标签映射 - 指向相关主题页面
  '预训练': '/ai-learning/topics/pretraining',
  '微调': '/ai-learning/topics/fine-tuning',
  '推理优化': '/ai-learning/topics/inference-optimization',
  'Stable Diffusion': '/ai-learning/topics/stable-diffusion',
  'Sora': '/ai-learning/topics/sora',
  '多模态融合': '/ai-learning/topics/multimodal-fusion',
  '向量数据库': '/ai-learning/topics/vector-database',
  '语义检索': '/ai-learning/topics/semantic-search',
  '知识图谱': '/ai-learning/topics/knowledge-graph',
  '任务分解': '/ai-learning/topics/task-decomposition',
  '工具调用': '/ai-learning/topics/tool-use',
  '多 Agent 协作': '/ai-learning/topics/multi-agent-collaboration',
  'PEFT': '/ai-learning/topics/peft',
  '量化': '/ai-learning/topics/quantization',
  '蒸馏': '/ai-learning/topics/distillation',
  '奖励建模': '/ai-learning/topics/reward-modeling',
  'PPO': '/ai-learning/topics/ppo',
  '价值对齐': '/ai-learning/topics/value-alignment',
  '机器人学习': '/ai-learning/topics/embodied-ai',
  '仿真环境': '/ai-learning/topics/embodied-ai',
  '端到端控制': '/ai-learning/topics/embodied-ai',
  '对抗攻击': '/ai-learning/topics/adversarial-attacks',
  '可解释 AI': '/ai-learning/topics/explainable-ai',
  'AI 治理': '/ai-learning/topics/ai-governance'
}

const navigateToTag = (tag, category) => {
  const url = tagUrlMap[tag];
  if (url) {
    // 使用 window.location 直接跳转
    window.location.href = url + '.html';
  } else {
    console.warn('No URL mapping for tag:', tag);
  }
}

const navigateToStage = (stageIndex, sectionIndex) => {
  router.go(`/ai-learning/stage-${stageIndex + 1}/section-${sectionIndex + 1}`)
}

const navigateToTopic = (fullTitle) => {
  // fullTitle 格式："大语言模型 (LLM) - 预训练"
  console.log('navigateToTopic called with:', fullTitle);
  
  // 提取标签名（破折号后面的部分）
  const parts = fullTitle.split(' - ');
  const tagName = parts.length > 1 ? parts[1].trim() : parts[0].trim();
  
  console.log('Extracted tagName:', tagName);
  
  // 尝试从映射表查找
  const url = tagUrlMap[tagName];
  console.log('Found URL:', url);
  
  if (url) {
    // 使用 window.location 直接跳转
    window.location.href = url + '.html';
  } else {
    console.warn('No URL mapping for topic:', tagName);
  }
}

const navigateToResource = (resource) => {
  const url = tagUrlMap[resource]
  if (url) {
    router.go(url)
  } else {
    // 默认跳转到资源列表页
    router.go('/ai-learning/resources')
  }
}

const timelineData = [
  {
    year: '1950s',
    title: '🌱 起源与萌芽',
    items: [
      '<strong>图灵测试 (1950)</strong> - 艾伦·图灵提出机器智能的判定标准',
      '<strong>达特茅斯会议 (1956)</strong> - "人工智能"概念正式诞生',
      '<strong>感知机 (1957)</strong> - Frank Rosenblatt 发明第一个神经网络模型'
    ],
    tags: ['符号主义', '逻辑推理', '早期神经网络']
  },
  {
    year: '1960s-70s',
    title: '📉 第一次 AI 寒冬',
    items: [
      '<strong>Lighthill 报告 (1973)</strong> - 对 AI 研究的严厉批评',
      '<strong>感知机的局限</strong> - Minsky 证明单层神经网络无法解决 XOR 问题',
      '<strong>专家系统兴起</strong> - 基于规则的知识表示成为主流'
    ],
    tags: ['专家系统', '知识工程', '归结原理']
  },
  {
    year: '1980s',
    title: '🔥 专家系统的黄金时代',
    items: [
      '<strong>反向传播算法 (1986)</strong> - Rumelhart 重新发现 BP 算法',
      '<strong>XCON 系统</strong> - DEC 公司的成功商业应用',
      '<strong>日本第五代计算机计划</strong> - 推动 AI 研究国际化'
    ],
    tags: ['连接主义复兴', '多层神经网络', '知识表示']
  },
  {
    year: '1990s-2000s',
    title: '📈 统计学习时代',
    items: [
      '<strong>支持向量机 (1995)</strong> - Vapnik 提出 SVM',
      '<strong>深度学习突破 (2006)</strong> - Hinton 提出深度信念网络',
      '<strong>ImageNet (2009)</strong> - 大规模视觉识别挑战赛启动'
    ],
    tags: ['统计学习', '核方法', '深度学习']
  },
  {
    year: '2010s',
    title: '🚀 深度学习革命',
    items: [
      '<strong>AlexNet (2012)</strong> - CNN 在 ImageNet 竞赛中一鸣惊人',
      '<strong>AlphaGo (2016)</strong> - 击败人类围棋冠军',
      '<strong>Transformer (2017)</strong> - "Attention is All You Need"',
      '<strong>BERT (2018)</strong> - NLP 领域的里程碑'
    ],
    tags: ['CNN', 'RNN/LSTM', 'Transformer', '强化学习']
  },
  {
    year: '2020s',
    title: '🤖 大模型与通用 AI',
    highlight: true,
    items: [
      '<strong>GPT-3 (2020)</strong> - 1750 亿参数的语言模型',
      '<strong>多模态模型 (2021-2022)</strong> - CLIP、DALL-E、Stable Diffusion',
      '<strong>ChatGPT (2022)</strong> - 引爆生成式 AI 热潮',
      '<strong>GPT-4/Claude/Gemini (2023-2024)</strong> - 多模态大模型竞争'
    ],
    tags: ['LLM', 'AIGC', '多模态', 'Agent']
  }
]

const stages = [
  {
    icon: '🔰',
    title: '基础入门',
    sections: [
      {
        title: '数学基础',
        items: ['线性代数（矩阵运算、特征值）', '微积分（导数、梯度、优化）', '概率论与数理统计']
      },
      {
        title: '编程基础',
        items: ['Python 编程', 'NumPy、Pandas、Matplotlib']
      },
      {
        title: '机器学习基础',
        items: ['监督学习（回归、分类）', '无监督学习（聚类、降维）', '经典算法（LR、SVM、决策树）']
      }
    ],
    resources: ['吴恩达 ML 课程', '《统计学习方法》', 'scikit-learn 实战']
  },
  {
    icon: '🧠',
    title: '深度学习核心',
    sections: [
      {
        title: '神经网络基础',
        items: ['感知机与多层感知机', '反向传播算法', '激活函数、损失函数、优化器']
      },
      {
        title: '卷积神经网络 (CNN)',
        items: ['LeNet、AlexNet、VGG', 'ResNet、Inception', '图像分类、目标检测']
      },
      {
        title: '序列模型',
        items: ['RNN、LSTM、GRU', 'Seq2Seq、Attention 机制']
      }
    ],
    resources: ['CS231n', 'CS224n', 'PyTorch/TensorFlow']
  },
  {
    icon: '⚡',
    title: 'Transformer 与大模型',
    sections: [
      {
        title: 'Transformer 架构',
        items: ['Self-Attention 机制', 'Positional Encoding', 'Encoder-Decoder 结构']
      },
      {
        title: '预训练语言模型',
        items: ['BERT、RoBERTa', 'GPT 系列', 'T5、BART']
      },
      {
        title: '大模型技术',
        items: ['Prompt Engineering', 'Fine-tuning (LoRA、QLoRA)', 'RAG 检索增强生成']
      }
    ],
    resources: ['"Attention is All You Need"', 'Hugging Face 课程', 'LLM 实战项目']
  },
  {
    icon: '🚀',
    title: '前沿技术方向',
    sections: [
      {
        title: '多模态 AI',
        items: ['CLIP、ALIGN', '文生图（DALL-E、Midjourney）', '视频理解与生成']
      },
      {
        title: 'AI Agent',
        items: ['ReAct、Plan-and-Solve', '工具使用与 API 调用', '多 Agent 协作']
      },
      {
        title: '强化学习与对齐',
        items: ['RLHF（人类反馈强化学习）', 'DPO、PPO 算法', '价值对齐与安全']
      }
    ],
    resources: ['LangChain', 'AutoGen', '最新论文追踪']
  }
]

const topics = [
  { icon: '🤖', title: '大语言模型 (LLM)', description: 'GPT、Claude、Gemini、Llama 等模型的训练、优化与应用', tags: ['预训练', '微调', '推理优化'] },
  { icon: '🎨', title: 'AIGC 与多模态', description: '文本、图像、音频、视频的生成与理解', tags: ['Stable Diffusion', 'Sora', '多模态融合'] },
  { icon: '🔍', title: 'RAG 与知识库', description: '检索增强生成，结合外部知识提升模型能力', tags: ['向量数据库', '语义检索', '知识图谱'] },
  { icon: '🤖', title: 'AI Agent', description: '自主智能体，规划、记忆、工具使用', tags: ['任务分解', '工具调用', '多 Agent 协作'] },
  { icon: '⚡', title: '高效微调', description: 'LoRA、QLoRA 等参数高效微调技术', tags: ['PEFT', '量化', '蒸馏'] },
  { icon: '🎯', title: '强化学习与对齐', description: 'RLHF、DPO 等人類偏好对齐技术', tags: ['奖励建模', 'PPO', '价值对齐'] },
  { icon: '📊', title: '具身智能', description: '机器人与物理世界的交互学习', tags: ['机器人学习', '仿真环境', '端到端控制'] },
  { icon: '🔒', title: 'AI 安全与治理', description: '模型安全性、可解释性、伦理规范', tags: ['对抗攻击', '可解释 AI', 'AI 治理'] }
]

const categories = [
  {
    icon: '👁️',
    title: '计算机视觉',
    tasks: [
      { name: '图像分类', datasets: 'ImageNet, CIFAR-10/100' },
      { name: '目标检测', datasets: 'COCO, Pascal VOC, YOLO 系列' },
      { name: '图像分割', datasets: 'Cityscapes, ADE20K' },
      { name: '图像生成', datasets: 'LAION, Stable Diffusion 数据集' }
    ]
  },
  {
    icon: '📝',
    title: '自然语言处理',
    tasks: [
      { name: '文本分类', datasets: 'AG News, IMDB' },
      { name: '机器翻译', datasets: 'WMT, IWSLT' },
      { name: '问答系统', datasets: 'SQuAD, Natural Questions' },
      { name: '文本生成', datasets: 'OpenWebText, Common Crawl' }
    ]
  },
  {
    icon: '🎙️',
    title: '语音与音频',
    tasks: [
      { name: '语音识别', datasets: 'LibriSpeech, Common Voice' },
      { name: '语音合成', datasets: 'VCTK, LJSpeech' },
      { name: '音频分类', datasets: 'AudioSet, ESC-50' }
    ]
  },
  {
    icon: '🎮',
    title: '强化学习',
    tasks: [
      { name: '游戏 AI', datasets: 'Atari, MuJoCo' },
      { name: '机器人控制', datasets: 'DM Control, Robosuite' },
      { name: '策略优化', datasets: 'AlphaGo Zero, OpenAI Five' }
    ]
  }
]

const tips = [
  {
    icon: '🎓',
    title: '理论学习',
    items: ['先看视频课程建立直观理解', '配合教材深入理解数学原理', '阅读经典论文掌握前沿进展', '做笔记、画思维导图加深记忆']
  },
  {
    icon: '💻',
    title: '实践项目',
    items: ['从 Kaggle 入门比赛开始', '复现经典论文的代码实现', '参与开源项目积累经验', '构建个人作品集展示能力']
  },
  {
    icon: '📚',
    title: '优质资源',
    items: [
      '<strong>课程:</strong> 吴恩达系列、李飞飞 CS231n',
      '<strong>平台:</strong> Coursera、edX、Hugging Face',
      '<strong>社区:</strong> Reddit r/MachineLearning、知乎',
      '<strong>论文:</strong> arXiv、Papers With Code'
    ]
  },
  {
    icon: '🚀',
    title: '持续成长',
    items: ['关注顶级会议（NeurIPS、ICML、CVPR）', '订阅 AI 领域 Newsletter', '参加技术沙龙和 Meetup', '保持好奇心，持续学习新技术']
  }
]
</script>

<style scoped>
.roadmap-container {
  max-width: 1400px;
  margin: 0 auto;
  padding: 2rem;
}

.roadmap-header {
  text-align: center;
  margin-bottom: 3rem;
}

.roadmap-header h1 {
  font-size: 2.5rem;
  margin-bottom: 1rem;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.roadmap-description {
  font-size: 1.2rem;
  color: #666;
}

.timeline-section {
  margin-bottom: 4rem;
}

.timeline-section h2,
.learning-path-section h2,
.hot-topics-section h2,
.tasks-datasets-section h2,
.tips-section h2 {
  font-size: 2rem;
  margin-bottom: 2rem;
  text-align: center;
}

.timeline {
  position: relative;
  max-width: 1200px;
  margin: 0 auto;
}

.timeline:before {
  content: '';
  position: absolute;
  left: 50%;
  transform: translateX(-50%);
  width: 4px;
  height: 100%;
  background: linear-gradient(to bottom, #667eea, #764ba2);
  border-radius: 2px;
}

.timeline-item {
  display: flex;
  margin-bottom: 2rem;
  position: relative;
}

.timeline-item:nth-child(odd) {
  flex-direction: row-reverse;
}

.timeline-year {
  flex: 0 0 150px;
  text-align: center;
  font-weight: bold;
  font-size: 1.2rem;
  color: #667eea;
  padding: 1rem;
}

.timeline-content {
  flex: 1;
  background: white;
  border-radius: 12px;
  padding: 1.5rem;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  margin: 0 2rem;
  position: relative;
  transition: transform 0.3s ease;
}

.timeline-content:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.15);
}

.timeline-item.highlight .timeline-content {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}

.timeline-item.highlight h3,
.timeline-item.highlight li {
  color: white;
}

.timeline-content h3 {
  margin-bottom: 1rem;
  color: #667eea;
}

.timeline-item.highlight .timeline-content h3 {
  color: white;
}

.timeline-content ul {
  list-style: none;
  padding: 0;
}

.timeline-content li {
  margin-bottom: 0.5rem;
  padding-left: 1.5rem;
  position: relative;
  color: #555;
}

.timeline-content li:before {
  content: '▸';
  position: absolute;
  left: 0;
  color: #667eea;
}

.timeline-item.highlight .timeline-content li:before {
  color: white;
}

.key-concepts {
  margin-top: 1rem;
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.concept-tag {
  background: #f0f0f0;
  padding: 0.25rem 0.75rem;
  border-radius: 20px;
  font-size: 0.85rem;
  color: #666;
  transition: all 0.2s ease;
}

.concept-tag:hover {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(102, 126, 234, 0.3);
}

.timeline-item.highlight .concept-tag {
  background: rgba(255, 255, 255, 0.2);
  color: white;
}

.timeline-item.highlight .concept-tag:hover {
  background: rgba(255, 255, 255, 0.9);
  color: #667eea;
}

.learning-stages {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 2rem;
}

.stage-card {
  background: white;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s ease;
}

.stage-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 12px 40px rgba(0, 0, 0, 0.15);
}

.stage-header {
  padding: 1.5rem;
  text-align: center;
  color: white;
}

.stage-1 .stage-header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.stage-2 .stage-header {
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
}

.stage-3 .stage-header {
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
}

.stage-4 .stage-header {
  background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
}

.stage-number {
  display: inline-block;
  background: rgba(255, 255, 255, 0.3);
  padding: 0.25rem 1rem;
  border-radius: 20px;
  font-size: 0.9rem;
  margin-bottom: 0.5rem;
}

.stage-header h3 {
  margin: 0;
  font-size: 1.5rem;
}

.stage-content {
  padding: 1.5rem;
}

.stage-content h4 {
  color: #667eea;
  margin: 1.5rem 0 0.75rem 0;
  font-size: 1.1rem;
}

.stage-content h4:first-child {
  margin-top: 0;
}

.stage-content > div > ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

.stage-content > div > ul > li {
  padding: 0.5rem 0;
  padding-left: 1.5rem;
  position: relative;
  color: #555;
  border-bottom: 1px solid #f0f0f0;
}

.stage-content > div > ul > li:last-child {
  border-bottom: none;
}

.stage-content > div > ul > li:before {
  content: '✓';
  position: absolute;
  left: 0;
  color: #43e97b;
  font-weight: bold;
}

.stage-resources {
  margin-top: 1.5rem;
  padding: 1rem;
  background: #f9fafb;
  border-radius: 8px;
}

.resource-tag {
  display: inline-block;
  background: #667eea;
  color: white;
  padding: 0.25rem 0.75rem;
  border-radius: 15px;
  font-size: 0.85rem;
  margin: 0.25rem 0.5rem 0.25rem 0;
  transition: all 0.2s ease;
  cursor: pointer;
}

.resource-tag:hover {
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(240, 147, 251, 0.3);
}

.topics-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 1.5rem;
}

.topic-card {
  background: white;
  border-radius: 12px;
  padding: 1.5rem;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
  border: 2px solid transparent;
}

.topic-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.15);
  border-color: #667eea;
}

.topic-icon {
  font-size: 3rem;
  margin-bottom: 1rem;
}

.topic-card h3 {
  color: #667eea;
  margin-bottom: 0.75rem;
}

.topic-card p {
  color: #666;
  line-height: 1.6;
  margin-bottom: 1rem;
}

.topic-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.topic-tags span {
  background: #f0f0f0;
  padding: 0.25rem 0.75rem;
  border-radius: 15px;
  font-size: 0.8rem;
  color: #666;
  transition: all 0.2s ease;
  cursor: pointer;
}

.topic-tags span:hover {
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
  color: white;
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(79, 172, 254, 0.3);
}

.tasks-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 1.5rem;
}

.task-category {
  background: white;
  border-radius: 12px;
  padding: 1.5rem;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}

.task-category h3 {
  color: #667eea;
  margin-bottom: 1rem;
  padding-bottom: 0.75rem;
  border-bottom: 2px solid #f0f0f0;
}

.task-list {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.task-item {
  padding: 0.75rem;
  background: #f9fafb;
  border-radius: 8px;
  font-size: 0.9rem;
  color: #555;
}

.task-item strong {
  color: #667eea;
}

.tips-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 1.5rem;
}

.tip-card {
  background: white;
  border-radius: 12px;
  padding: 1.5rem;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}

.tip-card h3 {
  color: #667eea;
  margin-bottom: 1rem;
}

.tip-card ul {
  list-style: none;
  padding: 0;
}

.tip-card li {
  padding: 0.5rem 0;
  padding-left: 1.5rem;
  position: relative;
  color: #555;
  line-height: 1.6;
}

.tip-card li:before {
  content: '💡';
  position: absolute;
  left: 0;
}

@media (max-width: 768px) {
  .roadmap-container {
    padding: 1rem;
  }

  .roadmap-header h1 {
    font-size: 1.8rem;
  }

  .timeline:before {
    left: 20px;
  }

  .timeline-item {
    flex-direction: column !important;
    padding-left: 60px;
  }

  .timeline-year {
    text-align: left;
  }

  .timeline-content {
    margin: 0;
  }

  .learning-stages,
  .topics-grid,
  .tasks-grid,
  .tips-grid {
    grid-template-columns: 1fr;
  }
}
</style>
