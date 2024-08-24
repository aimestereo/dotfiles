#!/usr/bin/env bash

set -euo pipefail

# Shows available memory

ICON_DEFAULT=""

show_mem() {
	local index icon color text module

	tmux_batch_options_commands+=("set-option -gq @mem_medium_thresh 1 ;") # background color when mem is low
	tmux_batch_options_commands+=("set-option -gq @mem_high_thresh 3 ;")   # background color when mem is medium

	tmux_batch_options_commands+=("set-option -gq @mem_low_bg_color $thm_red ;")       # background color when mem is low
	tmux_batch_options_commands+=("set-option -gq @mem_medium_bg_color $thm_orange ;") # background color when mem is medium
	tmux_batch_options_commands+=("set-option -gq @mem_high_bg_color $thm_blue ;")     # background color when mem is high

	run_tmux_batch_commands

	index=$1 # This variable is used internally by the module loader in order to know the position of this module

	icon="$(get_tmux_option "@catppuccin_mem_icon" "$ICON_DEFAULT")"
	color="$(get_tmux_option "@catppuccin_mem_color" "#($HOME/.config/tmux/plugins/tmux/custom/mem_bg_color.sh)")"
	text="$(get_tmux_option "@catppuccin_mem_text" "#($HOME/.config/tmux/plugins/tmux/custom/_mem.sh)")"

	build_status_module "$index" "$icon" "$color" "$text"
}
