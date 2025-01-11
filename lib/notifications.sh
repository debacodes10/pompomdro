#!/bin/bash

notify() {
	MESSAGE=$1

	if command -v notify-send &> /dev/null; then
		notify-send "Pomodoro Timer" "$MESSAGE"
	elif command -v osascript &> /dev/null; then
		osascript -e "display notification \"$MESSAGE\" with the title \"Pomodoro Timer\""
	else
		echo "$MESSAGE"
	fi
}
