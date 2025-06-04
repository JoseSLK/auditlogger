#!/bin/bash

LOG_DIR="/var/log/audit_frequent_errors"
ERROR_LOG="$LOG_DIR/error_$(date +%F).log"
TMP_LOG="/tmp/audit_error_${USER}_$$.log"

if [[ $- == *i* ]]; then
    echo "[*] User: $USER | Login: $(date)" >> "$TMP_LOG"
fi

function _log_error {
    local command="$BASH_COMMAND"
    local error_message=$(eval "$command" 2>&1 >/dev/null)
    echo "[$(date)] User: $USER | Command: '$command' | Error message: '$error_message'" >> "$TMP_LOG"
}

function _save_log {
    if [ -f "$TMP_LOG" ]; then
        cat "$TMP_LOG" | sudo tee -a "$ERROR_LOG" > /dev/null
        rm "$TMP_LOG"
    fi
}

set -E

trap '_log_error' ERR
trap '_save_log' EXIT