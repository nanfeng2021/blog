#!/bin/bash

# 生产环境提升脚本
# 用法：./deploy-promote.sh [feature-name]

set -e

FEATURE_NAME=${1:-"new-feature"}
GRAY_DIST="docs/.vitepress/dist"
PROD_DEPLOY_DIR="/var/www/ainanfeng-blog"
BACKUP_DIR="/var/www/ainanfeng-blog-backup-$(date +%Y%m%d-%H%M%S)"

echo "🚀 开始将灰度测试版本提升到生产环境..."
echo "📦 功能名称：$FEATURE_NAME"
echo ""

# 确认提示
echo "⚠️  警告：此操作将替换生产环境文件！"
echo ""
read -p "是否继续？(y/N): " confirm
if [[ ! $confirm =~ ^[Yy]$ ]]; then
    echo "❌ 操作已取消"
    exit 0
fi

# 1. 备份当前生产环境
echo "💾 步骤 1/5: 备份当前生产环境..."
echo "   备份到：$BACKUP_DIR"
sudo cp -r "$PROD_DEPLOY_DIR" "$BACKUP_DIR"

# 2. 重新构建生产版本
echo "🔨 步骤 2/5: 构建生产版本..."
npm run build

# 3. 部署到生产环境
echo "📋 步骤 3/5: 部署到生产环境..."
sudo cp -r "$GRAY_DIST"/* "$PROD_DEPLOY_DIR/"

# 4. 设置权限
echo "🔐 步骤 4/5: 设置文件权限..."
sudo chown -R www-data:www-data "$PROD_DEPLOY_DIR"
sudo chmod -R 755 "$PROD_DEPLOY_DIR"

# 5. 验证部署
echo "✅ 步骤 5/5: 验证部署..."
echo ""
echo "正在检查关键页面..."
curl -s -o /dev/null -w "首页：%{http_code}\n" "https://ainanfeng.cn/" || true
curl -s -o /dev/null -w "路线图：%{http_code}\n" "https://ainanfeng.cn/ai-learning-roadmap.html" || true
curl -s -o /dev/null -w "文章列表：%{http_code}\n" "https://ainanfeng.cn/posts/" || true

echo ""
echo "======================================"
echo "✅ 生产环境更新完成！"
echo ""
echo "🌐 访问地址："
echo "  首页：https://ainanfeng.cn/"
echo "  路线图：https://ainanfeng.cn/ai-learning-roadmap.html"
echo ""
echo "💾 备份位置："
echo "  $BACKUP_DIR"
echo ""
echo "🔄 如需回滚，执行："
echo "  sudo cp -r $BACKUP_DIR/* $PROD_DEPLOY_DIR/"
echo "======================================"
echo ""
