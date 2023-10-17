#!/bin/bash
echo "                                                           INSTALAÇÃO - Executavél DataGuard"
echo "------------------------------------------------------------------------------------------------------------------------------------------------------------------"

prompt="Você gostaria de instalar o DataGuard? (Se Sim, será iniciado a atualização do seus pacotes e a instalção de dependencias necessária para a execução do programa)"
options=("Sim" "Não")
PS3="$prompt "

updateAndUpgrade() {
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
        echo "java não instalado"
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
        curl -o cineproject.jar -LJO https://github.com/EigTech-Solutions/JAR---DataGuard/raw/main/Looca.jar #trocar para o nosso prj
        if [ $? -eq 0 ]; then
            echo "Instalação concluída!"
            echo "Iniciando o DataGuard."
            java -jar cineproject.jar
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
