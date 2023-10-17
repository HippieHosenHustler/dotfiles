#!/usr/bin/env zsh

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(tmuxinator ls -n | grep -v "tmuxinator projects:" | fzf)
fi

if [[ -z $selected ]]; then
    exit 0
fi

tmuxinator start $selected
