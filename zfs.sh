#!/bin/bash
script /vagrant/screept.txt
lsblk
zpool create zfs1 mirror /dev/sdb /dev/sdc
zpool create zfs2 mirror /dev/sdd /dev/sde
zpool create zfs3 mirror /dev/sdf /dev/sdg
zpool create zfs4 mirror /dev/sdh /dev/sdi
zfs set compression=lzjb zfs1 
zfs set compression=lz4 zfs2
zfs set compression=gzip-9 zfs3
zfs set compression=zle zfs4
wget https://gutenberg.org/cache/epub/2600/pg2600.converter.log  
for i in {1..4}; do cp pg2600.converter.log /zfs$i ; done 
zfs list
zfs get all | grep compressratio | grep -v ref


wget -O archive.tar.gz --no-check-certificate 'https://drive.usercontent.google.com/download?id=1MvrcEp-WgAQe57aDEzxSRalPAwbNN1Bb&export=download'
tar -xzvf archive.tar.gz
zpool import -d zpoolexport/
zpool import -d zpoolexport/ otus
zpool status
zpool get all otus
zfs get available otus
zfs get readonly otus
zfs get recordsize otus

wget -O otus_task2.file --no-check-certificate 'https://drive.usercontent.google.com/download?id=1wgxjih8YZ-cqLqaZVa0lA3h3Y029c3oI&export=download'
zfs receive otus/test@today < otus_task2.file
cat /otus/test/task1/file_mess/secret_message
exit
