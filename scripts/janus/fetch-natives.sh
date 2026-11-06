#!/usr/bin/env bash
# Install upstream's prebuilt Rust native addon matching the current natives version,
# so Janus does not need a local Rust/clang/cmake/ninja toolchain.
# Only valid while Janus carries no changes under crates/ or packages/natives/.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
version=$(jq -r .version packages/natives/package.json)
case "$(uname -s)-$(uname -m)" in
  Linux-x86_64) pkg=pi-natives-linux-x64 ;;
  Linux-aarch64) pkg=pi-natives-linux-arm64 ;;
  Darwin-arm64) pkg=pi-natives-darwin-arm64 ;;
  Darwin-x86_64) pkg=pi-natives-darwin-x64 ;;
  *) echo "unsupported platform" >&2; exit 1 ;;
esac
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
(cd "$tmp" && npm pack "@oh-my-pi/$pkg@$version" >/dev/null && tar xzf ./*.tgz)
rm -f packages/natives/native/pi_natives.*.node
cp "$tmp"/package/*.node packages/natives/native/
echo "installed @oh-my-pi/$pkg@$version"
