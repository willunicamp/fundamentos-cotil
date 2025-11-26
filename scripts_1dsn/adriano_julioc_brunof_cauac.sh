#!/bin/bash
echo "=== Missão 1: Segurança e Acesso ao Diretório ==="
echo "Digite o caminho do diretório que deseja verificar:"
read DIRETORIO
if [ ! -d "$DIRETORIO" ]; then
echo "Erro: o diretório '$DIRETORIO' não existe."
exit 1
fi

echo "Diretório encontrado. Verificando permissões..."
if [ -r "$DIRETORIO" ] && [ -w "$DIRETORIO" ] && [ -x "$DIRETORIO" ]; then
echo "Todas as permissões necessárias estão disponíveis (leitura, escrita e execução)."
else
echo "Aviso: Você não possui todas as permissões nesse diretório."
fi
echo
echo "=== Missão 2: Verificação de uso de disco ==="
USO=$(df -h | grep " /$" | awk '{print $5}' | sed 's/%//')
echo "Uso atual da partição /: $USO%"
if [ "$USO" -gt 90 ]; then
echo "[CRÍTICO] Uso de disco acima de 90%!"
elif [ "$USO" -gt 70 ]; then
echo "[ALERTA] Uso de disco acima de 70%!"
else
echo "[OK] Uso de disco dentro do normal."
fi
echo
echo "=== Missão 3: Monitoramento de Processos ==="
USUARIO=$(whoami)
TOTAL_PROCESSOS=$(ps -u "$USUARIO" | wc -l)
echo "Usuário atual: $USUARIO"
echo "Total de processos em execução: $TOTAL_PROCESSOS"
echo
echo "Top 5 processos que mais estão consumindo memória:"
echo "(PID) (%MEM) (COMANDO)"
ps -eo pid,%mem,comm --sort=-%mem | head -n 6
echo
echo "Missão 3 concluída!"