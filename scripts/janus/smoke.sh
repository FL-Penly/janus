#!/usr/bin/env bash
# Minimal post-merge smoke test. Extend as Janus features land.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
cli=(bun packages/coding-agent/src/cli.ts)
echo "== version";  "${cli[@]}" --version
echo "== help";     "${cli[@]}" --help >/dev/null
echo ok
echo "== divergence from upstream"; git diff --stat upstream/main | tail -1
echo "smoke passed"
