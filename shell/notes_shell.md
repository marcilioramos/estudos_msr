###Comando SHELL
~~~
#comando para mostrar atributos do SFP
ethtool --module-info ethX
~~~

###IPTABLES
~~~
##listar regras
iptables -nL

##add regra de firewall zabbix DEBIAN 10050 IPTABLES
iptables -A INPUT -p tcp -s 0.0.0.0/0 --dport 10050 -m state --state NEW,ESTABLISHED -m comment --comment "Zabbiz Agent" -j ACCEPT

iptables -A INPUT -p tcp -s 10.10.101.6 --dport 10050 -m state --state NEW,ESTABLISHED -m comment --comment "Zabbiz Agent" -j ACCEPT

##add regra de firewall zabbix DEBIAN 10050 IPTABLES
iptables -A INPUT -p tcp -s 187.45.177.70 --dport 443 -m state --state NEW,ESTABLISHED -m comment --comment "xcp-center" -j ACCEPT

iptables -A INPUT -p tcp -s 0.0.0.0/0 --dport 43211 -m state --state NEW,ESTABLISHED -m comment --comment "cloudbackup" -j ACCEPT

iptables -A INPUT -p tcp -s 0.0.0.0/0 --dport 4443 -m state --state NEW,ESTABLISHED -m comment --comment "tunnelssh" -j ACCEPT
~~~

~~~
##mostrar usuarios logados no servidor
w
~~~

~~~
## mostra portas abertas
netstat -lntp
~~~

~~~
## GREP = filtrar palavra shell zabbix
cat /etc/zabbix/zabbix_agent2.conf | grep -Ev '[:blank]*#|^[:blank]*$'
~~~

~~~
#Variaveis de ambiente

#Exporta uma variavel e a deixe acessivel globalmente para todos os shells
export 
Exemplo: export NOME_DA_VARIAVEL=linux
~~~

~~~
#set: Mostra todos as veriaveis que estão disponiveis no ambiente (locais e globais)
~~~

~~~
#saidas shell

echo $?
#retornará uma saida "0" caso o ultimo comando for sucesso, caso contrário poderá expor uma saída de 1-255
# no man de cada comando linux tem o exit code e o significado de cada um.
~~~

~~~
##Entradas de usuario no prompt
read CURSO

## Assim vc consegue por um contexto antes de digitar o valor da variavel
read -p "Informe o seu curso: " CURSO

##  Assim vc consegue esconder o que será escrita no prompt
read -s SEGREDO
~~~


### LVM + ISCI

~~~
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

--------------------------------------------
ISCI LINUX
--------------------------------------------
iscsiadm -m discovery -t sendtargets -p 172.17.52.184 
172.17.52.184:3260,1 iqn.2019-11.computingforgeeks.com:geekstarget1

iscsiadm -m node --login 

iscsiadm -m session -o show 

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
~~~


### CentOS 7 – Adicionar Segundo IP

~~~
Até o CentOS 6, nós tínhamos o costume de adicionar um segundo IP, copiando o arquivo da interface (eth0 -> eth0:1).

Após instalar o CentOS 7 em uma nova máquina eu tive esta surpresa! O procedimento ficou mais fácil ainda!É só adicionar no mesmo arquivo IPADDR1 e NETMASK1 ou qualquer outro informações ficando com sufixos finais iguais.
Veja um exemplo abaixo:

root@orion /]# cat /etc/sysconfig/network-scripts/ifcfg-ens32
TYPE=Ethernet
BOOTPROTO=none
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=no
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_PEERDNS=yes
IPV6_PEERROUTES=yes
IPV6_FAILURE_FATAL=no
NAME=eth0
UUID=323cf910-4aa2-4794-6b2a-bb8908d09dad
DEVICE=ens32
ONBOOT=yes
DNS1=8.8.8.8
IPADDR=172.17.50.128 #1° IP
IPADDR1=192.168.190.1 #2° IP
NETMASK=255.255.255.0 #1ª Mascara
NETMASK1=255.255.255.0 #2ª Mascara
PREFIX=24
GATEWAY=172.17.50.1

-------------------------------
dois ips debian - config rede debian - add novo IP
-------------------------------
auto eth0:1
iface eth0:1 inet static
name Ethernet alias LAN card
address 192.168.0.2
netmask 255.255.255.0
broadcast 192.168.0.255
network 192.168.0.0

~~~

~~~

-----------------------------------------------
#dar privilegios para acesso externo mysql
----------------------------------------------

GRANT ALL ON zabbix.* TO ‘zabbix’@’%’ IDENTIFIED BY ‘SENHA’ WITH GRANT OPTION;
FLUSH PRIVILEGES;

skip-grant-tables

mysql -e "create database zabbix character set utf8 collate utf8_bin"


CREATE USER 'zabbix'@'%' IDENTIFIED BY 'SENHA';
grant all privileges on zabbix.* to 'zabbix'@'%' with grant option";
FLUSH PRIVILEGES;
quit;

https://verdanadesk.com/aprenda-a-instalar-o-zabbix-server-passo-a-passo/

~~~

~~~
----------------------------
Comandos do VI ou vim
----------------------------

:$ ultima linha
:!"comando externo"

dd recorta uma linha
d4d recorta 4 linhas
y copia linhas
y4y copia 4 linhas
p cola as linhas

Como buscar uma palavras no Vi
Para pesquisar uma palavra no Vi/Vim, basta pressionar as teclas / (barra) ou ? (ponto de interrogação) e depois escrever a palavra que você está buscando.

~~~

~~~
--------------------------
Geração de Logs
--------------------------
#log de forma simples
./script >> log.out

#log saida padrão e saida de erro
./script >> log.out 2>&1

#log no arquivo e na tela
./script | tee -a log.out
-a = ">>"

#colocar o comando exec dentro do script, ele irá jogar toda a saida para um arquivo especificado
exec 1>> $LOG
exec 2&1
ou
exec 1>> (tee -a "$LOG") # para jogar na tela tbm as informações

###rsyslog
facility = O criador da mensagem
local0 a local7 = é de uso do administrador linux
niveis de prioridade = debug, info, notive, warning, warn, err, error, criti, alert emerg, panic
tipos de log = auth, authpriv.none, cron, daemon, kern, lpr, main, user

### usuando o local0 para gerar script
local0.* /var/log/script.log 
local2.* /var/log/script2.log
##chown syslog:adm "nome do arquivo"

##enviando mensangem para o arquivo de log
logger -p local0.err "Teste de mensagem de erro"
logger -p local0.warn "Teste de warn mensagem de erro"
## acima como estar com asterico ele vai enviar todas as mensagens de erro... para receber so mensagem do tipo warn seria assim "local0.warn"
## é possivel por tag
logger -p local0.warn -t [tag escolhida]"Teste de warn mensagem de erro"
## aducionando rsyslog a uma arquivo qualquer
echo "O texto que será escrito dentro do arquivo via rsyslog" | logger -p local0.warn -t [$0]
ou
logger -p local0.warn -t [$0] "O texto que será escrito dentro do arquivo via rsyslog" 

## usando logger com tee... para jogar na tela tbm
echo "saida de texto" > tee -a > (logger -p local0.warn -t [$0])

~~~

~~~
---------------------------------
comando de email - mail
---------------------------------
apt install bsd-mailx postfix -y

##enviando email
mail -s "assunto" marcilioramo@gmail.com < echo "Teste de email"

##outras opções de email
mutt
sendemail
~~~

~~~
---------------------
DEBU
---------------------
trap read DEBUG
~~~

~~~
-----------------
grep
-----------------
-i = desconsidera caixa alta e baixa
-R = recursivo
grep -iR "palavra" diretorio
~~~

~~~
----------------------
reboot e desligamento
---------------------
# Primeiro, se você quiser verificar quando o seu computador foi inicializado pela última vez, você pode usar o who comando com o -b sinalize para obter uma data e hora exatas em seu terminal.
who -b

#Com o last comando que você pode listar sempre que seu sistema for reinicializado.
last -x reboot

last -x shutdown

#Finalmente, quando você quiser saber há quanto tempo seu computador está funcionando, você pode usar o uptime comando para descobrir. 
#Combine-o com o -p sinalize para obter uma saída de leitura muito mais fácil.
uptime -p
~~~

~~~
Run shell script on gist
Shells that support process substitution such as bash and zsh allow to run shell script on gist as follows.

# With curl:
bash <(curl -sL ${GIST_URL}) args...

# With wget:
bash <(wget -nv -O - ${GIST_URL}) args...

# If wget-log is generated:
# https://bugs.launchpad.net/ubuntu/+source/wget/+bug/1765690
bash <(wget -o /dev/null -nv -O - ${GIST_URL}) args...
For example:

bash <(curl -sL https://gist.githubusercontent.com/mob-sakai/174a32b95572e7d8fdbf8e6f43a528f6/raw/hello.sh) I am mob-sakai!

~~~

~~~

--------------------------------------------
#eliminar linhas comentadas shell linux
--------------------------------------------
grep -v "^#" arquivo.bkp | sed '/^$/d' > arquivo

~~~

~~~
----------------------
##flush dns
----------------------
resolvectl flush-caches

~~~






