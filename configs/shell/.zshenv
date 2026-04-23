export EDITOR="nvim"
export VISUAL="nvim"
export BROWSER="zen-browser"
export PAGER="less -R"
export LANG="en_US.UTF-8"

typeset -U path
path=(
  $HOME/.local/bin
  $HOME/.cargo/bin
  $HOME/.cache/npm/global/bin
  $path
)
