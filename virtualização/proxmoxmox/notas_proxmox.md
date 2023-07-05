### migracao xen para proxmox

~~~
Capturando o disco virtual da VM no XenServer:
O disco virtual da maquina virtual no Xen deve ser exportado para um arquivo do tipo VHD. Na minha instalação do Xen, o storage utilizado foi do tipo LVM, então a unidade de volume lógico pertencente a VM que deve ser exportado.
Para identificar qual o caminho da unidade lógica, você deve usar o comando:

# xe vdi-list

e depois o comando
# lvdisplay

Você deve comparar o campo uuid pertencente a VM da saida do comando 'xe', com o campo LV Name da saída do comando lvdisplay. Ao encontrar um que seja igual, você pode conferir o tamanho do disco. O campo LV Path indica o caminho da unidade de volume lógico.
 
Descoberto o  caminho do disco de sua maquina virtual na qual quer fazer a exportação do disco, hora de ativar a unidade e fazer a exportação. (COM A VM DESLIGADA)

Para ativar o volume:

# lvchange -ay /dev/CAMINHO_DESCOBERTO_NO_COMANDO_ANTERIOR


Para exporta-lo para um arquivo local:

# dd if=/dev/CAMINHO_DESCOBERTO_NO_COMANDO_ANTERIOR of=/tmp/HardDisk_NOMEDAVM.vhd

Feita a exportação, você deve copiar o disco virtual para o servidor Proxmox. Você pode fazer isso utilizando o comando scp por exemplo, ou fazer de outra forma.

Você pode fazer estas etapas de exportação do disco, compactação e transferência, a partir de um comando apenas. Fique livre para utiliza-lo.
# dd if=/dev/CAMINHO_DESCOBERTO_NO_COMANDO_ANTERIOR | gzip -c | ssh root@IP_PROXMOX dd of=/DIRETORIO_DESTINO_PROMOX/HardDisk_NOMEDAVM.vhd.gz
ou sem compactar

# dd if=/dev/CAMINHO_DESCOBERTO_NO_COMANDO_ANTERIOR | ssh root@IP_PROXMOX dd of=/DIRETORIO_DESTINO_PROMOX/HardDisk_NOMEDAVM.vhd status=progress

Já no servidor Proxmox, com a VM com os mesmos recursos que a original criada o ID dela deve ser anotado, no caso de VMs Windows, no tipo de disco, esccolha o tipo IDE, tive problema ao utilizar discos migrados utilizando o tipo SATA.


Ainda no servidor Proxmox, você vai primeiro converter o tipo do disco virtual de VHD para RAW com o comando abaixo, (mas primeiro não esqueça de descompactar o arquivo caso o tenha compactado para transferência, com o comando gunzip):
Tenha em mente que aquele 301, é um ID da VM que eu criei, a sua vai ter outro ID.

# qemu-img convert ./HardDisk_NOMEDAVM.vhd -O raw ./vm-301-disk-1.raw

depois importe a VM para o repositorio e para a vm em questão

# qm importdisk 100 /discos/images/100/disco01.raw discos01 (nome do repositório)

Agora você tem o disco migrado em um formato reconhecido pelo Proxmox. O que você vai fazer com este arquivo, depende do tipo de storage que tem disponível. Vamos trabalhar com dois tipos, o tipo local e o tipo LVM local. Aqui caberia uma explicação mais detalhada sobre os tipos de storages no Proxmox mas isso é um assunto bem grande e não entra no escopo da migração. De forma bem resumida, os storages locais permitem discos virtuais em formato de arquivo, assim como aquele que acabamos de criar, o .raw, também permite arquivos do tipo qcow2 e outros. Os storages locais LVM, são similiares ao storage local XenServer e armazenam os discos virtuais em unidades lógicas LVM. Também existe o tipo zfs que segue a mesma logica do LVM.

Se você utiliza storage local LVM:
Nese caso, o arquivo migrado, que aqui chamamos de vm-301-disk-1.raw deve popular o volume lógico que ja foi criado quando você criou a VM no Proxmox.
Primeiro, identifique qual o caminho do volume lógico através do comando:
# lvdisplay
Diferente do Xen, o ID da VM esta no nome do volume lógico, o que facilita a busca

Depois popule o volume lógico. Faça isso com o comando (Claro que você deve trocar o ?ID? e ? pelo nome correto da unidade lógica pesquisada no comado anterior.):
# dd if=/caminho_do_arquivo_raw/vm-301-disk-1.raw of=/dev/StorageLVM/vm-?ID?-disk-?
 

Pronto, agora você ja pode iniciar sua VM no Proxmox

Se você utiliza storage local, sem LVM:
Então você irá trabalhar diretamente com o arquivo .raw, nesse caso, identifique onde esta o arquivo que foi automaticamente gerado ao criar a VM. Por padrão fica em /var/lib/vz/images/ID_DA_VM/
Basta você mover o arquivo de disco virtual migrado .raw para cima do disco que foi criado automaticamente.
# mv /caminho_do_arquivo_raw/vm-301-disk-1.raw /var/lib/vz/images/ID_DA_VM/arquivo.raw

 

E pronto novamente, você já pode iniciar sua maqina virtual, agora no Proxmox

 

Observações bem importantes:
. Ao criar as VMs no Proxmox, o tamanho do disco deve ser igual ao tamanho do disco da VM no XerServer ( aba Storage do Xencenter)
. Ao criar as VMs no Proxmox, selecionando um Storage do tipo local, você deve selecionar o tipo raw, do contrário terá que converter a imagem VHD para o modelo selecionado.
. VMs com mais de um disco seguem a mesma lógica, você deve criar mais de um disco na VM do Proxmox e substuir pelos discos migrados, vindos do XenServer.

 

Ficou com alguma duvida ou precisa de alguma Consultoria? Entre em Contato que iremos lhe ajudar!

 

Referências consultadas:
https://xenserver.org/blog/entry/xenserver-7-3-changes-to-the-free-edition.html
https://techblog.jeppson.org/2018/01/migrate-xenserver-proxmox/
https://pve.proxmox.com/wiki/Migration_of_servers_to_Proxmox_VE#VMware_to_Proxmox_VE_.28KVM.29
https://wiki.archlinux.org/index.php/disk_cloning




~~~
### Varrendo diretorio para adicionar disco migrado ou convertido
~~~
qm rescan --vmid 102
~~~

### Remover cluster 
~~~
systemctl stop pve-cluster corosync
pmxcfs -l
rm /etc/corosync/*
rm /etc/pve/corosync.conf
killall pmxcfs
systemctl start pve-cluster
~~~
