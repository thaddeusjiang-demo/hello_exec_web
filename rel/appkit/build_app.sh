#!/bin/sh
set -euo pipefail

# 保存当前目录
APPKIT_DIR=$PWD
PROJECT_ROOT=$PWD/../..

export MIX_ENV=prod
export ELIXIRKIT_APP_NAME=HelloExecWeb
export ELIXIRKIT_PROJECT_DIR=$PROJECT_ROOT

# 生成或设置 SECRET_KEY_BASE
if [ -z "${SECRET_KEY_BASE:-}" ]; then
    export SECRET_KEY_BASE=$(cd $PROJECT_ROOT && mix phx.gen.secret)
    echo "Generated SECRET_KEY_BASE for production build"
fi

echo "Building HelloExecWeb application..."
echo "Project root: $PROJECT_ROOT"
echo "AppKit directory: $APPKIT_DIR"

# 执行构建脚本
. ../../../../elixirkit/elixirkit_swift/Scripts/build_macos_app.sh

echo "Application built successfully!"
