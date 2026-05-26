# Interactive bash on Fedora. The exec into xonsh is gated on the container
# marker because `toolbox enter` ignores the in-container shell field in
# /etc/passwd and uses the host's $SHELL instead (toolbox bug containers/
# toolbox#908) — chsh inside the container is a no-op for toolbox enter, so
# .bashrc has to be the hook point. Gating on /run/.containerenv (podman /
# toolbox) and /.dockerenv (Docker-backed devpod) keeps host bash unaffected.
if [[ $- == *i* ]] && [[ -f /run/.containerenv || -f /.dockerenv ]] && [[ -x "$HOME/.local/bin/xonsh" ]]; then
	exec "$HOME/.local/bin/xonsh" -i
fi

# Host bash. atuin's `init bash` outputs hook code that calls `atuin` by bare
# name (PROMPT_COMMAND, Ctrl-R bind), so ~/.atuin/bin must be on PATH or every
# prompt errors with "atuin: command not found". Append (not prepend) so atuin's
# own `env` helper script in that dir doesn't shadow coreutils `env`. Dedup
# guard avoids unbounded PATH growth on `source ~/.bashrc`.
if [[ $- == *i* ]] && [[ -x "$HOME/.atuin/bin/atuin" ]]; then
	case ":$PATH:" in
		*:"$HOME/.atuin/bin":*) ;;
		*) export PATH="$PATH:$HOME/.atuin/bin" ;;
	esac
	eval "$($HOME/.atuin/bin/atuin init bash)"
fi
