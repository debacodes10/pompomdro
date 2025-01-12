#!/bin/bash

TIMER_PID=""

countdown() {
    local TIME=$1
    local MESSAGE=$2

    local SECONDS=$((TIME * 60))

    while [[ $SECONDS -gt 0 ]]; do
        echo -ne "Time remaining: $(($SECONDS / 60))m $(($SECONDS % 60))s\033[0K\r"
        sleep 1
        ((SECONDS--))

        # Check if the timer process is still running
        if [[ "$TIMER_PID" != "" && ! -d /proc/$TIMER_PID ]]; then
            echo "Timer stopped externally."
            exit 1
        fi
    done

    # Send notification when the time is up
    notify "$MESSAGE"
}

start_pomodoro() {
    local WORK_TIME=$1
    local BREAK_TIME=$2

    echo "Starting Pomodoro timer..."
    echo "Work time: $WORK_TIME minutes."
    echo "Break time: $BREAK_TIME minutes."

    # Save the work and break times to a file
    echo "$WORK_TIME" > /tmp/pomodoro_work_time.txt
    echo "$BREAK_TIME" > /tmp/pomodoro_break_time.txt

    # Continuous loop for work and break cycles
    while true; do
        echo "Work session starting..."
        countdown "$WORK_TIME" "Work time is up. Time for a break." &
        TIMER_PID=$!
        echo $TIMER_PID > /tmp/pomodoro_timer.pid  # Save the PID to a file
        wait $TIMER_PID
        if [[ $? -ne 0 ]]; then
            echo "Pomodoro timer was stopped during the work session."
            stop_timer
            return
        fi

        echo "Break session starting..."
        countdown "$BREAK_TIME" "Break time is up. Time to get back to work." &
        TIMER_PID=$!
        echo $TIMER_PID > /tmp/pomodoro_timer.pid  # Update the PID file
        wait $TIMER_PID
        if [[ $? -ne 0 ]]; then
            echo "Pomodoro timer was stopped during the break session."
            stop_timer
            return
        fi
    done
}

stop_timer() {
    if [[ -f /tmp/pomodoro_timer.pid ]]; then
        local TIMER_PID=$(cat /tmp/pomodoro_timer.pid)
        if [[ -d "/proc/$TIMER_PID" ]]; then
            echo "Stopping the timer..."
            kill $TIMER_PID
            wait $TIMER_PID 2>/dev/null
            rm /tmp/pomodoro_timer.pid  # Remove the PID file
            rm /tmp/pomodoro_work_time.txt  # Remove work time file
            rm /tmp/pomodoro_break_time.txt  # Remove break time file
        else
            echo "No timer is running."
        fi
    else
        echo "No timer is running."
    fi
}

show_status() {
    if [[ -f /tmp/pomodoro_timer.pid ]]; then
        local TIMER_PID=$(cat /tmp/pomodoro_timer.pid)
        if [[ -d "/proc/$TIMER_PID" ]]; then
            # Read work and break times from the saved files
            local WORK_TIME=$(cat /tmp/pomodoro_work_time.txt)
            local BREAK_TIME=$(cat /tmp/pomodoro_break_time.txt)
            echo "Pomodoro timer is running with $WORK_TIME minutes of work and $BREAK_TIME minutes of break."
        else
            echo "No timer is currently running."
        fi
    else
        echo "No timer is currently running."
    fi
}

pause_timer() {
    if [[ -f /tmp/pomodoro_timer.pid ]]; then
        local TIMER_PID=$(cat /tmp/pomodoro_timer.pid)
        if [[ -d "/proc/$TIMER_PID" ]]; then
            echo "Pausing the timer..."
            kill -STOP $TIMER_PID
        else
            echo "No timer is running."
        fi
    else
        echo "No timer is running."
    fi
}

resume_timer() {
    if [[ -f /tmp/pomodoro_timer.pid ]]; then
        local TIMER_PID=$(cat /tmp/pomodoro_timer.pid)
        if [[ -d "/proc/$TIMER_PID" ]]; then
            echo "Resuming the timer..."
            kill -CONT $TIMER_PID
        else
            echo "No timer is running."
        fi
    else
        echo "No timer is running."
    fi
}
