# Janus patches against upstream oh-my-pi

One entry per intentional divergence. Keep entries current; delete an entry when the patch is dropped.

| # | What | Files | Why | Verify |
|---|------|-------|-----|--------|
| 1 | Add `janus` CLI command (alongside `omp`) | `packages/coding-agent/package.json` (`bin`) | Fork identity with a one-line diff; config dir stays `~/.omp` | `janus --version` |
| 2 | Point agents at Janus rules | `AGENTS.md` (one line at top) | Rules live in `JANUS.md` to avoid conflicts in the frequently edited upstream `AGENTS.md` | Read top of `AGENTS.md` |

## Janus-only files (never conflict with upstream)

- `JANUS.md`, `PATCHES.md`
- `scripts/janus/` — sync, prebuilt-natives fetch, and smoke-test scripts
- `eval/` — task set comparing Claude Code / Codex / Janus (to be added)

## Native addon policy

Janus does **not** build the Rust native layer (`crates/`, `packages/natives/`) locally.
`scripts/janus/fetch-natives.sh` installs upstream's prebuilt `@oh-my-pi/pi-natives-<platform>@<version>` from npm
(the `.node` files are gitignored). This avoids a clang/libclang/cmake/ninja toolchain and a rebuild on every sync.
If Janus ever patches Rust code, this policy must change: build with `bun run build:native`
(prereqs per upstream `Dockerfile`: clang, libclang-dev, cmake, make, ninja-build, pkg-config, libssl-dev).
