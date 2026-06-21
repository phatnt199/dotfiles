# Neovim

A modular, LSP-first Neovim configuration written in Lua, managed by
[lazy.nvim](https://github.com/folke/lazy.nvim) and themed with **devglow**.

Built on Neovim's modern (0.11+) APIs: native `vim.lsp.config`/`vim.lsp.enable`,
[blink.cmp](https://github.com/saghen/blink.cmp) completion (no Rust toolchain
needed), Treesitter, and Telescope. The leader key is `\`.

## Structure

```
neovim/
├── init.lua                    # entry point → require("index")
├── lua/
│   ├── index.lua               # loads main/ then plugs/
│   ├── main/                   # core editor settings (load order by prefix)
│   │   ├── 000-lazy.lua         leader keys + lazy.nvim bootstrap
│   │   ├── 001-preload.lua      options (tabs, undo, clipboard, providers)
│   │   ├── 002-autocmds.lua     yank-highlight, cursor restore, big-file guard,
│   │   │                        LSP buffer-local keymaps (on LspAttach)
│   │   └── 003-keymaps.lua      global keymaps (data-driven table)
│   ├── plugs/                  # one file per plugin (auto-imported)
│   │   ├── blink-conf.lua        completion
│   │   ├── telescope-conf.lua    fuzzy finder (+ fzf-native, ui-select)
│   │   ├── nvim-lsp-conf.lua     LSP orchestration
│   │   ├── lsp/                  per-language LSP modules
│   │   │   ├── servers.lua        aggregator (name → config)
│   │   │   ├── diagnostics.lua    global diagnostic display
│   │   │   └── <lang>.lua         pyright, lua_ls, rust_analyzer, jdtls, …
│   │   └── …                     treesitter, conform, gitsigns, diffview,
│   │                             nvim-tree, lualine, markview, which-key, …
│   └── utilities/
├── lang-servers/               # language-server helper assets (Java style, etc.)
├── JAVA_SETUP.md               # Java / jdtls setup guide
└── lazy-lock.json              # pinned plugin versions
```

**Load order:** `init.lua` → `lua/index.lua` → everything in `main/` (by numeric
prefix) → lazy.nvim imports every spec under `plugs/`.

**LSP architecture:** `nvim-lsp-conf.lua` does orchestration only — it resolves
blink's completion capabilities, applies global diagnostics, then loops over
`plugs/lsp/servers.lua`, calling `vim.lsp.config` + `vim.lsp.enable` for each.
Adding a language = drop a `plugs/lsp/<name>.lua` returning its settings and
register it in `servers.lua`.

## Plugins

| Area | Plugin |
|------|--------|
| Plugin manager | lazy.nvim |
| Theme | [devglow](https://github.com/phatnt199/devglow) |
| Completion | blink.cmp (native snippets, prebuilt fuzzy binaries) |
| LSP | nvim-lspconfig + native `vim.lsp` API |
| Syntax | nvim-treesitter (+ ts-context-commentstring) |
| Fuzzy find | telescope.nvim (+ fzf-native, ui-select, media-files) |
| Formatting | conform.nvim |
| Git | gitsigns.nvim, diffview.nvim |
| File tree | nvim-tree.lua |
| Statusline | lualine.nvim (global statusline) |
| Editing | Comment.nvim, nvim-autopairs |
| Markdown | markview.nvim |
| Colors | nvim-colorizer.lua |
| Discoverability | which-key.nvim |

## Keymaps

Leader is `\`. Press `\` (or `<space>`, `g`, `]`, `[`) and pause to see
available mappings via **which-key**. Highlights:

| Keys | Action |
|------|--------|
| `jk` | Exit insert mode |
| `Ctrl+s` | Save |
| `Ctrl+p` / `Ctrl+r` | Find git files / all files (Telescope) |
| `Ctrl+f` | Fuzzy find in buffer |
| `<leader>ff` | Live grep |
| `ff` | Format buffer (conform) |
| `<leader>nv` / `nf` | Toggle / focus file tree |
| `<leader>gd` / `<leader>gh` | Diffview: open / file history |
| `]c` / `[c` | Next / previous git hunk |
| `<space>e` | Show diagnostic float |
| `]d` / `[d` | Next / previous diagnostic |
| `<leader>dl` | Toggle inline diagnostics (virtual lines) |

**LSP maps** are buffer-local and set on attach (`002-autocmds.lua`): `gd`, `gD`,
`gi`, `gr`, `K`, `<leader>rn`, `<leader>ac`, and more.

## Requirements

- **Neovim** ≥ 0.11 — https://github.com/neovim/neovim/wiki/Installing-Neovim
- A **Nerd Font** — https://www.nerdfonts.com/
- **ripgrep** (Telescope live grep) — https://github.com/BurntSushi/ripgrep
- A **clipboard tool** — `wl-clipboard` (Wayland) or `xclip`/`xsel` (X11)
- **Language servers** (install whichever languages you use):
  `ts_ls`, `lua_ls`, `pyright`, `bashls`, `sqlls`, `yamlls`, `dartls`,
  `rust_analyzer`, `jdtls` (Java — see [`JAVA_SETUP.md`](JAVA_SETUP.md))
- **Formatters** (conform.nvim): `stylua`, `prettier`, `ruff`, `shfmt`,
  `pg_format`, `taplo`, `yq`, `rustfmt`, `dart`

Plugins are managed by lazy.nvim, which bootstraps itself on first launch.

## Installation

1. Back up your existing `~/.config/nvim`.
2. Symlink (or copy) this `neovim` folder to `~/.config/nvim`
   (the repo's `configure.sh` does this for you).
3. Open Neovim: `nvim .` — lazy.nvim clones itself and installs all plugins.
4. Restart Neovim and enjoy.

## Notes

- Completion is provided by blink.cmp — native snippets and prebuilt fuzzy
  binaries, so **no Rust toolchain is required**.
- Inline diagnostic virtual text is **off by default** to reduce noise. Peek the
  current line with `<space>e`, or toggle inline messages with `<leader>dl`.
- A large-file guard (`002-autocmds.lua`) disables Treesitter/syntax/folding on
  files over ~1.5 MB to keep editing snappy.
- `:checkhealth` should be clean. If a luarocks warning ever returns, note that
  rocks are intentionally disabled in `000-lazy.lua`.
