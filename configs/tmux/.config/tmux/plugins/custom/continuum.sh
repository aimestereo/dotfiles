#!/usr/bin/env bash

# Simple plugin to show the status of tmux-continuum
# Just an example of how to use the plugin system
# no real use case for this

set -euo pipefail

print_tmux_status() {
	local text="#{continuum_status}"

	echo "Continuum: $text"
}

main() {
	print_tmux_status
}

main
