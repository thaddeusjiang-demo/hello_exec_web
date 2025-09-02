#!/bin/sh
set -euo pipefail

# 保存当前目录
APPKIT_DIR=$PWD
PROJECT_ROOT=$PWD/../..

export ELIXIRKIT_APP_NAME=HelloExecWeb
export ELIXIRKIT_PROJECT_DIR=$PROJECT_ROOT

# 设置Phoenix服务器环境变量
export PHX_SERVER=true
export PHX_ENV=dev
export MIX_ENV=dev

# 检查应用程序是否已经在运行
if pgrep -f "HelloExecWeb.app" > /dev/null; then
    echo "HelloExecWeb 应用程序已经在运行中"
    echo "正在停止现有进程..."
    pkill -f "HelloExecWeb.app" || true
    sleep 2

    # 确保所有相关进程都已停止
    while pgrep -f "HelloExecWeb.app" > /dev/null; do
        echo "等待进程完全停止..."
        sleep 1
    done
fi

# 执行构建脚本

. ../../../../elixirkit/elixirkit_swift/Scripts/build_macos_app.sh

# 使用 open -W 保持web应用运行，但先确保没有冲突的进程
open -W --stdout `tty` --stderr `tty` .build/HelloExecWeb.app
