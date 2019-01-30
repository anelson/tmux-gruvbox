#/usr/bin/env sh
#
# Format the window status for the tmux status line
#
# Take into account the following:
#
# * If the key binding table is 'off', that means tmux bindings are disable and being passed
#   through to a remote tmux instance, so we want to hide all windows from the status bar
# * The current window should be highlighted while the other windows are not highlighted
# * Each window should have icons indicating if it's zoomed, active, or has a bell
#
# The config file passes the following arguments:
#
#  $1 - window ID
#  $2 - window index number
#  $3 - window name
#  $4 - is-current set to 1 if this is the current window else 0

#set-window-option -g window-status-current-format "#{? #{!=:#{client_key_table},off},#[fg=colour239, bg=colour248, nobold, noitalics, nounderscore]#[fg=colour239, bg=colour214] #I #[fg=colour239, bg=colour214, bold] ${win_name_and_icons} #[fg=colour214, bg=colour237, nobold, noitalics, nounderscore],}"
window_id=$1
window_index=$2
window_name="$3"
is_current=$4

# the client key table tells us which key bindings are active.  possible values are an
# empty string which is the normal bindings, and "off" indicating the key bindings are disabled
client_key_table=$(tmux display-message -p -t $window_id "#{client_key_table}" )

win_is_zoomed="#{?window_zoomed_flag,🔍,}"
win_activity="#{?window_activity_flag,,}"
win_bell="#{?window_bell_flag,,}"
win_status_icons="${win_is_zoomed}${win_activity}${win_bell}"
win_name_and_icons="#W ${win_status_icons}"

set_colors() {
    fg=$1
    bg=$2
    printf "#[fg=$fg,bg=$bg"
}

# If the key table is 'off', don't output anything
if [ "$client_key_table" != "off" ]; then
    printf "#[nobold,noitalics,nounderscore]"
    # Left-most powerline symbol 
    if [ "$is_current" = "1" ]; then
	set_colors "colour237" "colour214"
    else
	set_colors "colour237" "colour239"
    fi

    printf "]"

    # Index number of the window
    if [ "$is_current" = "1" ]; then
	set_colors "colour239" "colour214"
    else
	set_colors "colour223" "colour239"
    fi

    printf "] #I "

    # Name of window
    if [ "$is_current" = "1" ]; then
	printf "#[bold]"
    fi

    printf " ${win_name_and_icons} "

    # Right-side powerline symbol 
    if [ "$is_current" = "1" ]; then
	set_colors "colour214" "colour237"
    else
	set_colors "colour239" "colour237"
    fi

    printf ",nobold]"

    printf "\n"
fi

