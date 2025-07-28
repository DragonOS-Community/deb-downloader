# 通用打包脚本说明

## 概述

该项目现在包含一个通用的打包脚本 `pack.sh`，可以根据配置文件打包不同的deb包集合。

## 使用方法

### 基本用法

```bash
# 列出所有可用的包配置
./pack.sh

# 使用特定的包配置进行打包
./pack.sh <config_name>
```

### 示例

```bash
# 打包glibc
./pack.sh glibc-ubuntu2404

# 打包构建工具
./pack.sh build-essential-ubuntu2404

# 打包示例包
./pack.sh example-ubuntu2404
```

## 配置文件格式

配置文件位于 `packages/` 目录下，以 `.conf` 为扩展名。

### 必需的配置变量

- `PACKAGES`: 包名数组，例如 `PACKAGES=("libc-bin" "libstdc++6")`
- `DOCKER_TAG`: Docker标签，例如 `DOCKER_TAG="ubuntu2404"`
- `TAR_NAME`: 输出tar文件名，例如 `TAR_NAME="glibc-ubuntu2404.tar.xz"`

### 可选的配置

- `post_unpack_hook()`: 后处理钩子函数，在解压完成后执行自定义操作

### 配置文件示例

```bash
# packages/mypackage-ubuntu2404.conf

# 包列表
PACKAGES=("package1" "package2" "package3")

# Docker标签
DOCKER_TAG="ubuntu2404"

# 输出tar文件名
TAR_NAME="mypackage-ubuntu2404.tar.xz"

# 可选: 后处理钩子函数
post_unpack_hook() {
    echo "Executing custom post-processing..."
    # 在这里添加自定义处理步骤
    # 例如: 创建符号链接，修改权限等
}
```

## 目录结构

```
deb-downloader/
├── pack.sh                              # 通用打包脚本
├── packages/                            # 包配置目录
│   ├── glibc-ubuntu2404.conf           # glibc配置
│   ├── build-essential-ubuntu2404.conf  # 构建工具配置
│   ├── example-ubuntu2404.conf         # 示例配置
│   └── glibc-ubuntu2404/               # 原glibc目录（向后兼容）
│       └── pack.sh                     # 调用通用脚本的包装器
├── output/                             # 输出目录
└── tmp/                               # 临时目录
```

## 向后兼容性

原有的 `packages/glibc-ubuntu2404/pack.sh` 脚本仍然可以正常使用，它现在内部调用新的通用脚本。

## 添加新的包配置

1. 在 `packages/` 目录下创建新的 `.conf` 文件
2. 按照配置文件格式填写必需的变量
3. 如果需要特殊的后处理步骤，定义 `post_unpack_hook()` 函数
4. 使用 `./pack.sh <config_name>` 进行打包

## 工作流程

1. 脚本读取指定的配置文件
2. 验证必需的配置变量
3. 创建输出目录
4. 清理之前的构建
5. 下载指定的包
6. 解压包到sysroot
7. 执行后处理钩子（如果定义）
8. 设置文件权限
9. 打包为tar.xz文件
10. 计算MD5并重命名文件
