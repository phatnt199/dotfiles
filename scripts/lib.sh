#!/bin/sh
# Shared helpers for configure.sh and cleanup.sh (sourced, not executed).
# ------------------------------------------------------------------

BACKUP_SUFFIX=".dotfiles-bak"

# link SRC DEST — make DEST a symlink to SRC without ever destroying user data.
#   - DEST already links to SRC, or is a dangling symlink: nothing to keep (linked / replaced).
#   - Anything else (real file/dir, or a live symlink elsewhere): moved aside to
#     DEST.dotfiles-bak (timestamped if that exists).
link() {
  src=$1
  dest=$2

  mkdir -p "$(dirname -- "$dest")"

  if [ -L "$dest" ] && [ "$(readlink -- "$dest")" = "$src" ]; then
    return 0
  fi

  if [ -L "$dest" ] && [ ! -e "$dest" ]; then
    rm -- "$dest"
  elif [ -e "$dest" ] || [ -L "$dest" ]; then
    backup=$dest$BACKUP_SUFFIX
    if [ -e "$backup" ] || [ -L "$backup" ]; then
      backup=$backup.$(date +%Y%m%d%H%M%S)
    fi
    mv -- "$dest" "$backup"
    echo "  existing $dest moved to $backup"
  fi

  ln -s -- "$src" "$dest"
}

# unlink SRC_ROOT DEST — remove DEST only if it is a symlink pointing into SRC_ROOT, then
# restore the backup `link` made of the file it replaced, if any. Anything else is left alone.
unlink_ours() {
  root=$1
  dest=$2

  if [ ! -L "$dest" ]; then
    [ -e "$dest" ] && echo "  skipped $dest (not a symlink)"
    return 0
  fi

  case $(readlink -- "$dest") in
    "$root"/*) ;;
    *)
      echo "  skipped $dest (links outside this repo)"
      return 0
      ;;
  esac

  rm -- "$dest"
  backup=$dest$BACKUP_SUFFIX
  if [ -e "$backup" ] || [ -L "$backup" ]; then
    mv -- "$backup" "$dest"
    echo "  restored $dest from $backup"
  fi
}
