# Powerlevel10k instant prompt (must be at the very top)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- Zinit ---
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [[ ! -d $ZINIT_HOME ]]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# Plugins
zinit ice depth=1; zinit light romkatv/powerlevel10k
zinit light zsh-users/zsh-autosuggestions

# --- History ---
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE="$HOME/.zsh_history"

setopt EXTENDED_HISTORY HIST_FCNTL_LOCK
setopt HIST_FIND_NO_DUPS HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS HIST_IGNORE_DUPS HIST_IGNORE_SPACE
setopt INC_APPEND_HISTORY autocd
# Session-isolated history: C-p/C-n navigate only current session commands
# Cross-session search available via atuin (Ctrl-R, Up/Down arrow)
setopt NO_SHARE_HISTORY

# Platform-specific (fpath setup must precede compinit)
case "$(uname)" in
  Darwin) source "$HOME/.config/zsh/zshrc-darwin" ;;
esac

# --- Completion ---
autoload -U compinit && compinit

# --- Aliases ---
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias l='eza --icons=auto'
alias ls='eza --icons=auto'
alias ll='eza -la --icons=auto'
alias la='eza -la --icons=auto'
alias lt='eza --tree --icons=auto'
alias c='bat -p'
alias cat='bat'
alias g='git'
alias gst='git status'
alias gco='git checkout'
alias gcm='git commit -m'
alias gcam='git commit -am'
alias v='nvim'
alias lazyvim='NVIM_APPNAME=lazyvim nvim'
alias cl='clear'
alias rd='rmdir'
alias tf='terraform'
alias tg='terragrunt'
alias k='kubectl'
alias s='kitten ssh'
alias hm='home-manager switch --flake ~/projects/my/dotfiles/nix#main'

# --- FZF ---
export FZF_DEFAULT_OPTS='--height 20% --layout=reverse --border --preview="if [ -d {} ]; then eza --tree --level 2 --color=always {} | head -200; elif [ -f {} ]; then bat -n --color=always --line-range :500 {}; fi" --bind="ctrl-y:accept"'

# --- Tool initializations ---
eval "$(zoxide init zsh)"
[[ $options[zle] = on ]] && source <(fzf --zsh)
eval "$(direnv hook zsh)"
source <(carapace _carapace zsh)
[[ $options[zle] = on ]] && eval "$(atuin init zsh)"

# --- Source configs ---
source "$HOME/.config/shell/rc"
source "$HOME/.config/zsh/zshrc-common"

# Syntax highlighting must load after all zle/bindkey registrations
zinit light zsh-users/zsh-syntax-highlighting

# Powerlevel10k config
[[ -f "$HOME/.config/zsh/.p10k.zsh" ]] && source "$HOME/.config/zsh/.p10k.zsh"

# Worktrunk integration
if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi
