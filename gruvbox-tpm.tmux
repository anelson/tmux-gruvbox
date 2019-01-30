#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/scripts/helpers.sh"

window_status="$CURRENT_DIR/scripts/window-status.sh"

status_interpolation="\#{window_status}"

do_interpolation() {
    local input=$1
    local result=""

    # First escape any double quotes in the input literal
    #input=${input//\"/\\\"}
    result=${input//$status_interpolation/$window_status}

    echo $result
}

update_tmux_option() {
	local option=$1
	local option_value=$(get_tmux_option "$option")
	local new_option_value=$(do_interpolation "$option_value")
	set_tmux_option "$option" "$new_option_value"
}

update_tmux_window_option() {
	local option=$1
	local option_value=$(get_tmux_window_option "$option")
	local new_option_value=$(do_interpolation "$option_value")
	set_tmux_window_option "$option" "$new_option_value"
}

main() {
    tmux source-file "$CURRENT_DIR/tmux-gruvbox-dark.conf"

    update_tmux_window_option "window-status-format"
    update_tmux_window_option "window-status-current-format"
}

main
