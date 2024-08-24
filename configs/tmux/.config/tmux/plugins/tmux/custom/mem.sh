#!/usr/bin/env bash

set -euo pipefail

# Shows available memory

ICON_DEFAULT=""

show_mem() {
	local index icon color text module

	index=$1 # This variable is used internally by the module loader in order to know the position of this module

	icon="$(get_tmux_option "@catppuccin_mem_icon" "$ICON_DEFAULT")"
	color="$(get_tmux_option "@catppuccin_mem_color" "$thm_blue")"
	text="$(get_tmux_option "@catppuccin_mem_text" "#($HOME/.config/tmux/plugins/tmux/custom/_mem.sh)")"

	build_status_module "$index" "$icon" "$color" "$text"
}
