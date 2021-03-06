#!/bin/bash

# Start from scratch
PS1=''

# Put in current directory and time only
PS1+='\[$BLUE\]\T \u@\h: \w'

# If we have __git_ps1 installed, then put it in the prompt. We do what we can
# from the previous two lines.
if command -v __git_ps1 > /dev/null 2>&1; then
  PS1+='\[$YELLOW\]$(__git_ps1 " (%s)")\n'
fi

# Show unstaged (*) and staged (+) changes 
export GIT_PS1_SHOWDIRTYSTATE=1 

# Normalize prompt contents
PS1+='\[${NORMAL}\]$ '
