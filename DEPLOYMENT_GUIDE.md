# 🚀 南风博客部署指南

> 完整的生产环境部署流程，包含 Docker、Nginx 反向代理和 GitHub 推送

---

## 📋 目录

1. [本地测试](#本地测试)
2. [推送到 GitHub](#推送到-github)
3. [服务器部署](#服务器部署)
4. [Nginx 反向代理配置](#nginx-反向代理配置)
5. [HTTPS 配置（可选）](#https-配置可选)
6. [监控与维护](#监控与维护)

---

## 🧪 本地测试

### 1. 启动所有服务

```bash
cd /root/.openclaw/workspace/blog

# 方式一：使用 Docker Compose（推荐）
docker compose --profile with-rag --profile with-fall-detection up -d

# 方式二：使用启动脚本
./start-all.sh
```

### 2. 验证服务状态

```bash
# 查看所有容器状态
docker compose ps

# 查看日志
docker compose logs -f

# 健康检查
curl http://localhost:8080/health
```

### 3. 访问测试

**直接访问各服务：**
- 博客：http://localhost:8080
- RAG: http://localhost:7860
- 摔倒检测：http://localhost:8501

**通过 Nginx 统一入口：**
- 博客：http://localhost/
- RAG: http://localhost/rag/
- 摔倒检测：http://localhost/fall-detection/

---

## 📤 推送到 GitHub

### 1. 配置 Git（首次）

```bash
cd /root/.openclaw/workspace/blog

# 配置用户信息（如未配置）
git config user.name "nanfeng2021"
git config user.email "your-email@example.com"
```

### 2. 关联远程仓库

```bash
# 添加远程仓库（如已关联可跳过）
git remote add origin https://github.com/nanfeng2021/blog.git

# 或 SSH 方式
git remote set-url origin git@github.com:nanfeng2021/blog.git
```

### 3. 推送代码

```bash
# 提交所有更改
git add .
git commit -m "feat: 集成摔倒检测系统 + Nginx 反向代理"

# 推送到主分支
git push origin main

# 或推送到特定分支
git push origin feature/fall-detection
```

### 4. 触发 CI/CD

推送后自动触发 GitHub Actions：
- ✅ 代码检查
- ✅ 构建测试
- ✅ Docker 镜像构建
- ✅ 自动部署（如配置）

查看流水线状态：https://github.com/nanfeng2021/blog/actions

---

## 🖥️ 服务器部署

### 前置要求

- Ubuntu 20.04+ / Debian 10+
- Docker 20.10+
- Docker Compose 2.0+
- Nginx 1.18+（如不使用 Docker Nginx）

### 方案一：Docker Compose 部署（推荐）

```bash
# 1. 克隆项目
git clone https://github.com/nanfeng2021/blog.git
cd blog

# 2. 启动所有服务
docker compose --profile with-rag --profile with-fall-detection up -d

# 3. 查看状态
docker compose ps

# 4. 查看日志
docker compose logs -f fall-detection
```

### 方案二：手动部署

```bash
# 1. 安装依赖
apt update && apt install -y nginx python3-pip nodejs npm

# 2. 部署博客
cd /var/www
git clone https://github.com/nanfeng2021/blog.git
cd blog
npm install
npm run build

# 3. 配置 Nginx
cp nginx.conf /etc/nginx/sites-available/blog
ln -s /etc/nginx/sites-available/blog /etc/nginx/sites-enabled/
nginx -t && systemctl restart nginx

# 4. 启动 Python 服务
cd projects/fall-detection
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
nohup streamlit run app_optimized.py --server.port 8501 &
```

---

## 🔀 Nginx 反向代理配置

### 已配置的服务路由

| 路径 | 后端服务 | 端口 |
|------|----------|------|
| `/` | 博客前端 | 80 (内部) |
| `/rag/` | RAG 知识库 | 7860 |
| `/emotion/` | 情感分析 | 8001 |
| `/tetris/` | AI 俄罗斯方块 | 5000 |
| `/fall-detection/` | 摔倒检测 | 8501 |

### Nginx 配置说明

```nginx
# 摔倒检测代理配置示例
location /fall-detection/ {
    proxy_pass http://nanfeng-fall-detection:8501/;
    
    # WebSocket 支持（Streamlit 需要）
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    
    # 标准代理头
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    
    # 超时设置
    proxy_read_timeout 300s;
    proxy_connect_timeout 75s;
    
    # 禁用缓冲（实时应用需要）
    proxy_buffering off;
}
```

### 测试 Nginx 配置

```bash
# 检查配置语法
nginx -t

# 重载配置
systemctl reload nginx

# 或重启 Nginx
systemctl restart nginx
```

---

## 🔒 HTTPS 配置（可选）

### 使用 Let's Encrypt

```bash
# 安装 Certbot
apt install certbot python3-certbot-nginx

# 获取证书
certbot --nginx -d ainanfeng.cn -d www.ainanfeng.cn

# 自动续期（已自动添加 cron）
certbot renew --dry-run
```

### 强制 HTTPS 重定向

在 Nginx 配置中添加：

```nginx
server {
    listen 80;
    server_name ainanfeng.cn www.ainanfeng.cn;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl;
    server_name ainanfeng.cn www.ainanfeng.cn;
    
    ssl_certificate /etc/letsencrypt/live/ainanfeng.cn/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/ainanfeng.cn/privkey.pem;
    
    # ... 其他配置
}
```

---

## 📊 监控与维护

### 健康检查

```bash
# 检查所有服务
curl http://localhost/health
curl http://localhost:7860/health
curl http://localhost:8501/_stcore/health

# 查看容器资源占用
docker stats

# 查看日志
docker compose logs -f
```

### 备份数据

```bash
# 备份脚本示例
#!/bin/bash
BACKUP_DIR="/backup/blog-$(date +%Y%m%d)"
mkdir -p $BACKUP_DIR

# 备份 RAG 数据
cp -r /root/.openclaw/workspace/rag-knowledge-base/data $BACKUP_DIR/rag-data

# 备份数据库（如有）
docker compose exec umami-db pg_dump -U umami > $BACKUP_DIR/umami.sql

# 压缩备份
tar -czf $BACKUP_DIR.tar.gz $BACKUP_DIR
rm -rf $BACKUP_DIR
```

### 更新部署

```bash
# 拉取最新代码
git pull origin main

# 重建并重启
docker compose down
docker compose build --no-cache
docker compose --profile with-rag --profile with-fall-detection up -d

# 清理旧镜像
docker image prune -f
```

---

## 🆘 故障排查

### 常见问题

**1. 服务无法访问**
```bash
# 检查容器状态
docker compose ps

# 检查端口占用
netstat -tulpn | grep :8501

# 查看日志
docker compose logs fall-detection
```

**2. Nginx 代理失败**
```bash
# 检查 Nginx 配置
nginx -t

# 检查后端服务
curl http://localhost:8501

# 查看 Nginx 日志
tail -f /var/log/nginx/error.log
```

**3. WebSocket 连接失败**
```bash
# 确保 Nginx 配置了 WebSocket 支持
# 检查 proxy_set_header Upgrade 和 Connection
```

---

## 📞 支持

- **GitHub Issues**: https://github.com/nanfeng2021/blog/issues
- **在线文档**: https://ainanfeng.cn/docs/deployment
- **邮件联系**: your-email@example.com

---

**🎉 部署完成！祝你使用愉快！**

*最后更新：2026-04-12*
