#!/usr/bin/env bash

# Call this script with DEBUG=1 to add some debugging output
if [[ "$DEBUG" ]]; then
	export PS4='+ [${BASH_SOURCE##*/}:${LINENO}] '
	set -x
fi

# Call this script with TEST_RUN=1 to test without calling tmux functions
if [[ "$TEST_RUN" ]]; then
	test_run=1
else
	test_run=""
fi

# set -o pipefail
# set -euo pipefail

ALERT_IF_IN_NEXT_MINUTES=15
ALERT_POPUP_BEFORE_SECONDS=10
ICON_FREE="󱁕"
ICON_BUSY="󰤙"
ICON_ERROR=""

# Echoes given args to STDERR
#
# $@ - args to pass to echo
debug() {
	if [[ "$test_run" ]]; then
		echo "$@" >&2
	fi
}

# Echoes given args to STDERR
#
# $@ - args to pass to echo
warn() {
	echo "$@" >&2
}

fetch_events() {
	# Example of JSON output:
	# [
	#   {
	#     "title": "Test 4",
	#     "calendar": "aimestereo@gmail.com",
	#     "notes": "",
	#     "date": "2024-08-24",
	#     "start_at": "16:45",
	#     "end_at": "16:55",
	#     "start_at_iso": "2024-08-24T16:45:00",
	#     "end_at_iso": "2024-08-24T16:55:00",
	#     "duration": 10,
	#     "urls": []
	#   }
	# ]

	local events=$("$HOME"/.local/bin/ical-buddy-json --tmux)
	debug "events=$events"
	echo "$events"
}

filter_events() {
	local events=$1
	local now=$(date +%Y-%m-%dT%H:%M:%S)

	# sort json by .start_at_iso and filter out already started events
	local filtered_events=$(
		jq -c --arg now "$now" \
			'sort_by(.start_at_iso) | map(select(.start_at_iso >= $now))' <<<"$events"
	)

	debug "filtered_events=$filtered_events"
	echo "$filtered_events"
}

parse_result() {
	local events="$1"

	if [[ "$events" == "[]" ]]; then
		debug "No events"
		return 1
	fi

	debug "Events found"

	next_event=$(jq -r '.[0]' <<<"$events")
	debug "next_event=$next_event"

	start_time=$(jq -r '.start_at_iso' <<<"$next_event")
	end_time=$(jq -r '.end_at_iso' <<<"$next_event")
	title=$(jq -r '.title' <<<"$next_event")
	notes=$(jq -r '.notes' <<<"$next_event")

	debug "start_time=$start_time"
	debug "end_time=$end_time"
	debug "title=$title"
	debug "notes=$notes"

	return 0
}

calculate_times() {
	epoc_event=$(date -j -f "%Y-%m-%dT%H:%M:%S" "$start_time" +%s)
	epoc_now=$(date +%s)
	epoc_diff=$((epoc_event - epoc_now))
	minutes_till_event=$((epoc_diff / 60))
}

display_popup() {
	tmux display-popup \
		-S "fg=#eba0ac" \
		-w50% \
		-h50% \
		-d '#{pane_current_path}' \
		-T meeting \
		icalBuddy \
		--propertyOrder "datetime,title" \
		--noCalendarNames \
		--formatOutput \
		--includeEventProps "title,datetime,notes,url,attendees" \
		--includeOnlyEventsFromNowOn \
		--limitItems 1 \
		--excludeAllDayEvents \
		--excludeCals "example_cal1,example_cal2" \
		eventsToday
}

set_result_vars() {
	if [[ $minutes_till_event -lt $ALERT_IF_IN_NEXT_MINUTES &&
		$minutes_till_event -gt -60 ]]; then
		result_icon=$ICON_BUSY
		result_text="$start_time $title ($minutes_till_event minutes)"
	else
		result_icon=$ICON_FREE
		result_text=""
	fi
}

update_tmux_module() {
	if [[ "$test_run" ]]; then
		echo "update_tmux_module $@"
		return
	fi

	local icon text

	icon=$1
	text=$2
	echo "$icon $text"

	if [[ $epoc_diff -gt $ALERT_POPUP_BEFORE_SECONDS && epoc_diff -lt $ALERT_POPUP_BEFORE_SECONDS+10 ]]; then
		display_popup
	fi
}

main() {
	local calendars raw events filtered_events

	while [[ $# -gt 0 ]]; do
		case "$1" in
		-r | --raw)
			raw=1
			shift
			;;
		-c | --calendars)
			calendars="$2"
			shift 2
			;;
		--)
			shift
			break
			;;
		-*)
			warn "Invalid option '$1'"
			return 1
			;;
		*) break ;;
		esac
	done

	if ! events="$(fetch_events)"; then
		debug "IF: Error fetching events"
		update_tmux_module "$ICON_ERROR" ""
		return 0
	fi

	filtered_events=$(filter_events "$events")

	if ! parse_result "$filtered_events"; then
		debug "IF: No events or parsing error"
		update_tmux_module "$ICON_FREE" ""
		return 0
	fi

	calculate_times
	set_result_vars
	update_tmux_module "$result_icon" "$result_text"

	return 0
}

main "$@"
