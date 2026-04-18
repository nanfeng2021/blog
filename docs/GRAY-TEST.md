# 灰度测试流程文档

## 📋 概述

为确保新功能迭代时不影响现有用户，我们采用灰度测试机制：

- **生产环境**: `https://ainanfeng.cn/` - 稳定版本
- **灰度环境**: `https://ainanfeng.cn/gray/` - 新功能测试版本

## 🔄 工作流程

### 1. 开发新功能

```bash
# 在 docs/ 目录下开发新功能
# 例如：修改 AILearningRoadmap.vue
```

### 2. 构建灰度版本

```bash
# 方式一：使用 npm 脚本
npm run build:gray

# 方式二：手动指定 base 路径
VITEPRESS_BASE=/gray/ vitepress build docs
```

### 3. 部署到灰度环境

```bash
# 方式一：使用部署脚本
./scripts/deploy-gray.sh feature-name

# 方式二：手动部署
cp -r docs/.vitepress/dist/* /var/www/ainanfeng-blog-gray/
chown -R www-data:www-data /var/www/ainanfeng-blog-gray/
```

### 4. 测试验证

访问灰度环境进行测试：

- 首页：`https://ainanfeng.cn/gray/`
- 路线图：`https://ainanfeng.cn/gray/ai-learning-roadmap.html`
- 订阅页：`https://ainanfeng.cn/gray/subscribe.html`

**测试清单：**
- [ ] 所有原有功能正常工作
- [ ] 新功能按预期运行
- [ ] 页面加载速度正常
- [ ] 移动端适配正常
- [ ] 浏览器兼容性正常

### 5. 提升到生产环境

测试通过后，提升到生产环境：

```bash
# 方式一：使用提升脚本（推荐）
./scripts/deploy-promote.sh feature-name

# 方式二：手动提升
npm run build
cp -r docs/.vitepress/dist/* /var/www/ainanfeng-blog/
chown -R www-data:www-data /var/www/ainanfeng-blog/
```

### 6. 生产验证

提升后再次验证生产环境：

```bash
curl -s -o /dev/null -w "%{http_code}\n" https://ainanfeng.cn/
curl -s -o /dev/null -w "%{http_code}\n" https://ainanfeng.cn/ai-learning-roadmap.html
```

## 🛠️ 可用脚本

| 脚本 | 用途 | 命令 |
|------|------|------|
| `build-gray.sh` | 构建灰度版本 | `./scripts/build-gray.sh feature-name` |
| `deploy-gray.sh` | 部署到灰度环境 | `./scripts/deploy-gray.sh feature-name` |
| `deploy-promote.sh` | 提升到生产环境 | `./scripts/deploy-promote.sh feature-name` |

## 📁 目录结构

```
blog/
├── docs/                      # 源代码
│   ├── .vitepress/
│   │   ├── dist/             # 生产构建输出
│   │   ├── gray/             # 灰度配置文件
│   │   └── theme/            # 主题组件
│   ├── ai-learning-roadmap.md
│   └── ...
├── scripts/
│   ├── build-gray.sh         # 灰度构建脚本
│   ├── deploy-gray.sh        # 灰度部署脚本
│   └── deploy-promote.sh     # 生产提升脚本
└── package.json
```

## 🚨 回滚方案

如果生产环境出现问题，立即回滚：

```bash
# 1. 找到最近的备份
ls -lt /var/www/ainanfeng-blog-backup-* | head -1

# 2. 恢复备份
BACKUP_DIR="/var/www/ainanfeng-blog-backup-20260416-003000"
sudo cp -r $BACKUP_DIR/* /var/www/ainanfeng-blog/
sudo chown -R www-data:www-data /var/www/ainanfeng-blog/

# 3. 验证恢复
curl -s -o /dev/null -w "%{http_code}\n" https://ainanfeng.cn/
```

## 💡 最佳实践

1. **小步快跑**: 每次只测试一个小功能，便于定位问题
2. **充分测试**: 灰度环境至少测试 24 小时再上线
3. **备份优先**: 提升前自动备份，确保可回滚
4. **监控日志**: 关注 Umami 统计和用户反馈
5. **文档记录**: 在 memory/YYYY-MM-DD.md 记录每次更新

## 📊 示例：订阅功能灰度测试

```bash
# 1. 开发订阅功能
# 编辑 ai-learning-roadmap.md 添加订阅卡片

# 2. 构建灰度版本
npm run build:gray

# 3. 部署到灰度环境
./scripts/deploy-gray.sh subscribe-feature

# 4. 测试验证
# 访问 https://ainanfeng.cn/gray/ai-learning-roadmap.html
# 检查订阅卡片、弹窗、二维码等功能

# 5. 提升到生产环境
./scripts/deploy-promote.sh subscribe-feature

# 6. 生产验证
# 访问 https://ainanfeng.cn/ai-learning-roadmap.html
# 确认所有功能正常
```

---

*最后更新：2026-04-16*
