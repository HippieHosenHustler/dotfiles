#!/usr/bin/env zsh

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find ~/Projects -mindepth 1 -maxdepth 1 -type d | fzf)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    echo "first"
    tmux new-session -s $selected_name -c $selected
    exit 0
fi

if ! tmux has-session -t=$selected_name 2> /dev/null; then
    echo "second"
    tmux new-session -ds $selected_name -c $selected \; \
        renamew 'editor' \; \
        send-keys 'nvim' C-m \; \
        neww -t 'git' \; \
        send-keys 'lazygit' C-m \; \
        neww -t 'zsh'
fi

tmux switch-client -t $selected_name
