#!/bin/bash

echo "Current user's command usage frequency"

OUTPUT_FILE="./logs/frequency_commands.log"

if [[ "$SHELL" == */zsh ]]; then
    fc -W 2>/dev/null
elif [[ "$SHELL" == */bash ]]; then
    history -a 2>/dev/null
fi

if [[ -f "$HOME/.bash_history" ]]; then
    HISTORY_FILE="$HOME/.bash_history"
elif [[ -f "$HOME/.zsh_history" ]]; then
    HISTORY_FILE="$HOME/.zsh_history"
else
    echo "No se encontró historial de comandos."
    exit 1
fi

cat "$HISTORY_FILE" | sed 's/^: [0-9]*:[0-9]*;//' | awk '{print $1}' | sort | uniq -c | sort -nr | tee "$OUTPUT_FILE"

echo "Frequency saved in: $OUTPUT_FILE"