#!/bin/bash

if [ -z "$HOMEBREW_PREFIX" ]; then
  for brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    [ -x "$brew" ] && eval "$("$brew" shellenv)" && break
  done
fi

export PATH="$HOME/.dotfiles/bin:$PATH"
