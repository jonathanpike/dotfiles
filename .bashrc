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
if [ -f /usr/local/etc/bash_completion ]; then
  . /usr/local/etc/bash_completion

  # Add git completion to aliases
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

ssh-add -A > /dev/null 2>&1

# Enable shims and autocompletion for rbenv
eval "$(rbenv init -)"
