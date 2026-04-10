#!/bin/bash
# 南风博客 - 备份脚本
# 定期备份博客内容和配置

set -e

echo "============================================================"
echo "💾 南风博客 - 备份脚本"
echo "============================================================"
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR/.."

# 配置
BACKUP_DIR="/root/backups/blog"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="blog_backup_$DATE.tar.gz"

# 创建备份目录
mkdir -p "$BACKUP_DIR"

echo "📁 备份目录：$BACKUP_DIR"
echo "📦 备份文件：$BACKUP_NAME"
echo ""

# 备份内容
echo "🔨 开始备份..."
tar -czf "$BACKUP_DIR/$BACKUP_NAME" \
  --exclude='node_modules' \
  --exclude='docs/.vitepress/dist' \
  --exclude='.git' \
  .

# 显示备份大小
echo ""
echo "✅ 备份完成！"
echo ""
echo "📊 备份大小："
ls -lh "$BACKUP_DIR/$BACKUP_NAME"

# 清理旧备份（保留最近 7 个）
echo ""
echo "🧹 清理旧备份（保留最近 7 个）..."
cd "$BACKUP_DIR"
ls -t blog_backup_*.tar.gz | tail -n +8 | xargs -r rm
echo "✅ 清理完成"

echo ""
echo "============================================================"
echo "✨ 备份成功！"
echo "============================================================"
echo ""
echo "💡 恢复方法："
echo "   cd $BACKUP_DIR"
echo "   tar -xzf $BACKUP_NAME -C /root/.openclaw/workspace/blog"
echo ""
