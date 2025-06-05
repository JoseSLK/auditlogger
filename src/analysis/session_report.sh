function session_report {

    LOG_FILE=$1
    REPORT_FILE=$2

    declare -A login_time
    declare -A login_user

    if [[ -z "$3"  ]]; then
        echo "Saving session log in $2"
    fi

    > "$REPORT_FILE" 

    while IFS= read -r line; do

        action=$(echo "$line" | grep -oP '^\[\s*\K[^ ]+')
        timestamp=$(echo "$line" | grep -oP '\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}')
        user=$(echo "$line" | grep -oP 'user: \K[^ ]+')
        tty=$(echo "$line" | grep -oP 'tty:\K[^ ]+')

        key="${user}_${tty}"

        if [[ $action == "login" ]]; then
            login_time["$key"]="$timestamp"
            login_user["$key"]="$user"
        elif [[ $action == "logout" ]]; then
            if [[ -n "${login_time[$key]}" ]]; then
                start="${login_time[$key]}"
                end="$timestamp"
                duration=$(( $(date -d "$end" +%s) - $(date -d "$start" +%s) ))
                printf "%s | %s | start: %s | end: %s | duration(s): %ds\n" \
                    "$user" "$tty" "$start" "$end" "$duration" >> "$REPORT_FILE"
                unset login_time["$key"]
                unset login_user["$key"]
            fi
        fi
    done < "$LOG_FILE"

    for key in "${!login_time[@]}"; do
        user="${key%%_*}"
        tty="${key#*_}"
        start="${login_time[$key]}"
        end=$(date "+%Y-%m-%d %H:%M:%S")
        duration=$(( $(date -d "$end" +%s) - $(date -d "$start" +%s) ))
        printf "%s | %s | start: %s  (ACTIVE) | duration(s): %ds\n" \
            "$user" "$tty" "$start" "$duration" >> "$REPORT_FILE"
    done
}


function all_session_report {
    LOG_HISTORY="/var/log/audit/users/"
    REPORT_FILE="/var/log/audit/report/sessions.log"
    tmp=$(mktemp)
    find ${LOG_HISTORY} -maxdepth 1 -type f -name '*_session*' -exec cat {} + > ${tmp} 
    chmod 600 ${tmp}
    session_report "$tmp" "$REPORT_FILE"
}

function session_report_by_user {
    user=$1
    LOG_HISTORY="/var/log/audit/users/${user}_session.log"
    REPORT_FILE="/var/log/audit/report/${user}_sessions.log"
    session_report "${LOG_HISTORY}" "${REPORT_FILE}"
}

function session_report_by_user_tmp {
    user=$1
    tmp=$2
    LOG_HISTORY="/var/log/audit/users/${user}_session.log"
    session_report "${LOG_HISTORY}" "${tmp}" "n"
}

