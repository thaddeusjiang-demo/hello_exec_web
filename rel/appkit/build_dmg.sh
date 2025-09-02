#!/bin/sh
set -euo pipefail

# 保存当前目录
APPKIT_DIR=$PWD
PROJECT_ROOT=$PWD/../..

echo "Building HelloExecWeb DMG package..."

# 首先构建应用程序
. `dirname $0`/build_app.sh

# 然后构建DMG
echo "Creating DMG package..."
. ../../../../elixirkit/elixirkit_swift/Scripts/build_macos_dmg.sh

echo "DMG package created successfully!"
