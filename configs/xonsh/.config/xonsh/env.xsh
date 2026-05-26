import shutil

# Set vi mode here (not in keybinds.xsh) so it's in effect BEFORE tools.xsh
# runs `atuin init xonsh` — atuin's @events.on_ptk_create registers Ctrl-R
# bindings; toggling $VI_MODE later forces xonsh to rebuild key bindings,
# which drops atuin's earlier registration.
$VI_MODE = True

$EDITOR = 'nvim'
$VISUAL = 'nvim'
# xdg-open dispatches via MIME assoc on host (resolves to zen-browser flatpak);
# inside toolbox, flatpak-xdg-utils' xdg-open hops back to host xdg-open.
# Hardcoding a flatpak app name (e.g. 'zen-browser') breaks because the flatpak
# binary isn't on PATH on either side.
$BROWSER = 'xdg-open'
$PAGER = 'less -R'
$LANG = 'en_US.UTF-8'

$XONSH_HISTORY_SIZE = (1_000_000, 'commands')

for _p in [
    f"{$HOME}/.local/bin",
    f"{$HOME}/.cargo/bin",
    f"{$HOME}/.cache/npm/global/bin",
    f"{$HOME}/.atuin/bin",
]:
    if _p not in $PATH:
        $PATH.insert(0, _p)

# `$PATH.insert()` mutates xonsh's Env value in place and bypasses
# Env.__setitem__, so os.environ['PATH'] stays at whatever the parent
# process had (bash via `exec ~/.local/bin/xonsh -i` only sets the base
# /usr/local/bin:/usr/bin in non-login shells). Python-side path lookups —
# every `shutil.which()` in tools.xsh + prompt.xsh — read os.environ
# directly, so without this sync none of zoxide / mise / carapace / atuin /
# starship initialise in the bash-exec'd xonsh. Manual `xonsh -i` from inside
# xonsh works because subprocess.Popen passes the parent's Env via env=.
import os as _os
_os.environ['PATH'] = _os.pathsep.join($PATH)

if shutil.which('id'):
    $DOCKER_USER = f"{$(id -u).strip()}:{$(id -g).strip()}"

$FZF_DEFAULT_OPTS = (
    '--height 20% --layout=reverse --border '
    '--preview="if [ -d {} ]; then eza --tree --level 2 --color=always {} | head -200; '
    'elif [ -f {} ]; then bat -n --color=always --line-range :500 {}; fi" '
    '--bind="ctrl-y:accept"'
)

del _p, _os, shutil
