source /usr/local/bin/auditlogger/src/analysis/get_commands.sh
FREQ_REPORT="/var/log/audit/report/frequency.log"


function clean_commands {
    cat "$1" | sed 's/^: [0-9]*:[0-9]*;//' | awk '{print $1}' | sort | uniq -c | sort -nr > "$2"
}

function command_history_by_user {
    local user="$1"
    OUTPUT_FILE="$2"

    tmp=$(mktemp)
    get_command_by_user ${user} ${tmp}

    clean_commands ${tmp} ${OUTPUT_FILE} 
}

function command_freq_all {
    get_all_commands
    clean_commands ${CMD_LOG} ${FREQ_REPORT}
}


