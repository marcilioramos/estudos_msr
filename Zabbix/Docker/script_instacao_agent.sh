#!/bin/bash

# Set the default values for the script arguments
SERVER_IP=127.0.0.1
SERVER_ACTIVE_IP=127.0.0.1
HOSTNAME=`hostname`

# Parse the script arguments
while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in
        -s|--server)
            SERVER_IP="$2"
            shift
            shift
            ;;
        -a|--server-active)
            SERVER_ACTIVE_IP="$2"
            shift
            shift
            ;;
        -h|--hostname)
            HOSTNAME="$2"
            shift
            shift
            ;;
        *)
            shift
            ;;
    esac
done

# Check if the system is Debian, Ubuntu, CentOS, or Red Hat
if [ -f /etc/debian_version ]; then
    # Install the Zabbix repository on Debian or Ubuntu
    wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-1+focal_all.deb
    dpkg -i zabbix-release_6.0-1+focal_all.deb
    rm zabbix-release_6.0-1+focal_all.deb
elif [ -f /etc/redhat-release ]; then
    # Install the Zabbix repository on CentOS or Red Hat
    rpm -Uvh https://repo.zabbix.com/zabbix/6.0/rhel/7/x86_64/zabbix-release-6.0-1.el7.noarch.rpm
else
    # If the system is not recognized, exit the script
    echo "This script only works on Debian, Ubuntu, CentOS, or Red Hat."
    exit 1
fi

# Install the Zabbix agent2
if [ -f /etc/debian_version ]; then
    # Install the Zabbix agent2 on Debian or Ubuntu
    apt-get update
    apt-get install -y zabbix-agent2
elif [ -f /etc/redhat-release ]; then
    # Install the Zabbix agent2 on CentOS or Red Hat
    yum update
    yum install -y zabbix-agent2
fi

# Backup the Zabbix agent2 configuration file
cp /etc/zabbix/zabbix_agent2.conf /etc/zabbix/zabbix_agent2.conf.bak

# Set the server and server active parameters in the Zabbix agent2 configuration file
sed -i "s/Server=127.0.0.1/Server=$SERVER_IP/g" /etc/zabbix/zabbix_agent2.conf
sed -i "s/ServerActive=127.0.0.1/ServerActive=$SERVER_ACTIVE_IP
