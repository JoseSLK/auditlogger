#!/bin/bash

HISTORY_LOG="/var/log/audit/users/${USER}.log"

CRITICAL_CMDS=("sudo" "su" "chmod" "chown" "rm" "wget" "curl" "scp" "ftp" "dd" "kill" "pkill")

function is_critical_cmd {
    local cmd=$1
    for c in "${CRITICAL_CMDS[@]}"; do
        if [[ "$cmd" == "$c"* ]]; then
            return 0
        fi
    done
    return 1
}

function save_log {
    local status=$?
    local time=$(date +"%Y-%m-%d %H:%M:%S")
    local tty=$(tty)
    local cmd=${PREV_COMMAND}

    echo "[ ${time} | user: ${USER} | status:${status} | tty: ${tty} | cmd: ${cmd} ]" >> ${HISTORY_LOG}

}

trap '
    if is_critical_cmd "$BASH_COMMAND"; then
        if [[ $alert_shown -eq 0 ]]; then
            echo "WARNING!: Running critical command: $BASH_COMMAND"
            alert_shown=1
        fi
    else
        alert_shown=0
    fi
    PREV_COMMAND=${LAST_COMMAND}
    LAST_COMMAND=$BASH_COMMAND
' DEBUG
PROMPT_COMMAND='save_log'