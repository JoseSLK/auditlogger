#!/bin/bash

# Archivo donde se guarda el reporte
OUTPUT_FILE="$HOME/logs/frequency_risky_commands.log"

# Lista de comandos considerados "peligrosos"
RISKY_COMMANDS="sudo|rm|dd|chmod|chown|mkfs|kill|shutdown|reboot|iptables|systemctl"

# Identificar archivo de historial
if [[ -f "$HOME/.bash_history" ]]; then
    HISTORY_FILE="$HOME/.bash_history"
elif [[ -f "$HOME/.zsh_history" ]]; then
    HISTORY_FILE="$HOME/.zsh_history"
else
    echo "No se encontró historial de comandos."
    exit 1
fi

# Extraer comandos peligrosos y contar frecuencia
grep -E "^($RISKY_COMMANDS)" "$HISTORY_FILE" | awk '{print $1}' | sort | uniq -c | sort -nr | tee "$OUTPUT_FILE"

echo "Frecuencia de comandos riesgosos guardada en: $OUTPUT_FILE"
