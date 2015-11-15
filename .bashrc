#!/bin/bash

# Reads files in .bash/ 
shopt -s nullglob
for file in ~/.bash/*.bash; do
  source $file
done
shopt -u nullglob

# Bash Completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
. $(brew --prefix)/etc/bash_completion
fi

eval "$(fasd --init auto)"
eval "$(rbenv init -)"
