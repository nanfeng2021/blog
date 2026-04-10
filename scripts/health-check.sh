#!/bin/bash
# 南风博客 - 健康检查脚本
# 用于监控博客服务状态

set -e

echo "============================================================"
echo "🏥 南风博客 - 健康检查"
echo "============================================================"
echo ""

# 配置
BLOG_URL="${BLOG_URL:-http://localhost:8080}"
TIMEOUT=5

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

check_service() {
    local name=$1
    local url=$2
    local expected_status=${3:-200}
    
    echo -n "检查 $name ... "
    
    if curl -f -s -o /dev/null -w "%{http_code}" --max-time $TIMEOUT "$url" | grep -q "$expected_status"; then
        echo -e "${GREEN}✅ OK${NC}"
        return 0
    else
        echo -e "${RED}❌ FAILED${NC}"
        return 1
    fi
}

# 检查博客服务
check_service "博客首页" "$BLOG_URL/" 200 || exit 1

# 检查健康端点
check_service "健康检查" "$BLOG_URL/health" 200 || true

# 检查文章页面
check_service "文章列表" "$BLOG_URL/posts/" 200 || true

# 检查关于页面
check_service "关于页面" "$BLOG_URL/about" 200 || true

# 检查 RAG 服务（如果存在）
if curl -f -s --max-time $TIMEOUT "http://localhost:7860" > /dev/null 2>&1; then
    check_service "RAG 知识库" "http://localhost:7860" 200 || true
else
    echo -e "${YELLOW}⚠️  RAG 服务未运行${NC}"
fi

# 检查情感分析服务（如果存在）
if curl -f -s --max-time $TIMEOUT "http://localhost:8001/health" > /dev/null 2>&1; then
    check_service "情感分析" "http://localhost:8001/health" 200 || true
else
    echo -e "${YELLOW}⚠️  情感分析服务未运行${NC}"
fi

echo ""
echo "============================================================"
echo "✨ 健康检查完成！"
echo "============================================================"
echo ""
