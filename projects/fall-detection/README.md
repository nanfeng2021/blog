# 🚨 摔倒检测系统

> 基于 3D 点云技术的实时摔倒监控系统

---

## 📖 项目简介

这是一个基于 Streamlit 和 Plotly 的实时摔倒检测可视化系统，通过 3D 点云模拟人体姿态变化，检测并预警摔倒事件。

### ✨ 主要特性

- 🌐 **实时监控**：20 FPS 流畅的点云动画展示
- 🎯 **摔倒检测**：自动识别人体姿态异常变化
- 🚨 **多级预警**：疑似摔倒 → 确认摔倒 分级报警
- 📊 **数据统计**：FPS 趋势、处理耗时、报警记录
- 🎨 **可视化**：3D 点云 + 高度热力图

---

## 🚀 快速启动

### 方式一：Docker Compose（推荐）

```bash
cd /root/.openclaw/workspace/blog

# 启动摔倒检测服务
docker-compose --profile with-fall-detection up -d fall-detection

# 查看日志
docker-compose logs -f fall-detection

# 停止服务
docker-compose down fall-detection
```

**访问地址**: http://localhost:8501

### 方式二：直接运行

```bash
cd projects/fall-detection

# 创建虚拟环境
python3 -m venv venv
source venv/bin/activate

# 安装依赖
pip install -r requirements.txt

# 启动服务
streamlit run app_optimized.py --server.address 0.0.0.0 --server.port 8501
```

---

## 🎛️ 使用说明

1. **启动系统**：点击侧边栏的 "▶️ 启动" 按钮
2. **观察监控**：系统会自动播放 100 帧模拟动画
   - Frame 1-49：正常站立状态
   - Frame 50-51：疑似摔倒预警（⚠️）
   - Frame 52-100：确认摔倒报警（🚨）
3. **查看统计**：切换到 "📈 统计图表" 标签页查看 FPS 趋势
4. **重置系统**：点击 "🔄 重置" 重新开始

---

## 🔧 技术栈

- **前端框架**: Streamlit
- **3D 可视化**: Plotly + Open3D
- **数据处理**: NumPy, SciPy
- **部署方式**: Docker

---

## 📁 项目结构

```
projects/fall-detection/
├── app_optimized.py      # 主应用（高性能版本）
├── requirements.txt      # Python 依赖
└── Dockerfile           # Docker 镜像配置
```

---

## 🔗 相关链接

- [博客首页](https://ainanfeng.cn)
- [RAG 知识库](http://localhost:7860)
- [情感分析系统](http://localhost:8001)
- [AI 俄罗斯方块](http://localhost:5000)

---

## 📝 更新日志

### v1.0.0 (2026-04-12)
- ✅ 集成到博客项目
- ✅ 使用 `@st.experimental_fragment` 实现局部刷新
- ✅ 优化帧率至稳定 20 FPS
- ✅ 减少页面闪烁和卡顿
- ✅ Docker Compose 一键部署

---

**🌟 祝你使用愉快！**
