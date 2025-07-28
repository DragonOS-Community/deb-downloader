#!/bin/bash
set -e

# 通用打包脚本
# 使用方法: ./pack.sh <package_config_name>
# 例如: ./pack.sh glibc-ubuntu2404

SCRIPT_DIR=$(realpath "$(dirname "$0")")
DEB_DOWNLOAD_DIR="$SCRIPT_DIR"
OUTPUT_DIR="${DEB_DOWNLOAD_DIR}/output"
SYSROOT_DIR="${OUTPUT_DIR}/sysroot"

# 显示使用方法
show_usage() {
    echo "Usage: $0 <package_config_name>"
    echo "Available package configs:"
    find "${SCRIPT_DIR}/packages" -name "*.conf" | sed 's|.*/||' | sed 's|\.conf$||' | sort
    exit 1
}

# 检查参数
if [ $# -ne 1 ]; then
    echo "Error: Missing package config name" >&2
    show_usage
fi

PACKAGE_CONFIG_NAME="$1"
CONFIG_FILE="${SCRIPT_DIR}/packages/${PACKAGE_CONFIG_NAME}.conf"

# 检查配置文件是否存在
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Config file $CONFIG_FILE not found" >&2
    show_usage
fi

# 载入配置文件
echo "Loading config from $CONFIG_FILE"
source "$CONFIG_FILE"

# 验证必需的配置变量
if [ -z "$PACKAGES" ]; then
    echo "Error: PACKAGES variable not defined in config file" >&2
    exit 1
fi

if [ -z "$DOCKER_TAG" ]; then
    echo "Error: DOCKER_TAG variable not defined in config file" >&2
    exit 1
fi

if [ -z "$TAR_NAME" ]; then
    echo "Error: TAR_NAME variable not defined in config file" >&2
    exit 1
fi

echo "Package config: $PACKAGE_CONFIG_NAME"
echo "Docker tag: $DOCKER_TAG"
echo "Packages: ${PACKAGES[*]}"
echo "Output tar: $TAR_NAME"

TAR_PATH="$OUTPUT_DIR/$TAR_NAME"

# 创建输出目录
if ! mkdir -p "$OUTPUT_DIR"; then
    echo "Error: Failed to create output directory" >&2
    exit 1
fi
if ! mkdir -p "$SYSROOT_DIR"; then
    echo "Error: Failed to create sysroot directory" >&2
    exit 1
fi

pushd . || { echo "pushd failed" >&2; exit 1; }
cd "$DEB_DOWNLOAD_DIR" || { echo "cd to $DEB_DOWNLOAD_DIR failed" >&2; exit 1; }

# 清理之前的构建
if ! make clean; then
    echo "Warning: make clean failed, retrying with sudo..." >&2
    if ! sudo make clean; then
        echo "Error: sudo make clean also failed" >&2
        exit 1
    fi
fi

# 下载包
for PACKAGE in "${PACKAGES[@]}"; do
    export PACKAGE_NAME=$PACKAGE
    export DOCKER_TAG=$DOCKER_TAG
    if ! make download; then
        echo "Error: make download failed for $PACKAGE" >&2
        exit 1
    fi
done

# 解压包
if ! make unpack; then
    echo "Error: make unpack failed" >&2
    exit 1
fi

# 执行后处理步骤（如果定义了的话）
if declare -f post_unpack_hook > /dev/null; then
    echo "Executing post-unpack hook..."
    post_unpack_hook
fi

# 设置权限
if ! sudo chmod -R a+r "$SYSROOT_DIR"; then
    echo "Error: Failed to set read permissions on $SYSROOT_DIR" >&2
    exit 1
fi

if ! sudo chmod a+rw "$OUTPUT_DIR"; then
    echo "Error: Failed to set read/write permissions on $OUTPUT_DIR" >&2
    exit 1
fi

pushd . || { echo "pushd failed" >&2; exit 1; }
cd "$OUTPUT_DIR" || { echo "cd to $OUTPUT_DIR failed" >&2; exit 1; }

echo "Packaging..."
# 打包sysroot为tarball
if ! sudo tar -cJf "$OUTPUT_DIR/${TAR_NAME}" sysroot; then
    echo "Error: failed to create tarball" >&2
    exit 1
fi

echo "Calculating MD5 and renaming the tarball..."
# 计算MD5并重命名tarball
MD5_SUM=$(md5sum "$OUTPUT_DIR/${TAR_NAME}" | cut -d' ' -f1)
DATE_SUFFIX=$(date +"%Y%m%d%H%M")
NEW_TAR_NAME="${TAR_NAME%.tar.xz}-${DATE_SUFFIX}-${MD5_SUM}.tar.xz"
if ! mv "$OUTPUT_DIR/${TAR_NAME}" "$OUTPUT_DIR/${NEW_TAR_NAME}"; then
    echo "Error: failed to rename tarball with MD5 sum" >&2
    exit 1
fi

echo "Package ${NEW_TAR_NAME} downloaded, unpacked, and sysroot prepared successfully."

popd || { echo "popd failed" >&2; exit 1; }
popd || { echo "popd failed" >&2; exit 1; }
