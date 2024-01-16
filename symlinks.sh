#!/usr/bin/env bash

set -euo pipefail

for d in `ls -d */ | grep -v nix | grep -v home-manager`;
do
    ( stow --restow -t ${HOME} -v $d )
done
