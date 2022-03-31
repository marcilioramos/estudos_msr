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


#Variaveis de ambiente

#Exporta uma variavel e a deixe acessivel globalmente para todos os shells
export 
Exemplo: export NOME_DA_VARIAVEL=linux

#set: Mostra todos as veriaveis que estão disponiveis no ambiente (locais e globais)

#saidas shell

echo $?
#retornará uma saida "0" caso o ultimo comando for sucesso, caso contrário poderá expor uma saída de 1-255
# no man de cada comando linux tem o exit code e o significado de cada um.

##Entradas de usuario no prompt
read CURSO

## Assim vc consegue por um contexto antes de digitar o valor da variavel
read -p "Informe o seu curso: " CURSO

##  Assim vc consegue esconder o que será escrita no prompt
read -s SEGREDO
