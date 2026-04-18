#!/bin/bash

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=====================================${NC}"
echo -e "${BLUE}   南风博客 - Docker 部署脚本${NC}"
echo -e "${BLUE}=====================================${NC}"
echo ""

# 检查依赖
check_dependencies() {
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}❌ Docker 未安装${NC}"
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        echo -e "${RED}❌ Docker Compose 未安装${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✅ 依赖检查通过${NC}"
}

# 加载环境变量
load_env() {
    if [ -f .env ]; then
        source .env
        echo -e "${GREEN}✅ 环境变量已加载${NC}"
    else
        echo -e "${YELLOW}⚠️  .env 文件不存在，使用默认配置${NC}"
        echo "请复制 .env.example 为 .env 并修改配置"
    fi
}

# 构建镜像
build_image() {
    local env=$1
    echo -e "${BLUE}🔨 开始构建镜像 (环境：$env)...${NC}"
    
    export VITE_ENV=$env
    
    if [ "$env" = "gray" ]; then
        docker-compose build blog-gray
    else
        docker-compose build blog-production
    fi
    
    echo -e "${GREEN}✅ 镜像构建完成${NC}"
}

# 部署服务
deploy() {
    local env=$1
    echo -e "${BLUE}🚀 开始部署到 $env 环境...${NC}"
    
    if [ "$env" = "gray" ]; then
        docker-compose up -d blog-gray
        SERVICE_URL="http://localhost:8081"
        HEALTH_PORT=8081
    elif [ "$env" = "production" ]; then
        docker-compose up -d blog-production nginx-proxy
        SERVICE_URL="https://ainanfeng.cn"
        HEALTH_PORT=8082
    elif [ "$env" = "all" ]; then
        docker-compose up -d
        SERVICE_URL="https://ainanfeng.cn"
        HEALTH_PORT=8082
    fi
    
    echo -e "${YELLOW}⏳ 等待服务启动...${NC}"
    sleep 10
    
    # 健康检查
    if curl -f http://localhost:$HEALTH_PORT/health > /dev/null 2>&1; then
        echo -e "${GREEN}✅ 部署成功！${NC}"
        echo -e "${BLUE}访问地址：$SERVICE_URL${NC}"
    else
        echo -e "${RED}❌ 健康检查失败！${NC}"
        echo -e "${YELLOW}查看日志：docker-compose logs${NC}"
        exit 1
    fi
}

# 回滚
rollback() {
    local env=$1
    echo -e "${YELLOW}🔄 开始回滚 $env 环境...${NC}"
    
    # TODO: 实现回滚逻辑
    echo "回滚功能开发中..."
}

# 查看状态
status() {
    echo -e "${BLUE}📊 服务状态:${NC}"
    docker-compose ps
    
    echo -e "\n${BLUE}📈 资源使用:${NC}"
    docker stats --no-stream
}

# 查看日志
logs() {
    local service=$1
    if [ -n "$service" ]; then
        docker-compose logs -f $service
    else
        docker-compose logs -f
    fi
}

# 清理
cleanup() {
    echo -e "${YELLOW}🧹 清理未使用的资源...${NC}"
    docker system prune -f
    docker volume prune -f
    echo -e "${GREEN}✅ 清理完成${NC}"
}

# 主菜单
show_menu() {
    echo ""
    echo "请选择操作:"
    echo "1) 部署灰度环境"
    echo "2) 部署生产环境"
    echo "3) 部署所有环境"
    echo "4) 查看状态"
    echo "5) 查看日志"
    echo "6) 回滚"
    echo "7) 清理资源"
    echo "0) 退出"
    echo ""
    read -p "请输入选项 [0-7]: " choice
}

# 主程序
main() {
    cd "$(dirname "$0")"
    
    check_dependencies
    load_env
    
    if [ $# -gt 0 ]; then
        case $1 in
            "gray")
                build_image gray
                deploy gray
                ;;
            "production")
                build_image production
                deploy production
                ;;
            "all")
                build_image production
                deploy all
                ;;
            "status")
                status
                ;;
            "logs")
                logs $2
                ;;
            "cleanup")
                cleanup
                ;;
            *)
                echo -e "${RED}未知命令：$1${NC}"
                exit 1
                ;;
        esac
    else
        # 交互模式
        while true; do
            show_menu
            case $choice in
                "1") build_image gray && deploy gray ;;
                "2") build_image production && deploy production ;;
                "3") build_image production && deploy all ;;
                "4") status ;;
                "5") logs ;;
                "6") 
                    read -p "要回滚哪个环境？(gray/production): " env
                    rollback $env
                    ;;
                "7") cleanup ;;
                "0") exit 0 ;;
                *) echo -e "${RED}无效选项${NC}" ;;
            esac
        done
    fi
}

main "$@"
