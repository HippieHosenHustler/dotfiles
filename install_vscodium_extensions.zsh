#!/usr/bin/env zsh

IFS=$'\n'       # make newlines the only separator
set -f          # disable globbing
for i in $(cat < ./codium_extensions); do
  codium --install-extension $i
done