#!/bin/bash

PROMPT_DIRTRIM=3

__prompt_git() {
  local repo status line conflict="" dirty="" ahead=0 behind=0 oid=""
  repo=$(git rev-parse --show-toplevel --git-dir --show-prefix 2>/dev/null) || return 1
  local top=${repo%%$'\n'*}
  repo=${repo#*$'\n'}
  local git_dir=${repo%%$'\n'*} prefix=""
  [[ $repo == *$'\n'* ]] && prefix=${repo#*$'\n'}
  prefix=${prefix%/}
  __prompt_path="${top##*/}${prefix:+/$prefix}"

  local untracked=normal fsmonitor
  fsmonitor=$(git config --get core.fsmonitor)
  # An index over ~3MB is roughly 20k tracked files, where scanning for untracked files takes seconds without fsmonitor.
  if [[ -z $fsmonitor || $fsmonitor == false ]] && (( $(stat -f %z "$git_dir/index" 2>/dev/null || echo 0) > 3000000 )); then
    untracked=no
  fi

  status=$(git status --porcelain=v2 --branch --untracked-files=$untracked 2>/dev/null) || return 1
  __prompt_branch=""
  while IFS= read -r line; do
    case $line in
      "# branch.head "*) __prompt_branch=${line#\# branch.head } ;;
      "# branch.oid "*) oid=${line#\# branch.oid } ;;
      "# branch.ab "*) read -r _ _ ahead behind <<< "$line"; ahead=${ahead#+}; behind=${behind#-} ;;
      "u "*) conflict=1 ;;
      "#"*) ;;
      ?*) dirty=1 ;;
    esac
  done <<< "$status"

  [[ $__prompt_branch == "(detached)" ]] && __prompt_branch=${oid:0:7}
  [[ -d $git_dir/rebase-merge || -d $git_dir/rebase-apply || -f $git_dir/MERGE_HEAD ]] && conflict=1

  if [[ -n $conflict ]]; then
    __prompt_git_colour=$RED
  elif [[ -n $dirty ]]; then
    __prompt_git_colour=$YELLOW
  else
    __prompt_git_colour=$GREEN
  fi

  __prompt_ahead_behind=""
  (( ahead > 0 )) && __prompt_ahead_behind+=" ↑$ahead"
  (( behind > 0 )) && __prompt_ahead_behind+=" ↓$behind"
  return 0
}

__prompt_duration() {
  local seconds=$1
  if (( seconds >= 3600 )); then
    printf '%dh %dm' $((seconds / 3600)) $((seconds % 3600 / 60))
  elif (( seconds >= 60 )); then
    printf '%dm %ds' $((seconds / 60)) $((seconds % 60))
  else
    printf '%ds' "$seconds"
  fi
}

__prompt_command() {
  local exit=$?
  local duration=""
  if [[ -n $__prompt_start ]]; then
    (( SECONDS - __prompt_start >= 5 )) && duration=$(__prompt_duration $((SECONDS - __prompt_start)))
    unset __prompt_start
  fi

  PS1='\[${LIGHT_BLUE}\]'
  if __prompt_git; then
    PS1+='${__prompt_path}'
    PS1+='\[${NORMAL}\]  \[${__prompt_git_colour}\]${__prompt_branch}\[${NORMAL}\]${__prompt_ahead_behind}'
  else
    PS1+='\w\[${NORMAL}\]'
  fi
  [[ -n $duration ]] && PS1+="  \[\${GRAY}\]took $duration\[\${NORMAL}\]"

  if (( exit == 0 )); then
    PS1+='\n❯ '
  else
    PS1+='\n\[${RED}\]❯\[${NORMAL}\] '
  fi
}

# Bash 4.4+ expands PS0 just before each command runs; older bash skips the duration.
PS0+='${PS1:$((__prompt_start=SECONDS, 0)):0}'
PROMPT_COMMAND="__prompt_command${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
