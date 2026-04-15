#!/bin/bash

# 灰度测试部署脚本
# 用法：./deploy-gray.sh [feature-name]

set -e

FEATURE_NAME=${1:-"new-feature"}
GRAY_DIST="docs/.vitepress/dist"
DEPLOY_DIR="/var/www/ainanfeng-blog-gray"

echo "🚀 开始部署灰度测试环境..."
echo "📦 功能名称：$FEATURE_NAME"
echo ""

# 1. 构建灰度版本
echo "🔨 步骤 1/4: 构建灰度版本..."
npm run build:gray

# 2. 创建部署目录
echo "📁 步骤 2/4: 创建部署目录..."
sudo mkdir -p "$DEPLOY_DIR"

# 3. 复制文件
echo "📋 步骤 3/4: 复制文件到部署目录..."
sudo cp -r "$GRAY_DIST"/* "$DEPLOY_DIR/"

# 4. 设置权限
echo "🔐 步骤 4/4: 设置文件权限..."
sudo chown -R www-data:www-data "$DEPLOY_DIR"
sudo chmod -R 755 "$DEPLOY_DIR"

echo ""
echo "✅ 灰度测试环境部署完成！"
echo ""
echo "======================================"
echo "🌐 访问地址："
echo "  首页：https://ainanfeng.cn/gray/"
echo "  路线图：https://ainanfeng.cn/gray/ai-learning-roadmap.html"
echo "  订阅页：https://ainanfeng.cn/gray/subscribe.html"
echo ""
echo "📝 下一步操作："
echo "  1. 访问灰度环境测试新功能"
echo "  2. 确认无误后，执行 ./deploy-promote.sh 提升到生产环境"
echo "======================================"
echo ""
