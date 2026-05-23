def _pyclean(args):
    ![find . -type f -name "*.py[co]" -delete]
    ![find . -type d -name "__pycache__" -delete]

aliases['pyclean'] = _pyclean


def _listening(args):
    import subprocess, sys
    if len(args) > 1:
        print('Usage: listening [pattern]')
        return
    if not args:
        ![sudo lsof -iTCP -sTCP:LISTEN -n -P]
        return
    # Two stages so lsof failures stay distinguishable from grep's exit-1-on-no-match.
    # errors='replace': lsof column-truncates process names mid-UTF8 sequence.
    lsof = subprocess.run(
        ['sudo', 'lsof', '-iTCP', '-sTCP:LISTEN', '-n', '-P'],
        capture_output=True, text=True, errors='replace',
    )
    if lsof.returncode != 0:
        sys.stderr.write(lsof.stderr)
        return
    grep = subprocess.run(
        ['grep', '-i', '--color=always', args[0]],
        input=lsof.stdout, capture_output=True, text=True, errors='replace',
    )
    if grep.stdout:
        sys.stdout.write(grep.stdout)

aliases['listening'] = _listening
