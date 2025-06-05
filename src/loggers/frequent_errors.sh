#!/bin/bash

LOG_DIR="/var/log/audit_frequent_errors"
ERROR_LOG="$LOG_DIR/error.log"
TMP_LOG="/tmp/audit_error_${USER}_$$.log"

LOCK_FILE="/usr/local/bin/auditlogger/setup/error.lock"


function _log_error {
    local command="$BASH_COMMAND"
    local error_message=$(eval "$command" 2>&1 >/dev/null)
    flock "${LOCK_FILE}" -c "echo \"[$(date)] User: $USER | Command: '$command' | Error message: '$error_message'\" >> \"$ERROR_LOG\""
}

set -E

trap '_log_error' ERR
