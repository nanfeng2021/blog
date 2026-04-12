# 📋 博客运维操作规范

> **核心目标**: 时刻保证 https://ainanfeng.cn/ 正常访问

**最后更新**: 2026-04-12  
**执行人**: 旺财 🐕

---

## 🎯 核心原则

### 第一优先级
✅ **https://ainanfeng.cn/ 必须 24/7 可访问**

任何操作都不能影响博客主站的正常访问。

---

## 📁 关键文件位置

### Nginx 配置
```bash
配置文件：/etc/nginx/sites-available/ainanfeng-blog
启用链接：/etc/nginx/sites-enabled/ainanfeng-blog
静态文件：/var/www/ainanfeng-blog/
```

### SSL 证书
```bash
证书目录：/etc/letsencrypt/live/ainanfeng.cn/
自动续期：certbot renew --dry-run
```

### 博客源码
```bash
源码目录：/root/.openclaw/workspace/blog/
构建产物：/root/.openclaw/workspace/blog/docs/.vitepress/dist/
```

---

## 🔧 标准操作流程

### 1. 更新博客内容后

```bash
# ✅ 必须执行以下步骤

# 步骤 1: 构建博客
cd /root/.openclaw/workspace/blog
npm run build

# 步骤 2: 同步到 Nginx 目录
cp -r docs/.vitepress/dist/* /var/www/ainanfeng-blog/
chown -R www-data:www-data /var/www/ainanfeng-blog

# 步骤 3: 验证 Nginx 配置
/usr/sbin/nginx -t

# 步骤 4: 重载 Nginx
/usr/sbin/nginx -s reload

# 步骤 5: 验证访问
curl -I https://ainanfeng.cn/
# 应该返回 HTTP/1.1 200 OK
```

### 2. 修改 Nginx 配置后

```bash
# ✅ 必须执行以下步骤

# 步骤 1: 测试配置语法
/usr/sbin/nginx -t
# 必须看到 "syntax is ok" 和 "test is successful"

# 步骤 2: 重载配置
/usr/sbin/nginx -s reload

# 步骤 3: 验证所有服务
curl -I https://ainanfeng.cn/          # 博客主站
curl -I https://ainanfeng.cn/rag/      # RAG 知识库
curl -I https://ainanfeng.cn/emotion/  # 情感分析
curl -I https://ainanfeng.cn/tetris/   # AI 方块

# 步骤 4: 检查错误日志
tail -20 /var/log/nginx/error.log
# 不应该有新的错误
```

### 3. 系统重启后

```bash
# ✅ 必须检查以下服务

# 检查 Nginx 状态
systemctl status nginx
# 应该是 active (running)

# 如果未运行，启动 Nginx
systemctl start nginx

# 验证访问
curl -I https://ainanfeng.cn/

# 检查 SSL 证书状态
certbot certificates
# 确认证书未过期
```

---

## ⚠️ 禁止操作

### ❌ 绝对不要做的事

1. **不要删除或移动** `/var/www/ainanfeng-blog/` 目录
2. **不要停止 Nginx 服务**（除非必要且已安排维护窗口）
3. **不要修改** `/etc/nginx/sites-enabled/ainanfeng-blog` 而不测试
4. **不要在未备份的情况下** 修改 Nginx 配置
5. **不要让 SSL 证书过期**（确保自动续期正常）

### ❌ 危险命令

```bash
# 禁止直接执行
rm -rf /var/www/ainanfeng-blog/     # ❌ 删除网站文件
systemctl stop nginx                # ❌ 停止 Nginx
pkill nginx                         # ❌ 杀死 Nginx 进程
rm /etc/nginx/sites-enabled/*       # ❌ 删除 Nginx 配置
```

---

## 🔍 日常检查清单

### 每日检查（自动化）

```bash
#!/bin/bash
# 保存为 /root/.openclaw/workspace/scripts/blog-health-check.sh

# 检查 Nginx 状态
if ! systemctl is-active --quiet nginx; then
    echo "❌ Nginx 未运行！"
    systemctl start nginx
fi

# 检查 HTTPS 访问
if ! curl -sf https://ainanfeng.cn/ > /dev/null; then
    echo "❌ HTTPS 访问失败！"
    # 发送告警通知
fi

# 检查 SSL 证书有效期
cert_end=$(certbot certificates | grep "Valid Until" | awk '{print $4}')
days_left=$(( ($(date -d "$cert_end" +%s) - $(date +%s)) / 86400 ))

if [ $days_left -lt 14 ]; then
    echo "⚠️ SSL 证书将在 $days_left 天后过期！"
    certbot renew
fi

echo "✅ 博客健康检查完成"
```

### 每周检查

```bash
# 检查磁盘空间
df -h /var/www

# 检查 Nginx 日志
tail -100 /var/log/nginx/error.log | grep -v "deprecated"

# 检查系统更新
apt list --upgradable | grep nginx
```

### 每月检查

```bash
# 测试 SSL 证书续期
certbot renew --dry-run

# 清理旧日志
find /var/log/nginx -name "*.log" -mtime +30 -delete

# 备份配置文件
cp /etc/nginx/sites-available/ainanfeng-blog \
   /root/.openclaw/workspace/backups/nginx-$(date +%Y%m%d).conf
```

---

## 🚨 故障排查流程

### 问题 1: HTTPS 访问失败

```bash
# 步骤 1: 检查 Nginx 状态
systemctl status nginx

# 步骤 2: 检查端口监听
netstat -tulpn | grep :443
# 应该有 nginx 在监听 443 端口

# 步骤 3: 检查 Nginx 配置
/usr/sbin/nginx -t

# 步骤 4: 查看错误日志
tail -50 /var/log/nginx/error.log

# 步骤 5: 重启 Nginx
systemctl restart nginx

# 步骤 6: 验证访问
curl -I https://ainanfeng.cn/
```

### 问题 2: SSL 证书过期

```bash
# 步骤 1: 检查证书状态
certbot certificates

# 步骤 2: 手动续期
certbot renew --force-renewal

# 步骤 3: 重载 Nginx
/usr/sbin/nginx -s reload

# 步骤 4: 验证
curl -Iv https://ainanfeng.cn/ 2>&1 | grep "SSL certificate"
```

### 问题 3: 页面显示 403/404

```bash
# 步骤 1: 检查文件权限
ls -la /var/www/ainanfeng-blog/
# 应该是 www-data:www-data 所有者

# 步骤 2: 修复权限
chown -R www-data:www-data /var/www/ainanfeng-blog
chmod -R 755 /var/www/ainanfeng-blog

# 步骤 3: 检查文件是否存在
ls -la /var/www/ainanfeng-blog/index.html

# 步骤 4: 如果文件缺失，重新构建
cd /root/.openclaw/workspace/blog
npm run build
cp -r docs/.vitepress/dist/* /var/www/ainanfeng-blog/

# 步骤 5: 重载 Nginx
/usr/sbin/nginx -s reload
```

---

## 📊 监控指标

### 关键指标

| 指标 | 阈值 | 告警级别 |
|------|------|---------|
| HTTPS 可用性 | < 99.9% | 🔴 严重 |
| SSL 证书剩余天数 | < 14 天 | 🟡 警告 |
| Nginx CPU 使用率 | > 80% | 🟡 警告 |
| 磁盘使用率 | > 90% | 🔴 严重 |
| 错误日志增长率 | > 100 条/小时 | 🟡 警告 |

### 监控命令

```bash
# 检查可用性
curl -o /dev/null -s -w "%{http_code}\n" https://ainanfeng.cn/
# 应该返回 200

# 检查响应时间
curl -o /dev/null -s -w "%{time_total}s\n" https://ainanfeng.cn/
# 应该 < 1 秒

# 检查 SSL 证书
echo | openssl s_client -connect ainanfeng.cn:443 2>/dev/null | openssl x509 -noout -dates
```

---

## 🔄 变更管理

### 任何变更前

1. ✅ 备份当前配置
   ```bash
   cp /etc/nginx/sites-available/ainanfeng-blog \
      /root/.openclaw/workspace/backups/
   ```

2. ✅ 记录变更计划
   - 变更内容
   - 预期影响
   - 回滚方案

3. ✅ 选择低峰时段（如凌晨 2-4 点）

### 变更后

1. ✅ 立即验证 https://ainanfeng.cn/ 访问
2. ✅ 检查错误日志
3. ✅ 观察 15 分钟确认无异常

---

## 📞 应急联系

### 快速恢复脚本

```bash
#!/bin/bash
# /root/.openclaw/workspace/scripts/blog-emergency-restore.sh

echo "🚨 开始紧急恢复..."

# 1. 确保 Nginx 运行
systemctl start nginx

# 2. 从备份恢复
LATEST_BACKUP=$(ls -t /root/.openclaw/workspace/backups/nginx-*.conf | head -1)
if [ -n "$LATEST_BACKUP" ]; then
    cp $LATEST_BACKUP /etc/nginx/sites-available/ainanfeng-blog
    /usr/sbin/nginx -t && /usr/sbin/nginx -s reload
fi

# 3. 验证访问
if curl -sf https://ainanfeng.cn/ > /dev/null; then
    echo "✅ 博客已恢复！"
else
    echo "❌ 恢复失败，需要人工干预！"
fi
```

---

## ✅ 检查清单模板

### 每次操作后必查

- [ ] https://ainanfeng.cn/ 可访问
- [ ] HTTP 状态码为 200
- [ ] SSL 证书有效（浏览器显示安全锁）
- [ ] Nginx 错误日志无新增错误
- [ ] 所有反向代理服务正常（RAG/情感分析等）

---

**承诺**: 我将严格遵守此规范，确保 https://ainanfeng.cn/ 24/7 正常访问！🐕

*规范制定时间：2026-04-12*  
*下次审查时间：2026-05-12*
