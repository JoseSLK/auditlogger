#!/bin/bash

LOGFILE="/var/log/audit/users/${USER}_session.log"



function session_log {
    DATE=$(date +"%Y-%m-%d %H:%M:%S")
    TTY=$(tty)
    echo "[ $1 | ${DATE} | user: $USER | tty:${TTY} ]" >> "$LOGFILE"
}

if [[ $- == *i* ]]; then
    session_log "login"
fi


trap 'session_log logout' EXIT 