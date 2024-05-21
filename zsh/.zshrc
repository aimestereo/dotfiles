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
eval "$(mise activate zsh)"   # Polyglot runtime manager (asdf rust clone)

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
zinit light Aloxaf/fzf-tab

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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#
# Keybindings
#

bindkey -v
bindkey '^y' autosuggest-accept

# Use C-n/C-p keys to search history based on current input
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^p" up-line-or-beginning-search
bindkey "^n" down-line-or-beginning-search

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

# Completion styling
# enable case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:ls:*' fzf-preview 'eza -1 --color=always $realpath'
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'
# allow option-stacking for docker completion
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

#
# Aliases
#

alias v='nvim'
alias c='clear'

alias l='eza -lah'
alias ll='eza -lh'
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

alias git_clean='git remote prune origin && currBranch=$(git rev-parse --abbrev-ref HEAD) && git for-each-ref refs/heads/ "--format=%(refname:short)" | grep -v $currBranch | while read branch; do mergeBase=$(git merge-base $currBranch $branch) && [[ $(git cherry $currBranch $(git commit-tree $(git rev-parse $branch^{tree}) -p $mergeBase -m _)) == "-"* ]] && git branch -D $branch; done'

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
