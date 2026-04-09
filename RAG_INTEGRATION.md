# RAG 知识库集成指南

## ✅ 已完成集成

RAG 知识库 Web 界面已成功集成到南风博客项目中！

---

## 🎯 访问方式

### 方式一：通过博客导航栏

1. 启动博客服务
2. 访问 http://localhost:5173
3. 点击顶部导航栏的 **🤖 RAG 知识库**

### 方式二：直接访问

- **本地访问**: http://localhost:7860
- **博客集成页面**: http://localhost:5173/rag

---

## 🚀 快速启动

### 一键启动所有服务（推荐）

```bash
cd /root/.openclaw/workspace/blog
./start-all.sh
```

这会同时启动：
- 博客服务 (端口 5173)
- RAG 知识库服务 (端口 7860)

### 分别启动

**启动博客：**
```bash
cd /root/.openclaw/workspace/blog
npm run dev
```

**启动 RAG 知识库：**
```bash
cd /root/.openclaw/workspace/rag-knowledge-base
./scripts/start_web.sh
```

---

## 📱 功能特性

### 博客集成页面功能

1. **内嵌 iframe** - 直接在博客中访问 RAG 界面
2. **状态检测** - 自动检测 RAG 服务是否运行
3. **快捷操作** - 一键在新窗口打开
4. **使用文档** - 链接到详细使用指南
5. **功能展示** - 介绍 RAG 知识库的核心功能
6. **示例问题** - 提供常用查询示例

### RAG 知识库功能

- 🔍 **智能问答** - 基于本地知识库的专业回答
- 📊 **多结果展示** - 显示相关度和来源
- 📑 **来源追溯** - 每个答案都有据可查
- 💡 **示例引导** - 点击示例快速体验

---

## 🎨 界面预览

### 导航栏入口

```
[首页] [文章] [🤖 RAG 知识库] [关于]
```

### 集成页面布局

```
┌─────────────────────────────────────┐
│  🤖 RAG 知识库查询系统                │
│  基于本地知识库的智能问答系统          │
│                                     │
│  [🚀 在新窗口打开] [📖 使用文档]     │
├─────────────────────────────────────┤
│                                     │
│         [内嵌 RAG Web 界面]          │
│                                     │
├─────────────────────────────────────┤
│  ✨ 功能特性                         │
│  - 智能问答                          │
│  - 多结果展示                        │
│  - 来源追溯                          │
│  - 示例引导                          │
└─────────────────────────────────────┘
```

---

## 📊 知识库内容

当前包含以下主题：

| 类别 | 文档数 | 内容 |
|------|--------|------|
| 数控机床 | 1 | 基础知识、G 代码指令、刀具分类 |
| CAD/CAM | 1 | AI 平台方案、技术路线、竞品分析 |
| G 代码示例 | 1 | 传动轴加工程序实例 |

**总计**: 3 个文档，28 个文本块

---

## 🔧 配置说明

### 博客配置

文件：`docs/.vitepress/config.js`

已添加导航入口：
```javascript
nav: [
  { text: '首页', link: '/' },
  { text: '文章', link: '/posts/' },
  { text: '🤖 RAG 知识库', link: '/rag' },  // ← 新增
  { text: '关于', link: '/about' }
]
```

### RAG 服务配置

文件：`/root/.openclaw/workspace/rag-knowledge-base/config/config.json`

- 检索模式：关键词检索
- 返回结果数：5（可调）
- 服务端口：7860

---

## 💡 使用技巧

### 在博客中访问

1. 访问 http://localhost:5173/rag
2. 如果显示"服务未启动"，按提示启动 RAG 服务
3. 服务启动后刷新页面即可

### 直接使用 RAG 界面

1. 访问 http://localhost:7860
2. 输入专业问题或点击示例
3. 查看 AI 答案和详细结果

### 添加新文档

```bash
# 1. 放入文档
cp 你的文档.md /root/.openclaw/workspace/rag-knowledge-base/sources/feishu_docs/

# 2. 重建索引
cd /root/.openclaw/workspace/rag-knowledge-base
python3 scripts/build_index.py

# 3. 刷新页面即可查询新内容
```

---

## 🎯 示例问题

试试问这些问题：

- 二轴车床能加工什么零件？
- G71 外径粗车循环怎么用？
- 45 号钢的切削参数是多少？
- 数控车床常见刀具类型有哪些？
- CAD 转 G 代码的 AI 方案？
- 五轴机床相比三轴的优势？

---

## 📝 日志查看

### RAG 服务日志

```bash
tail -f /root/.openclaw/workspace/rag-knowledge-base/logs/rag-web.log
```

### 博客服务日志

博客服务会在终端直接输出日志。

---

## ⚠️ 常见问题

### Q: 点击 RAG 知识库显示"服务未启动"？

**A**: 
1. 检查 RAG 服务是否运行：`curl http://localhost:7860`
2. 如未运行，执行：`cd /root/.openclaw/workspace/rag-knowledge-base && ./scripts/start_web.sh`
3. 刷新博客页面

### Q: 如何停止服务？

**A**:
- 博客服务：在终端按 `Ctrl+C`
- RAG 服务：找到进程并 kill，或重启服务器

### Q: 可以在手机上访问吗？

**A**: 可以！在同一局域网内访问：
- 博客：`http://服务器 IP:5173`
- RAG: `http://服务器 IP:7860`

---

## 🚧 未来优化

- [ ] 统一认证系统（博客 +RAG 共用登录）
- [ ] 查询历史记录
- [ ] 热门问题统计
- [ ] 向量检索升级
- [ ] AI 答案优化

---

## 📞 技术支持

有问题请联系旺财或查看相关文档：

- RAG 使用指南：`/root/.openclaw/workspace/rag-knowledge-base/QUICKSTART.md`
- Web 界面指南：`/root/.openclaw/workspace/rag-knowledge-base/WEB_UI_GUIDE.md`

---

**更新时间**: 2026-04-09  
**维护者**: 旺财 🐕
