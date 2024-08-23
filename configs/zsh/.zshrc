# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# 
# Shell integrations
#

if [[ -f "/opt/homebrew/bin/brew" ]] then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  
  # Load completions
  fpath=(
      ~/.zfunc
      ${HOMEBREW_PREFIX}/share/zsh/site-functions
      "${fpath[@]}"
  )
fi
eval "$(fzf --zsh)"

#
# User configuration
#

# correct max limits for open files and processes (done per bash session)
# also ~/Library/LaunchAgents/limit.maxfiles.plist
# https://docs.riak.com/riak/kv/2.1.4/using/performance/open-files-limit/#mac-os-x
ulimit -n 200000
ulimit -u 2048

export ALTERNATE_EDITOR=""
export EDITOR="nvim"       # $EDITOR usualy opens in terminal, but no
export VISUAL="nvim"       # $VISUAL opens in GUI mode

export FZF_DEFAULT_OPTS='--bind ctrl-y:accept'

path=(
    ${HOME}/.local/bin
    $path
)

# Python
source "${HOME}/.rye/env"
# eval "$(mise activate zsh)"   # Polyglot runtime manager (asdf rust clone)

# go
export GOPATH="$HOME/go"
export GOROOT="$(brew --prefix go)/libexec"
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

#
# Plugins
#

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
zinit light atuinsh/atuin

export DIRENV_HOME="${HOME}/.config/direnv"
zinit light ptavares/zsh-direnv

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::aws
# zinit snippet OMZP::docker/completions/_docker
# zinit snippet OMZP::docker-compose/_docker-compose
# zinit snippet OMZP::kubectl
# zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# fixes after zinit
unalias gclean

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#
# Keybindings
#

bindkey -v
bindkey '^y' autosuggest-accept

# Use C-n/C-p and Up/Down keys
# to search history based on current input
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^p" up-line-or-beginning-search
bindkey "^n" down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

# edit command line in nvim
autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd '^v' edit-command-line

# 
# History
#

HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=$HISTSIZE
HISTFILESIZE=1000000
HISTDUP=erase

setopt extended_history       # record timestamp of command in HISTFILE
setopt append_history
setopt share_history          # share command history data
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_find_no_dups


#
# Aliases
#

alias v='nvim'
alias cl='clear'

alias l='eza -lah'
alias ll='eza -lh'
alias lt='eza -lh --tree'
alias lat='eza -lah --tree'
alias ls='eza'

alias tree='eza --tree'
alias c='bat'
alias cat='bat -p'

setopt auto_cd
alias md='mkdir -p'
alias rd=rmdir
alias -g ...='../..'
alias -g ....='../../..'

alias tf=terraform
alias tg=terragrunt
alias k=kubectl

# It will automatically copy over the terminfo files and also magically enable shell integration on the remote machine.
alias s="kitten ssh"

#
# Helpers
#

alias wanip='dig +short myip.opendns.com @resolver1.opendns.com'
alias whatismyip='curl ipinfo.io/ip'

export DOCKER_USER="$(id -u):$(id -g)"

function pyclean() {
    find . -type f -name "*.py[co]" -delete
    find . -type d -name "__pycache__" -delete
}

function listening() {
    if [ $# -eq 0 ]; then
        sudo lsof -iTCP -sTCP:LISTEN -n -P
    elif [ $# -eq 1 ]; then
        sudo lsof -iTCP -sTCP:LISTEN -n -P | grep -i --color $1
    else
        echo "Usage: listening [pattern]"
    fi
}

# pnpm
export PNPM_HOME="/Users/aimestereo/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
