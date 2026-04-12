# 🔒 HTTPS 配置指南 - 南风博客

## 📋 前置检查

在开始之前，请确认：
- ✅ 你已登录到服务器（腾讯云 VM-0-9-ubuntu）
- ✅ 域名 `ainanfeng.cn` 和 `www.ainanfeng.cn` 已解析到服务器 IP
- ✅ Nginx 正在运行并托管你的博客

---

## 🚀 步骤 1: 安装 Certbot

```bash
# 更新包列表
sudo apt update

# 安装 Certbot 和 Nginx 插件
sudo apt install certbot python3-certbot-nginx -y
```

---

## 🚀 步骤 2: 获取 SSL 证书

### 方式 A: 自动配置（推荐）

```bash
# 一条命令搞定所有
sudo certbot --nginx -d ainanfeng.cn -d www.ainanfeng.cn
```

**Certbot 会自动：**
1. 验证域名所有权
2. 获取证书
3. 修改 Nginx 配置
4. 询问是否重定向 HTTP → HTTPS（选 **2** 或 **Yes**）

### 方式 B: 手动配置（如果自动失败）

```bash
# 仅获取证书，不自动修改配置
sudo certbot certonly --nginx -d ainanfeng.cn -d www.ainanfeng.cn
```

然后手动编辑 Nginx 配置（见步骤 3）。

---

## 🚀 步骤 3: 验证 Nginx 配置

Certbot 自动配置后，检查 `/etc/nginx/sites-available/default` 或你的站点配置文件：

```nginx
server {
    listen 443 ssl http2;
    server_name ainanfeng.cn www.ainanfeng.cn;

    ssl_certificate /etc/letsencrypt/live/ainanfeng.cn/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/ainanfeng.cn/privkey.pem;

    # SSL 优化配置
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;

    root /root/.openclaw/workspace/blog/docs/.vitepress/dist;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    # 静态资源缓存
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|woff|woff2)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}

# HTTP 自动重定向到 HTTPS
server {
    listen 80;
    server_name ainanfeng.cn www.ainanfeng.cn;
    return 301 https://$host$request_uri;
}
```

---

## 🚀 步骤 4: 测试并重载 Nginx

```bash
# 测试配置是否正确
sudo nginx -t

# 如果测试通过，重载 Nginx
sudo systemctl reload nginx
```

---

## 🚀 步骤 5: 验证 HTTPS

### 方法 1: 浏览器访问
```
https://ainanfeng.cn
```
应该看到绿色小锁图标。

### 方法 2: 命令行测试
```bash
curl -I https://ainanfeng.cn
```
应该返回 `HTTP/2 200`。

### 方法 3: 检查重定向
```bash
curl -I http://ainanfeng.cn
```
应该返回 `301 Moved Permanently` 并重定向到 HTTPS。

### 方法 4: 在线检测工具
访问以下网站进行深度检测：
- 🔗 https://www.ssllabs.com/ssltest/ （SSL Labs 评级）
- 🔗 https://cryptcheck.fr/ （加密配置检查）

**目标：获得 A 或 A+ 评级**

---

## 🔄 证书自动续期

Let's Encrypt 证书有效期为 90 天，Certbot 会自动设置定时任务续期。

### 验证自动续期
```bash
# 查看定时器
sudo systemctl list-timers | grep certbot

# 手动测试续期（干跑模式，不会实际续期）
sudo certbot renew --dry-run
```

### 如果需要手动续期
```bash
sudo certbot renew
sudo systemctl reload nginx
```

---

## ⚠️ 常见问题排查

### 问题 1: 端口 80 被占用
```bash
# 检查谁在用 80 端口
sudo lsof -i :80

# 如果是其他 Nginx 配置冲突
sudo nginx -t
sudo systemctl status nginx
```

### 问题 2: 域名验证失败
确保 DNS 已正确解析：
```bash
# 检查 A 记录
dig ainanfeng.cn
dig www.ainanfeng.cn

# 应该返回你的服务器 IP: 43.134.43.119
```

### 问题 3: 混合内容警告
如果 HTTPS 页面加载了 HTTP 资源，浏览器会显示警告。

**解决方法：**
1. 检查所有资源链接使用 `https://` 或相对路径
2. 在 Nginx 中添加 CSP 头：
```nginx
add_header Content-Security-Policy "upgrade-insecure-requests";
```

---

## 📊 完成后检查清单

- [ ] HTTPS 可以正常访问
- [ ] HTTP 自动重定向到 HTTPS
- [ ] SSL Labs 评级达到 A 或以上
- [ ] 浏览器无安全警告
- [ ] 证书自动续期已配置

---

## 🎯 下一步

HTTPS 配置完成后，继续：
1. ✅ 上传 sitemap.xml 到服务器
2. ✅ 上传 robots.txt 到服务器
3. ✅ 提交到 Google Search Console
4. ✅ 提交到百度站长平台

---

**预计用时:** 30 分钟  
**难度:** ⭐⭐☆☆☆（简单）

遇到问题随时问我！🐕
