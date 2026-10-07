#!/bin/bash

drill() {
  command drill "$@" || return
  if [[ $# -eq 0 || $1 == reset ]]; then
    cd "$HOME/.cache/drill/sandbox" || return
  fi
}
