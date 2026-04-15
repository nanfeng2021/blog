# 🧪 灰度测试机制 - 旺财开发流程

## 📋 核心原则

**新功能开发时必须遵守的流程：**
1. ✅ 保证原有页面功能正常
2. ✅ 新功能在灰度环境充分测试
3. ✅ 测试通过后再整体替换生产环境
4. ✅ 灰度环境 URL 带 `/gray/` 前缀

## 🎯 推荐方案：简化灰度测试

### 方案概述

采用最简单的部署策略，不需要修改 VitePress 配置：

- **生产环境**: `https://ainanfeng.cn/`
- **灰度环境**: `https://ainanfeng.cn/gray/`

### 工作流程

#### 1️⃣ 开发新功能

```bash
# 在 docs/ 目录下正常开发
# 例如：修改 AILearningRoadmap.vue
#      或创建新的 Markdown 页面
```

#### 2️⃣ 构建并部署到灰度环境

```bash
# 使用简化的部署脚本
./scripts/deploy-gray-simple.sh feature-name

# 或手动执行：
npm run build
sudo mkdir -p /var/www/ainanfeng-blog/gray
sudo cp -r docs/.vitepress/dist/* /var/www/ainanfeng-blog/gray/
sudo chown -R www-data:www-data /var/www/ainanfeng-blog/gray/
```

#### 3️⃣ 测试灰度环境

访问以下 URL 进行测试：

```
https://ainanfeng.cn/gray/
https://ainanfeng.cn/gray/ai-learning-roadmap.html
https://ainanfeng.cn/gray/subscribe.html
https://ainanfeng.cn/gray/posts/
```

**测试清单：**
- [ ] 所有原有标签跳转正常（符号主义、预训练等）
- [ ] 新功能按预期工作
- [ ] 页面加载速度正常
- [ ] 移动端显示正常
- [ ] 浏览器控制台无错误

#### 4️⃣ 提升到生产环境

测试通过后，手动提升到生产环境：

```bash
# 备份当前生产环境
sudo cp -r /var/www/ainanfeng-blog /var/www/ainanfeng-blog-backup-$(date +%Y%m%d-%H%M%S)

# 替换生产环境
sudo rm -rf /var/www/ainanfeng-blog/*
sudo cp -r /var/www/ainanfeng-blog/gray/* /var/www/ainanfeng-blog/
sudo chown -R www-data:www-data /var/www/ainanfeng-blog/

# 验证生产环境
curl -s -o /dev/null -w "%{http_code}\n" https://ainanfeng.cn/
curl -s -o /dev/null -w "%{http_code}\n" https://ainanfeng.cn/ai-learning-roadmap.html
```

## 🔧 Nginx 配置

需要在服务器上配置 Nginx 支持 `/gray/` 路径：

```nginx
server {
    listen 80;
    server_name ainanfeng.cn;
    root /var/www/ainanfeng-blog;
    
    # 生产环境
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    # 灰度测试环境
    location /gray/ {
        alias /var/www/ainanfeng-blog/gray/;
        try_files $uri $uri/ /gray/index.html;
    }
}
```

配置后重载 Nginx：
```bash
sudo nginx -t
sudo systemctl reload nginx
```

## 📁 目录结构

```
/var/www/ainanfeng-blog/
├── index.html                    # 生产环境首页
├── ai-learning-roadmap.html      # 生产环境路线图
├── posts/                        # 生产环境文章
├── ai-learning/                  # 生产环境学习文档
└── gray/                         # 灰度测试环境
    ├── index.html                # 灰度首页
    ├── ai-learning-roadmap.html  # 灰度路线图
    ├── posts/                    # 灰度文章
    └── ai-learning/              # 灰度学习文档
```

## 🛠️ 可用脚本

| 脚本 | 用途 | 命令 |
|------|------|------|
| `deploy-gray-simple.sh` | 部署到灰度环境 | `./scripts/deploy-gray-simple.sh feature-name` |
| `backup.sh` | 备份生产环境 | `./scripts/backup.sh` |
| `health-check.sh` | 健康检查 | `./scripts/health-check.sh` |

## 📊 实战示例：订阅功能灰度测试

### 场景
开发订阅功能，需要确保不影响现有路线图页面。

### 步骤

**1. 开发阶段**
```bash
# 修改 ai-learning-roadmap.md 添加订阅卡片
# 修改 AILearningRoadmap.vue 添加导航逻辑
```

**2. 部署灰度**
```bash
./scripts/deploy-gray-simple.sh subscribe-feature
```

**3. 灰度测试**
```bash
# 访问测试
https://ainanfeng.cn/gray/ai-learning-roadmap.html

# 验证原有功能
- 点击【符号主义】→ 正常跳转 ✓
- 点击【预训练】→ 正常跳转 ✓
- 点击其他所有标签 → 全部正常 ✓

# 验证新功能
- 订阅卡片显示 ✓
- 弹窗功能正常 ✓
- 二维码显示正常 ✓
```

**4. 提升生产**
```bash
# 备份
sudo cp -r /var/www/ainanfeng-blog /var/www/ainanfeng-blog-backup-20260416

# 替换
sudo rm -rf /var/www/ainanfeng-blog/*
sudo cp -r /var/www/ainanfeng-blog/gray/* /var/www/ainanfeng-blog/
sudo chown -R www-data:www-data /var/www/ainanfeng-blog/

# 验证
curl https://ainanfeng.cn/ai-learning-roadmap.html
```

## 🚨 回滚方案

如果生产环境出现问题，立即回滚：

```bash
# 1. 找到最近的备份
ls -lt /var/www/ainanfeng-blog-backup-* | head -1

# 2. 恢复备份
BACKUP_DIR="/var/www/ainanfeng-blog-backup-20260416-003000"
sudo systemctl stop nginx
sudo rm -rf /var/www/ainanfeng-blog/*
sudo cp -r $BACKUP_DIR/* /var/www/ainanfeng-blog/
sudo chown -R www-data:www-data /var/www/ainanfeng-blog/
sudo systemctl start nginx

# 3. 验证恢复
curl -s -o /dev/null -w "%{http_code}\n" https://ainanfeng.cn/
```

## 💡 最佳实践

1. **小步快跑**: 每次只测试一个小功能
2. **充分测试**: 灰度环境至少测试 24 小时
3. **必做备份**: 提升前必须备份生产环境
4. **监控日志**: 关注 Umami 统计和浏览器控制台
5. **记录文档**: 在 `memory/YYYY-MM-DD.md` 记录每次更新
6. **用户反馈**: 收集早期使用者的反馈意见

## 📝 检查清单

### 开发完成时
- [ ] 代码已提交到 git
- [ ] 本地测试通过
- [ ] 无 console 错误

### 灰度部署后
- [ ] 访问 `/gray/` 所有页面
- [ ] 测试所有原有功能
- [ ] 测试所有新功能
- [ ] 移动端适配检查
- [ ] 性能测试（加载速度）

### 提升生产前
- [ ] 灰度测试至少 24 小时
- [ ] 无用户报告问题
- [ ] 已备份生产环境
- [ ] 准备回滚方案

### 提升生产后
- [ ] 验证生产环境所有页面
- [ ] 监控 Umami 统计数据
- [ ] 关注用户反馈
- [ ] 保留备份至少 7 天

---

*最后更新：2026-04-16*  
*维护者：旺财 🐕*
