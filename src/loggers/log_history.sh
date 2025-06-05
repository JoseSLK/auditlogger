#!/bin/bash

HISTORY_LOG="/var/log/audit/users/${USER}.log"

function save_log {

    local status=$?
    local time=$(date +"%Y-%m-%d %H:%M:%S")
    local tty=$(tty)
    local cmd=${PREV_COMMAND}

    echo "[ ${time} | user: ${USER} | status:${status} | tty: ${tty} | cmd: ${cmd} ]" >> ${HISTORY_LOG}
}

trap 'PREV_COMMAND=${LAST_COMMAND};LAST_COMMAND=$BASH_COMMAND' DEBUG
PROMPT_COMMAND='save_log'