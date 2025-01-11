#!/bin/bash

source ../lib/timer.sh
source ../lib/notifications.sh

DEFAULT_WORK_TIME=25
DEFAULT_BREAK_TIME=5

show_help() {
    echo "Pomodoro CLI Tool"
    echo "Usage:"
    echo "  pom start [-t <work_time>] [-b <break_time>]"
    echo "  pom status"
    echo "  pom stop"
    echo ""
    echo "Options:"
    echo "  -t, --time    Specify the work time in minutes (default: 25)"
    echo "  -b, --break   Specify the break time in minutes (default: 5)"
    echo "  -h, --help    Show this help message"
}

start_timer() {
	WORK_TIME=$DEFAULT_WORK_TIME
	BREAK_TIME=$DEFAULT_BREAK_TIME
	
	while [[ "$1" == "-t" || "$1" == "--time" ]]; do
		WORK_TIME=$2
		shift 2
	done

	while [[ "$1" == "-b" || "$1" == "--break" ]]; do
		BREAK_TIME=$2
		shift 2
	done

	start_pomodoro "$WORK_TIME" "$BREAK_TIME"
}

while [[ "$1" != "" ]]; do
	case $1 in
		start)
			shift
			start_timer "$@"
			exit 0
			;;
		
		status)
			show_status
			exit 0
			;;
		
		stop)
			stop_timer
			exit 0
			;;
		
		pause)
			pause_timer
			exit 0
			;;

		resume)
			resume_timer
			exit 0
			;;

		-h|--help)
			show_help
			exit 0
			;;

		*)
			echo "Invalid Option: $1"
			show_help
			exit 1
			;;
	esac
done
