import shutil

$EDITOR = 'nvim'
$VISUAL = 'nvim'
$BROWSER = 'zen-browser'
$PAGER = 'less -R'
$LANG = 'en_US.UTF-8'

$XONSH_HISTORY_SIZE = (1_000_000, 'commands')

for _p in [
    f"{$HOME}/.local/bin",
    f"{$HOME}/.cargo/bin",
    f"{$HOME}/.cache/npm/global/bin",
]:
    if _p not in $PATH:
        $PATH.insert(0, _p)

if shutil.which('id'):
    $DOCKER_USER = f"{$(id -u).strip()}:{$(id -g).strip()}"

$FZF_DEFAULT_OPTS = (
    '--height 20% --layout=reverse --border '
    '--preview="if [ -d {} ]; then eza --tree --level 2 --color=always {} | head -200; '
    'elif [ -f {} ]; then bat -n --color=always --line-range :500 {}; fi" '
    '--bind="ctrl-y:accept"'
)

del _p, shutil
