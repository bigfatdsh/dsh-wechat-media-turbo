#!/bin/sh
# 把本目录打成 DSH 可安装的 bundle tgz（package/ 前缀）。
set -e
cd "$(dirname "$0")"
version=$(node -p "require('./package.json').version")
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/package"
cp package.json cordis.patch.yml README.md LICENSE "$tmp/package/"
(cd "$tmp" && tar czf - package) > "dsh-wechat-media-turbo-$version.tgz"
echo "$(pwd)/dsh-wechat-media-turbo-$version.tgz"
