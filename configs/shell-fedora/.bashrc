# Host-side bash startup. Toolbox / devpod containers don't source this
# anymore — their login shell is xonsh (set by install-personal-tools via
# chsh inside each container).
#
# Wire up atuin so host bash's Ctrl-R hits the atuin TUI rather than
# readline's reverse-i-search.
if [[ $- == *i* ]] && [[ -x "$HOME/.atuin/bin/atuin" ]]; then
	eval "$($HOME/.atuin/bin/atuin init bash)"
fi
