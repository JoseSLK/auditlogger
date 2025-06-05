CRITICAL_CMDS=("sudo" "su" "chmod" "chown" "rm" "wget" "curl" "scp" "ftp" "dd" "kill" "pkill")

generate_freq_report() {
    INPUT_FILE="$1"
    ALERT_FILE="$2"


    if [[ ! -f "$INPUT_FILE" ]]; then
        echo "Frequency File not found!: $INPUT_FILE"
        return 1
    fi

    mkdir -p "$(dirname "$ALERT_FILE")"
    echo "Command Frequency Report" > "$ALERT_FILE"
    echo "" >> "$ALERT_FILE"

    local total_commands
    total_commands=$(awk '{sum += $1} END {print sum}' "$INPUT_FILE")
    local top_command
    top_command=$(head -n 1 "$INPUT_FILE" | awk '{print $2}')
    local top_count
    top_count=$(head -n 1 "$INPUT_FILE" | awk '{print $1}')

    echo "Total Anlyzed Commands: $total_commands" >> "$ALERT_FILE"
    echo "Most Used Command: $top_command ($top_count times)" >> "$ALERT_FILE"
    echo "" >> "$ALERT_FILE"

    echo "Possible Critic Commands detected" >> "$ALERT_FILE"

    while read -r line; do
        local count
        count=$(echo "$line" | awk '{print $1}')
        local cmd
        cmd=$(echo "$line" | awk '{print $2}')

        for critical in "${CRITICAL_CMDS[@]}"; do
            if [[ "$cmd" == "$critical" ]]; then
                echo "Use of a Critic Command '$cmd': $count times" >> "$ALERT_FILE"
            fi
        done

        if (( count > total_commands / 2 )); then
            echo "The command '$cmd' is more than 50% of total use." >> "$ALERT_FILE"
        fi
    done < "$INPUT_FILE"

    echo "" >> "$ALERT_FILE"
    echo "Report stored at: $ALERT_FILE"
}