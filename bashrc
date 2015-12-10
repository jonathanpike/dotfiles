#!/bin/bash

# Reads files in .bash/ 
shopt -s nullglob
for file in ~/.bash/*.bash; do
  source $file
done
shopt -u nullglob

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Bash Completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
. $(brew --prefix)/etc/bash_completion
fi

# Enable shims and autocompletion for rbenv
eval "$(rbenv init -)"
