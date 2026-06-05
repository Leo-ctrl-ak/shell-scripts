#!/bin/bash
# 服务器资源监控脚本
# 功能：监控CPU、内存、磁盘使用率，超过阈值输出告警日志

# 设置阈值
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80
LOG_FILE="/var/log/monitor.log"

# 获取当前时间
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# 获取CPU使用率
CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}' | cut -d. -f1)
CPU_USAGE=$((100 - CPU_IDLE))

# 获取内存使用率
MEM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100}' | cut -d. -f1)

# 获取磁盘使用率
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')

# 记录当前状态
echo "[$TIMESTAMP] CPU:${CPU_USAGE}% MEM:${MEM_USAGE}% DISK:${DISK_USAGE}%" >> $LOG_FILE

# CPU告警
if [ $CPU_USAGE -gt $CPU_THRESHOLD ]; then
    echo "[$TIMESTAMP] 告警：CPU使用率过高，当前 ${CPU_USAGE}%" >> $LOG_FILE
fi

# 内存告警
if [ $MEM_USAGE -gt $MEM_THRESHOLD ]; then
    echo "[$TIMESTAMP] 告警：内存使用率过高，当前 ${MEM_USAGE}%" >> $LOG_FILE
fi

# 磁盘告警
if [ $DISK_USAGE -gt $DISK_THRESHOLD ]; then
    echo "[$TIMESTAMP] 告警：磁盘使用率过高，当前 ${DISK_USAGE}%" >> $LOG_FILE
fi

echo "[$TIMESTAMP] 监控完成"