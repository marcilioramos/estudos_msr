### Teoria ISCSI
~~~
ISCSI: Internet Small Computer System Interface
Target: Servidor
Initiators: Clientes
Luns: Blocos de dados, como discos fisicos.
Rede SAN: Rede Storage Area Network
IQN: ISCSI Qualified Name
  - iqn."data"."dominio"."identificador_qualquer"
Segurança:
  - Texto puro
  - Sem autenticação
  - CHAP
~~~

![Conceitos](https://user-images.githubusercontent.com/48597831/185492329-fdaca6ee-638b-4a79-b2fe-7e488bcf5e8d.png)
![image](https://user-images.githubusercontent.com/48597831/185492622-5648ed3c-f7e7-4463-8af4-7cb8783175f8.png)
![image](https://user-images.githubusercontent.com/48597831/185493211-05cccb04-51d0-4426-a81c-2253db1f5b48.png)

### Configurando o Target
~~~
- systemclt stop firewalld
- sestatus 
- vim /etc/hosts
  -- seta os ips associados aos seus nomes
- configurar o bond
  -- vim /etc/sysconfig/network-scripts/ifcfg-enp0s8
    --- DEVICE="enp0s8"
        TYPE=Ethernet
        ONBOOT="yes" ### iniciar automaticamente
        BOOTPROTO="none" ### boot protocol
        USERCTL=no ### controle nivel de usuario
        MASTER=bond0 ### associado ao dispositivo master
        SLAVE=yes
  
  -- vim /etc/sysconfig/network-scripts/ifcfg-enp0s9
    --- DEVICE="enp0s9"
        TYPE=Ethernet
        ONBOOT="yes" ### iniciar automaticamente
        BOOTPROTO="none" ### boot protocol
        USERCTL=no ### controle nivel de usuario
        MASTER=bond0 ### associado ao dispositivo master
        SLAVE=yes
        
   -- vim /etc/sysconfig/network-scripts/ifcfg-bond0
    --- DEVICE="bond0"
        IPADDR=172.16.0.1
        NETMASK= 255.255.255.0
        BONDING_OPTS="mode=0 miimon 100"    
          ### mode=0 é para fazer load balance
          #### miinon= 100 é para fazer a checagem a cada 100 milisegundos
        ONBOOT="yes" ### iniciar automaticamente

- systemctl restart network
- ifconfig
  -- deve aparecer a flag SLAVE nas interfaces enp0s8 e enp0s9.
  -- deve aparecer a flag MASTER nas interface BOND0
  
- cat /proc/net/bonding/bond0
  -- mostra a interface bond0 é pleno funcionamento, em modo round-robin.
   
- yum install tagetcli targetd

- targetcli
- cd backstore/block
- create server.project /dev/md1
- ls
- cd /iscsi
- create iqn.2019-01.com.hpc.target:tgt1
- 

        
~~~

### Configurando o INITIATOR
~~~
- systemclt stop firewalld
- sestatus 
- vim /etc/hosts
  -- seta os ips associados aos seus nomes
  
- configurar o bond
  -- vim /etc/sysconfig/network-scripts/ifcfg-enp0s8
    --- DEVICE="enp0s8"
        TYPE=Ethernet
        ONBOOT="yes" ### iniciar automaticamente
        BOOTPROTO="none" ### boot protocol
        USERCTL=no ### controle nivel de usuario
        MASTER=bond0 ### associado ao dispositivo master
        SLAVE=yes
  
  -- vim /etc/sysconfig/network-scripts/ifcfg-enp0s9
    --- DEVICE="enp0s9"
        TYPE=Ethernet
        ONBOOT="yes" ### iniciar automaticamente
        BOOTPROTO="none" ### boot protocol
        USERCTL=no ### controle nivel de usuario
        MASTER=bond0 ### associado ao dispositivo master
        SLAVE=yes
        
   -- vim /etc/sysconfig/network-scripts/ifcfg-bond0
    --- DEVICE="bond0"
        IPADDR=172.16.0.2
        NETMASK= 255.255.255.0
        BONDING_OPTS="mode=0 miimon 100"    
          ### mode=0 é para fazer load balance
          #### miinon= 100 é para fazer a checagem a cada 100 milisegundos
        ONBOOT="yes" ### iniciar automaticamente  

~~~

