# Interactive bash logins drop straight into xonsh (when present), keeping bash
# as the system login shell so /etc/profile and PAM continue to apply normally.
if [[ $- == *i* ]] && command -v xonsh >/dev/null 2>&1; then
	exec xonsh -i
fi
