#!/bin/bash

echo "--- Missão 1: Segurança e Acesso ---"
echo
read -p "Escreva o caminho do diretório que deseja verificar: " dir
echo

# Missão 1 — Segurança e Acesso
if [ ! -d "$dir" ]; then
    echo "Erro: diretório não encontrado."
    exit 1
fi

if [ ! -r "$dir" ] || [ ! -w "$dir" ] || [ ! -x "$dir" ]; then
    echo "[AVISO] O usuário atual NÃO possui todas as permissões (rwx) no diretório."
    echo "Detalhes das permissões:"
    [ -r "$dir" ] || echo " - Falta permissão de leitura (r)"
    [ -w "$dir" ] || echo " - Falta permissão de escrita (w)"
    [ -x "$dir" ] || echo " - Falta permissão de execução (x)"
else
    echo "[OK] O usuário atual possui permissões completas (rwx)."
fi

echo
echo "--- Missão 2 — Análise de Recursos ---"
echo

# Pegando uso da partição do diretório analisado
uso=$(df "$dir" | tail -1 | awk '{print $5}' | tr -d '%')

if [ "$uso" -gt 90 ]; then
    echo "Uso da partição: $uso% — [CRÍTICO]"
elif [ "$uso" -gt 70 ]; then
    echo "Uso da partição: $uso% — [ALERTA]"
else
    echo "Uso da partição: $uso% — [OK]"
fi

echo
echo "--- Missão 3 — Monitoramento ---"
echo

# Contagem de processos
total=$(ps -u "$USER" | wc -l)
echo "Total de processos ativos do usuário $USER: $total"
echo

# Top 5 processos por uso de memória — formato universal
lista=$(ps -o pid,comm,%mem --sort=-%mem -u "$USER" | awk 'NR>1 && NR<=6')

echo "$lista" | while read pid comando mem; do
    echo "PID: $pid  |  Comando: $comando | Memória: $mem"
done

echo
echo "Fim da análise"