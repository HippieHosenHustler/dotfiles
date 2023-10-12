# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
eval "$(starship init zsh)"

ZSH_THEME="crunch"
plugins=(git)

# Set Variables
# Syntax highlighting for man pages using bat
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export HOMEBREW_CASK_OPTS="--no-quarantine"
export N_PREFIX="$HOME/.n"
export NULLCMD="bat"
export EDITOR="nvim"

# Change ZSH Options

# Create Aliases
# alias ls='ls -lAFh'
alias ls='exa -laFh --git'
alias exa='exa -laFh --git'
alias cat='bat'
alias brewdump='brew bundle dump --force --describe'
alias trail='<<<${(F)path}'
alias rm=trash
alias vim='nvim'
alias neo='neovide --neovim-bin lvim'

# Add Locations to $path array
typeset -U path
path=(
	"$N_PREFIX/bin"
	"/opt/homebrew/opt/openjdk@17/bin"
	$path

)

# Write Handy Functions
function mkcd() {
	mkdir -p "$@" && cd "$_";
}

# Use ZSH Plugins

# ...and other Surprises

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="/usr/local/sbin:$PATH"

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
