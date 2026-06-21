# tmux

Terminal multiplexer configuration — vim-flavored panes, windows, and sessions
with a live system status bar. Tested on **tmux 3.5a**.

## File

| File | Purpose |
|------|---------|
| `.tmux.conf` | The entire configuration (server, session, window, and binding options) |

## Highlights

- **Prefix:** `Ctrl+b` (default).
- **True color + clipboard + focus** declared via
  `terminal-features ",alacritty:RGB:clipboard:..."`, matching what Alacritty
  advertises — so colors, OSC52 copy, and Vim `autoread` all work inside tmux.
- **Vi everywhere:** vi keys in copy mode and at the status prompt.
- **Mouse on:** click to select panes, drag borders to resize, scroll history.
- **Sensible counting:** windows and panes start at `1`; closing a window
  renumbers the rest.
- **10k-line scrollback** and a snappy `10ms` escape-time for responsive
  mode switching.
- **Live status bar:** hostname, memory used/total, IP address, and a ticking
  clock, refreshed every 5s.

## Keybindings

Prefix is `Ctrl+b`. `-r` keys repeat within the repeat window; `M-` = `Alt`.

| Keys | Action |
|------|--------|
| `prefix` + `\` | Split pane horizontally (keeps cwd) |
| `prefix` + `-` | Split pane vertically (keeps cwd) |
| `prefix` + `h/j/k/l` | Move between panes (vim-style, repeatable) |
| `prefix` + `H/J/K/L` | Resize pane by 5 cells (repeatable) |
| `Alt+1` … `Alt+9` | Jump to window 1–9 (no prefix) |
| `Alt+Shift+K` | Toggle pane zoom (no prefix) |
| `prefix` + `r` | Reload `~/.tmux.conf` |
| `prefix` + `[` | Enter copy mode |
| (copy mode) `v` / `y` / `Ctrl+v` | Begin selection / copy / rectangle toggle |

Arrow keys are intentionally unbound to reinforce the vim motions.

## Installation

Handled by the repo's `configure.sh`, which links `.tmux.conf` to `~/.tmux.conf`.

Apply changes in a running session with `prefix` + `r`, or `tmux source-file
~/.tmux.conf`.

## Notes

- `default-shell` is `/usr/bin/zsh`; adjust if zsh lives elsewhere.
- The status bar's memory/IP widgets shell out to `awk`/`ip` and assume a Linux
  `/proc`. They degrade gracefully but are Linux-oriented.
- The file documents many optional settings inline (commented out) — a handy
  menu for future tweaks.
