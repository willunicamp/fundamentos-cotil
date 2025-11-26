#!/bin/bash

echo "========================"
echo " Monitoramento Simples "
echo "========================"

# MISSAO 1 - verificar diretorio
echo
echo "digite o diretorio q quer verificar:"
read pastaUser

if [ -d "$pastaUser" ]
then
    echo "diretorio existe"
else
    echo "erro!! diretorio nao encontrado"
    exit 1
fi

# tentando ver permissoes
permis=$(ls -ld "$pastaUser" | awk '{print $1}')
echo "permissoes encontradas: $permis"

if [[ "$permis" != *r* || "$permis" != *w* || "$permis" != *x* ]]; then
   echo "aviso: pode faltar alguma permissao rwx ai"
else
   echo "tudo certo com permissoes"
fi

# MISSAO 2 - disco
echo
echo "checando uso do disco (/) ..."

usoDisco=$(df / | grep / | awk '{print $5}' | tr -d '%')
echo "uso atual: $usoDisco%"

if [ $usoDisco -gt 90 ]; then
    echo "estado: CRITICO"
elif [ $usoDisco -gt 70 ]; then
    echo "estado: ALERTA"
else
    echo "estado: OK"
fi

# MISSAO 3 - processos
echo
echo "processos do usuario: $USER"

qtd=$(ps -u $USER | wc -l)
echo "total de processos: $qtd"

echo
echo "top 5 processos que estao usando mais memoria:"

lista=$(ps -u $USER -o pid,comm,%mem --sort=-%mem | head -n 6 | tail -n 5)

for linha in "$lista"
do
    echo "$linha"
done

echo
echo "fim do monitoramento :)"