#!/bin/bash
# monitor_ambiente.sh - Script de monitoramento de saúde e segurança
#
# Objetivo: Criar uma ferramenta automatizada para checar o estado de um servidor
# antes de uma implantação crítica, utilizando conceitos de Shell Script.
#
# Uso:
# 1. Conceder permissão de execução: chmod +x monitor_ambiente.sh
# 2. Executar: ./monitor_ambiente.sh
# -----------------------------------------------------------------------------

## 1. Definição de Variáveis de Estilo (Cores ANSI para o Terminal)
VERDE="\e[32m"      # Para SUCESSO (OK)
VERMELHO="\e[31m"   # Para FALHA (CRÍTICO)
AMARELO="\e[33m"    # Para AVISO (Monitorar)
AZUL="\e[34m"       # Para TÍTULOS e INFORMAÇÕES
FIM_COR="\e[0m"     # Resetar a cor para o padrão do terminal

## 2. Cabeçalho da Ferramenta
echo -e "${AZUL}=======================================================${FIM_COR}"
echo -e "${AZUL}     Ferramenta de Check-up de Servidor (SysAdmin Jr)  ${FIM_COR}"
echo -e "${AZUL}=======================================================${FIM_COR}"
echo ""

## 3. Interação: Pede o Nome do Servidor
# Armazena o input do usuário na variável NOME_SERVIDOR.
read -p "Digite o NOME/IP do Servidor a ser verificado: " NOME_SERVIDOR
echo -e "${AMARELO}Iniciando varredura em: $NOME_SERVIDOR...${FIM_COR}"
echo ""

## 4. Início do Relatório
echo -e "--- ${AZUL}RELATÓRIO DE SAÚDE E SEGURANÇA BÁSICA${FIM_COR} ---"
echo ""

# --- 4.1. VERIFICAÇÃO DE SAÚDE GERAL ---
echo -e "${AMARELO}** 1. SAÚDE GERAL DO SISTEMA **${FIM_COR}"

# Teste A: Uso de Disco
# df -h / | grep / | awk '{ print $5 }' | sed 's/%//g' extrai a porcentagem de uso do disco.
USO_DISCO=$(df -h / | grep / | awk '{ print $5 }' | sed 's/%//g')
if [ "$USO_DISCO" -gt 80 ]; then
    echo -e "  [${VERMELHO}FALHA${FIM_COR}] Uso de Disco: ${USO_DISCO}% (CRÍTICO!)"
elif [ "$USO_DISCO" -gt 60 ]; then
    echo -e "  [${AMARELO}AVISO${FIM_COR}] Uso de Disco: ${USO_DISCO}% (Monitorar!)"
else
    echo -e "  [${VERDE}OK${FIM_COR}] Uso de Disco: ${USO_DISCO}%"
fi

# Teste B: Memória Livre
# free -m | grep Mem | awk '{ print $4 }' extrai a memória livre em Megabytes.
MEMORIA_LIVRE_MB=$(free -m | grep Mem | awk '{ print $4 }')
if [ "$MEMORIA_LIVRE_MB" -lt 500 ]; then
    echo -e "  [${VERMELHO}FALHA${FIM_COR}] Memória Livre: ${MEMORIA_LIVRE_MB}MB (ALERTA!)"
else
    echo -e "  [${VERDE}OK${FIM_COR}] Memória Livre: ${MEMORIA_LIVRE_MB}MB"
fi

# Teste C: Tempo de Atividade (Apenas informativo)
TEMPO_ATIVIDADE=$(uptime -p)
echo -e "  [${AZUL}INFO${FIM_COR}] Tempo de Atividade (Uptime): $TEMPO_ATIVIDADE"
echo ""

# --- 4.2. VERIFICAÇÃO DE SEGURANÇA BÁSICA ---
echo -e "${AMARELO}** 2. SEGURANÇA E AUDITORIA BÁSICA **${FIM_COR}"

# Teste D: Último Login do Root (Checa se o histórico de login está vazio)
ULTIMO_LOGIN_ROOT=$(last -R root | head -n 1)
if [ -z "$ULTIMO_LOGIN_ROOT" ]; then
    echo -e "  [${VERDE}OK${FIM_COR}] Root não logou diretamente via terminal (TTY)."
else
    echo -e "  [${AMARELO}AVISO${FIM_COR}] Último Login do Root (Log): $ULTIMO_LOGIN_ROOT"
fi

# Teste E: Verificação da Shell Padrão
SHELL_PADRAO=$(echo $SHELL)
if [[ "$SHELL_PADRAO" == *bash* ]]; then
    echo -e "  [${VERDE}OK${FIM_COR}] Shell Padrão é: $SHELL_PADRAO"
else
    echo -e "  [${AMARELO}AVISO${FIM_COR}] Shell Padrão é: $SHELL_PADRAO (Recomendado usar Bash para scripts.)"
fi

# Teste F: Existe o arquivo .bashrc
if [ -f ~/.bashrc ]; then
    echo -e "  [${VERDE}OK${FIM_COR}] Arquivo de configuração (~/.bashrc) ENCONTRADO."
else
    echo -e "  [${AMARELO}AVISO${FIM_COR}] Arquivo de configuração (~/.bashrc) NÃO ENCONTRADO."
fi
echo ""

## 5. Rodapé
echo -e "${AZUL}=======================================================${FIM_COR}"
echo -e "${VERDE}Verificação no ambiente '$NOME_SERVIDOR' CONCLUÍDA. Relatório gerado.${FIM_COR}"
echo -e "${AZUL}=======================================================${FIM_COR}"