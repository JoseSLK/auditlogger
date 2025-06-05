LOG_HISTORY="/var/log/audit/users/"
CMD_LOG="/var/log/audit/report/cmds.log"


function get_all_commands {
    find ${LOG_HISTORY} -maxdepth 1 -type f ! -name '*_session*' -exec cat {} +  | sed -n 's/.*cmd:[[:space:]]*\(.*\)/\1/p' | sed 's/.$//' > ${CMD_LOG} 
}

function get_command_by_user {
    local user=$1
    local history="${LOG_HISTORY}${user}.log"
    local OUTPUT_FILE=$2
    sed -n 's/.*cmd:[[:space:]]*\(.*\)/\1/p' "$history" | sed 's/.$//' > "$OUTPUT_FILE"
}