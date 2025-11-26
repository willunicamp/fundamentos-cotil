#!/bin/bash
#Grupo: Júlia Chiarotto Filippini, Marina Calchi Coser, Nicolas Sena, Júlia Silva
#Projeto de Shell Script- monitoramento de amibiente

echo "## Missão 1: Acesso e Segurança"
#embaixo aqui, o código pergunta qual diretório/caminho a pessoa quer procurar
read -p "Digite o caminho completo do diretório que você deseja verificar: " DIR_ALVO
#agora, verifica se existe o diretório que pediu encima
if [ -d "$DIR_ALVO" ]; then
    echo "[OK] Diretório '$DIR_ALVO' encontrado."
else
    echo "[ERRO]- O diretório '$DIR_ALVO' não existe. Encerrando o script."
    exit 1
fi
#agora tem que verificar se tem permissão pra mexer lá
permissoes_faltando=""

# Verifica permissão de leitura (-r)
if [ ! -r "$DIR_ALVO" ]; then
    permissoes_faltando+="r"
fi

# Verifica permissão de escrita (-w)
if [ ! -w "$DIR_ALVO" ]; then
    permissoes_faltando+="w"
fi

# Verifica permissão de execução (-x)
if [ ! -x "$DIR_ALVO" ]; then
    permissoes_faltando+="x"
fi

if [ -n "$permissoes_faltando" ]; then
   echo "[AVISO] Permissões faltantes do usuário atual no diretório:[$permissoes_faltando]"
else
    echo "[OK] Permissões totais (rwx) para o usuário atual."
fi
echo "
"
echo "## Missão 2: Uso do disco"
# Captura a porcentagem de uso do disco na partição raiz (/)
USO_DISCO=$(df -h | grep ' /$' | awk '{print $5}' | tr -d '%')
echo "Uso da partição raiz (/) atual: ${USO_DISCO}%"
# Relatório das porcentagens
if [[ $USO_DISCO -gt 90 ]]; then
    echo "[CRÍTICO] O uso do disco ($USO_DISCO%) está altíssimo. Risco de falha de serviço."
elif [[ $USO_DISCO -gt 70 ]]; then
    echo "[ALERTA] O uso do disco ($USO_DISCO%) está elevado. Monitore o espaço."
else
    echo "[OK] O uso do disco ($USO_DISCO%) está dentro dos limites aceitáveis."
fi
echo "
"
echo "## Missão 3: Monitorando processos"
#embaixo tem a contagem de todos os procesos do usuário do momento
CONTAGEM_BRUTA=$(ps -u $USER | wc -l)
numprocessos=$((CONTAGEM_BRUTA - 1))
echo "O usuário atual ($USER) está rodando ${numprocessos} processos ativos."
echo "Top 5 Processos do Sistema (por consumo de memória %MEM):"
processos_pesados=$(ps aux --sort=-%mem | head -n 6 | tail -n 5 | awk '{print $2 " " $11}')
while IFS= read -r LINHA; do
    PID=$(echo "$LINHA" | awk '{print $1}')
    COMANDO=$(echo "$LINHA" | awk '{for(i=2;i<=NF;i++) printf "%s%s", $i, (i==NF ? "" : " ")}')

    echo "  • PID: $PID | Comando: $COMANDO"
done <<< "$processos_pesados"