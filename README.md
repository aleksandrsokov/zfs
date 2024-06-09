# zfs
# 1. Определение алгоритма с наилучшим сжатием
lsblk  
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS  
sda      8:0    0 19.5G  0 disk  
├─sda1   8:1    0    1M  0 part  
├─sda2   8:2    0  200M  0 part /boot/efi  
├─sda3   8:3    0  512M  0 part /boot  
└─sda4   8:4    0 18.8G  0 part /  
sdb      8:16   0  512M  0 disk  
sdc      8:32   0  512M  0 disk  
sdd      8:48   0  512M  0 disk  
sde      8:64   0  512M  0 disk  
sdf      8:80   0  512M  0 disk  
sdg      8:96   0  512M  0 disk  
sdh      8:112  0  512M  0 disk  
sdi      8:128  0  512M  0 disk  

создаем пулы  
zpool create zfs1 mirror /dev/sdb /dev/sdc  
zpool create zfs2 mirror /dev/sdd /dev/sde  
zpool create zfs3 mirror /dev/sdf /dev/sdg  
zpool create zfs4 mirror /dev/sdh /dev/sdi  

смотрим инфу по пулам  
zpool list  
NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT  
zfs1   480M   140K   480M        -         -     0%     0%  1.00x    ONLINE  -  
zfs2   480M   135K   480M        -         -     0%     0%  1.00x    ONLINE  -  
zfs3   480M   135K   480M        -         -     0%     0%  1.00x    ONLINE  -  
zfs4   480M   136K   480M        -         -     0%     0%  1.00x    ONLINE  - 

для каждого пула задаем алгоритм сжатия  
zfs set compression=lzjb zfs1  
zfs set compression=lz4 zfs2  
zfs set compression=gzip-9 zfs3  
zfs set compression=zle zfs4  

zfs get all | grep compression  
zfs1  compression           lzjb                   local  
zfs2  compression           lz4                    local  
zfs3  compression           gzip-9                 local  
zfs4  compression           zle                    local  

скачиваем файл  
wget https://gutenberg.org/cache/epub/2600/pg2600.converter.log  
for i in {1..4}; do cp pg2600.converter.log /zfs$i ; done  

проеряем компресию  
zfs get all | grep compressratio | grep -v ref  
gzip-9 с наибольшей компресией 3.63x

# 2. Определение настроек пула
