# Fedora .bashrc — kept separate from Mac so the two can diverge.
#
# On Fedora Atomic host: xonsh is NOT installed, this line is a no-op,
# and the shell stays plain bash. The host is intentionally minimal.
# In the toolbox `tools` and in DevPod containers (both have xonsh), the
# exec fires and drops into the dev shell. Same file via $HOME bind-mount,
# different behaviour driven by whether xonsh is on PATH.
if [[ $- == *i* ]] && command -v xonsh >/dev/null 2>&1; then
	exec xonsh -i
fi
