# zsh

Shell configuration built on [oh-my-zsh](https://ohmyz.sh/), themed with
**devglow**, and wired up for a polyglot development workflow.

## File

| File | Purpose |
|------|---------|
| `.zshrc` | oh-my-zsh setup, prompt theme, aliases, and language toolchain `PATH` wiring |

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

Rust (`cargo`), Node via **nvm**, **Bun** (via `bum` version manager), **Java**
(OpenJDK 21 + `jdtls` language server), **Android** SDK (emulator, platform-tools,
cmdline-tools), **Go**, **Flutter**, **Lua** (+ lua-language-server), **protoc**,
and **pg_format**.

Most are rooted at `$WORKSPACE_ENV/<tool>`, so reproducing the environment means
placing the corresponding runtime there. `JAVA_HOME` points at a specific
OpenJDK build that the Neovim Java setup also relies on
(see `../neovim/JAVA_SETUP.md`).

> **Note:** the custom `append_path` helper skips appending when inside tmux
> (tmux already inherits the parent shell's `PATH`), avoiding duplicate entries
> in nested shells.

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
