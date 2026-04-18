# 多阶段构建 - 生产优化
FROM node:20-alpine AS builder

WORKDIR /app

# 复制 package 文件
COPY package*.json ./

# 安装依赖（生产环境）
RUN npm ci --only=production && npm cache clean --force

# 复制源代码
COPY . .

# 根据环境变量决定构建目标
ARG VITEPRESS_BASE=/
ENV VITEPRESS_BASE=$VITEPRESS_BASE

# 构建静态站点
RUN if [ "$VITEPRESS_BASE" = "/gray/" ]; then \
      echo "🔧 Building for GRAY environment..." && \
      npm run build:gray; \
    else \
      echo "🚀 Building for PRODUCTION environment..." && \
      npm run build; \
    fi

# ============================================
# 生产环境 - Nginx
# ============================================
FROM nginx:alpine

# 安装必要工具
RUN apk add --no-cache curl wget

# 复制自定义 Nginx 配置
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/conf.d/ /etc/nginx/conf.d/

# 从构建阶段复制构建产物
COPY --from=builder /app/docs/.vitepress/dist /usr/share/nginx/html

# 创建数据目录（共享卷挂载点）
RUN mkdir -p /usr/share/nginx/html/data && \
    chown -R nginx:nginx /usr/share/nginx/html/data

# 健康检查端点
RUN echo '<!DOCTYPE html><html><head><title>OK</title></head><body><h1>OK</h1></body></html>' > /usr/share/nginx/html/health/index.html

# 暴露端口
EXPOSE 80

# 添加启动脚本
COPY scripts/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD curl -f http://localhost/health || exit 1

# 设置环境变量
ENV NODE_ENV=production
ENV VITE_ENV=${VITE_ENV:-production}

# 启动
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
