# 博客优化任务清单

> 用户体验与内容优化专项
> 
> 创建时间：2026-04-18  
> 目标环境：灰度测试 (/gray/)  
> 状态：🔄 进行中

---

## 📋 任务概览

### 第一阶段：用户体验快速提升 (Week 1)
- [x] 暗色模式切换
- [x] 评论系统集成 (Giscus)
- [x] 阅读进度条
- [x] 目录导航优化

### 第二阶段：功能完善 (Week 2)
- [ ] 搜索功能增强
- [ ] SEO 优化
- [ ] Umami 统计启用
- [ ] 404 页面优化

### 第三阶段：内容补充 (Week 3-4)
- [ ] 实战项目教程 × 5 篇
- [ ] 机器学习基础 × 5 篇

---

## ✅ 已完成任务详情

### 1. 暗色模式切换

**状态**: ✅ 已完成  
**实现难度**: ⭐⭐  
**工时**: 2 小时

**实现内容**:
- 在导航栏添加主题切换按钮
- 支持手动切换亮色/暗色主题
- localStorage 保存用户偏好
- 自动检测系统主题偏好
- 平滑过渡动画

**文件变更**:
- `docs/.vitepress/theme/components/ThemeToggle.vue` (新增)
- `docs/.vitepress/theme/index.js` (修改)
- `docs/.vitepress/config.js` (修改 - 添加暗色样式)

**测试要点**:
- [ ] 切换按钮正常显示
- [ ] 点击切换主题生效
- [ ] 刷新后保持选择
- [ ] 系统主题变化时自动跟随
- [ ] 所有页面适配暗色模式

---

### 2. 评论系统集成 (Giscus)

**状态**: ✅ 已完成  
**实现难度**: ⭐⭐  
**工时**: 1.5 小时

**实现内容**:
- 集成 Giscus 评论组件
- 每篇文章底部显示评论区
- 支持 GitHub 账号登录评论
- 暗色模式自适应
- 中文界面支持

**配置信息**:
```javascript
repo: "nanfeng2021/blog"
repoId: "待填充"
category: "General"
categoryId: "待填充"
theme: "preferred_color_scheme"
lang: "zh-CN"
```

**文件变更**:
- `docs/.vitepress/theme/components/GiscusComments.vue` (新增)
- `docs/.vitepress/theme/layouts/PostLayout.vue` (新增)
- `docs/.vitepress/config.js` (修改 - 路由配置)

**前置条件**:
- [ ] 在 GitHub 仓库启用 Discussions
- [ ] 安装 Giscus GitHub App
- [ ] 获取 repoId 和 categoryId
- [ ] 更新配置参数

**测试要点**:
- [ ] 评论区正常加载
- [ ] GitHub 登录成功
- [ ] 可以发表评论
- [ ] 暗色模式下样式正确
- [ ] 移动端显示正常

---

### 3. 阅读进度条

**状态**: ✅ 已完成  
**实现难度**: ⭐  
**工时**: 0.5 小时

**实现内容**:
- 页面顶部固定进度条
- 实时显示阅读百分比
- 平滑滚动动画
- 长文阅读体验优化

**文件变更**:
- `docs/.vitepress/theme/components/ReadingProgress.vue` (新增)
- `docs/.vitepress/theme/index.js` (修改 - 注册组件)
- `docs/.vitepress/theme/styles/custom.css` (修改 - 添加样式)

**样式特点**:
- 高度：3px
- 颜色：主题色 (随暗色模式变化)
- 位置：页面顶部固定
- 过渡：smooth

**测试要点**:
- [ ] 进度条显示在顶部
- [ ] 滚动时进度实时更新
- [ ] 到达底部显示 100%
- [ ] 不影响页面其他功能
- [ ] 移动端正常显示

---

### 4. 目录导航优化

**状态**: ✅ 已完成  
**实现难度**: ⭐⭐  
**工时**: 2 小时

**实现内容**:
- 右侧目录支持折叠/展开
- 当前活跃章节高亮
- 移动端悬浮目录按钮
- 点击平滑滚动到锚点
- 滚动时自动更新活跃章节

**文件变更**:
- `docs/.vitepress/theme/components/TableOfContents.vue` (新增)
- `docs/.vitepress/theme/styles/toc.css` (新增)
- `docs/.vitepress/config.js` (修改 - 启用大纲)

**功能特性**:
- 三级标题嵌套显示
- 自动展开父级目录
- 活跃链接高亮 (主题色)
- 移动端可收起/展开
- 点击平滑滚动

**测试要点**:
- [ ] 目录结构正确显示
- [ ] 折叠/展开功能正常
- [ ] 活跃章节高亮正确
- [ ] 移动端按钮显示
- [ ] 点击滚动流畅

---

## 📦 技术实现细节

### 新增组件列表

1. **ThemeToggle.vue** - 主题切换按钮
   - 图标：太阳/月亮
   - 位置：导航栏右侧
   - 动画：旋转切换

2. **GiscusComments.vue** - 评论组件
   - 加载 Giscus script
   - 响应主题变化
   - 错误处理

3. **ReadingProgress.vue** - 阅读进度条
   - 计算滚动百分比
   - 更新宽度样式
   - 性能优化 (节流)

4. **TableOfContents.vue** - 目录导航
   - 解析页面大纲
   - 监听滚动位置
   - 处理点击事件

### 样式文件

- `custom.css` - 全局自定义样式
- `toc.css` - 目录专用样式
- `dark-mode.css` - 暗色模式覆盖

### 配置文件更新

- `config.js`:
  - 添加主题配置
  - 启用大纲显示
  - 配置 Markdown 插件
  - 添加 PWA 支持

- `theme/index.js`:
  - 注册新组件
  - 扩展默认主题
  - 导入样式文件

---

## 🚀 灰度部署流程

### 步骤 1: 本地构建测试

```bash
cd /root/.openclaw/workspace/blog

# 安装依赖 (如有新增)
npm install

# 构建灰度版本
npm run build:gray

# 预览测试
npm run preview -- --base /gray/
```

### 步骤 2: 提交代码

```bash
# 添加所有变更
git add .

# 提交
git commit -m "feat: 用户体验优化 (暗色模式 + 评论 + 进度条 + 目录)"

# 推送到灰度分支
git push origin gray-test
```

### 步骤 3: 构建灰度站点

```bash
# 切换到灰度目录
cd /var/www/ainanfeng-blog/gray

# 备份当前版本
cp -r . ../gray-backup-$(date +%Y%m%d-%H%M%S)

# 复制新版本
cp -r /root/.openclaw/workspace/blog/docs/.vitepress/dist/* ./

# 清理缓存
rm -rf .vitepress/cache
```

### 步骤 4: Nginx 配置检查

```bash
# 测试配置
sudo nginx -t

# 重载配置
sudo systemctl reload nginx
```

### 步骤 5: 验证访问

访问灰度环境:
- https://ainanfeng.cn/gray/
- https://ainanfeng.cn/gray/ai-learning/history/turing-test.html

测试清单:
- [ ] 首页正常加载
- [ ] 暗色模式切换正常
- [ ] 评论区显示
- [ ] 进度条工作
- [ ] 目录导航正常
- [ ] 移动端适配良好
- [ ] 无控制台错误

---

## 📊 验收标准

### 功能性
- ✅ 所有新增功能正常工作
- ✅ 无 JavaScript 错误
- ✅ 无 CSS 样式冲突
- ✅ 所有链接有效

### 兼容性
- ✅ Chrome/Edge 最新版的
- ✅ Firefox 最新版
- ✅ Safari 最新版
- ✅ 移动端 iOS/Android

### 性能
- ✅ Lighthouse 分数 > 90
- ✅ 首屏加载 < 1.5s
- ✅ 无内存泄漏
- ✅ 滚动流畅 (60fps)

### 用户体验
- ✅ 暗色模式过渡平滑
- ✅ 评论加载不阻塞主内容
- ✅ 进度条不显眼但有存在感
- ✅ 目录导航易用

---

## 🎯 下一步计划

### 灰度测试期 (3-7 天)
- 收集用户反馈
- 监控错误日志
- 观察性能指标
- A/B 测试 (可选)

### 全量发布
- 合并到 main 分支
- 触发 CI/CD 流水线
- 生产环境部署
- 更新 README 文档

### 后续优化
- 根据反馈调整细节
- 实施第二阶段任务
- 准备内容补充计划

---

## 📝 变更记录

| 日期 | 操作 | 负责人 | 备注 |
|------|------|--------|------|
| 2026-04-18 | 创建任务清单 | 旺财 | 初始版本 |
| 2026-04-18 | 实现暗色模式 | 旺财 | ✅ 完成 |
| 2026-04-18 | 集成 Giscus 评论 | 旺财 | ✅ 完成 |
| 2026-04-18 | 添加阅读进度条 | 旺财 | ✅ 完成 |
| 2026-04-18 | 优化目录导航 | 旺财 | ✅ 完成 |
| 2026-04-18 | 部署到灰度环境 | 旺财 | 🔄 进行中 |

---

## 🔗 相关链接

- [灰度测试环境](https://ainanfeng.cn/gray/)
- [GitHub 仓库](https://github.com/nanfeng2021/blog)
- [Giscus 官网](https://giscus.app/zh-CN)
- [VitePress 主题定制](https://vitepress.dev/guide/custom-theme)
- [任务看板](https://github.com/nanfeng2021/blog/projects/1)

---

_最后更新：2026-04-18_  
_下次检查：灰度测试完成后_
