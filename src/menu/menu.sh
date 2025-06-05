USERS="/usr/local/bin/auditlogger/setup/users.config"
PATH_AUDIT="/usr/local/bin/auditlogger/src/analysis"

source ${PATH_AUDIT}/analysis_frecuent_errors.sh
source ${PATH_AUDIT}/analysis_frequency_commands.sh
source ${PATH_AUDIT}/frequency_commands.sh
source ${PATH_AUDIT}/frequency_risky_commands.sh
source ${PATH_AUDIT}/history_report.sh
source ${PATH_AUDIT}/session_report.sh


function history_log {
    echo "[*] Generating All Command History. . . "
    generate_history_all_report 
}

function session {
    echo "[*] Generating All Session Resume. . . "
    all_session_report
}

function session_by_user {
    echo "[*] Generating Session Resume of $1. . . "
    session_report_by_user "$1"
}


function errors {
    echo "[*] Analyzing Errors. . . "
    generate_report
}

function freqency {
    echo "[*] Analyzing Overall Commands. . . "
    ALERT_ALL="/var/log/audit/report/freq_alerts.log"
    command_freq_all
    generate_freq_report ${FREQ_REPORT} ${ALERT_ALL}
}

function frequency_by_user {
    user=$1
    out="/var/log/audit/report/${user}.log"
    out_alert="/var/log/audit/report/${user}_alert.log"
    command_history_by_user "${user}" "${out}"
    generate_freq_report ${out} ${out_alert}
}


function all_general_audit {
    history_log
    session
    errors
    freqency
}


function header {
    clear
    title=$(figlet  "AuditLogger" | gum style --border double --padding "1 4" --margin "0 0" --foreground 212)
    width=$(tput cols)
    width_box=$(echo "${title}" | awk '{ print length }' | sort -nr | head -n1)
    spaces=$(( ( width - width_box ) / 2 ))

    while IFS= read -r line; do
        printf "%*s%s\n" ${spaces} "" "${line}" 
    done <<< "${title}"
}