# 服务集成指南

## ✅ 已集成的服务

南风博客已成功集成以下 AI 服务：

| 服务 | 端口 | 访问路径 | 状态 |
|------|------|----------|------|
| 🤖 RAG 知识库 | 7860 | `/rag` | ✅ 已集成 |
| 🧠 情感分析 | 8001 | `/emotion` | ✅ 已集成 |
| 🎮 AI 俄罗斯方块 | 5000 | `/tetris` | ✅ 已集成 |

---

## 🚀 一键启动所有服务

### 推荐方式

```bash
cd /root/.openclaw/workspace/blog
./start-all.sh
```

这会同时启动：
- ✅ 博客服务 (http://localhost:5173)
- ✅ RAG 知识库 (http://localhost:7860)
- ✅ 情感分析 (http://localhost:8001)
- ✅ AI 俄罗斯方块 (http://localhost:5000)

---

## 📱 访问方式

### 方式一：通过博客导航栏

访问博客首页 http://localhost:5173，点击顶部导航：

```
[首页] [文章] [🤖 RAG 知识库] [🧠 情感分析] [🎮 AI 方块] [关于]
```

### 方式二：直接访问页面

- **RAG 知识库**: http://localhost:5173/rag
- **情感分析**: http://localhost:5173/emotion
- **AI 俄罗斯方块**: http://localhost:5173/tetris

### 方式三：独立访问服务

- **RAG 知识库**: http://localhost:7860
- **情感分析**: http://localhost:8001
- **AI 俄罗斯方块**: http://localhost:5000

---

## 🎯 服务详情

### 🤖 RAG 知识库

**功能**: 基于本地知识库的智能问答系统

**专业领域**:
- 数控机床基础知识
- CAD/CAM 技术
- G 代码生成
- 工艺规划与刀具选择

**特色功能**:
- 🔍 智能关键词检索
- 📊 多结果展示
- 📑 来源追溯
- 💡 示例问题引导

**访问**: 
- 博客集成：http://localhost:5173/rag
- 独立访问：http://localhost:7860

**文档**: `rag-knowledge-base/QUICKSTART.md`

---

### 🧠 情感分析服务

**功能**: AI 驱动的文本情感分析

**核心能力**:
- 🎭 情绪识别（7 种基本情绪）
- 📊 极性分析（积极/消极）
- 🔍 关键词提取
- 📈 批量分析与统计

**支持的情绪**:
- 高兴 😊
- 悲伤 😢
- 愤怒 😠
- 恐惧 😨
- 惊讶 😲
- 厌恶 😒
- 中性 😐

**API 接口**:
```bash
# 分析单个文本
POST http://localhost:8001/api/analyze
{
  "text": "今天天气真好！"
}

# 批量分析
POST http://localhost:8001/api/batch-analyze
{
  "texts": ["句子 1", "句子 2", ...]
}

# 健康检查
GET http://localhost:8001/health
```

**访问**:
- 博客集成：http://localhost:5173/emotion
- 独立访问：http://localhost:8001

**文档**: `emotion-analyzer-mvp/QUICK_REFERENCE.md`

---

### 🎮 AI 俄罗斯方块

**功能**: AI 驱动的经典俄罗斯方块游戏

**游戏模式**:
- 👤 **手动模式**: 自己控制，经典体验
- 🤖 **AI 托管**: 观看 AI 自动游戏
- ⚡ **极速模式**: 挑战反应极限

**操作说明**:
- ← → : 左右移动
- ↑ : 旋转方块
- ↓ : 加速下落
- Space : 直接掉落
- P : 暂停游戏
- R : 重新开始

**AI 算法**:
- 基于强化学习（Reinforcement Learning）
- Q-Learning / Deep Q-Network
- 经过数千局自我对弈训练

**访问**:
- 博客集成：http://localhost:5173/tetris
- 独立访问：http://localhost:5000

**文档**: `ai-tetris/docs/README.md`

---

## 🔧 分别启动服务

如果不想使用一键启动脚本，可以分别启动：

### 启动博客

```bash
cd /root/.openclaw/workspace/blog
npm run dev
```

### 启动 RAG 知识库

```bash
cd /root/.openclaw/workspace/rag-knowledge-base
./scripts/start_web.sh
```

### 启动情感分析

```bash
cd /root/.openclaw/workspace/emotion-analyzer-mvp
docker-compose up -d
```

### 启动 AI 俄罗斯方块

```bash
cd /root/.openclaw/workspace/ai-tetris
docker-compose up -d
```

---

## 📊 服务状态检查

### 检查所有服务

```bash
# RAG 知识库
curl http://localhost:7860

# 情感分析
curl http://localhost:8001/health

# AI 俄罗斯方块
curl http://localhost:5000/health
```

### 查看日志

```bash
# RAG 日志
tail -f /root/.openclaw/workspace/rag-knowledge-base/logs/rag-web.log

# 情感分析日志（Docker）
cd /root/.openclaw/workspace/emotion-analyzer-mvp
docker-compose logs -f

# AI 俄罗斯方块日志（Docker）
cd /root/.openclaw/workspace/ai-tetris
docker-compose logs -f
```

---

## 🛑 停止服务

### 停止博客

在运行博客的终端按 `Ctrl+C`

### 停止 RAG 知识库

```bash
pkill -f web_ui_simple.py
```

### 停止 Docker 服务

```bash
# 情感分析
cd /root/.openclaw/workspace/emotion-analyzer-mvp
docker-compose down

# AI 俄罗斯方块
cd /root/.openclaw/workspace/ai-tetris
docker-compose down
```

---

## 📱 移动端访问

在同一局域网内，手机/平板可访问：

```
http://服务器IP:5173  # 博客
http://服务器IP:7860  # RAG 知识库
http://服务器IP:8001  # 情感分析
http://服务器IP:5000  # AI 俄罗斯方块
```

所有页面均采用响应式设计，完美适配移动设备。

---

## 🎨 界面预览

### 导航栏

```
┌─────────────────────────────────────────────────────┐
│  南风的博客                                          │
│                                                      │
│  [首页] [文章] [🤖 RAG 知识库] [🧠 情感分析]        │
│  [🎮 AI 方块] [关于]                                 │
└─────────────────────────────────────────────────────┘
```

### 服务页面布局

每个服务页面包含：
- 服务介绍和描述
- 内嵌 iframe（自动检测服务状态）
- 快捷操作按钮（新窗口打开、使用文档）
- 功能特性展示
- 使用示例/操作说明
- 统计信息
- API 接口说明（如适用）

---

## ⚠️ 常见问题

### Q: 页面显示"服务未启动"？

**A**: 
1. 检查服务是否运行（见"服务状态检查"）
2. 如未运行，使用 `./start-all.sh` 一键启动
3. 刷新页面

### Q: 多个服务同时运行会卡顿吗？

**A**: 
- 博客：轻量级，占用资源少
- RAG: 中等，主要占用内存
- 情感分析：需要 GPU 加速（如有）
- AI 俄罗斯方块：轻量级

建议配置：4GB+ 内存，有 GPU 更佳。

### Q: 如何部署到生产环境？

**A**: 
1. 使用 Nginx 反向代理
2. 配置 HTTPS 证书
3. 设置服务自启动（systemd）
4. 添加访问认证（可选）

详见各服务的部署文档。

### Q: 可以自定义服务端口吗？

**A**: 
- RAG: 修改 `web_ui_simple.py` 中的 `server_port`
- 情感分析：修改 `.env` 文件
- AI 俄罗斯方块：修改 `docker-compose.yml`

修改后记得重启服务。

---

## 🚧 未来计划

- [ ] 统一用户认证系统
- [ ] 服务间数据互通
- [ ] 仪表盘汇总所有服务状态
- [ ] 性能监控和告警
- [ ] 更多 AI 服务集成

---

## 📞 技术支持

有问题请联系旺财或查看相关文档：

- **RAG 知识库**: `rag-knowledge-base/QUICKSTART.md`
- **情感分析**: `emotion-analyzer-mvp/QUICK_REFERENCE.md`
- **AI 俄罗斯方块**: `ai-tetris/docs/README.md`

---

**更新时间**: 2026-04-09  
**维护者**: 旺财 🐕
