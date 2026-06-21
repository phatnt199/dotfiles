# dotfiles

Personal development environment for Linux — a cohesive, keyboard-driven
terminal setup tied together by a single hand-made theme, **devglow**.

Everything here is configured to feel like one tool rather than four separate
ones: the same palette, the same vim-style motions, and the same calm, low-glare
aesthetic across the terminal, multiplexer, shell, and editor.

```
Alacritty  →  the terminal (GPU-rendered, true color, OSC52 clipboard)
   └─ tmux        →  panes, windows & sessions (vim keys, persistent layout)
        └─ zsh    →  the shell (oh-my-zsh + devglow prompt, language toolchains)
             └─ Neovim  →  the editor (lazy.nvim, LSP, blink.cmp, Telescope)
```

All four share the **devglow** look. Its default variant is `sage` — muted,
grey-tinted, and calm: *"a dark room with just enough candlelight to read by."*

---

## What's inside

| Folder | Tool | Highlights |
|--------|------|------------|
| [`confs/alacritty`](confs/alacritty) | [Alacritty](https://alacritty.org/) terminal | True color, OSC52 copy, URL hints, vi-mode, swappable devglow theme |
| [`confs/tmux`](confs/tmux) | [tmux](https://github.com/tmux/tmux) 3.5a | Vim pane navigation, `Alt+number` window switching, RGB + clipboard passthrough, live system status bar |
| [`confs/zsh`](confs/zsh) | [zsh](https://www.zsh.org/) + [oh-my-zsh](https://ohmyz.sh/) | devglow prompt, fzf, language toolchain `PATH` wiring (Rust, Node/Bun, Java, Android, Go, Flutter, Lua, protoc) |
| [`confs/neovim`](confs/neovim) | [Neovim](https://neovim.io/) ≥ 0.11 | lazy.nvim, native LSP (0.11 API), blink.cmp completion, Treesitter, Telescope, conform.nvim, modular Lua config |

The repository root also holds the install tooling and a `backup/` directory of
earlier configurations (kept for reference; not used by the active setup).

---

## The devglow theme

[devglow](https://github.com/phatnt199/devglow) is a custom theme authored
specifically for this environment. Rather than mixing unrelated color schemes,
every layer renders the *same* palette:

- **Neovim** — the `devglow` colorscheme (a lazy.nvim plugin)
- **zsh** — the `devglow` oh-my-zsh prompt theme
- **Alacritty** — `confs/alacritty/themes/devglow-sage.toml`
- **superfile** — a matching file-manager theme

Variants live as separate files, so switching the whole terminal's mood is a
one-line change (e.g. point Alacritty's `import` at a different
`devglow-*.toml`). The active variant across this repo is **sage**.

---

## Requirements

Core:

- **Alacritty**, **tmux** (≥ 3.2 for `terminal-features`), **zsh**, **Neovim** (≥ 0.11)
- A **Nerd Font** (default: `UbuntuMono Nerd Font`) — needed for icons/glyphs
- **oh-my-zsh** with the `devglow` theme installed in `$ZSH_CUSTOM/themes`
- **wl-clipboard** (Wayland) or **xclip/xsel** (X11) for system-clipboard integration

Neovim additionally wants language servers, formatters, and `ripgrep` — see
[`confs/neovim/README.md`](confs/neovim/README.md) for the full list.

---

## Installation

The repo uses **symlinks** so edits here take effect live, with no copy step.

```sh
git clone <this-repo> ~/dotfiles
cd ~/dotfiles
./install.sh        # installs core deps, then symlinks everything (needs sudo)
```

`install.sh` runs two steps from `scripts/`:

1. **`scripts/install-deps.sh`** — installs the universal runtime dependencies on
   apt-based distros: `ripgrep`, `fzf`, `build-essential`, `curl`, `git`,
   `unzip`, and the right clipboard tool for your session (`wl-clipboard` on
   Wayland, `xclip` on X11). Idempotent; skips anything already present.
   Version-sensitive apps (Neovim, Alacritty, tmux, zsh) and per-language
   servers/formatters are installed separately — see each tool's README.
2. **`scripts/configure.sh`** — symlinks each config into place:

| Source | Linked to |
|--------|-----------|
| `confs/zsh/.zshrc` | `~/.zshrc` |
| `confs/tmux/.tmux.conf` | `~/.tmux.conf` |
| `confs/neovim` | `~/.config/nvim` |
| `confs/alacritty/alacritty.toml` | `~/.config/alacritty/alacritty.toml` |
| `confs/alacritty/themes` | `~/.config/alacritty/themes` (theme imports) |

The Neovim and Alacritty steps are skipped (with a notice) if those programs
aren't installed, so the script always finishes. It also runs
`nvim --headless "+Lazy! sync"` once so
[lazy.nvim](https://github.com/folke/lazy.nvim) bootstraps itself and installs
all plugins up front (it also self-installs on first interactive launch).

### Uninstall

```sh
./uninstall.sh
```

Runs `scripts/cleanup.sh` to remove every symlink the install created
(`~/.zshrc`, `~/.tmux.conf`, and the Alacritty/Neovim config links). System
packages installed by `install-deps.sh` are left in place — they're shared
system tools, so remove them manually only if you really want to.

---

## Repository layout

```
dotfiles/
├── install.sh            # one-shot: deps + symlinks
├── uninstall.sh          # one-shot: remove symlinks
├── scripts/              # individual steps
│   ├── install-deps.sh    install core CLI deps (apt; sudo)
│   ├── configure.sh       symlink configs into ~ and ~/.config
│   └── cleanup.sh         remove the symlinks
├── confs/
│   ├── alacritty/        # terminal emulator
│   │   ├── alacritty.toml
│   │   └── themes/        devglow-sage.toml
│   ├── tmux/             # multiplexer
│   │   └── .tmux.conf
│   ├── zsh/              # shell
│   │   └── .zshrc
│   └── neovim/           # editor (modular Lua config)
│       ├── init.lua
│       ├── lua/...        main/ + plugs/ + plugs/lsp/
│       └── JAVA_SETUP.md
└── backup/               # previous configs (reference only)
```

---

## License

Released into the public domain under the [Unlicense](LICENSE). Copy, modify,
and use freely.

Authored by **Phat Nguyen** ([@phatnt199](https://github.com/phatnt199)).
