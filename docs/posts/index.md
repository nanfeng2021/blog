---
title: 文章列表
layout: page
sidebar: false
page: true
---

<div class="posts-container">
<div class="posts-header">
<h1>📚 所有文章</h1>
<p class="description">南风的所有文章和 AI 学习教程列表</p>
</div>

<!-- AI 学习文档专区 -->
<div class="ai-learning-section highlight-section">
<h2>🎓 AI 学习文档</h2>
<p class="section-desc">完整的 AI 学习教程集合，从基础到前沿技术</p>

<div class="featured-card">
<a href="/ai-learning-roadmap" class="card-link">
<div class="card-content">
<span class="card-badge">⭐ 核心</span>
<h3>🗺️ AI 学习计划路线图</h3>
<p>从人工智能发展历史到前沿技术的完整学习路径，包含 60+ 个详细教程页面</p>
<div class="card-meta">
<span class="tag-count">60+ 篇教程</span>
<span class="update-time">持续更新</span>
</div>
</div>
</a>
</div>

<div class="resource-grid">
<a href="/ai-learning/" class="quick-link">
<div class="link-card">
<span class="icon">🎯</span>
<h4>AI 学习中心</h4>
<p>快速入口</p>
</div>
</a>
<a href="/ai-learning/history/" class="quick-link">
<div class="link-card">
<span class="icon">📜</span>
<h4>AI 历史</h4>
<p>发展历程</p>
</div>
</a>
<a href="/ai-learning/topics/" class="quick-link">
<div class="link-card">
<span class="icon">⚡</span>
<h4>核心技术</h4>
<p>技术专题</p>
</div>
</a>
<a href="/ai-learning/resources/" class="quick-link">
<div class="link-card">
<span class="icon">📖</span>
<h4>学习资源</h4>
<p>课程与书籍</p>
</div>
</a>
</div>

<div class="tutorial-list">
<h3>最新教程</h3>
<ul>
<li><a href="/ai-learning/topics/rnn-lstm">🔁 RNN 与 LSTM</a> - 序列建模的经典方法</li>
<li><a href="/ai-learning/history/backpropagation">🔄 反向传播算法</a> - 神经网络训练基石</li>
<li><a href="/ai-learning/topics/gpt">✨ GPT 系列</a> - 从 GPT-1 到 GPT-4 的演进</li>
<li><a href="/ai-learning/topics/bert">🤖 BERT</a> - NLP 领域的里程碑</li>
<li><a href="/ai-learning/topics/transformer">⚡ Transformer</a> - 革命性架构</li>
</ul>
</div>
</div>

<!-- 博客文章 -->
<div class="blog-posts-section">
<h2>📝 博客文章</h2>

<div class="post-list">
<article class="post-item new">
<div class="post-content">
<h3><a href="/posts/blog-transformation">🎉 博客改造全记录 - 从模板到专业平台的蜕变</a></h3>
<p class="excerpt">记录了博客从简单模板改造成专业平台的全过程，包括导航优化、页面布局、SEO 优化等。</p>
<div class="post-meta">
<span class="date">2026 年 4 月 2 日</span>
<span class="category">博客</span>
</div>
</div>
</article>

<article class="post-item">
<div class="post-content">
<h3><a href="/posts/ai-history">AI 发展简史：从图灵测试到大模型时代</a></h3>
<p class="excerpt">回顾人工智能 70 年的发展历程，从图灵测试的提出到 GPT-4 等大模型的突破。</p>
<div class="post-meta">
<span class="date">2026 年 4 月 1 日</span>
<span class="category">AI 技术</span>
</div>
</div>
</article>

<article class="post-item">
<div class="post-content">
<h3><a href="/posts/welcome">欢迎来到我的博客</a></h3>
<p class="excerpt">这是我的个人博客，我会在这里分享 AI 技术、编程实践和生活感悟。</p>
<div class="post-meta">
<span class="date">2026 年 4 月 1 日</span>
<span class="category">随笔</span>
</div>
</div>
</article>
</div>
</div>

<!-- 分页导航 -->
<div class="pagination">
<span class="page-number active">1</span>
<span class="page-number disabled">2</span>
<span class="page-number disabled">3</span>
<span class="page-info">共 1 页</span>
</div>

</div>

<style scoped>
.posts-container { max-width: 1200px; margin: 0 auto; padding: 2rem; }
.posts-header { text-align: center; margin-bottom: 3rem; padding-bottom: 2rem; border-bottom: 2px solid #e5e7eb; }
.posts-header h1 { font-size: 2.5rem; margin-bottom: 0.5rem; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }
.description { color: #6b7280; font-size: 1.1rem; }
.highlight-section { background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); padding: 2rem; border-radius: 16px; margin-bottom: 3rem; color: white; }
.highlight-section h2 { font-size: 1.8rem; margin-bottom: 0.5rem; }
.section-desc { opacity: 0.9; margin-bottom: 1.5rem; }
.featured-card { background: rgba(255,255,255,0.15); border-radius: 12px; padding: 1.5rem; margin-bottom: 1.5rem; backdrop-filter: blur(10px); }
.card-link { text-decoration: none; color: inherit; display: block; }
.card-link:hover { transform: translateY(-2px); transition: transform 0.2s; }
.card-badge { display: inline-block; background: #fbbf24; color: #78350f; padding: 0.25rem 0.75rem; border-radius: 20px; font-size: 0.85rem; font-weight: 600; margin-bottom: 0.75rem; }
.card-content h3 { font-size: 1.5rem; margin-bottom: 0.5rem; }
.card-content p { opacity: 0.95; line-height: 1.6; }
.card-meta { display: flex; gap: 1rem; margin-top: 1rem; font-size: 0.9rem; opacity: 0.8; }
.resource-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 1rem; margin-bottom: 1.5rem; }
.quick-link { text-decoration: none; color: inherit; }
.link-card { background: rgba(255,255,255,0.15); padding: 1rem; border-radius: 8px; text-align: center; transition: all 0.2s; }
.link-card:hover { background: rgba(255,255,255,0.25); transform: translateY(-2px); }
.link-card .icon { font-size: 2rem; display: block; margin-bottom: 0.5rem; }
.link-card h4 { font-size: 1rem; margin-bottom: 0.25rem; }
.link-card p { font-size: 0.85rem; opacity: 0.9; }
.tutorial-list { background: rgba(255,255,255,0.1); padding: 1.5rem; border-radius: 8px; }
.tutorial-list h3 { margin-bottom: 1rem; font-size: 1.2rem; }
.tutorial-list ul { list-style: none; padding: 0; margin: 0; }
.tutorial-list li { margin-bottom: 0.5rem; }
.tutorial-list a { color: white; text-decoration: underline; text-underline-offset: 3px; }
.tutorial-list a:hover { text-decoration: none; }
.blog-posts-section h2 { font-size: 1.8rem; margin-bottom: 1.5rem; color: #374151; }
.post-list { display: flex; flex-direction: column; gap: 1.5rem; }
.post-item { background: white; border: 2px solid #e5e7eb; border-radius: 12px; padding: 1.5rem; transition: all 0.3s; }
.post-item:hover { border-color: #667eea; box-shadow: 0 4px 12px rgba(102, 126, 234, 0.15); transform: translateY(-2px); }
.post-item.new { border-left: 4px solid #f5576c; }
.post-content h3 { margin-bottom: 0.75rem; font-size: 1.4rem; }
.post-content h3 a { color: #1f2937; text-decoration: none; }
.post-content h3 a:hover { color: #667eea; }
.excerpt { color: #6b7280; line-height: 1.6; margin-bottom: 1rem; }
.post-meta { display: flex; gap: 1rem; font-size: 0.9rem; color: #9ca3af; }
.pagination { display: flex; justify-content: center; gap: 0.5rem; margin-top: 3rem; padding-top: 2rem; border-top: 2px solid #e5e7eb; }
.page-number { padding: 0.5rem 1rem; border: 2px solid #e5e7eb; border-radius: 8px; cursor: pointer; transition: all 0.2s; }
.page-number.active { background: #667eea; color: white; border-color: #667eea; }
.page-number.disabled { opacity: 0.5; cursor: not-allowed; }
.page-number:hover:not(.disabled) { border-color: #667eea; color: #667eea; }
.page-info { padding: 0.5rem 1rem; color: #9ca3af; }
@media (max-width: 768px) { .posts-container { padding: 1rem; } .posts-header h1 { font-size: 1.8rem; } .highlight-section { padding: 1.5rem; } .resource-grid { grid-template-columns: repeat(2, 1fr); } }
</style>
