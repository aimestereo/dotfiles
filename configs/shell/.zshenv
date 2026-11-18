export EDITOR="nvim"
export VISUAL="nvim"
export BROWSER="zen-browser"
export PAGER="less -R"
export LANG="en_US.UTF-8"
export NO_PROXY="mcp.atlassian.com,auth.atlassian.com,id.atlassian.com,api.atlassian.com,mcp.slack.com,mcp.sentry.dev,mcp.miro.com,localhost,127.0.0.1"
export no_proxy="mcp.atlassian.com,auth.atlassian.com,id.atlassian.com,api.atlassian.com,mcp.slack.com,mcp.sentry.dev,mcp.miro.com,localhost,127.0.0.1"

typeset -U path
path=(
  $HOME/.local/bin
  $HOME/.cargo/bin
  $HOME/.cache/npm/global/bin
  ${GOBIN:-${GOPATH:-$HOME/go}/bin}
  $path
)
