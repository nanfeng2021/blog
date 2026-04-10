# 🚀 南风博客 - 部署指南

_完整部署流程，从本地开发到生产环境_

---

## 📋 前置要求

### 系统要求

- Node.js >= 20.0.0
- npm >= 9.0.0
- Git
- Docker（可选，用于容器化部署）

### 检查环境

```bash
# 检查 Node.js
node --version  # 应该 >= v20.0.0

# 检查 npm
npm --version   # 应该 >= 9.0.0

# 检查 Git
git --version

# 检查 Docker（可选）
docker --version
```

---

## 🏠 本地开发部署

### 1. 克隆项目

```bash
git clone https://github.com/nanfeng2021/blog.git
cd blog
```

### 2. 安装依赖

```bash
npm install
```

### 3. 启动开发服务器

```bash
npm run dev
```

访问：http://localhost:5173

### 4. 构建生产版本

```bash
npm run build
```

构建产物在：`docs/.vitepress/dist/`

### 5. 预览生产构建

```bash
npm run preview
```

访问：http://localhost:4173

### 6. 运行测试

```bash
# 安装 Playwright 浏览器（首次使用）
npx playwright install

# 运行所有测试
npm test

# 运行特定浏览器测试
npx playwright test --project=chromium

# 带 UI 运行
npm run test:ui

# 调试模式
npm run test:debug
```

---

## 🐳 Docker 部署（推荐生产环境）

### 方式一：使用 docker-compose（最简单）

```bash
# 一键启动所有服务
docker-compose up -d

# 查看日志
docker-compose logs -f blog

# 停止服务
docker-compose down

# 重建并重启
docker-compose up -d --build
```

访问：http://localhost:8080

### 方式二：手动 Docker 部署

```bash
# 1. 构建镜像
docker build -t nanfeng2021/ainanfeng-blog:latest .

# 2. 运行容器
docker run -d \
  --name nanfeng-blog \
  -p 8080:80 \
  --restart unless-stopped \
  nanfeng2021/ainanfeng-blog:latest

# 3. 查看日志
docker logs -f nanfeng-blog

# 4. 健康检查
curl http://localhost:8080/health

# 5. 停止服务
docker stop nanfeng-blog
docker rm nanfeng-blog
```

### 方式三：使用部署脚本

```bash
# 一键 Docker 部署
./scripts/deploy-docker.sh

# 健康检查
./scripts/health-check.sh
```

---

## ☁️ 云服务器部署

### 腾讯云轻量应用服务器

#### 1. 安装 Docker

```bash
# 更新系统
sudo apt update && sudo apt upgrade -y

# 安装 Docker
curl -fsSL https://get.docker.com | sh

# 启动 Docker
sudo systemctl start docker
sudo systemctl enable docker

# 验证安装
docker --version
```

#### 2. 部署博客

```bash
# 拉取镜像
docker pull nanfeng2021/ainanfeng-blog:latest

# 运行容器
docker run -d \
  --name nanfeng-blog \
  -p 80:80 \
  --restart unless-stopped \
  nanfeng2021/ainanfeng-blog:latest
```

#### 3. 配置域名和 HTTPS

```bash
# 安装 Nginx（如果需要反向代理）
sudo apt install nginx -y

# 配置 Nginx
sudo nano /etc/nginx/sites-available/ainanfeng.cn
```

Nginx 配置示例：

```nginx
server {
    listen 80;
    server_name ainanfeng.cn www.ainanfeng.cn;
    
    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

启用站点：

```bash
sudo ln -s /etc/nginx/sites-available/ainanfeng.cn /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

#### 4. 配置 HTTPS（Let's Encrypt）

```bash
# 安装 Certbot
sudo apt install certbot python3-certbot-nginx -y

# 获取证书
sudo certbot --nginx -d ainanfeng.cn -d www.ainanfeng.cn

# 自动续期
sudo crontab -e
# 添加：0 3 * * * certbot renew --quiet
```

---

## 🔄 CI/CD 自动部署

### GitHub Actions 配置

项目已包含完整的 CI/CD 流水线：`.github/workflows/ci-cd.yml`

#### 触发条件

- **Push 到 main**: 运行 lint、build、test
- **Pull Request**: 运行完整 CI + 预览部署
- **Tag (v*)**: 构建 Docker 镜像并推送，创建 GitHub Release
- **每周一凌晨 2 点**: 定时完整检查

#### 配置 Secrets

在 GitHub 仓库设置中添加以下 Secrets：

1. 进入：Settings → Secrets and variables → Actions
2. 点击：New repository secret
3. 添加：

| Name | Value |
|------|-------|
| `DOCKERHUB_USERNAME` | 你的 Docker Hub 用户名 |
| `DOCKERHUB_TOKEN` | Docker Hub access token |

#### 手动触发部署

1. 进入 GitHub Actions 页面
2. 选择 "Blog CI/CD Pipeline"
3. 点击 "Run workflow"
4. 选择分支和选项
5. 点击 "Run workflow"

---

## 📊 监控与维护

### 健康检查

```bash
# 使用脚本
./scripts/health-check.sh

# 手动检查
curl http://localhost:8080/health

# 查看容器状态
docker ps
docker stats nanfeng-blog
```

### 日志查看

```bash
# Docker 日志
docker logs -f nanfeng-blog

# 最近 100 行
docker logs --tail 100 nanfeng-blog

# 带时间戳
docker logs -f --timestamps nanfeng-blog
```

### 备份数据

```bash
# 创建备份
./scripts/backup.sh

# 备份位置
ls -lh /root/backups/blog/

# 恢复备份
cd /root/backups/blog
tar -xzf blog_backup_YYYYMMDD_HHMMSS.tar.gz -C /root/.openclaw/workspace/blog
```

### 更新部署

```bash
# 1. 拉取最新代码
cd /root/.openclaw/workspace/blog
git pull origin main

# 2. 重新构建
npm run build

# 3. 重启服务
# Docker 方式
docker-compose up -d --build

# 或直接重启
docker restart nanfeng-blog
```

---

## 🎯 性能优化建议

### 1. 启用 CDN

```nginx
# Nginx 配置中添加
location ~* \.(jpg|jpeg|png|gif|ico|css|js)$ {
    expires 1y;
    add_header Cache-Control "public, immutable";
}
```

### 2. 启用 Gzip 压缩

已在 `nginx.conf` 中配置：

```nginx
gzip on;
gzip_types text/plain text/css application/json application/javascript text/xml application/xml;
gzip_min_length 1024;
```

### 3. 图片优化

```bash
# 安装 imagemin
npm install -D imagemin-cli

# 压缩图片
imagemin docs/public/* --out-dir=docs/public/optimized
```

---

## 🐛 故障排查

### 问题 1：端口被占用

```bash
# 查看端口占用
sudo lsof -i :8080

# 停止占用端口的进程
sudo kill -9 <PID>

# 或修改端口
docker run -p 8081:80 ...
```

### 问题 2：构建失败

```bash
# 清理缓存
rm -rf node_modules package-lock.json docs/.vitepress/cache

# 重新安装
npm install

# 重新构建
npm run build
```

### 问题 3：Docker 容器无法启动

```bash
# 查看日志
docker logs nanfeng-blog

# 进入容器调试
docker exec -it nanfeng-blog /bin/sh

# 重新创建容器
docker rm -f nanfeng-blog
docker run -d --name nanfeng-blog -p 8080:80 nanfeng2021/ainanfeng-blog:latest
```

### 问题 4：测试失败

```bash
# 查看详细错误
npx playwright test --reporter=list

# 截图和录像位置
ls -la playwright-report/
ls -la test-results/

# 单步调试
npx playwright test --debug
```

---

## 📞 获取帮助

- **GitHub Issues**: [提交问题](https://github.com/nanfeng2021/blog/issues)
- **博客首页**: [https://ainanfeng.cn](https://ainanfeng.cn)
- **文档**: [HARNESS_COMPLIANCE.md](HARNESS_COMPLIANCE.md)

---

## 📝 快速参考卡片

```bash
# =====================
# 本地开发
# =====================
npm install          # 安装依赖
npm run dev          # 开发服务器
npm run build        # 构建
npm run preview      # 预览
npm test             # 测试

# =====================
# Docker 部署
# =====================
docker-compose up -d              # 启动
docker-compose down               # 停止
docker-compose logs -f            # 日志
docker-compose restart            # 重启

# =====================
# 运维脚本
# =====================
./scripts/health-check.sh         # 健康检查
./scripts/backup.sh               # 备份
./scripts/deploy-docker.sh        # Docker 部署

# =====================
# 监控
# =====================
docker stats                      # 资源使用
docker logs -f nanfeng-blog       # 日志
curl http://localhost:8080/health # 健康检查
```

---

**维护者**: 南风  
**助手**: 旺财 🐕  
**最后更新**: 2026-04-10  
**版本**: v1.0.0
