import shutil

from xonsh.xontribs import find_xontrib

if shutil.which('zoxide'):
    execx($(zoxide init xonsh))

if shutil.which('mise'):
    execx($(mise activate xonsh))

if shutil.which('carapace'):
    execx($(carapace _carapace xonsh))

# direnv has no native `direnv hook xonsh`; xonsh-direnv (PyPI) provides
# the xontrib that wires on_chdir / on_post_init handlers instead.
if find_xontrib('direnv'):
    xontrib load direnv

# fzf-widgets provides Ctrl-T (file picker) and Alt-C (cd), and also binds
# Ctrl-R to its own fzf history search. Loaded before atuin so atuin's init
# registers Ctrl-R last and wins — last prompt_toolkit binding wins.
if find_xontrib('fzf-widgets'):
    xontrib load fzf-widgets

if shutil.which('atuin'):
    execx($(atuin init xonsh))

del shutil, find_xontrib
