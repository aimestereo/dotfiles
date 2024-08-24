# is second float bigger or equal?
fcomp() {
	awk -v n1="$1" -v n2="$2" 'BEGIN {if (n1<=n2) exit 0; exit 1}'
}

# tmux inner func, useful for scripts called outside of tmux
get_tmux_option() {
	local option
	local default_value
	local option_value

	option="$1"
	default_value="$2"
	option_value="$(tmux show-option -qv "$option")"

	if [ "$option_value" = "" ]; then
		option_value="$(tmux show-option -gqv "$option")"
	fi

	if [ "$option_value" = "" ]; then
		echo "$default_value"
	else
		echo "$option_value"
	fi
}

# compare the value to the thresholds and return the status
load_status() {
	local value=$1
	local prefix=$2

	medium_thresh=$(get_tmux_option "@${prefix}_medium_thresh" "30")
	high_thresh=$(get_tmux_option "@${prefix}_high_thresh" "80")

	if fcomp "$high_thresh" "$value"; then
		echo "high"
	elif fcomp "$medium_thresh" "$value" && fcomp "$value" "$high_thresh"; then
		echo "medium"
	else
		echo "low"
	fi
}
