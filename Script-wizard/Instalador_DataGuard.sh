#!/bin/bash
title="INSTALAÇÃO - DataGuard"
prompt="Você gostaria de instalar o DataGuard?"
options=("Sim" "Não")
echo "$title"
PS3="$prompt "
updateAndUpgrade() {
    clear
    echo "Atualizando pacotes para iniciar a instalação..."
    sudo apt update -y
    echo "Pacotes atualizados!"
}
verificarJava() {
    clear
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
instalardockerio() {
    echo "Verificando a versão do Docker..."
    docker version
    if [$? = 0]; then
        echo "O Docker não está instalado"
        echo "Instalando o Docker..."
        sudo apt install docker.io -y
    else
        echo "Docker ja está instalado"
    fi
}
rodarDockerIo() {
    if ! systemctl is-active --quiet docker; then
        echo "O Docker não está em execução."c
        sudo systemctl start docker
    fi
    NOME_CONTAINER="dataguard_mysql"
    if docker ps --format '{{.Names}}' | grep -q "$NOME_CONTAINER"; then
        echo "O container $NOME_CONTAINER está em execução."
    else
        sudo docker run --name dataguard_mysql -d -p 3306:3306 dataguard2023/db:latest
    fi
}
instalarJar() {
    clear
    ls | grep "dataguard-1.0-SNAPSHOT-jar-with-dependencies.jar"

    if [ $? = 0 ]; then
        echo "DataGuard já instalado"
        echo "Iniciando o DataGuard."
        java -jar dataguard.jar
    else
        echo "Instalando o DataGuard..."
        Sudo docker run –it dataguard2023/jar:latest
        if [ $? -eq 0 ]; then
            echo "Instalação concluída!"
            echo "Iniciando o DataGuard."
            java -jar dataguard-1.0-SNAPSHOT-jar-with-dependencies.jar
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
            instalardockerio
            rodarDockerIo
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
