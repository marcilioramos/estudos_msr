#!/bin/bash
##########################################################################################################
# Descrição: Script de instalação do agente Zabbix 2 para a versão 6 LTS nos Sistemas Operacionais Debian, Red Hat e Ubuntu
# Autor: Marcilio Ramos
# Data: 30.06.2023
# Versão: 1.1
##########################################################################################################

# Função para instalar o Zabbix Agent 2 no Red Hat
install_zabbix_agent_redhat() {
    if rpm -qa | grep -q zabbix-agent; then
        echo "================================================================"
        echo "O agente do Zabbix está instalado. Abortando a instalação!"
        echo "================================================================"
        echo "Por favor, verifique o arquivo de configuração do Zabbix em /etc/zabbix/zabbix_agent2.conf"
        sleep 1
        echo "."
        sleep 1
        echo ".."
        sleep 1
        echo "..."
        echo "Saindo do script em 5 segundos..."
        sleep 5
    else
        echo "O agente do Zabbix não está instalado. Iniciando a instalação..."
        sleep 3
        echo "===================================================="
        echo "Instalando o Zabbix Agent 2 no Red Hat..."
        echo "===================================================="
        cd /tmp/
        wget -O zabbixagent.rpm "https://repo.zabbix.com/zabbix/6.0/debian/pool/main/z/zabbix/zabbix-agent2_6.0.19-1%2Bdebian12_amd64.deb"
        if [ -f "/tmp/zabbixagent.rpm" ]; then
            yum localinstall /tmp/zabbixagent.rpm -y
            sed -i "s/Server=.*/Server=$zabbix_server/g" /etc/zabbix/zabbix_agent2.conf
            sed -i "s/Hostname=.*/Hostname=$Hostname/g" /etc/zabbix/zabbix_agent2.conf
            systemctl enable zabbix-agent2
            systemctl start zabbix-agent2
        else
            echo "Falha ao baixar o pacote do Zabbix Agent 2 para Red Hat."
            exit 1
        fi
    fi
}

# Função para instalar o Zabbix Agent 2 no Debian
install_zabbix_agent_debian() {
    if dpkg -l | grep -q zabbix-agent; then
        echo "================================================================"
        echo "O agente do Zabbix está instalado. Abortando a instalação!"
        echo "================================================================"
        echo "Por favor, verifique o arquivo de configuração do Zabbix em /etc/zabbix/zabbix_agent2.conf"
        sleep 1
        echo "."
        sleep 1
        echo ".."
        sleep 1
        echo "..."
        echo "Saindo do script em 5 segundos..."
        sleep 5
    else
        echo "===================================================="
        echo "Instalando o Zabbix Agent 2 no Debian..."
        echo "===================================================="
        cd /tmp/

    case $versao in
    "9")
       wget -O zabbixagent.deb "https://repo.zabbix.com/zabbix/6.0/debian/pool/main/z/zabbix/zabbix-agent2_6.0.17-1%2Bdebian9_amd64.deb"
        ;;
    "10")
        wget -O zabbixagent.deb "https://repo.zabbix.com/zabbix/6.0/debian/pool/main/z/zabbix/zabbix-agent2_6.0.18-1%2Bdebian10_amd64.deb"

        ;;
    "11")
        wget -O zabbixagent.deb "https://repo.zabbix.com/zabbix/6.0/debian/pool/main/z/zabbix/zabbix-agent2_6.0.18-1%2Bdebian11_amd64.deb"

        ;;
     "12")
        wget -O zabbixagent.deb "https://repo.zabbix.com/zabbix/6.0/debian/pool/main/z/zabbix/zabbix-agent2_6.0.18-1%2Bdebian12_amd64.deb"
        ;;   
    *)
        echo "Sistema operacional não suportado."
        exit 1
        ;;
esac
        
        if [ -f "/tmp/zabbixagent.deb" ]; then
            dpkg -i /tmp/zabbixagent.deb
            sed -i "s/Server=.*/Server=$zabbix_server/g" /etc/zabbix/zabbix_agent2.conf
            sed -i "s/Hostname=.*/Hostname=$Hostname/g" /etc/zabbix/zabbix_agent2.conf
            systemctl enable zabbix-agent2
            systemctl start zabbix-agent2
        else
            echo "Falha ao baixar o pacote do Zabbix Agent 2 para Debian."
            exit 1
        fi
    fi
}

# Função para instalar o Zabbix Agent 2 no Ubuntu
install_zabbix_agent_ubuntu() {
    if dpkg -l | grep -q zabbix-agent; then
        echo "================================================================"
        echo "O agente do Zabbix está instalado. Abortando a instalação!"
        echo "================================================================"
        echo "Por favor, verifique o arquivo de configuração do Zabbix em /etc/zabbix/zabbix_agent2.conf"
        sleep 1
        echo "."
        sleep 1
        echo ".."
        sleep 1
        echo "..."
        echo "Saindo do script em 5 segundos..."
        sleep 5
    else
        echo "===================================================="
        echo "Instalando o Zabbix Agent 2 no Ubuntu..."
        echo "===================================================="
        cd /tmp/

    case $versao in
    "18.04")
       wget -O zabbixagent.deb "https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-1%2Bubuntu18.04_all.deb"
        ;;

    "20.04")
        wget -O zabbixagent.deb "https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-1%2Bubuntu20.04_all.deb"

        ;;
    "22.04")
        wget -O zabbixagent.deb "https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-2%2Bubuntu22.04_all.deb"

        ;;

    *)
        echo "Sistema operacional não suportado."
        exit 1
        ;;
esac


        
        if [ -f "/tmp/zabbixagent.deb" ]; then
            dpkg -i /tmp/zabbixagent.deb
            sed -i "s/Server=.*/Server=$zabbix_server/g" /etc/zabbix/zabbix_agent2.conf
            sed -i "s/Hostname=.*/Hostname=$Hostname/g" /etc/zabbix/zabbix_agent2.conf
            systemctl enable zabbix-agent2
            systemctl start zabbix-agent2
        else
            echo "Falha ao baixar o pacote do Zabbix Agent 2 para Ubuntu."
            exit 1
        fi
    fi
}

cat /etc/os-release

# Solicita o sistema operacional
read -p "Informe o sistema operacional (redhat - opção 1, debian - opção 2, ubuntu - opção 3): " sistema_operacional

# Verifica o sistema operacional informado
case $sistema_operacional in
    "1")
        # Solicita a versão
        read -p "Informe a versão do Red Hat (6, 7, 8 ou 9): " versao
        ;;
    "2")
        # Solicita a versão
        read -p "Informe a versão do Debian (9, 10, 11 ou 12): " versao
        ;;
    "3")
        # Solicita a versão
        read -p "Informe a versão do Ubuntu (18.04, 20.04 ou 22.04): " versao
        ;;
    *)
        echo "Sistema operacional não suportado."
        exit 1
        ;;
esac

# Solicita o Hostname, nome do host que será adicionado no Zabbix
read -p "Informe o Hostname: " Hostname

# Solicita o Zabbix Server
read -p "Informe o endereço do Zabbix Server: " zabbix_server

# Verifica o sistema operacional e chama a função correta para instalação
case $sistema_operacional in
    "1")
            install_zabbix_agent_redhat
        ;;
    "2")
        install_zabbix_agent_debian
        ;;
    "3")
        install_zabbix_agent_ubuntu
        ;;
esac

systemctl status zabbix-agent2
