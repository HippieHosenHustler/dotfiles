# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
	mkdir -p "$(dirname $ZINIT_HOME)"
	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZP::git

# Load completions
autoload -U compinit && compinit

zinit cdreplay -q

# Set Variables
export JAVA_HOME="/opt/homebrew/opt/openjdk@17/bin"
# Syntax highlighting for man pages using bat
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export HOMEBREW_CASK_OPTS="--no-quarantine"
export N_PREFIX="$HOME/.n"
export NULLCMD="bat"
export EDITOR="nvim"
export CHROME_EXECUTABLE="/run/current-system/sw/bin/google-chrome-stable"

# Create Aliases
# alias ls='ls -lAFh'
alias ls='eza -lah --git'
alias exa='exa -lah --git'
alias cat='bat'
alias brewdump='brew bundle dump --force --describe'
alias trail='<<<${(F)path}'
alias rm=trash
alias vim='nvim'
alias mux='$HOME/.dotfiles/tmux_sessionizer.zsh'
alias sfpullp='sf project retrieve preview'
alias sfpull='sf project retrieve start'
alias sfpullf='sf project retrieve start --ignore-conflicts'
alias sfpush='sf project deploy start'
alias sfpushf='sf project deploy start --ignore-conflicts --ignore-warnings'
alias sfpushp='sf project deploy preview'
alias sfswitch='sf config set target-org'
alias grep='rg'
alias nixup='nix flake update && darwin-rebuild switch --flake ~/.dotfiles/nix-darwin-config#air'

# Add Locations to $path array
typeset -U path
path=(
	"$N_PREFIX/bin"
	"/opt/homebrew/opt/openjdk@17/bin"
  	"/run/current-system/sw/bin"
	"/opt/homebrew/opt/openssl@3/bin"
	"$HOME/.pyenv/shims"
	$path

)
export PATH=$PATH:/Users/edwinscharfe/.spicetify

# Write Handy Functions
function mkcd() {
	mkdir -p "$@" && cd "$_";
}

wallpaper () {
	automator -i "${1}" ~/.dotfiles/automations/SetDesktopWallpaper.workflow
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
bindkey '^a' autosuggest-accept
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/edwinscharfe/.cache/lm-studio/bin"

# Added by Windsurf
export PATH="/Users/edwinscharfe/.codeium/windsurf/bin:$PATH"
