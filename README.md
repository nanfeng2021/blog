# 🚀 南风的博客

> 专注于 AI 技术、编程实践与生活感悟的个人博客 | AI Learning Journey

[![CI/CD Pipeline](https://github.com/nanfeng2021/blog/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/nanfeng2021/blog/actions/workflows/ci-cd.yml)
[![Docker Build](https://img.shields.io/docker/builds/nanfeng2021/ainanfeng-blog)](https://hub.docker.com/r/nanfeng2021/ainanfeng-blog)
[![Harness Compliance](https://img.shields.io/badge/Harness-70%25-green)](HARNESS_COMPLIANCE.md)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

---

## 🌟 最近更新

- **2026-04-18**: ✨ 新增完整的 AI 学习路线图，涵盖从机器学习到多模态大模型的全栈知识体系
- **2026-04-18**: 🚨 摔倒检测系统优化完成，支持 HTTPS 访问和静态资源缓存
- **2026-04-15**: 📚 添加 AI 学习资源合集，包括吴恩达 ML、CS224n、CS231n 等经典课程笔记

---

## 🌐 在线访问

### 生产环境（HTTPS）
- **博客首页**: [https://ainanfeng.cn](https://ainanfeng.cn)
- **摔倒检测系统**: [https://ainanfeng.cn/fall-detection/](https://ainanfeng.cn/fall-detection/) 🔒
- **RAG 知识库**: [https://ainanfeng.cn/rag/](https://ainanfeng.cn/rag/)
- **情感分析系统**: [https://ainanfeng.cn/emotion/](https://ainanfeng.cn/emotion/)
- **AI 俄罗斯方块**: [https://ainanfeng.cn/tetris/](https://ainanfeng.cn/tetris/)

### 开发环境（本地）
- **博客首页**: [http://localhost:8080](http://localhost:8080)
- **RAG 知识库**: [http://localhost:7860](http://localhost:7860)
- **情感分析**: [http://localhost:8001](http://localhost:8001)
- **AI 俄罗斯方块**: [http://localhost:5000](http://localhost:5000)
- **摔倒检测系统**: [http://localhost:8501](http://localhost:8501)

---

## 📚 AI 学习路线图

本项目包含完整的 AI 学习文档，按照以下路线组织：

### 📖 第一阶段：AI 发展史
- ✅ [图灵测试与早期思想](docs/ai-learning/history/turing-test.md)
- ✅ [符号主义与知识工程](docs/ai-learning/history/symbolism.md)
- ✅ [连接主义与神经网络起源](docs/ai-learning/history/connectionism.md)
- ✅ [感知机与第一次寒冬](docs/ai-learning/history/perceptron.md)
- ✅ [专家系统与第二次寒冬](docs/ai-learning/history/expert-systems.md)
- ✅ [深度学习复兴](docs/ai-learning/history/deep-learning-revival.md)

### 🧠 第二阶段：机器学习基础
- 🔄 统计学习方法
- 🔄 监督学习算法
- 🔄 无监督学习算法
- 🔄 强化学习基础

### 🤖 第三阶段：深度学习
- ⏳ 神经网络基础
- ⏳ CNN 与计算机视觉
- ⏳ RNN/LSTM 与序列建模
- ⏳ Transformer 架构
- ⏳ Attention 机制

### 🌐 第四阶段：大语言模型
- ⏳ GPT 系列模型
- ⏳ BERT 与预训练模型
- ⏳ Prompt Engineering
- ⏳ Fine-tuning 技术
- ⏳ RAG 检索增强生成

### 🎨 第五阶段：多模态与前沿
- ⏳ Stable Diffusion
- ⏳ Sora 与视频生成
- ⏳ 多模态融合
- ⏳ Agent 与工具使用
- ⏳ 价值对齐与安全

**📖 完整学习资源**: [AI 学习资源索引](docs/ai-learning/resources/index.md)

---

## ⚡ 快速开始

### 本地开发

```bash
# 克隆项目
git clone https://github.com/nanfeng2021/blog.git
cd blog

# 安装依赖
npm install

# 启动开发服务器
npm run dev

# 构建生产版本
npm run build

# 预览生产构建
npm run preview
```

### Docker 部署（推荐）

```bash
# 一键启动所有服务
docker-compose up -d

# 查看日志
docker-compose logs -f

# 停止服务
docker-compose down
```

### 使用启动脚本

```bash
# 一键启动所有服务（博客 + RAG + 情感分析 + AI 方块 + 摔倒检测）
./start-all.sh

# 单独启动博客
npm run dev

# Docker 部署
./scripts/deploy-docker.sh
```

### 启动特定服务

```bash
# 只启动摔倒检测系统
docker-compose --profile with-fall-detection up -d fall-detection

# 只启动 RAG 知识库
docker-compose --profile with-rag up -d rag

# 启动所有服务
docker-compose --profile with-rag --profile with-fall-detection up -d
```

---

## 📁 项目结构

```
blog/
├── .github/
│   └── workflows/
│       └── ci-cd.yml          # CI/CD 流水线
├── docs/                      # 博客内容
│   ├── posts/                 # 文章
│   ├── ai-learning/           # 🆕 AI 学习路线图
│   │   ├── history/           # AI 发展史
│   │   ├── topics/            # 技术主题
│   │   └── resources/         # 学习资源
│   ├── public/                # 静态资源
│   └── .vitepress/            # VitePress 配置
├── projects/                  # 集成的项目应用
│   ├── fall-detection/        # 摔倒检测系统 🚨
│   │   ├── app_optimized.py   # 主应用
│   │   ├── requirements.txt   # Python 依赖
│   │   ├── Dockerfile         # Docker 配置
│   │   └── README.md          # 项目文档
│   └── ...                    # 其他项目
├── tests/
│   └── e2e/                   # E2E 测试
├── scripts/                   # 运维脚本
│   ├── build.sh               # 构建脚本
│   ├── deploy-docker.sh       # Docker 部署
│   ├── backup.sh              # 备份脚本
│   └── health-check.sh        # 健康检查
├── Dockerfile                 # Docker 构建文件
├── docker-compose.yml         # Docker 编排
├── nginx.conf                 # Nginx 配置
├── playwright.config.js       # Playwright 测试配置
├── package.json               # 项目配置
├── start-all.sh               # 一键启动脚本
└── HARNESS_COMPLIANCE.md      # Harness 合规性报告
```

---

## 🛠️ 可用命令

| 命令 | 说明 |
|------|------|
| `npm run dev` | 启动开发服务器 |
| `npm run build` | 构建生产版本 |
| `npm run preview` | 预览生产构建 |
| `npm test` | 运行 E2E 测试 |
| `npm run docker:build` | 构建 Docker 镜像 |
| `npm run docker:run` | 运行 Docker 容器 |
| `npm run docker:stop` | 停止 Docker 容器 |
| `./scripts/health-check.sh` | 健康检查 |
| `./scripts/backup.sh` | 备份数据 |

---

## 🧪 测试

```bash
# 运行所有测试
npm test

# 带 UI 运行测试
npm run test:ui

# 调试模式
npm run test:debug

# 运行特定测试
npx playwright test tests/e2e/basic.test.js
```

---

## 📊 监控与运维

### 健康检查

```bash
# 使用脚本检查
./scripts/health-check.sh

# 手动检查
curl http://localhost:8080/health
```

### 备份

```bash
# 创建备份
./scripts/backup.sh

# 备份位置
ls -lh /root/backups/blog/
```

### 日志查看

```bash
# Docker 日志
docker logs -f nanfeng-blog

# Nginx 访问日志
sudo tail -f /var/log/nginx/ainanfeng.cn.access.log

# Nginx 错误日志
sudo tail -f /var/log/nginx/ainanfeng.cn.error.log
```

---

## 🚀 CI/CD

### 自动触发条件

- **Push 到 main/develop**: 运行 lint、build、test
- **Pull Request**: 运行完整 CI 流程 + 预览部署
- **Tag (v*)**: 构建 Docker 镜像并推送到 Docker Hub，创建 GitHub Release
- **每周一凌晨 2 点**: 定时完整检查

### 手动触发

在 GitHub Actions 页面选择 "Run workflow"，可选择：
- 跳过测试（仅构建）
- 部署预览环境

### 配置 Secrets

需要在 GitHub 仓库设置以下 Secrets：

- `DOCKERHUB_USERNAME`: Docker Hub 用户名
- `DOCKERHUB_TOKEN`: Docker Hub 访问令牌

---

## 📈 Harness Engineering 合规性

本项目遵循 Harness Engineering 规范，当前合规性评分：**70/100**

详见：[HARNESS_COMPLIANCE.md](HARNESS_COMPLIANCE.md)

### 已实现组件

- ✅ CI/CD 流水线
- ✅ Docker 容器化
- ✅ E2E 测试框架
- ✅ 健康检查
- ✅ 备份机制
- ✅ 监控集成（Umami）

### 待完成项

- ⏳ Harness 约束系统
- ⏳ 高级监控（Sentry、Prometheus）
- ⏳ 安全加固

---

## 🔗 相关链接

- [博客首页](https://ainanfeng.cn)
- [GitHub 仓库](https://github.com/nanfeng2021/blog)
- [Docker Hub](https://hub.docker.com/r/nanfeng2021/ainanfeng-blog)
- [AI 学习路线图](docs/ai-learning/index.md)
- [Harness Engineering 规范](../docs/龙虾-Harness-Engineering-工程实践.md)
- [VitePress 文档](https://vitepress.dev/)
- [Playwright 文档](https://playwright.dev/)

---

## 👥 维护者

- **作者**: [南风](https://github.com/nanfeng2021)
- **助手**: [旺财 🐕](https://github.com/nanfeng2021/openclaw)

---

## 📄 许可证

MIT License © 2026 南风

---

_最后更新：2026-04-18_  
_Harness 合规性评分：70/100 🎉_  
_AI 学习文档：50+ 篇 📚_
