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
    sudo docker -v
    if [ $? -eq 0 ]; then
        echo "Docker já está instalado."
    else
        echo "Instalando o Docker..."
        sudo apt install docker.io -y
    fi
}
rodarDockerIo() {
    if ! systemctl is-active --quiet docker; then
        echo "O Docker não está em execução."c
        sudo systemctl start docker
    fi
    sudo docker run -d -p 3306:3306 dataguard2023/db:latest
    sleep 5
    sudo docker run -it dataguard2023/jar:latest
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
