# Janus fork rules

Janus is a long-lived fork of [oh-my-pi](https://github.com/can1357/oh-my-pi) (MIT, by Stencil Labs),
itself a fork of [Pi](https://github.com/earendil-works/pi) by Mario Zechner.

Goal: a terminal coding agent whose experience matches Claude Code (Claude models) and Codex (GPT models),
while tracking upstream oh-my-pi closely.

These rules take precedence over upstream `AGENTS.md` wherever they conflict.

## Remotes and branches

- `upstream` = can1357/oh-my-pi. Never push to it.
- `origin`   = FL-Penly/janus. `main` is the Janus branch.
- Sync with `scripts/janus/sync-upstream.sh` roughly once a week. Small, frequent merges beat large ones.
- Always **merge** upstream (no rebase of `main`, no cherry-picking selected upstream commits).

## How to change behavior (in priority order)

1. **Config** (`~/.omp/agent/config.yml`, `--tools`, `disabledProviders`, `SYSTEM.md`) — no source change.
2. **Extension / plugin** — put new features in `janus-pack/` (or an external package), not in core.
3. **Cut at the registration point** — to remove an upstream feature, disable it where it is registered
   (tool registry, slash-command table, provider list) behind a small guard. Leave the implementation files in place.
4. **Delete code** — only for things that phone home, add security risk, or measurably slow startup.
   State the reason in `PATCHES.md`.

Never delete or mass-rename upstream files: it creates modify/delete conflicts on every merge.

## Bookkeeping

- Every intentional divergence from upstream gets an entry in `PATCHES.md` (what, where, why, how to verify).
- Keep `git diff upstream/main --stat` as small as possible; review it after each sync.
- Janus-only files live in: `JANUS.md`, `PATCHES.md`, `scripts/janus/`, `janus-pack/`, `eval/`.

## Compatibility that must not break

- Pi extension compatibility layer: `packages/coding-agent/src/extensibility/plugins/legacy-pi-compat.ts`
  and the legacy shims next to it.
- Claude Code plugin/marketplace fallback (`.claude-plugin/marketplace.json`) and discovery of
  `CLAUDE.md`, `.claude/skills`, `AGENTS.md`, `~/.codex/AGENTS.md`.
- The `~/.omp` config directory name (kept on purpose so upstream docs and plugins keep working).

## Licensing

- Keep upstream `LICENSE` and attribution intact.
- Code ported from Codex CLI (Apache-2.0) must keep its license header and be noted in `PATCHES.md`.
- Never copy Claude Code source or leaked Claude Code system prompts. Design-inspired, self-written code only.

## After every upstream merge

Run `bun install`, `scripts/janus/fetch-natives.sh`, then `scripts/janus/smoke.sh`; tag the result `janus-<upstream-version>-<n>` only if it passes.
