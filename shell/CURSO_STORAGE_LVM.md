### Diagram sobre LVM
![image](https://user-images.githubusercontent.com/48597831/184878932-f2251f71-2fae-40b3-be10-6b4d6ffaf7c8.png)

### Diagram Voumes Logicos
![image](https://user-images.githubusercontent.com/48597831/184880234-ff0445d1-0796-4ccb-9879-35571db2f993.png)

## Passo a passo para Manipulação de Discos LVM

### VG
~~~
1 - Adicionasse os discos físicos (PV)
  - pvscan: Comando para listar os discos fisicos inseridos no S.O.
2 - Listasse com fdisk -l (para ter certeza que eles foram inseridos)
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

LV - 
~~~
~~~