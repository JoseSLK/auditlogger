#!/bin/bash

INPUT_FILE="./logs/frequency_commands.log"
ALERT_FILE="./logs/frequency_analysis_alerts.log"

CRITICAL_CMDS=("sudo" "su" "chmod" "chown" "rm" "wget" "curl" "scp" "ftp" "dd" "kill" "pkill")

generate_report() {
    echo "Iniciando análisis de frecuencia de comandos..."

    if [[ ! -f "$INPUT_FILE" ]]; then
        echo "Archivo de frecuencia no encontrado: $INPUT_FILE"
        return 1
    fi

    mkdir -p "$(dirname "$ALERT_FILE")"
    echo "Análisis de Frecuencia de Comandos" > "$ALERT_FILE"
    echo "" >> "$ALERT_FILE"

    local total_commands
    total_commands=$(awk '{sum += $1} END {print sum}' "$INPUT_FILE")
    local top_command
    top_command=$(head -n 1 "$INPUT_FILE" | awk '{print $2}')
    local top_count
    top_count=$(head -n 1 "$INPUT_FILE" | awk '{print $1}')

    echo "Total de comandos analizados: $total_commands" >> "$ALERT_FILE"
    echo "Comando más usado: $top_command ($top_count veces)" >> "$ALERT_FILE"
    echo "" >> "$ALERT_FILE"

    echo "Posibles Comandos Críticos Detectados" >> "$ALERT_FILE"

    while read -r line; do
        local count
        count=$(echo "$line" | awk '{print $1}')
        local cmd
        cmd=$(echo "$line" | awk '{print $2}')

        for critical in "${CRITICAL_CMDS[@]}"; do
            if [[ "$cmd" == "$critical" ]]; then
                echo "Uso de un comando crítico '$cmd': $count veces" >> "$ALERT_FILE"
            fi
        done

        if (( count > total_commands / 2 )); then
            echo "El comando '$cmd' representa más del 50% del uso total." >> "$ALERT_FILE"
        fi
    done < "$INPUT_FILE"

    echo "" >> "$ALERT_FILE"
    echo "Análisis guardado en: $ALERT_FILE"
    cat "$ALERT_FILE"
}

generate_report "$1"

