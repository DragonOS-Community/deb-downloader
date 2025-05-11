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

### Download DEB Packages and Dependencies

Replace `xxx` with the name of the DEB package you want to download.

```
make PACKAGE_NAME=xxx download
```

### Extract DEB Packages

This command will extract the downloaded DEB packages to the `output/sysroot` directory.

```
make unpack
```

### Clean Up

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
