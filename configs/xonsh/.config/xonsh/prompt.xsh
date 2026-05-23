import shutil

if shutil.which('starship'):
    execx($(starship init xonsh))

del shutil
