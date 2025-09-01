#!/bin/bash

# Minecraft 服务器启动脚本的路径
MINECRAFT_SERVER_SCRIPT="./run.sh"

# 最大重启次数（防止无限重启循环）
MAX_RESTARTS=10
RESTART_COUNT=0

# 日志文件路径
LOG_FILE="$(dirname "$0")./minecraft_server_watchdog.log"

# 函数：记录日志
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# 检查服务器脚本是否存在
if [ ! -f "$MINECRAFT_SERVER_SCRIPT" ]; then
    log "错误：找不到 Minecraft 服务器脚本 $MINECRAFT_SERVER_SCRIPT"
    exit 1
fi

log "Minecraft 服务器监控启动"

while [ $RESTART_COUNT -lt $MAX_RESTARTS ]; do
    log "正在启动 Minecraft 服务器 (尝试 $((RESTART_COUNT+1))/$MAX_RESTARTS)"
    
    # 启动服务器
    "$MINECRAFT_SERVER_SCRIPT"
    
    # 获取服务器退出状态
    EXIT_CODE=$?
    
    if [ $EXIT_CODE -eq 0 ]; then
        log "服务器正常关闭，监控程序退出"
        exit 0
    else
        RESTART_COUNT=$((RESTART_COUNT+1))
        log "服务器异常退出 (代码: $EXIT_CODE)，将在 10 秒后尝试重启"
        sleep 10
    fi
done

log "达到最大重启次数 ($MAX_RESTARTS)，不再尝试重启"
exit 1
