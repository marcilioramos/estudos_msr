#!/bin/bash

# Parar os serviços Proxmox
systemctl stop pve-cluster.service
systemctl stop pvedaemon.service
systemctl stop pveproxy.service
systemctl stop pvestatd.service

# Atualizar o arquivo /etc/hostname
echo "msr02.home.msr01" > /etc/hostname

# Atualizar o arquivo /etc/hosts
sed -i 's/^\(127\.0\.1\.1\s\).*$/\1msr02.home.msr01/' /etc/hosts

# Atualizar o nome do nó no cluster
pvecm setname msr02.home.msr01

# Reiniciar o nó
reboot
