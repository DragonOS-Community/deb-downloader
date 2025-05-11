# deb downloader

这是一个用来下载deb包及其依赖项，并解压到指定文件夹的工具

当前，DragonOS使用它来构建一些关键的包。

## 发布包下载

本项目使用[云原生构建cnb.cool](https://cnb.cool/)进行CI/CD, 并发布到[cnb cool release](https://cnb.cool/DragonOS-Community/deb-downloader/-/releases)。


## 安装

```
make build-docker-ubuntu2404
```

## 使用

### 下载deb包及其依赖项

请将xxx替换成你要下载的deb包的名称

```
make PACKAGE_NAME=xxx download
```

### 解压deb包

这个命令将会把上述的deb包解压到`output/sysroot`文件夹中

```
make unpack
```

### 清理

```
make clean
```



## 参与贡献

您可以选择通过cnb.cool或者github PR进行贡献。

### （推荐）在CNB.cool上贡献

由于本项目的主仓库托管在cnb.cool上，因此我们推荐您通过CNB.cool的PR进行代码提交。

仓库地址： https://cnb.cool/DragonOS-Community/deb-downloader

### 在github上贡献

如果您更喜欢使用github，请将您的修改推送到github上的对应分支，并发起一个PR。

仓库地址： https://github.com/DragonOS-Community/deb-downloader

> 由于仓库是从cnb.cool单向同步到github的，因此，
> 一旦您在github上的PR被approve， maintainer将会手动为您在cnb.cool上创建一个PR，并把代码合并进去。
>
> （这有点麻烦，但请理解）

## 联系我们

如果您有任何问题或建议，请随时联系我们的[社区](https://bbs.dragonos.org.cn/)。

本项目 Maintainer： <longjin@dragonos.org>
