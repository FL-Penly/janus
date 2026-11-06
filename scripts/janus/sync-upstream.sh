#!/usr/bin/env bash
# Merge the latest upstream oh-my-pi into Janus main on a dedicated branch.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
[ -z "$(git status --porcelain)" ] || { echo "working tree not clean" >&2; exit 1; }
git fetch upstream --tags
git checkout main
git pull --ff-only origin main
branch="sync/upstream-$(date +%Y%m%d)"
git checkout -b "$branch"
if ! git merge --no-edit upstream/main; then
  echo "Merge conflicts. Resolve them following JANUS.md and PATCHES.md, then commit." >&2
  git diff --name-only --diff-filter=U >&2
  exit 2
fi
echo "Merged on $branch. Next: bun install && scripts/janus/fetch-natives.sh && scripts/janus/smoke.sh, then merge into main."
git diff --stat upstream/main -- . | tail -1
