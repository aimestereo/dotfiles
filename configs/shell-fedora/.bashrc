# Interactive bash on Fedora: drop into xonsh when present (toolbox + dev
# containers); silently stay as bash on host where xonsh isn't installed.
if [[ $- == *i* ]] && command -v xonsh >/dev/null 2>&1; then
	exec xonsh -i
fi
