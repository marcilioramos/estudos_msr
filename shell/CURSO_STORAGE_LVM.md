### Diagram sobre LVM
![image](https://user-images.githubusercontent.com/48597831/184878932-f2251f71-2fae-40b3-be10-6b4d6ffaf7c8.png)

### Diagram Voumes Logicos
![image](https://user-images.githubusercontent.com/48597831/184880234-ff0445d1-0796-4ccb-9879-35571db2f993.png)

## Passo a passo para Manipulação de Discos LVM

### VG
~~~
1 - Adiciona-se os discos físicos (PV)
  - pvscan: Comando para listar os discos fisicos inseridos no S.O.
2 - Lista-se com fdisk -l (para ter certeza que eles foram inseridos)
3 - Formatá-os com: fdisk /dev/sda (atentar para marcar o disco como tipo LVM(8e))
4 - Depois será criado o volume grupo com os PV inseridos.
  - vgcreate: Comando para criar um volume de discos a partir dos discos fisicos (PV) que foram inseridos no S.O.
    -- vgcreate vgdata /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdXX
      --- vgdata = nome do volume group
      --- /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdXX = discos criados após formatação com o fdisk /dev/sdX
5 - vgs: Comando para escanear os Volume Group criados.
  - vgdisplay "vgdata"
    -- mostra dados mais detalhados do Volume Group.
  - vgscan: comando para varrer os Volumes Group e atualizar a tabela de VGs.
6 - vgchange -a y
  -- vgchange = comando usado para ativar o VG criado.
~~~

### LV
~~~
1 - lvcreate -L 10G -n alunos vgdata
  -- -L 10G: tamanho do LV
  -- -n alunos: tamanho do LV
  -- vgdata: nome do VG
  ou
  - lvcreate -l 100%FREE -n profes vgdata
  - lscan: para varrer os LVs
  - lvs: mostra como ele montou com detalhes a estrutura.
  - lvdisplay: monstra outros detalhes dos LVs
  
  - mkfs -t ext4 /dev/vgdata/alunos
    -- mkfs -t ext4: formata o volume como tipo ext4
      --- -t ext4: define o volume como do tipo ext4
    - /dev/vgdata/alunos: volume formatado.
    
  - mkdir /alunos
    -- cria a pasta "alunos"
  - mount -t ext4 /dev/vgdata/alunos /alunos
    -- monta a volume na pasta criada.
    
  - fstab
    -- linha fstab
        --- /dev/vgdata/alunos  /alunos ext4 defaults   0 0
    -- mount -a v
      --- monta os volumes descritos no fstab
~~~

### Snapshots LVM
~~~
1 - Adicione um disco para armazenar esses instataneos
2 - Formate-o como os demais acima
3 - cria-se um novo PV, com o  nosso disco adicionado
4 - extende-se o VG com esse novo PV
  -- vgextend vgdata /dev/sdX1
    -- vgextend: comando para adicionar novo PV e extender o Volume Group
    -- "vgdata": nome do Volume group
    -- "/dev/sdX1": o volume adicionado no VG
5 - criar o LV para o serviço de snapshot
  -- lvcreate -s -L 20G -n vgdata-snapshot /dev/vgdata/alunos
    --- assim será feio o snapshot desse volume lvm
  -- lvdisplay /dev/vgdata/vgdata-snapshot
    --- mostra os detalhes desse lv que foi criado
  -- mkdir /backup
  -- mount /dev/vgdata/vgdata-snapshot /backup
    --- monta o snapshot que foi feito do volume
  -- umount /backup
  -- lvremove /dev/vgdata/vgdata-snapshot
    -- lvremove: comanda para remove o snaphost
  -- vgreduce vgdata /dev/sdfX
    --- vgreduce: comando para remover uma LV de um VG
  -- pvremove /dev/sdfX
    -- pvremove: comando para remover o PV.
  -- cd /etc/lvm/backup
    --- local onde são guardados os backups dos metadados do LVM
  -- cd /etc/lvm/archive
    --- local onde ficam armazenados todas as informação referentes ao ambiente LVM, organizado por data.

~~~

### Troubleshoot LVM

~~~
- pvscan -v (esse verbose pode ser aumentado)
- vgs -v (esse verbose pode ser aumentado)
- lvmdump
  -- gera um arquivo .tgz com diversas informações para suporte técnico.
- dmsetup ifo
  -- mostra mais informações sobre o ambiente e sua saúde
- lvm dumpconfig
  -- mostra todas as informações do ambiente LVM
- pvs -o +pv_uuid
  -- esse parametro "-o" possibilita mostrar apenas o parametro indicado no comando, no caso "+pv_uuid"
- vgs -P -o +devices
  -- ajuda a identificar discos que estão com problemas
-- É possivel mover os dados de um disco danificado usando comando "pvmove"
  --- pvmove /dev/sddX /dev/sdfX
       ---- esse disco deve ser criado via "pvcreate", depois extendemos o "VG" com vgextend e depois rodamos o comando acima.
  --- vgreduce vgdata /dev/sddX
      ---- vgdata é o nome do VG
~~~

### Recuperando um Volume apagado acidentalmente

~~~
- vgcfgbackup
  -- faz o backup dos VGs existentes
  
 - simulando
  -- umount /alunos
  -- lvs (ja perde o atributo "o" de open)
  -- lvremove /dev/vgdata/alunos
  -- lvs (ja nao aparece mais o LV)
  -- vgcfgrestore vgdata --test -f /etc/lvm/archive/vgdataXXXXX.vg
    --- test: valida se será possivel fazer a restauração
  -- vgcfgrestore vgdata -f /etc/lvm/archive/vgdataXXXXX.vg
  -- lvchange -a y /dev/vgdata/alunos
    --- -a: ativar
  -- lvs
  -- mount /dev/vgdata/alunos


~~~

### Removendo todo o ambiente

~~~
- umont /alunox
- vim /etc/fstab (apaga as entradas referente aos volumes)
- lvremove /dev/vgdata/alunos
- vgremove vgdata
- pvremove /dev/sdXX
- pvs
- vgs
- lvs
  -- nao deve aparecer mais nada
~~~

### LVM ESPELHADO

~~~
- pvcreate /dev/sda1 /dev/sdb1
- vgcreate datavg /dev/sda1 /dev/sdb1
- vgs ## para visualizar
- vgscan ## para att
- lvcrete -L 7.99G -m1 -n espelho datavg
- lvs -a -o name,devices,copy_percent datavg (mostrado o processo de sincronização dos discos)
- lvs --all -segments -o +devices
- mkfs -t ext4 /dev/datavg/espelho
- mkdir /data
- mount /dev/datavg/espelho /data
- pvdisplay -m (mostra o ambiente espelhado)

quebrando o mirror
- lvconvert -m0 datavg/espelho /dev/sdb1
- lvs -a -o +devices (visualizar os LVs ups)
- vgreduce datavg /dev/sdb1
  -- retira o disco do VG
- vgextend datavg /dev/sdc1
  -- re-adicionar o disco ao VG
- lvconvert -m 1 /dev/datavg/espelho
  -- re-transforma e adicionar o disco ao mirror
- lvs -a -o +devices (visualizar os LVs ups)
  
~~~

### LVM Stripper

~~~
aproveitaremos o ambiente anterior, do mirror:
- pvcreate /dev/sdd1
- pvcreate /dev/sde1
- pvcreate /dev/sdf1
- vgvreate vg01 /dev/sdd1 /dev/sde1 /dev/sdf1
- vgscan (atualiza a área de metadados)
- lvcreate -i3 -I4 -L 23.98G -n distribuido vg01
  -- -i3: 3 discos usando interliving entre eles
  -- -I4: diz que vai usar cada stripper de 4K
  -- -L 23.98G: tamanho do volume stripper
  -- -n: o nome do volume que será criado
  -- vg01: o nome do volume group
 - mkfs -t ext4 /dev/vg01/distribuido
 - mkdir /distribuido
 - mount /dev/vg01/distribuido /distribuido
 - lvs -a -o +devices (monitoring)
 - pvdisplay
~~~


### caso real de expansão de disco, adicionando um volume de 1TB e expandindo um VG existente:

~~~
fdisk -l
pvs
pvcreate /dev/xvde 
vgextend centos /dev/xvde 
vgs
lvs
df -h 
lvextend -l +100%FREE /dev/mapper/centos-root 
df -h 
blkid 
xfs_growfs /dev/mapper/centos-root 
df -h /dev/mapper/centos-root 
~~~



