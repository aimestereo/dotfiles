import os, sys

_dir = $XONSH_CONFIG_DIR


def _load(name):
    try:
        source @(os.path.join(_dir, name))
    except Exception as e:
        print(f'xonsh: failed to source {name}: {e}', file=sys.stderr)


for _n in ('env.xsh', 'aliases.xsh', 'functions.xsh', 'tools.xsh', 'keybinds.xsh', 'prompt.xsh'):
    _load(_n)

del _load, _dir, _n, os, sys
