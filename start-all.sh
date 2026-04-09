#!/bin/bash
# 南风博客 - 一键启动所有服务
# 包括：博客服务 + RAG 知识库 + 情感分析 + AI 俄罗斯方块

echo "============================================================"
echo "🚀 南风博客 - 一键启动所有服务"
echo "============================================================"
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RAG_DIR="/root/.openclaw/workspace/rag-knowledge-base"
EMOTION_DIR="/root/.openclaw/workspace/emotion-analyzer-mvp"
TETRIS_DIR="/root/.openclaw/workspace/ai-tetris"

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

# 检查并启动情感分析服务
echo "🧠 检查情感分析服务..."
if ! curl -s http://localhost:8001/health > /dev/null 2>&1; then
    echo "   ⚠️  情感分析服务未运行，正在启动..."
    
    if [ -d "$EMOTION_DIR" ] && [ -f "$EMOTION_DIR/docker-compose.yml" ]; then
        cd "$EMOTION_DIR"
        docker-compose up -d
        echo "   ✓ 情感分析服务已启动 (端口：8001)"
    else
        echo "   ❌ 情感分析目录或 docker-compose.yml 不存在"
    fi
else
    echo "   ✓ 情感分析服务已在运行 (端口：8001)"
fi

echo ""

# 检查并启动俄罗斯方块服务
echo "🎮 检查 AI 俄罗斯方块服务..."
if ! curl -s http://localhost:5000/health > /dev/null 2>&1; then
    echo "   ⚠️  俄罗斯方块服务未运行，正在启动..."
    
    if [ -d "$TETRIS_DIR" ] && [ -f "$TETRIS_DIR/docker-compose.yml" ]; then
        cd "$TETRIS_DIR"
        docker-compose up -d
        echo "   ✓ 俄罗斯方块服务已启动 (端口：5000)"
    else
        echo "   ❌ 俄罗斯方块目录或 docker-compose.yml 不存在"
    fi
else
    echo "   ✓ 俄罗斯方块服务已在运行 (端口：5000)"
fi

echo ""

# 启动博客服务
echo "📝 启动博客服务..."
cd "$SCRIPT_DIR"

if [ -d "node_modules" ]; then
    echo "   🌐 博客地址：http://localhost:5173"
    echo "   🤖 RAG 知识库：http://localhost:7860"
    echo "   🧠 情感分析：http://localhost:8001"
    echo "   🎮 AI 俄罗斯方块：http://localhost:5000"
    echo ""
    echo "   💡 按 Ctrl+C 停止博客服务"
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
