#!/bin/bash

LOG_FILE="/tmp/pom/pom.log"
log_message() {
	local LEVEL=$1
	local MESSAGE=$2
	local TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
	echo "[$TIMESTAMP] [$LEVEL] $MESSAGE" >> "$LOG_FILE"
}

log_info() {
	log_message "INFO" "$1"
}

log_warning() {
	log_message "WARNING" "$1"
}

log_error() {
	log_message "ERROR" "$1"
}
