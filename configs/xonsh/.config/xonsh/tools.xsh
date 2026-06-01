import shutil

from xonsh.xontribs import find_xontrib

# `os` is supplied by rc.xsh (shared namespace via `source`) — do not import
# or del here. env.xsh uses `import os as _os` as the defensive pattern when
# a private alias is needed; for a single `os.path.exists` call we just
# reference the rc.xsh-provided binding.

if shutil.which('zoxide'):
    execx($(zoxide init xonsh))

# Pattern B: mise stays inactive in the `tools` toolbox. The global mise
# config is intentionally empty (project tools live in the per-project devpod
# container, not the toolbox), so the per-prompt hook-env has nothing to load
# globally and would loudly error on every untrusted project .mise.toml. Host
# (no mise installed) is a no-op via shutil.which; devpod containers (no
# /run/.toolboxenv) still activate normally.
if shutil.which('mise') and not os.path.exists('/run/.toolboxenv'):
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
