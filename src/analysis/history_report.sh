
LOG_DIR_REPORT="/var/log/audit/report/"
LOG_HISTORY="/var/log/audit/users/"

function generate_history_all_report {
    filename="${LOG_DIR_REPORT}history.log"
    echo "Saving All Command History on ${filename}"
    find ${LOG_HISTORY} -maxdepth 1 -type f ! -name '*_session*' -exec cat {} + | sort  > ${filename}
}