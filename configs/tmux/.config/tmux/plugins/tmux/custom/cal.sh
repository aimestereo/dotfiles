#!/usr/bin/env bash

set -euo pipefail

ICON_DEFAULT=""

show_cal() {
	local index icon color text module

	index=$1 # This variable is used internally by the module loader in order to know the position of this module

	icon="$(get_tmux_option "@catppuccin_cal_icon" "$ICON_DEFAULT")"
	color="$(get_tmux_option "@catppuccin_cal_color" "$thm_blue")"
	text="$(get_tmux_option "@catppuccin_cal_text" "#($HOME/.config/tmux/plugins/tmux/custom/_cal.sh)")"

	build_status_module "$index" "$icon" "$color" "$text"
}
