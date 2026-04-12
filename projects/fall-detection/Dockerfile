FROM python:3.12-slim

WORKDIR /app

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# 复制依赖文件
COPY requirements.txt .

# 安装 Python 依赖
RUN pip install --no-cache-dir -r requirements.txt

# 复制应用代码
COPY app_optimized.py .

# 暴露端口
EXPOSE 8501

# 启动命令
CMD ["streamlit", "run", "app_optimized.py", "--server.address", "0.0.0.0", "--server.port", "8501"]
