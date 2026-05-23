import shutil

from xonsh.xontribs import find_xontrib

if shutil.which('zoxide'):
    execx($(zoxide init xonsh))

if shutil.which('mise'):
    execx($(mise activate xonsh))

if shutil.which('atuin'):
    execx($(atuin init xonsh))

if shutil.which('carapace'):
    execx($(carapace _carapace xonsh))

# direnv has no native `direnv hook xonsh`; xonsh-direnv (PyPI) provides
# the xontrib that wires on_chdir / on_post_init handlers instead.
if find_xontrib('direnv'):
    xontrib load direnv

# fzf widgets (Ctrl-T file picker, Alt-C cd). Atuin's Ctrl-R takes precedence.
if find_xontrib('fzf-widgets'):
    xontrib load fzf-widgets

del shutil, find_xontrib
