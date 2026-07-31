#!/usr/bin/env zsh

# Herdr port of tmux_sessionizer.zsh: pick a project with fzf and get a
# workspace with Nvim / Claude / zsh tabs. Runs as a herdr popup (prefix+f).

set -e

if [[ "${HERDR_ENV:-}" != 1 ]]; then
  echo "Not running inside herdr!" >&2
  exit 1
fi

# Create (or focus) a workspace for a directory, with Nvim / Claude / zsh tabs.
open_space() {
  local TARGET_DIR="$1"

  # Workspace name from the directory name, leading dot replaced by underscore
  local WS_NAME
  WS_NAME=$(basename "$TARGET_DIR")
  WS_NAME="${WS_NAME/#./_}"

  # Switch to an existing workspace with this name if there is one
  local EXISTING_ID
  EXISTING_ID=$(herdr workspace list | jq -r --arg name "$WS_NAME" \
    '.result.workspaces[] | select(.label == $name) | .workspace_id' | head -n1)

  if [[ -n "$EXISTING_ID" ]]; then
    herdr workspace focus "$EXISTING_ID" > /dev/null
    return 0
  fi

  # New workspace; its first tab becomes the Nvim tab
  local CREATED WS_ID NVIM_TAB NVIM_PANE CLAUDE_TAB CLAUDE_PANE
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
}

if [[ "$1" == "--prompt" ]]; then
  # Arbitrary directory: fuzzy-search any dir under $HOME (bounded depth so the
  # walk stays instant). fzf's --print-query means a typed/pasted absolute path
  # is accepted verbatim too, so dirs outside $HOME or deeper than the walk are
  # still reachable — the selection wins over the query when both are present.
  OUT=$(
    fd --type d --hidden --follow --absolute-path --max-depth 6 \
       -E .git -E node_modules -E Library -E .Trash -E .cache -E .npm -E .cargo \
       . "$HOME" 2>/dev/null \
      | fzf --prompt="Directory: " --print-query
  ) || true
  [[ -z "$OUT" ]] && exit 0
  TARGET_DIR=${OUT##*$'\n'}             # last line: selection if any, else query
  TARGET_DIR=${TARGET_DIR/#\~/$HOME}    # expand leading ~
  TARGET_DIR=${TARGET_DIR:A}            # resolve to absolute path
  if [[ ! -d "$TARGET_DIR" ]]; then
    echo "Not a directory: $TARGET_DIR" >&2
    sleep 1
    exit 1
  fi
else
  # Project picker: immediate subdirs of ~/Projects plus the top level of $HOME
  PROJECTS_DIR="$HOME/Projects"

  if [[ ! -d "$PROJECTS_DIR" ]]; then
    echo "Projects directory not found!" >&2
    exit 1
  fi

  TARGET_DIR=$(find "$PROJECTS_DIR" "$HOME" -maxdepth 1 -mindepth 1 -type d | fzf --prompt="Select a project: ")
  [[ -z "$TARGET_DIR" ]] && exit 0
fi

open_space "$TARGET_DIR"
