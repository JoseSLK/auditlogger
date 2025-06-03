#!/bin/bash

OUTPUT_FILE="./logs/frequency_commands.log"

get_history_file() {
    if [[ -f "$HOME/.bash_history" ]]; then
        echo "$HOME/.bash_history"
    elif [[ -f "$HOME/.zsh_history" ]]; then
        echo "$HOME/.zsh_history"
    else
        echo ""
    fi
}

update_history() {
    if [[ "$SHELL" == */zsh ]]; then
        fc -W 2>/dev/null
    elif [[ "$SHELL" == */bash ]]; then
        history -a 2>/dev/null
    fi
}

command_history() {
    local user="$1"

    update_history

    local history_file
    history_file=$(get_history_file)

    if [[ -z "$history_file" ]]; then
        echo "No se encontró historial de comandos para el usuario: $user"
        return 1
    fi

    mkdir -p "$(dirname "$OUTPUT_FILE")"

    cat "$history_file" | \
        sed 's/^: [0-9]*:[0-9]*;//' | \
        awk '{print $1}' | \
        sort | uniq -c | sort -nr | \
        tee "$OUTPUT_FILE"

    echo ""
    echo "Reporte de comandos frecuentes guardado en: $OUTPUT_FILE"
}

command_history "$1"

