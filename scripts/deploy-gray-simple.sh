#!/bin/bash

# 简化的灰度测试部署脚本
# 用法：./deploy-gray.sh [feature-name]

set -e

FEATURE_NAME=${1:-"new-feature"}
DIST_DIR="docs/.vitepress/dist"
GRAY_DEPLOY_DIR="/var/www/ainanfeng-blog/gray"

echo "🚀 开始部署灰度测试环境..."
echo "📦 功能名称：$FEATURE_NAME"
echo ""

# 1. 正常构建生产版本
echo "🔨 步骤 1/4: 构建生产版本..."
npm run build

# 2. 创建灰度目录
echo "📁 步骤 2/4: 创建灰度目录..."
sudo mkdir -p "$GRAY_DEPLOY_DIR"

# 3. 复制文件到灰度目录
echo "📋 步骤 3/4: 复制文件到灰度目录..."
sudo cp -r "$DIST_DIR"/* "$GRAY_DEPLOY_DIR/"

# 4. 设置权限
echo "🔐 步骤 4/4: 设置文件权限..."
sudo chown -R www-data:www-data "$GRAY_DEPLOY_DIR"
sudo chmod -R 755 "$GRAY_DEPLOY_DIR"

echo ""
echo "✅ 灰度测试环境部署完成！"
echo ""
echo "======================================"
echo "🌐 访问地址（带 /gray/ 前缀）："
echo "  首页：https://ainanfeng.cn/gray/"
echo "  路线图：https://ainanfeng.cn/gray/ai-learning-roadmap.html"
echo "  订阅页：https://ainanfeng.cn/gray/subscribe.html"
echo "  文章列表：https://ainanfeng.cn/gray/posts/"
echo ""
echo "📝 下一步操作："
echo "  1. 访问灰度环境测试新功能"
echo "  2. 确认无误后，执行以下命令提升到生产："
echo "     sudo rm -rf /var/www/ainanfeng-blog/*"
echo "     sudo cp -r $GRAY_DEPLOY_DIR/* /var/www/ainanfeng-blog/"
echo "     sudo chown -R www-data:www-data /var/www/ainanfeng-blog/"
echo ""
echo "⚠️  注意："
echo "  - 灰度环境和生产环境使用相同的构建文件"
echo "  - 灰度环境通过 URL 路径 /gray/ 区分"
echo "  - 需要配置 Nginx 支持 /gray/ 路径"
echo "======================================"
echo ""
