#!/bin/bash
# monitor_ambiente.sh - Script de monitoramento (Missões 1, 2 e 3)



echo "Digite o diretório que deseja verificar:"
read DIR

# Validação
if [ ! -d "$DIR" ]; then
    echo "[ERRO] O diretório não existe."
    exit 1
fi

# Auditoria de permissões
echo "Verificando permissões (rwx) do usuário atual..."
PERMS=$(stat -c %A "$DIR")
USER=$(whoami)

if [[ "$PERMS" != *"r"* || "$PERMS" != *"w"* || "$PERMS" != *"x"* ]]; then
    echo "[AVISO] O usuário $USER não possui todas as permissões rwx no diretório."
fi


# Captura do uso da partição raiz
df_output=$(df / | grep /)
usado=$(echo $df_output | awk '{print $5}' | tr -d '%')

echo "Uso da partição raiz: $usado%"

# Relatório de risco
if [ $usado -gt 90 ]; then
    echo "[CRÍTICO] Uso acima de 90%!"
elif [ $usado -gt 70 ]; then
    echo "[ALERTA] Uso acima de 70%."
else
    echo "[OK] Uso dentro do normal."
fi


echo "Contando processos do usuário atual..."
count=$(ps -u $USER | wc -l)
echo "Total de processos: $count"

echo "Top 5 processos por uso de memória:"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6