# Interactive bash on Fedora: drop into xonsh when installed (toolbox + dev
# containers); silently stay as bash on host. Absolute-path test because
# `toolbox enter tools` is non-login — /etc/profile.d/local-bin.sh hasn't run.
if [[ $- == *i* ]] && [[ -x "$HOME/.local/bin/xonsh" ]]; then
	exec "$HOME/.local/bin/xonsh" -i
fi
