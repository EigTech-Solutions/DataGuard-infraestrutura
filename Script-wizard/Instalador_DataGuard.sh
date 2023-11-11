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
    echo "Pacotes atualizados!"
    sleep 2
    exit 1
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
        sleep 2
        sudo apt install openjdk-17-jre -y
        exit 1
    fi
}
instalardockerio() {
    echo "Verificando a versão do Docker..."
    docker version
    if [$? = 0]; then
        echo "O Docker não está instalado"
        echo "Instalando o Docker..."
        sleep 2
        sudo apt install docker.io -y
        exit 0
    else
        echo "Docker ja está instalado"
        sleep 2
        exit 1
    fi
}
rodarDockerIo() {
    if ! systemctl is-active --quiet docker; then
        echo "O Docker não está em execução."c
        sudo systemctl start docker
        exit 1
    fi
    NOME_CONTAINER="dataguard_mysql"
    if docker ps --format '{{.Names}}' | grep -q "$NOME_CONTAINER"; then
        echo "O container $NOME_CONTAINER está em execução."
        exit 0
    else
        echo sudo docker run --name dataguard_mysql -d -p 3306:3306 dataguard2023/infra-dataguard:latest
        exit 1
    fi
}
instalarDockerCompose() {
    echo "Verificando o docker compose..."
    sleep 2
    docker-compose –version
    if [ $? = 0 ]; then
        echo "Docker compose não instalado."
        echo "Instalando docker compose..."
        sudo apt install docker-compose
        docker-compose -f /Images/docker-compose.yml up
        sleep 2
        exit 0
    else
        echo "Iniciando o docker compose..."
        docker-compose -f /Images/docker-compose.yml up
        sleep 2
        exit 1
    fi
}
instalarJar() {
    clear
    ls | grep "dataguard.jar"

    if [ $? = 0 ]; then
        echo "DataGuard já instalado"
        echo "Iniciando o DataGuard."
        sleep 2
        java -jar dataguard.jar
    else
        echo "Instalando o DataGuard..."
        sleep 2
        curl -o dataguard.jar -LJO https://github.com/EigTech-Solutions/JAR---DataGuard/raw/main/dataguard.jar #trocar para o nosso prj
        if [ $? -eq 0 ]; then
            echo "Instalação concluída!"
            echo "Iniciando o DataGuard."
            sleep 2
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
