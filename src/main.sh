#!/bin/bash


source /usr/local/bin/analysis_frecuent_errors.sh
source /usr/local/bin/frequency_risky_commands.sh

# Función que crea el reporte de errores frecuentes
generate_report

# Generar reporte de comandos riesgosos
# pasar usuario como argumento: ./main.sh muskan
generate_risky_command_report "$1"
