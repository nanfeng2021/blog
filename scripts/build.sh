#!/bin/bash
# 南风博客 - 构建脚本
# 用于本地构建和 CI/CD

set -e

echo "============================================================"
echo "🔨 南风博客 - 构建脚本"
echo "============================================================"
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

# 检查 Node.js
if ! command -v node &> /dev/null; then
    echo "❌ 未找到 Node.js，请先安装 Node.js 20+"
    exit 1
fi

echo "📦 Node.js 版本："
node --version

echo ""
echo "📦 NPM 版本："
npm --version

echo ""
echo "🔨 开始构建..."

# 清理旧的构建产物
if [ -d "docs/.vitepress/dist" ]; then
    echo "🧹 清理旧的构建产物..."
    rm -rf docs/.vitepress/dist
fi

# 安装依赖（如果缺失）
if [ ! -d "node_modules" ]; then
    echo "📥 安装依赖..."
    npm ci
else
    echo "✅ 依赖已存在"
fi

# 构建
echo ""
echo "🏗️  开始构建 VitePress 站点..."
npm run build

# 验证构建结果
echo ""
if [ -d "docs/.vitepress/dist" ]; then
    echo "✅ 构建成功！"
    echo ""
    echo "📊 构建产物大小："
    du -sh docs/.vitepress/dist/
    echo ""
    echo "📁 文件列表："
    ls -lh docs/.vitepress/dist/ | head -20
else
    echo "❌ 构建失败：dist 目录不存在"
    exit 1
fi

echo ""
echo "============================================================"
echo "✨ 构建完成！"
echo "============================================================"
echo ""
echo "💡 下一步操作："
echo "   - 本地预览：npm run preview"
echo "   - Docker 构建：docker-compose build"
echo "   - 部署到服务器：./deploy.sh"
echo ""
