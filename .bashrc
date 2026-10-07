#!/bin/bash

# Reads files in .bash/ 
shopt -s nullglob
for file in ~/.bash/*.bash; do
  source $file
done
shopt -u nullglob

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

shopt -s cdspell checkwinsize
shopt -s dirspell globstar 2> /dev/null

# Bash Completion
if [ -f "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]; then
  . "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
fi

if [ -n "$BASH_COMPLETION_VERSINFO" ]; then
  # Add git completion to aliases
  __load_completion git
  __git_complete g __git_main
  __git_complete gs _git_status
  __git_complete gc _git_commit
  __git_complete gch _git_checkout
  __git_complete ga _git_add
  __git_complete gd _git_diff
  __git_complete gst _git_stash
  __git_complete gl _git_log
  __git_complete gp _git_push
fi

command -v fzf > /dev/null && eval "$(fzf --bash)"

# Enable shims and autocompletion for rbenv
eval "$(rbenv init -)"
