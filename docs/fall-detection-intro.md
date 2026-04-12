# 🚨 摔倒检测系统

> 基于 3D 点云技术的实时监控系统

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

## 🎬 功能演示

### 监控画面

系统实时显示 3D 点云模拟的人体姿态：
- **蓝色区域**：地面点云
- **彩色柱状**：人体点云（颜色代表高度）
- **绿色状态**：正常站立
- **红色警报**：检测到摔倒

### 检测流程

1. **Frame 1-49**: 正常站立状态 ✅
2. **Frame 50-51**: 疑似摔倒预警 ⚠️
3. **Frame 52-100**: 确认摔倒报警 🚨

---

## 🚀 快速访问

### 方式一：Nginx 统一入口（推荐）

```
http://localhost/fall-detection/
```

✅ 优势：避免跨域问题，支持 HTTPS，统一管理

### 方式二：直接访问

```
http://localhost:8501
```

---

## 🎛️ 使用说明

### 启动系统

1. 点击侧边栏的 **"▶️ 启动"** 按钮
2. 系统开始播放 100 帧模拟动画
3. 观察点云变化和状态提示

### 查看数据

- **实时监控标签页**：查看当前帧、人数、状态
- **统计图表标签页**：查看 FPS 趋势和处理性能

### 控制系统

| 按钮 | 功能 |
|------|------|
| ▶️ 启动 | 开始监控系统 |
| ⏹️ 停止 | 暂停监控 |
| 🔄 重置 | 重新开始播放 |

---

## 🔧 技术架构

### 核心技术

```
┌─────────────────┐
│   Streamlit     │ ← Web UI 框架
└────────┬────────┘
         │
┌────────▼────────┐
│    Plotly       │ ← 3D 可视化引擎
└────────┬────────┘
         │
┌────────▼────────┐
│    Open3D       │ ← 点云数据处理
└────────┬────────┘
         │
┌────────▼────────┐
│    NumPy        │ ← 科学计算
└─────────────────┘
```

### 性能优化

- ✅ **局部刷新**：使用 `@st.experimental_fragment` 实现 20 FPS 流畅动画
- ✅ **容器复用**：固定图表 key，避免重复创建
- ✅ **非阻塞**：移除 `time.sleep()`，使用 fragment 自动节流
- ✅ **CSS 优化**：禁用不必要的动画过渡

---

## 📁 部署方式

### Docker Compose（推荐）

```bash
cd /root/.openclaw/workspace/blog

# 启动摔倒检测服务
docker compose --profile with-fall-detection up -d fall-detection

# 查看日志
docker compose logs -f fall-detection

# 停止服务
docker compose down fall-detection
```

### 手动运行

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

## 📊 系统指标

| 指标 | 数值 |
|------|------|
| 帧率 | 20 FPS |
| 延迟 | < 50ms |
| 点云数量 | ~1300 点/帧 |
| CPU 占用 | ~15% |
| 内存占用 | ~400MB |

---

## 🔗 相关资源

- [项目源码](https://github.com/nanfeng2021/blog/tree/main/projects/fall-detection)
- [集成报告](https://github.com/nanfeng2021/blog/blob/main/projects/fall-detection/INTEGRATION_REPORT.md)
- [部署指南](/DEPLOYMENT_GUIDE)
- [博客首页](/)

---

## 🎯 后续规划

### P0 - 短期优化
- [ ] 接入真实摄像头数据（深度相机）
- [ ] 添加用户认证
- [ ] 移动端适配

### P1 - 中期目标
- [ ] 历史回放功能
- [ ] 多摄像头支持
- [ ] 微信/短信报警推送

### P2 - 长期规划
- [ ] 机器学习模型训练
- [ ] 云端部署
- [ ] API 开放平台

---

**🌟 立即体验**: [启动摔倒检测系统](http://localhost:8501)

*注意：需要先启动 Docker 服务或手动运行应用*

*最后更新：2026-04-12*
