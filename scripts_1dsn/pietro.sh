#!/bin/bash

valcritico=90
valalerta=70
usuario=$(whoami)

read -p "Qual diretório você gostaria de identificar? " dir

if [ -d "$dir" ]; then
    echo "Diretório encontrado."
    usoporc=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')

    if [ "$usoporc" -gt "$valcritico" ]; then
        echo "[CRÍTICO]: Uso de disco acima de $valcritico%! ($usoporc%)"
    elif [ "$usoporc" -gt "$valalerta" ]; then
        echo "[ALERTA]: Uso de disco acima de $valalerta%! ($usoporc%)]"
    else
        echo "Uso de disco normal! ($usoporc%)"
    fi

    quantiaProcessos=$(ps -ef -u $USER | wc -l)

    echo "O usuário atual está rodando $quantiaProcessos processos."
    echo -e "\nProcessos que mais utilizam memória:\n"
    echo "PID | Comando"
    echo "--------------"
 
    ps aux -u $USER --sort=-%mem --noheaders | head -n 5 | awk '{print $2 " - " $11}' | while read -r line; do
        echo "$line"
    done
else
    echo "Esse diretório não existe."
    exit 1
fi