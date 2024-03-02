#!/usr/bin/env bash

set -euo pipefail

function stow() {
    bash -c "stow $* 2> >(grep -v 'BUG in find_stowed_path? Absolute/relative mismatch' 1>&2)"
}

for d in `ls -d */`;
do
    ( stow --restow -t ${HOME} -v $d )
done
