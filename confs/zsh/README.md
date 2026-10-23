# zsh

Shell configuration built on [oh-my-zsh](https://ohmyz.sh/), themed with
**devglow**, and wired up for a polyglot development workflow.

## Files

`.zshrc` is only a loader: it sources every `conf.d/*.zsh` in name order, then the optional
machine-private `~/.zshrc.local` (not tracked by git; skipped when absent). The loader finds
`conf.d/` through the `~/.zshrc` symlink, so linking just `.zshrc` is enough.

| File | Purpose |
|------|---------|
| `conf.d/00-workspace.zsh` | `WORKSPACE`, `WORKSPACE_ENV`, `WORKSPACE_SAVE` |
| `conf.d/10-oh-my-zsh.zsh` | oh-my-zsh settings, theme, plugins, then `source oh-my-zsh.sh` |
| `conf.d/20-env.zsh` | `LANG`, `EDITOR`, `ARCHFLAGS` |
| `conf.d/30-aliases.zsh` | aliases |
| `conf.d/40-path.zsh` | unique `PATH` + `append_path` / `prepend_path` helpers |
| `conf.d/5x-<tool>.zsh` | one file per toolchain: rust, node (nvm), bun, java, android, go, flutter, lua, misc tools |
| `~/.zshrc.local` | accounts, gateways, keys (e.g. the `claude-*` aliases); yours, never committed |

Add a tool by creating `conf.d/<NN>-<name>.zsh`; the number decides the load order (and so
the `PATH` order). Files may use the helpers from `40-path.zsh`, so keep tool files after it.

## Highlights

- **Prompt:** the `devglow` oh-my-zsh theme (matches the editor and terminal).
- **Plugins:** `fzf` (fuzzy finder + key bindings), `git`, `dotenv`
  (auto-loads `.env` files when entering a directory).
- **Auto-updates:** oh-my-zsh updates itself automatically.
- **Editor:** `nvim` locally, `vim` over SSH.
- **History timestamps:** `yyyy-mm-dd`.

## Workspace convention

The config centers on a `~/Workspace` layout:

| Variable | Path | Meaning |
|----------|------|---------|
| `WORKSPACE` | `~/Workspace` | Root of all work |
| `WORKSPACE_ENV` | `~/Workspace/env` | Self-managed language runtimes & tools |
| `WORKSPACE_SAVE` | `~/Workspace/save` | Saved projects |

Language toolchains are installed under `WORKSPACE_ENV` and added to `PATH`
explicitly rather than via system package managers — keeping versions pinned and
self-contained.

## Aliases

| Alias | Expands to |
|-------|------------|
| `nv` | `nvim .` |
| `sa` | `sudo apt` |
| `ws` | `cd $WORKSPACE` |

## Language toolchains wired in `PATH`

Rust (`cargo`), Node via **nvm** (fast `PATH` resolution + lazy-loaded CLI),
**Bun** (`~/.bun`), **Java** (auto-detected OpenJDK + `jdtls` language server),
**Android** SDK (emulator, platform-tools, cmdline-tools), **Go**, **Flutter**,
**Lua** (+ lua-language-server), **protoc**, **pg_format**, **kubectl**, and
**git-delta**.

Most are rooted at `$WORKSPACE_ENV/<tool>`, so reproducing the environment means
placing the corresponding runtime there. `JAVA_HOME` automatically resolves to
the newest OpenJDK build under `$WORKSPACE_ENV/openjdk/`.

> **Note:** `typeset -U path PATH` keeps `PATH` entries automatically
> deduplicated across nested shells, tmux panes, and `source ~/.zshrc` reloads,
> and `append_path`/`prepend_path` only add directories that exist on disk.
## Installation

Handled by the repo's `configure.sh`, which links `.zshrc` to `~/.zshrc`.

Prerequisites:

- **oh-my-zsh** installed at `~/.oh-my-zsh`
- the **devglow** zsh theme placed in `$ZSH_CUSTOM/themes/devglow.zsh-theme`
- **fzf** installed (for the `fzf` plugin and `fzf --zsh` key bindings)

Reload after edits with `source ~/.zshrc` or by opening a new shell.

## Notes

- Paths under `$WORKSPACE_ENV` are machine-specific; adjust or remove the blocks
  for toolchains you don't use.
- `starship` is present but commented out — devglow is the active prompt.
