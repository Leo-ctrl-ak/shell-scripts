#!/bin/bash

# 检查参数
if [ -z "$1" ]; then
    echo "用法: $0 <服务名>"
    exit 1
fi

SERVICE_NAME=$1
LOG_FILE="/var/log/service-check.log"
MAX_RETRIES=3
RETRY_COUNT=0

echo "$(date): 开始检查服务 $SERVICE_NAME" | sudo tee -a "$LOG_FILE"

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if systemctl is-active --quiet "$SERVICE_NAME"; then
        echo "$(date): 服务 $SERVICE_NAME 运行正常" | sudo tee -a "$LOG_FILE"
        exit 0
    else
        echo "$(date): 服务 $SERVICE_NAME 未运行，尝试重启 (尝试 $((RETRY_COUNT+1))/$MAX_RETRIES)" | sudo tee -a "$LOG_FILE"
        sudo systemctl restart "$SERVICE_NAME"
        sleep 5
        ((RETRY_COUNT++))
    fi
done

echo "$(date): 错误：服务 $SERVICE_NAME 经过 $MAX_RETRIES 次尝试仍无法启动" | sudo tee -a "$LOG_FILE"
exit 1