#!/bin/bash
# 南风博客 - 一键启动所有服务
# 包括：博客服务 + RAG 知识库服务

echo "============================================================"
echo "🚀 南风博客 - 一键启动所有服务"
echo "============================================================"
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RAG_DIR="/root/.openclaw/workspace/rag-knowledge-base"

# 检查并启动 RAG 服务
echo "📊 检查 RAG 知识库服务..."
if ! curl -s http://localhost:7860 > /dev/null 2>&1; then
    echo "   ⚠️  RAG 服务未运行，正在启动..."
    
    if [ -d "$RAG_DIR/venv" ]; then
        cd "$RAG_DIR"
        source venv/bin/activate
        nohup python3 scripts/web_ui_simple.py > logs/rag-web.log 2>&1 &
        echo "   ✓ RAG 服务已启动 (端口：7860)"
        echo "   📝 日志：$RAG_DIR/logs/rag-web.log"
    else
        echo "   ❌ RAG 虚拟环境不存在，请先运行："
        echo "      cd $RAG_DIR && ./scripts/start_web.sh"
    fi
else
    echo "   ✓ RAG 服务已在运行 (端口：7860)"
fi

echo ""

# 启动博客服务
echo "📝 启动博客服务..."
cd "$SCRIPT_DIR"

if [ -d "node_modules" ]; then
    echo "   🌐 博客地址：http://localhost:5173"
    echo "   💡 按 Ctrl+C 停止服务"
    echo "============================================================"
    echo ""
    
    # 使用 npm run dev 启动
    if command -v npm &> /dev/null; then
        npm run dev
    else
        echo "   ❌ 未找到 npm，请先安装 Node.js"
        exit 1
    fi
else
    echo "   ❌ node_modules 不存在，请先运行：npm install"
    exit 1
fi
