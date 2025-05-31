#!/bin/bash

INPUT_FILE="./logs/frequency_commands.log"
ALERT_FILE="./logs/frequency_analysis_alerts.log"

echo "Análisis de Frecuencia de Comandos" > "$ALERT_FILE"
echo "" >> "$ALERT_FILE"

if [[ ! -f "$INPUT_FILE" ]]; then
    echo "Archivo de frecuencia no encontrado: $INPUT_FILE"
    exit 1
fi

TOTAL_COMMANDS=$(awk '{sum += $1} END {print sum}' "$INPUT_FILE")
TOP_COMMAND=$(head -n 1 "$INPUT_FILE" | awk '{print $2}')
TOP_COUNT=$(head -n 1 "$INPUT_FILE" | awk '{print $1}')

echo "Total de comandos analizados: $TOTAL_COMMANDS" >> "$ALERT_FILE"
echo "Comando más usado: $TOP_COMMAND ($TOP_COUNT veces)" >> "$ALERT_FILE"
echo "" >> "$ALERT_FILE"

echo "Posibles Comandos Críticos Detectados" >> "$ALERT_FILE"

CRITICAL_CMDS=("sudo" "su" "chmod" "chown" "rm" "wget" "curl" "scp" "ftp" "dd" "kill" "pkill")

while read -r line; do
    COUNT=$(echo "$line" | awk '{print $1}')
    CMD=$(echo "$line" | awk '{print $2}')
    
    if [[ " ${CRITICAL_CMDS[*]} " == *" $CMD "* ]]; then
        echo "Uso de un comando crítico '$CMD': $COUNT veces" >> "$ALERT_FILE"
    fi

    if (( COUNT > TOTAL_COMMANDS / 2 )); then
        echo "El comando '$CMD' representa más del 50% del uso total." >> "$ALERT_FILE"
    fi
done < "$INPUT_FILE"

echo "" >> "$ALERT_FILE"
echo "Análisis guardado en: $ALERT_FILE"
cat "$ALERT_FILE"
