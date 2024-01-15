#!/usr/bin/env bash

set -euo pipefail

for d in `ls -d */ | grep -v nix`;
do
    ( stow --restow -t ${HOME} -v $d )
done
