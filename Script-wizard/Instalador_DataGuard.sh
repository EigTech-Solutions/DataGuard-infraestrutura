#!/bin/bash
title="INSTALAÇÃO - DataGuard"
prompt="Você gostaria de instalar o DataGuard?"
options=("Sim" "Não")
echo "$title"
PS3="$prompt "
update() {
    clear
    echo "Atualizando pacotes para iniciar a instalação..."
    sudo apt update -y
    echo "Pacotes atualizados!"
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
        sleep 5
        sudo docker run –it dataguard2023/jar:latest
    fi
}

menu() {
    select item in "${options[@]}"; do
        case $REPLY in
        1)
            echo "Iniciando a instalação..."
            update
            instalardockerio
            rodarDockerIo
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
