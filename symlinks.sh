#!/usr/bin/env bash

set -euo pipefail

for d in `ls -d */`;
do
    ( stow --restow -t ${HOME} -v $d )
done
