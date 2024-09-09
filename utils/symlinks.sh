#!/usr/bin/env bash

set -euo pipefail

ignored_line='BUG in find_stowed_path? Absolute/relative mismatch'

stow="/nix/store/skr5pb3gxq9b59ymmr7vxws6hfizj5lp-home-manager-path/bin/stow"

cd configs/

ls -d */ |
	xargs -I{} bash -c \
		"${stow} --restow -t $HOME -v {} 2> >(grep -v '${ignored_line}' 1>&2)"
