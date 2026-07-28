#!/usr/bin/env zsh

# Herdr port of tmux_sessionizer.zsh: pick a project with fzf and get a
# workspace with Nvim / Claude / zsh tabs. Runs as a herdr popup (prefix+f).

set -e

if [[ "${HERDR_ENV:-}" != 1 ]]; then
  echo "Not running inside herdr!" >&2
  exit 1
fi

PROJECTS_DIR="$HOME/Projects"

if [[ ! -d "$PROJECTS_DIR" ]]; then
  echo "Projects directory not found!" >&2
  exit 1
fi

TARGET_DIR=$(find "$PROJECTS_DIR" "$HOME" -maxdepth 1 -mindepth 1 -type d | fzf --prompt="Select a project: ")
[[ -z "$TARGET_DIR" ]] && exit 0

# Workspace name from the directory name, leading dot replaced by underscore
WS_NAME=$(basename "$TARGET_DIR")
WS_NAME="${WS_NAME/#./_}"

# Switch to an existing workspace with this name if there is one
EXISTING_ID=$(herdr workspace list | jq -r --arg name "$WS_NAME" \
  '.result.workspaces[] | select(.label == $name) | .workspace_id' | head -n1)

if [[ -n "$EXISTING_ID" ]]; then
  herdr workspace focus "$EXISTING_ID" > /dev/null
  exit 0
fi

# New workspace; its first tab becomes the Nvim tab
CREATED=$(herdr workspace create --cwd "$TARGET_DIR" --label "$WS_NAME" --no-focus)
WS_ID=$(echo "$CREATED" | jq -r '.result.workspace.workspace_id')
NVIM_TAB=$(echo "$CREATED" | jq -r '.result.tab.tab_id')
NVIM_PANE=$(echo "$CREATED" | jq -r '.result.root_pane.pane_id')

herdr tab rename "$NVIM_TAB" "Nvim" > /dev/null
sleep 0.3 # let the shell reach its prompt before sending commands
herdr pane run "$NVIM_PANE" "nvim"

CLAUDE_TAB=$(herdr tab create --workspace "$WS_ID" --cwd "$TARGET_DIR" --label "Claude" --no-focus)
CLAUDE_PANE=$(echo "$CLAUDE_TAB" | jq -r '.result.root_pane.pane_id')
sleep 0.3
herdr pane run "$CLAUDE_PANE" "claude"

herdr tab create --workspace "$WS_ID" --cwd "$TARGET_DIR" --label "zsh" --no-focus > /dev/null

herdr workspace focus "$WS_ID" > /dev/null
herdr tab focus "$NVIM_TAB" > /dev/null
