# Alacritty

GPU-accelerated terminal configuration, themed with **devglow**.

This is the outermost layer of the setup — it provides true color, a fast
clipboard, and clickable URLs to everything running inside it (tmux, zsh,
Neovim).

## Files

| File | Purpose |
|------|---------|
| `alacritty.toml` | Main config — window, font, cursor, keybindings, hints, shell |
| `themes/devglow-sage.toml` | The active color palette (imported by `alacritty.toml`) |

The palette is kept in a **separate file on purpose**: swapping the entire
terminal's colors is a one-line edit to the `import` in `alacritty.toml`
(e.g. point it at a different `devglow-*.toml`).

## Highlights

- **True color + clipboard + focus** advertised via `TERM = "alacritty"`, which
  is what lets tmux's `terminal-features` light up RGB, OSC52 clipboard, cursor
  style/color, and focus events.
- **Font:** `UbuntuMono Nerd Font` at 9pt with built-in box drawing for crisp
  TUI borders. A [Nerd Font](https://www.nerdfonts.com/) is required for glyphs.
- **Shell:** launches `/bin/zsh -l` (login shell).
- **OSC52 copy** (`OnlyCopy`) so programs can write to the system clipboard.

## Keybindings

| Keys | Action |
|------|--------|
| `Ctrl+Shift+N` | New window |
| `Ctrl+Shift+C` / `Ctrl+Shift+V` | Copy / Paste (plain `Ctrl+C/V` still reach the shell & tmux) |
| `Ctrl+Shift+F` / `Ctrl+Shift+B` | Search scrollback forward / backward |
| `Ctrl+Shift+U` | Label & open URLs (hints); or `Ctrl`+click |
| `Alt+Shift+V` | Toggle vi mode |
| `Ctrl+=` / `Ctrl+-` / `Ctrl+0` | Font size grow / shrink / reset |
| `Shift+PageUp` / `Shift+PageDown` | Page scrollback |
| `Shift+Home` / `Shift+End` | Scroll to top / bottom |

## Installation

Handled by the repo's `configure.sh`, which links both `alacritty.toml` and the
`themes/` directory into `~/.config/alacritty/` (the config imports its palette
from that themes directory).

`live_config_reload` is on, so saving the config applies changes immediately —
no restart needed.

## Notes

- The URL-hint opener is `xdg-open` (Linux). On macOS, change it to `open`.
- `opacity` is `1.0` and `blur` is off for maximum legibility; both are easy to
  tweak under `[window]`.
- The config is exhaustively commented — most options list their alternatives
  and defaults inline.
