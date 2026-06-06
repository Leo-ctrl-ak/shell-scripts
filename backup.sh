#!/bin/bash

# 检查是否提供了源目录参数
if [ $# -ne 1 ]; then
    echo "用法: $0 <要备份的目录>"
    exit 1
fi

SOURCE_DIR="$1"
BACKUP_DIR="/backup"

# 检查源目录是否存在
if [ ! -d "$SOURCE_DIR" ]; then
    echo "错误：源目录 '$SOURCE_DIR' 不存在"
    exit 1
fi

# 创建备份目录（如果不存在）
sudo mkdir -p "$BACKUP_DIR"

# 生成带时间戳的文件名
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_NAME="backup_$(basename "$SOURCE_DIR")_$TIMESTAMP.tar.gz"
BACKUP_PATH="$BACKUP_DIR/$BACKUP_NAME"

# 执行打包
echo "正在备份 '$SOURCE_DIR' 到 '$BACKUP_PATH' ..."
sudo tar -czf "$BACKUP_PATH" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"

# 删除7天前的旧备份文件
echo "正在清理7天前的旧备份..."
sudo find "$BACKUP_DIR" -name "backup_*.tar.gz" -type f -mtime +7 -exec rm -f {} \;

echo "✅ 备份完成！"