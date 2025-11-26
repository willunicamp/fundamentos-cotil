#!/bin/bash
VARIAVEL=0
while [ "$VARIAVEL" -lt 10 ]; do
    # Código a ser executado enquanto a condição for verdadeira
    echo "O valor é $VARIAVEL"
    VARIAVEL=$(($VARIAVEL + 1))
    # É crucial alterar a variável dentro do laço para não criar um loop infinito!
done
