# lista discos do pool
rbd ls -l -p ceph-pool01
# remove de forma forçado o disco travado
rbd rm --force ceph-pool01/vm-108-disk-0
rbd rm ceph-pool01/vm-108-disk-0

## a saida para ver se o disco está quebrado é

root@prox01dc:~# rbd ls -l -p ceph-pool01
rbd: error opening vm-108-disk-0: (2) No such file or directory
NAME           SIZE     PARENT  FMT  PROT  LOCK
vm-100-disk-0   32 GiB            2        excl
vm-100-disk-1  100 GiB            2        excl
vm-104-disk-0   20 GiB            2        excl
vm-106-disk-0  200 GiB            2        excl
vm-108-disk-1   50 GiB            2        excl
vm-108-disk-2    1 GiB            2            
vm-109-disk-0  200 GiB            2        excl
vm-109-disk-2   50 GiB            2        excl
vm-111-disk-0  100 GiB            2        excl
vm-111-disk-1  980 GiB            2        excl
vm-111-disk-2  490 GiB            2        excl
vm-114-disk-0   10 GiB            2        excl
vm-116-disk-0   32 GiB            2        excl
vm-117-disk-0   20 GiB            2        excl
vm-118-disk-0  1.5 TiB            2        excl
vm-200-disk-0   32 GiB            2        excl
vm-200-disk-1  2.0 TiB            2        excl
vm-200-disk-2  200 GiB            2        excl
vm-201-disk-0  1.5 TiB            2        excl
rbd: listing images failed: (2) No such file or directory
