# Interactive bash on Fedora: drop into xonsh when installed (toolbox + dev
# containers); silently stay as bash on host. Absolute-path test because
# `toolbox enter tools` is non-login — /etc/profile.d/local-bin.sh hasn't run.
if [[ $- == *i* ]] && [[ -x "$HOME/.local/bin/xonsh" ]]; then
	exec "$HOME/.local/bin/xonsh" -i
fi

# Reached only if the xonsh exec was skipped (xonsh not installed / not
# executable). Wire up atuin in bash so Ctrl-R still hits the atuin TUI
# rather than readline's reverse-i-search.
if [[ $- == *i* ]] && [[ -x "$HOME/.atuin/bin/atuin" ]]; then
	eval "$($HOME/.atuin/bin/atuin init bash)"
fi
