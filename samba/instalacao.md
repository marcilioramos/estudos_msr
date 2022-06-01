~~~
nome da maquina = sescabdc
ip = 192.168.0.2
senha/root= sescab.18!

reino por omissão = sescab.intranet

apt update
apt install samba smbclient dnsutils krb5-user winbind

cp /etc/samba/smb.conf /home/
 
rm /etc/samba/smb.conf

samba-tool domain provision sescab.intranet

reboot

smbclient -L localhost -U Administrator

nano /etc/resolv.conf 
>nameserver 127.0.0.1

teste

dig -t srv _ldap.tcp.sescab.intranet
dig -t srv _kerberos.tcp.sescab.intranet

nano /usr/share/samba/setup/krb5.conf > default realm = SESCAB.INTRANET

cp /usr/share/samba/setup/krb5.conf /etc

-------------------------------
editando o arquivo /etc/krb5.conf
-------------------------------
[libdefaults]
        default_realm = SESCAB.INTRANET
        dns_lookup_realm = false
        dns_lookup_kdc = true

[realms]
SESCAB.INTRANET = {
kdc = 192.168.222.108 #IP da sua máquina samba4
sescabdc = 192.168.222.108 #IP da sua máquina samba4
}
=========================================

#kinit Administrator

/etc/samba/smb.conf

systemctl mask smb nmbd wmbd winbind

systemctl disable smb nmbd winbind

systemctl stop samba-ad-dc

systemctl enable samba-ad-dc

systemctl start samba-ad-dc

mkdir /arquivos

chmod 770 /arquivos

samba-tool


===================================

Install duplicati

wget https://updates.duplicati.com/beta/duplicati_2.0.5.1-1_all.deb

edite o arquivo para liberar acesso externo:
/etc/default/duplicati

edite a linha:
DAEMON_OPTS="--webservice-port=8200 --webservice-interface=any"

==================================

Audiotoria - RSYSLOG

edite o arquivo /etc/rsyslog.conf

local2.notice /var/log/samba/setores/auditoriasescab.log

#*.*	      @@graylog.sescab:15140
local2.notice @graylog.sescab:15140

==================================

Instalação do agent Zabbix

wget https://repo.zabbix.com/zabbix/3.4/debian/pool/main/z/zabbix/zabbix-agent_3.4.1-1%2Bstretch_amd64.deb

==================================

~~~
