#!/usr/bin/env zsh

# Define the Projects directory
PROJECTS_DIR="$HOME/Projects"

# Ensure the Projects directory exists
if [ ! -d "$PROJECTS_DIR" ]; then
  echo "Projects directory not found!"
  exit 1
fi

# Use fzf to select a directory
TARGET_DIR=$(find "$PROJECTS_DIR" "$HOME" -maxdepth 1 -mindepth 1 -type d | fzf --prompt="Select a project: ")

# Extract the session name from the directory name
SESSION_NAME=$(basename "$TARGET_DIR")
# Replace leading dot in session name with an underscore if present
SESSION_NAME="${SESSION_NAME/#./_}"

# Check if the tmux session already exists
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
  # Check if there is an active tmux client
  if tmux list-clients 2>/dev/null | grep -q "^"; then
    # Switch to the existing session
    tmux switch-client -t "$SESSION_NAME"
  else
    # Attach to the existing session if no client is active
    tmux attach-session -t "$SESSION_NAME"
  fi
else
  # Create a new tmux session with the specified configuration
  tmux new-session -d -s "$SESSION_NAME" -c "$TARGET_DIR" -n "Nvim" "nvim"
  tmux new-window -t "$SESSION_NAME:1" -n "Git" -c "$TARGET_DIR" "lazygit"
  tmux new-window -t "$SESSION_NAME:2" -n "zsh" -c "$TARGET_DIR"
  # Attach to the new session
  tmux attach-session -t "$SESSION_NAME"
fi
