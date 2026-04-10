#!/bin/bash
# 南风博客 - Docker 部署脚本
# 一键构建并部署到生产环境

set -e

echo "============================================================"
echo "🐳 南风博客 - Docker 部署脚本"
echo "============================================================"
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

# 配置
DOCKER_IMAGE="nanfeng2021/ainanfeng-blog"
CONTAINER_NAME="nanfeng-blog"
PORT="8080:80"

# 检查 Docker
if ! command -v docker &> /dev/null; then
    echo "❌ 未找到 Docker，请先安装 Docker"
    exit 1
fi

echo "🐳 Docker 版本："
docker --version

echo ""
echo "🔨 开始部署..."

# 停止旧容器
echo ""
echo "🛑 停止旧容器（如果存在）..."
docker stop $CONTAINER_NAME 2>/dev/null || true
docker rm $CONTAINER_NAME 2>/dev/null || true

# 构建镜像
echo ""
echo "🏗️  构建 Docker 镜像..."
docker build -t $DOCKER_IMAGE .

# 启动新容器
echo ""
echo "🚀 启动新容器..."
docker run -d \
  --name $CONTAINER_NAME \
  -p $PORT \
  --restart unless-stopped \
  $DOCKER_IMAGE

# 等待容器启动
echo ""
echo "⏳ 等待容器启动..."
sleep 3

# 健康检查
echo ""
echo "🏥 执行健康检查..."
if docker exec $CONTAINER_NAME wget --quiet --tries=1 --spider http://localhost/health; then
    echo "✅ 健康检查通过！"
else
    echo "⚠️  健康检查失败，查看日志："
    docker logs $CONTAINER_NAME
    exit 1
fi

# 显示访问地址
echo ""
echo "============================================================"
echo "✨ 部署成功！"
echo "============================================================"
echo ""
echo "🌐 访问地址：http://localhost:$PORT"
echo "📊 查看日志：docker logs -f $CONTAINER_NAME"
echo "🛑 停止服务：docker stop $CONTAINER_NAME"
echo "🔄 重启服务：docker restart $CONTAINER_NAME"
echo ""
echo "💡 如需部署到远程服务器："
echo "   1. docker save $DOCKER_IMAGE | ssh user@host docker load"
echo "   2. ssh user@host \"docker run -d --name $CONTAINER_NAME -p 80:80 $DOCKER_IMAGE\""
echo ""
