# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="devglow"

export WORKSPACE="$HOME/Workspace"
export WORKSPACE_ENV="$WORKSPACE/env"
export WORKSPACE_SAVE="$WORKSPACE/save"

# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

plugins=(
  fzf
  git
  dotenv
)

source $ZSH/oh-my-zsh.sh

# Note: `fzf` keybindings and completions are already loaded by the oh-my-zsh `fzf` plugin above.
# User configuration
# export MANPATH="/usr/local/man:$MANPATH"
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Compilation flags
export ARCHFLAGS="-arch x86_64"

alias nv="nvim ."
alias sa="sudo apt"
alias "\e"="spf"

export CLAUDE_BIN="$HOME/.local/bin/claude"

# alias claude="CLAUDE_CONFIG_DIR=~/.claude claude"

alias claude-toantraz='CLAUDE_CONFIG_DIR=~/Workspace/save/tanphat199/agent-contracts/.claude-toantraz $CLAUDE_BIN'
alias claude-tanphat199='CLAUDE_CONFIG_DIR=~/Workspace/save/tanphat199/agent-contracts/.claude-tanphat199 $CLAUDE_BIN'

alias ws="cd $WORKSPACE"

# --------------------------------------------------------------------
# Keep PATH entries unique automatically across nested shells, tmux panes, and reloads.
typeset -U path PATH

append_path () {
  [ -d "$1" ] && export PATH="$PATH:$1"
}

prepend_path () {
  [ -d "$1" ] && export PATH="$1:$PATH"
}

append_path "$HOME/.local/bin"

# --------------------------------------------------------------------
# RUST
# --------------------------------------------------------------------
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# --------------------------------------------------------------------
# NVM (fast PATH wire-up + on-demand lazy load for `nvm` CLI)
# --------------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"
for _node_dir in "$NVM_DIR"/versions/node/v*; do
  [ -d "$_node_dir/bin" ] && _latest_node="$_node_dir/bin"
done
[ -n "$_latest_node" ] && prepend_path "$_latest_node"
unset _node_dir _latest_node

nvm () {
  unfunction nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm "$@"
}

# --------------------------------------------------------------------
# BUN
# --------------------------------------------------------------------
export BUN_INSTALL="$HOME/.bun"
prepend_path "$BUN_INSTALL/bin"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"
# --------------------------------------------------------------------
# JAVA
# --------------------------------------------------------------------
for _jdk_dir in "$WORKSPACE_ENV"/openjdk/openjdk-*; do
  [ -d "$_jdk_dir" ] && export JAVA_HOME="$_jdk_dir"
done
unset _jdk_dir
append_path "$JAVA_HOME/bin" # Java bin
append_path "$WORKSPACE_ENV/jdtls/latest/bin" # Java LSP

# --------------------------------------------------------------------
# ANDROID
# --------------------------------------------------------------------
export ANDROID_HOME="$WORKSPACE_ENV/android/sdk"
append_path "$ANDROID_HOME/emulator"
append_path "$ANDROID_HOME/platform-tools"
append_path "$ANDROID_HOME/cmdline-tools/latest/bin"
append_path "$ANDROID_HOME/tools"
append_path "$ANDROID_HOME/tools/bin"

# --------------------------------------------------------------------
# GO
# --------------------------------------------------------------------
export GO_HOME="$WORKSPACE_ENV/go"
export GOPATH="$GO_HOME/packages"
append_path "$GO_HOME/main/bin"
append_path "$GOPATH/bin"

# --------------------------------------------------------------------
# FLUTTER
# --------------------------------------------------------------------
export FLUTTER_HOME="$WORKSPACE_ENV/flutter"
append_path "$FLUTTER_HOME/bin"

# --------------------------------------------------------------------
# LUA LSP
# --------------------------------------------------------------------
append_path "$WORKSPACE_ENV/lua/lua-main/src"
append_path "$WORKSPACE_ENV/lua/lsp/bin"

# --------------------------------------------------------------------
# PROTOC
# --------------------------------------------------------------------
append_path "$WORKSPACE_ENV/protoc/linux/bin"

# --------------------------------------------------------------------
# PG_FORMAT
# --------------------------------------------------------------------
append_path "$WORKSPACE_ENV/pgFormatter"

# --------------------------------------------------------------------
# KUBECTL & GIT-DELTA
# --------------------------------------------------------------------
append_path "$WORKSPACE_ENV/kubectl"
append_path "$WORKSPACE_ENV/git-delta"

# bun completions
[ -s "/home/tanphat199/.bun/_bun" ] && source "/home/tanphat199/.bun/_bun"
