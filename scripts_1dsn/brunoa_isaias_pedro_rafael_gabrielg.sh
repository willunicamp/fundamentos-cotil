#!/bin/bash
 echo "--- Auxiliar de SysAdmin ---"

 # 1. Segurança e Acesso
 read -p "Dir para checar: " DIR
 [ ! -d "$DIR" ] && { echo "[ERRO] Dir não existe!"; exit 1; }
 [ ! -r "$DIR" ] || [ ! -w "$DIR" ] || [ ! -x "$DIR" ] && echo "[AVISO] Falta rwx no dir."

 # 2. Análise de Recursos
 Uso=$(df / | awk 'NR==2 {print $5}' | tr -d '%')
 echo -n "Disco / (${Uso}%): "
 if (( Uso > 90 )); then echo "[CRÍTICO]";
 elif (( Uso > 70 )); then echo "[ALERTA]";
 else echo "[OK]"; fi

 # 3. Monitoramento
 PCount=$(ps -u $USER --no-headers | wc -l)
 echo "Processos ($USER): $PCount"
 echo "Top 5 (PID | CMD):"
 ps aux --sort=-%mem | head -n 6 | tail -n 5 | while read -r line; do
    PID=$(echo "$line" | awk '{print $2}')
    CMD=$(echo "$line" | awk '{print $11}')
    echo "  -> $PID | $CMD"
 done