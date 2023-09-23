#!/usr/bin/env zsh

echo "\n<<<< Starting ZSH Setup >>>>\n"

if sh --version | grep -q zsh; then
    echo 'sh already symlinked to zsh'
else
    echo "Enter sudo password to symlink sh to zsh"
    sudo ln -sfv /bin/zsh /private/var/select/sh
fi

