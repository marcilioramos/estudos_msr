#!/bin/bash
##########################################################################################################
# Descrição: Script de instalacao do agent zabbix2 para versão 6 LTS para os S.Os Debian, RedHat e Ubuntu
# Autor: Marcilio Ramos
# Data: 30.06.2023
# Versão: 1.0
##########################################################################################################
# curl https://raw.githubusercontent.com/marcilioramos/estudos_msr/main/Zabbix/install_zabbix-agent2_versao_6.sh > 1.sh ; bash 1.sh
##########################################################################################################
# Pre requisitos para funcionar o monitoramento:
# Instalar os pacotes:
#
# --- like debian
# apt install wget smartmontools sudo
#
# --- like red-hat
#
# dnf install smartmontools sudo visudo wget 
#
# --- editar o arquivo: 
# nano /etc/sudoers
# adicionar a linha: "zabbix ALL=(ALL) NOPASSWD:/usr/sbin/smartctl", dando permissão para o agente zabbix ler o discos.
##########################################################################################################

cat /etc/os-release

# Função para instalar o Zabbix Agent 2 no Red Hat
install_zabbix_agent_redhat() {
    if rpm -qa | grep -q zabbix-agent; then
    echo "================================================================"
    echo "O agente do Zabbix está instalado.... Abortando instalação!!!!"
    echo "================================================================"
    echo "Favor verificar o arquivo de configuracao do zabbix"
    echo "/etc/zabbix/zabbix_agent2.conf"
    sleep 1
    echo "."
    sleep 1
    echo ".."
    sleep 1
    echo "..."
    echo "saindo do script em 5 segundos...."
    sleep 5
    else
    
    echo "O agente do Zabbix não está instalado.... vamos instalar!!!"
    sleep 3    
    clear
    echo "===================================================="
    echo "Instalando o Zabbix Agent 2 no REDHAT..."
    echo "===================================================="
    cd /tmp/
    wget -O zabbixagent.rpm https://repo.zabbix.com/zabbix/6.0/rhel/$versao/x86_64/zabbix-agent2-6.0.9-release1.el$versao.x86_64.rpm
    yum localinstall  /tmp/zabbixagent.rpm -y
    sed -i "s/Server=.*/Server=$zabbix_server/g" /etc/zabbix/zabbix_agent2.conf
    sed -i "s/Hostname=.*/Hostname = $Hostname/g" /etc/zabbix/zabbix_agent2.conf
    systemctl enable zabbix-agent2
    systemctl start zabbix-agent2
    fi    

}

# Função para instalar o Zabbix Agent 2 no Debian
install_zabbix_agent_debian() {
    if dpkg -l | grep -q zabbix-agent; then
    echo "================================================================"
    echo "O agente do Zabbix está instalado.... Abortando instalação!!!!"
    echo "================================================================"
    echo "Favor verificar o arquivo de configuracao do zabbix"
    echo "/etc/zabbix/zabbix_agent2.conf"
    sleep 1
    echo "."
    sleep 1
    echo ".."
    sleep 1
    echo "..."
    echo "saindo do script em 5 segundos...."
    sleep 5
    
    else

    clear
    echo "===================================================="
    echo "Instalando o Zabbix Agent 2 no DEBIAN..."
    echo "===================================================="
    cd /tmp/
    wget -O zabbixagent.deb https://repo.zabbix.com/zabbix/6.0/debian/pool/main/z/zabbix/zabbix-agent2_6.0.19-1%2Bdebian$versao_amd64.deb
    dpkg -i  /tmp/zabbixagent.deb
    sed -i "s/Server=.*/Server = $zabbix_server/g" /etc/zabbix/zabbix_agent2.conf
    sed -i "s/Hostname=.*/Hostname = $Hostname/g" /etc/zabbix/zabbix_agent2.conf
    systemctl enable zabbix-agent2
    systemctl start zabbix-agent2
    fi
}

# Função para instalar o Zabbix Agent 2 no Ubuntu
install_zabbix_agent_ubuntu() {
        if dpkg -l | grep -q zabbix-agent; then
    echo "================================================================"
    echo "O agente do Zabbix está instalado.... Abortando instalação!!!!"
    echo "================================================================"
    echo "Favor verificar o arquivo de configuracao do zabbix"
    echo "/etc/zabbix/zabbix_agent2.conf"
    sleep 1
    echo "."
    sleep 1
    echo ".."
    sleep 1
    echo "..."
    echo "saindo do script em 5 segundos...."
    sleep 5
    
    else

    clear
    echo "===================================================="
    echo "Instalando o Zabbix Agent 2 no UBUNTU..."
    echo "===================================================="
    cd /tmp/
    wget -O zabbixagent.deb https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix/zabbix-agent2_6.0.9-1%2Bubuntu"$versao"_amd64.deb
    dpkg -i  /tmp/zabbixagent.deb
    sed -i "s/Server=.*/Server = $zabbix_server/g" /etc/zabbix/zabbix_agent2.conf
    sed -i "s/Hostname=.*/Hostname = $Hostname/g" /etc/zabbix/zabbix_agent2.conf
    systemctl enable zabbix-agent2
    systemctl start zabbix-agent2
    fi
}

# Solicita o sistema operacional
read -p "Informe o sistema operacional (redhat (opção 1) - debian - (opção 2) - ubuntu (opção 3)): " sistema_operacional

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
