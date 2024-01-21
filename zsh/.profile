# correct max limits for open files and processes (done per bash session)
# also ~/Library/LaunchAgents/limit.maxfiles.plist
# https://docs.riak.com/riak/kv/2.1.4/using/performance/open-files-limit/#mac-os-x
ulimit -n 200000
ulimit -u 2048



#
#
#
#

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

#
# Editor
#
export ALTERNATE_EDITOR=""
export EDITOR="nvim"       # $EDITOR usualy opens in terminal, but no
export VISUAL="nvim"       # $VISUAL opens in GUI mode


#
# Homebrew
#

# Set PATH, MANPATH, etc., for Homebrew, will also set `HOMEBREW_PREFIX`
eval "$(/opt/homebrew/bin/brew shellenv)"


# Load completions from Homebrew apps
if type brew &>/dev/null; then
    FPATH=${HOMEBREW_PREFIX}/share/zsh/site-functions:${FPATH}

    autoload -Uz compinit
    compinit
fi


# Use Homebrew openssl (can be bad for certs)
export OPENSSL_PATH="/usr/local/opt/openssl@3" # $(brew --prefix openssl)
path=(${OPENSSL_PATH}/bin $path)
export LIBRARY_PATH="$LIBRARY_PATH:${OPENSSL_PATH}/lib/"
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=${OPENSSL_PATH}"

# For compilers:
#export LDFLAGS="-L${HOMEBREW_PREFIX}/opt/libpq/lib"
#export CPPFLAGS="-I${HOMEBREW_PREFIX}/opt/libpq/include"
#export CPPFLAGS="-I${HOMEBREW_PREFIX}/opt/openjdk/include"
export LDFLAGS="-L${OPENSSL_PATH}/lib"
export CPPFLAGS="-I${OPENSSL_PATH}/include"

# ------------


path=(
    ${HOME}/.local/bin
    $path
)



#
# git
#
alias gitconfig="${EDITOR} ~/.gitconfig"
alias git_clean='git remote prune origin && currBranch=$(git rev-parse --abbrev-ref HEAD) && git for-each-ref refs/heads/ "--format=%(refname:short)" | grep -v $currBranch | while read branch; do mergeBase=$(git merge-base $currBranch $branch) && [[ $(git cherry $currBranch $(git commit-tree $(git rev-parse $branch^{tree}) -p $mergeBase -m _)) == "-"* ]] && git branch -D $branch; done'


#
# go
#
# export GOPATH=${HOME}/projects/go
# export GOROOT=/usr/local/opt/go/libexec
# path+=${GOPATH}/bin


#
# pyenv
#
# path+=${HOME}/.pyenv/bin
# eval "$(pyenv init --path)"
# eval "$(pyenv virtualenv-init -)"


#
# Poetry
#
# export PATH="/Users/aimestereo/.local/bin:$PATH"

#
# Node.js
#
# Installed, Configured & lazy loaded through zsh-nvm (see .zshrc)
#  export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


#
# rbenv
#
# Lazy loaded by zsh-rbenv in .zshrc
# Why rbenv: https://habr.com/ru/post/137333/
# Захожу в путь проекта B
# Выполняю rbenv local B_VERSION. Это создаст файл .rbenv-version и теперь при нахождении в этой директории версия ruby будет устанавливаться из этого файла
# bundle install --path=vendor/bundle. Это заморозит гемы, описанные в Gemfile в путь ./vendor/bundle
# Делаю тоже самое с проектом A, устанавлявая версию A_VERSION

# NVM
. "${HOME}/.zsh_nvm"


#
# Aliases
#
alias v="nvim"
alias vim="nvim"
alias oldvim="\vim"

alias l="eza -lah"
alias ll="eza -lh"
alias tree="eza --tree"
alias c="bat"
alias cat="bat -p"

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

alias tf=terraform
alias tg=terragrunt
alias k=kubectl

alias wanip='dig +short myip.opendns.com @resolver1.opendns.com'

#
# Helpers
#

export DOCKER_USER="$(id -u):$(id -g)"

function pyclean() {
    find . -type f -name "*.py[co]" -delete
    find . -type d -name "__pycache__" -delete
}




#
# Fron .zshrc
#

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy-mm-dd"

# User configuration

export PATH="/usr/local/sbin:$PATH"
fpath+=~/.zfunc

. ${HOME}/.oh-my-zsh

# vi motions
bindkey -v

CFLAGS="-I$(xcrun --show-sdk-path)/usr/include"

# eval "$(mise activate zsh)"   # Polyglot runtime manager (asdf rust clone)

eval "$(starship init zsh)"  # The minimal, blazing-fast, and infinitely customizable prompt for any shell!

# Use Up&Down keys to search history based on current input
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
