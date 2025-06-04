#!/bin/bash

LOG_DIR="/var/log/audit_frequent_errors"
ERROR_LOG="$LOG_DIR/error_$(date +%F).log"
REPORT="$LOG_DIR/report_$(date +%F).log"

declare -a COMMON_COMMANDS=("ls" "cd" "mkdir" "rm" "cp" "mv" "cat" "nano" "vim" "grep" "find" "ps" "top" "kill" "touch" "echo")

classify_types_errors() {
    echo "## Tipos de error más comunes:"

    grep "Error message:" "$ERROR_LOG" | awk -F"Error message: " '{print $2}' |
        sed -e "s/$(echo -ne '\047')//g" \
            -e 's/ ls .*/ ls/' \
            -e 's/ cd .*/ cd/' \
            -e 's/:.*$/: command not found/' \
            -e 's/No such file or directory//' \
            -e 's/ls: cannot access '\''.*'\''/ls: cannot access '\''file'\''/' \
            -e 's/cd: .*$/cd: No such file or directory/' \
            -e 's/-bash: \(.*\): command not found/-bash: command not found/' \
            -e 's/invalid option -- '\''.''/invalid option/' \
            -e 's/[[:space:]]*$//' |
        sort | uniq -c | sort -nr
    echo ""
}

count_use_specific_commands() {
    echo "## Errores por comandos específicos:"

    for cmd in "${COMMON_COMMANDS[@]}"; do
        count=$(grep "Command: '$cmd" "$ERROR_LOG" | wc -l)
        if [ $count -gt 0 ]; then
            echo "      $count errores con el comando '$cmd'"
        fi
    done
    echo ""
}

list_users_with_errors() {
    echo "## Usuarios con más errores:"
    grep "Command:" "$ERROR_LOG" | awk -F"User: " '{print $2}' | awk '{print $1}' | sort | uniq -c | sort -nr
    echo ""
}

count_untracked_commands() {
    echo "## Comandos desconocidos (no reconocidos en lista blanca):"

    cut -d "'" -f2 "$ERROR_LOG" | while read -r command; do

        [[ -z "$command" ]] && continue

        base_cmd=$(echo "$command" | awk '{print $1}')

        encontrado=0
        for cmd in "${COMMON_COMMANDS[@]}"; do
            if [[ "$base_cmd" == "$cmd" ]]; then
                encontrado=1
                break
            fi
        done

        if [[ $encontrado -eq 0 ]]; then
            echo "$base_cmd"
        fi
    done | sort | uniq -c | sort -nr
    echo ""
}

generate_report() {
    echo "# Informe de Errores Frecuentes" >"$REPORT"
    echo "Generado el: $(date)" >>"$REPORT"
    echo "" >>"$REPORT"

    classify_types_errors >>"$REPORT"
    count_use_specific_commands >>"$REPORT"
    count_untracked_commands >>"$REPORT"
    list_users_with_errors >>"$REPORT"

    echo "Informe generado en: $REPORT"
}
