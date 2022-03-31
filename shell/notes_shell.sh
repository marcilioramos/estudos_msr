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



-------------------------------
LVM + ISCI
-------------------------------
Config ISCSI CENTOS + Formatação + configuração LVM

sudo  dnf -y install iscsi-initiator-utils

sudo vi /etc/iscsi/initiatorname.iscsi
## Altere-o para corresponder ao que você colocou na ACL do alvo
InitiatorName = iqn.2019-11.com.computingforgeeks: iniciador1

sudo vi /etc/iscsi/iscsid.conf 
## Remova o comentário desta linha
57 node.session.auth.authmethod = CHAP
58 
59 # Para definir um nome de usuário e senha CHAP para o iniciador
60 # autenticação pelo (s) destino (s), descomente as seguintes linhas: 
61 node.session.auth.username = iniciador1 
62 node.session.auth.password = gai0daeNgu

iscsiadm -m discovery -t sendtargets -p 172.17.52.184 
172.17.52.184:3260,1 iqn.2019-11.computingforgeeks.com:geekstarget1

iscsiadm -m node --login 

iscsiadm -m session -o show 

============================================================
# mostra as partições, incluse a LUN ISCSI
fdisk -l

#Vamos criar uma nova partição no disco /dev/sdX:
fdisk /dev/sdX

#nova partição
n
#partição primaria
p
#primeira partição
1
#o resto default e "w" para gravar
w

#Vamos listar os dispositivos físicos com detalhes:
pvdisplay

#E criamos a primeira partição:
pvcreate /dev/sdX1

#Podemos listar também os volumes lógicos com ‘pvscan’:
pvscan

#Podemos listar também os volumes lógicos com ‘pvscan’:
pvscan

[root@localhost ~]# vgcreate vg_teste /dev/sdb1
 Volume group "vg_teste" successfully created

#E criamos o volume lógico:
lvcreate -n LV1 -L 1G volume1

#Agora vamos criar um sistema de arquivos para o volume criado:
mkfs -t ext4 /dev/volume1/LV1

#Agora criamos um diretório para montarmos o sistema de arquivos:
mkdir vol1
mount /dev/volume1/LV1 /media/vol1/

#Para extender o volume
umount /media/vol1/

#Para add 2 giga de espaço
lvextfend -L +2G /media/vol1/

#Para add todo o espaço livre
lvextend -L +100%FREE /media/vol1/

resize2fs  /media/vol1/
mount /dev/volume1/LV1 /media/vol1/


-------------------------
fstab
-------------------------

FSTAB add novo volume

#Para encontrar um UUID, basta executar o blkid comando.
blkid
#copia o UUID

#add essa linha no /etc/fstab
UUID=83fef7c8-ea0a-4524-a101-d1832f4ffb9e /home/daddos/vol1 ext4 acl,user,nofail 0 0

#criar arquivo abaixo para não bugar a inicialização do iscsi
vim /etc/init.d/after.local

#!/bin/bash
/etc/init.d/boot.lvm reload
mount -a

