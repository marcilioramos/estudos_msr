#!/bin/bash

# Parar os serviços Proxmox
systemctl stop pve-cluster.service
systemctl stop pvedaemon.service
systemctl stop pveproxy.service
systemctl stop pvestatd.service

# Receber o novo nome do host
read -p "Digite o novo nome do host: " new_hostname

# Atualizar o arquivo /etc/hostname
echo "$new_hostname" > /etc/hostname

# Atualizar o arquivo /etc/hosts
sed -i "s/^\(127\.0\.1\.1\s\).*$/\1$new_hostname/" /etc/hosts

# Atualizar o nome do nó no cluster
pvecm setname $new_hostname

# Reiniciar o nó
reboot
