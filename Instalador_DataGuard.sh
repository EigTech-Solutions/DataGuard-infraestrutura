#!/bin/bash
title="INSTALAÇÃO - DataGuard"
prompt="Você gostaria de instalar o DataGuard?"
options=("Sim" "Não")
echo "$title"

PS3="$prompt "

updateAndUpgrade() {
    clear
    echo "Atualizando pacotes para iniciar a instalação..."
    sudo apt update && sudo apt upgrade -y
}

verificarJava() {
    clear
    echo "Pacotes atualizados!"
    echo "Verificando a versão do Java..."
    java -version
    if [ $? = 0 ]; then
        echo “java instalado na versão $?”
    else
        echo "Java não encontrado"
        echo "Instalando o Java 17..."
        sudo apt install openjdk-17-jre -y
    fi
}

instalarJar() {
    clear
    ls | grep "dataguard.jar"

    if [ $? = 0 ]; then
        echo "DataGuard já instalado"
        echo "Iniciando o DataGuard."
        java -jar dataguard.jar
    else
        echo "Instalando o DataGuard..."
        curl -o dataguard.jar -LJO https://github.com/EigTech-Solutions/JAR---DataGuard/raw/main/dataguard.jar #trocar para o nosso prj
        if [ $? -eq 0 ]; then
            echo "Instalação concluída!"
            echo "Iniciando o DataGuard."
            java -jar dataguard.jar
        else
            echo "O curl encontrou um erro."
        fi
    fi
}

menu() {
    select item in "${options[@]}"; do
        case $REPLY in
        1)
            echo "Iniciando a instalação..."
            updateAndUpgrade
            verificarJava
            instalarJar
            break
            ;;
        2)
            echo "Instalação cancelada!"
            break
            ;;
        *) echo "Por favor, escolha uma das opções acima" ;;
        esac
    done
}

menu
