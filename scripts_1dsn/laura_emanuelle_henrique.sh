#!/bin/bash

echo "Digite o nome do diretório:"
read DIR

if [ -d "$DIR" ]; then
    echo "O diretório existe."
else
    echo "O diretório NÃO existe."
    exit 1
fi

echo "Informações do diretório:"
ls -ld "$DIR"

#PERMISSAO=$(ls -ld "$DIR" | cut -c 2-4)
PERMISSAO=$(ls -ld "$DIR" | awk '{print substr($1, 2, 3)}')

PERMISSAO_REQUERIDA="rwx"

if [ "$PERMISSAO" != "$PERMISSAO_REQUERIDA" ]; then
    echo "[AVISO] Permissões insuficientes no diretório $DIR."
    echo "Permissões encontradas: $PERMISSAO. Permissões requeridas: rwx."
fi

echo "Uso de disco da partição /:"
df -h /

USO=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')

if [ "$USO" -gt 90 ]; then
    echo "CRÍTICO: uso acima de 90%."
elif [ "$USO" -gt 70 ]; then
    echo "ALERTA: uso acima de 70%."
else
    echo "OK: uso normal."
fi

USER=$(whoami)

echo "Número de processos desse usuário:"
ps -u "$USER" | wc -l

echo "Top 5 processos que mais usam memória:"
PROCESS_LINES=$(ps -u "$USER" -o pid,command --sort=-%mem | tail -n +2 | head -n 5)
    
COUNT=1
while read -r PID CMD; do
    echo "[$COUNT] PID: $PID | Comando: $CMD"
    COUNT=$((COUNT + 1))
done <<EOF
$PROCESS_LINES
EOF

#done <<< "$PROCESS_LINES"    
