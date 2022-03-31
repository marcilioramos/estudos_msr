Comando SHELL

#comando para mostrar atributos do SFP
ethtool --module-info ethX

#IPTABLES
##listar regras
iptables -nL

##add regra de firewall zabbix DEBIAN 10050 IPTABLES
iptables -A INPUT -p tcp -s 0.0.0.0/0 --dport 10050 -m state --state NEW,ESTABLISHED -m comment --comment "Zabbiz Agent" -j ACCEPT

iptables -A INPUT -p tcp -s 10.10.101.6 --dport 10050 -m state --state NEW,ESTABLISHED -m comment --comment "Zabbiz Agent" -j ACCEPT

##add regra de firewall zabbix DEBIAN 10050 IPTABLES
iptables -A INPUT -p tcp -s 187.45.177.70 --dport 443 -m state --state NEW,ESTABLISHED -m comment --comment "xcp-center" -j ACCEPT

iptables -A INPUT -p tcp -s 0.0.0.0/0 --dport 43211 -m state --state NEW,ESTABLISHED -m comment --comment "cloudbackup" -j ACCEPT

iptables -A INPUT -p tcp -s 0.0.0.0/0 --dport 4443 -m state --state NEW,ESTABLISHED -m comment --comment "tunnelssh" -j ACCEPT

#mostrar usuarios logados no servidor

## mostra portas abertas
netstat -lntp

##filtrar palavra shell zabbix
cat /etc/zabbix/zabbix_agent2.conf | grep -Ev '[:blank]*#|^[:blank]*$'
