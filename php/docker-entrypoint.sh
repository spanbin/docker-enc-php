#!/bin/bash
set -e

# 设置目录权限
if [ -d /www ]; then
    chown -R www-data:www-data /www
    chmod -R 755 /www
    echo "www directory permissions initialized successfully. "
fi

# 设置默认环境
DEFAULT_ENV=dev

# 如果设置了 APP_ENV 变量
if [ -n "$APP_ENV" ]; then
    ENV_FILE=".env.$APP_ENV"
    
    # 检查环境文件是否存在
    if [ -f "$ENV_FILE" ]; then
        cp "$ENV_FILE" .env
        echo "Using $ENV_FILE configuration"
    else
        echo "Warning: $ENV_FILE not found! Using default .env.$DEFAULT_ENV"
        cp ".env.$DEFAULT_ENV" .env
    fi
fi

# 执行原始的命令（比如启动PHP-FPM）
exec "$@"