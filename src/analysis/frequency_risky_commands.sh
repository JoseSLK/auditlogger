#!/bin/bash

generate_risky_command_report() {
    local target_user="${1:-$USER}"  
    local output_dir="/home/$target_user/logs"
    local output_file="$output_dir/frequency_risky_commands.log"

    mkdir -p "$output_dir"

    local history_file
    if [[ -f "/home/$target_user/.bash_history" ]]; then
        history_file="/home/$target_user/.bash_history"
    elif [[ -f "/home/$target_user/.zsh_history" ]]; then
        history_file="/home/$target_user/.zsh_history"
    else
        echo "No se encontró archivo de historial para el usuario: $target_user"
        return 1
    fi

    # Comandos riesgosos separados por pipe para grep
    local risky_commands="sudo|rm|chmod|chown|kill"

    echo "Frecuencia de comandos riesgosos para el usuario $target_user:" > "$output_file"
    
    # Buscar comandos riesgosos y contar ocurrencias, guardar en archivo
    grep -E "\b($risky_commands)\b" "$history_file" | awk '{print $1}' | \
        sort | uniq -c | sort -nr >> "$output_file"

    # Mostrar contenido generado
    cat "$output_file"

    echo "Frecuencia de comandos riesgosos guardada en: $output_file"
}

# Ejecutar la función (puedes pasar un usuario, si no usa $USER)
# generate_risky_command_report
