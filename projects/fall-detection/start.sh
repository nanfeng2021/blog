#!/bin/bash

# 摔倒检测系统启动脚本

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "🚀 启动摔倒检测系统..."
echo "📍 工作目录：$SCRIPT_DIR"

# 检查虚拟环境
if [ ! -d "venv" ]; then
    echo "📦 创建虚拟环境..."
    python3 -m venv venv
fi

# 激活虚拟环境
source venv/bin/activate

# 安装依赖
echo "📦 安装依赖..."
pip install -q -r requirements.txt

# 启动服务
echo "✅ 启动 Streamlit 服务..."
echo "🌐 访问地址：http://localhost:8501"
streamlit run app_optimized.py --server.address 0.0.0.0 --server.port 8501
