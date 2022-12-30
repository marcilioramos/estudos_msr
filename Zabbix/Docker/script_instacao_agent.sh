#!/bin/bash
#
# Comando para executado o script
#
# curl https://github.com/marcilioramos/estudos_msr/blob/main/Zabbix/Docker/script_instacao_agent.sh ; chmod +x script_instacao_agent.sh ; ./script_instacao_agent.sh "10.1.1.1, 10.10.0.0/8" 127.0.0.1 $HOSTNAME ; rm script_instacao_agent.sh


#
# Set the default values for the script arguments

#!/bin/bash

# Check distribution and version
if [ -f /etc/redhat-release ]; then
  # RHEL-based distribution
  distro="rhel"
  version=$(rpm -q --queryformat '%{VERSION}' centos-release)
elif [ -f /etc/lsb-release ]; then
  # Debian/Ubuntu-based distribution
  distro=$(lsb_release -i | cut -d: -f2 | tr -d '[:space:]')
  version=$(lsb_release -r | cut -d: -f2 | tr -d '[:space:]')
else
  # Unsupported distribution
  echo "Error: unsupported distribution"
  exit 1
fi

# Check if Zabbix Agent 2 is already installed
if [ "$(dpkg-query -W -f='${Status}' zabbix-agent 2>/dev/null | grep -c "ok installed")" -eq 1 ]; then
  echo "Zabbix Agent 2 is already installed"
  exit 0
fi

# Install dependencies
if [ "$distro" = "rhel" ]; then
  yum install -y wget
elif [ "$distro" = "Debian" ] || [ "$distro" = "Ubuntu" ]; then
  apt-get update
  apt-get install -y wget
else
  echo "Error: unsupported distribution"
  exit 1
fi

# Download and install Zabbix Agent 2
wget https://repo.zabbix.com/zabbix/6.0/rhel/$version/x86_64/zabbix-release-6.0-1.el$version.noarch.rpm
rpm -Uvh zabbix-release-6.0-1.el$version.noarch.rpm
yum install -y zabbix-agent2

# Configure Zabbix Agent 2
sed -i "s/Server=127.0.0.1/Server=$server/g" /etc/zabbix/zabbix_agentd.conf
sed -i "s/ServerActive=127.0.0.1/ServerActive=$server_active/g" /etc/zabbix/zabbix_agentd.conf
sed -i "s/Hostname=Zabbix server/Hostname=$hostname/g" /etc/zabbix/zabbix_agentd.conf

# Start Zabbix Agent 2
systemctl start zabbix-agent2
systemctl enable zabbix-agent2

# Clean up
rm -f zabbix-release-6.0-1.el$version.noarch.rpm

echo "Zabbix Agent 2 has been successfully installed and configured"
