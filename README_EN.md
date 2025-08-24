# DEB Downloader

This is a tool for downloading DEB packages along with their dependencies and extracting them to a specified directory.

Currently, DragonOS uses it to build some critical packages.

## Release Downloads

This project uses [Cloud Native Build (cnb.cool)](https://cnb.cool/) for CI/CD, with releases published to [cnb.cool releases](https://cnb.cool/DragonOS-Community/deb-downloader/-/releases).

## Installation

```
make build-docker-ubuntu2404
```

## Usage

### (Recommended) Method 1: Direct packaging

```bash
./pack.sh <package_config_name>
```

Package configurations are located in `./packages`.

### (Not Recommended) Method 2: Manual operations

#### Download deb packages and their dependencies

Please replace xxx with the name of the deb package you want to download.

```
make PACKAGE_NAME=xxx download
```

#### Extract deb packages

This command will extract the above deb packages to the `output/sysroot` folder.

```
make unpack
```

#### Clean

```
make clean
```

## Contributing

You can contribute either via cnb.cool or GitHub PR.

### (Recommended) Contribute via CNB.cool

Since the main repository is hosted on cnb.cool, we recommend submitting code via CNB.cool's PR system.

Repository address: https://cnb.cool/DragonOS-Community/deb-downloader

### Contribute via GitHub

If you prefer using GitHub, please push your changes to the corresponding branch on GitHub and open a PR.

Repository address: https://github.com/DragonOS-Community/deb-downloader

> Note: The repository is synced one-way from cnb.cool to GitHub.  
> Once your GitHub PR is approved, maintainers will manually create a PR on cnb.cool and merge the changes.  
> (This process is slightly cumbersome, but we appreciate your understanding.)

## Contact Us

If you have any questions or suggestions, feel free to reach out to our [community](https://bbs.dragonos.org.cn/).

Project Maintainer: <longjin@dragonos.org>
