#! /bin/sh
####
#the init script for system
####
ifconfig eth1 down
ifconfig eth1 hw ether 00:00:aa:bb:cc:dd
ifconfig eth1 inet 192.168.1.67
ifconfig eth1 up


ifconfig eth0 down
ifconfig eth0 hw ether 00:00:aa:bb:cc:de
ifconfig eth0 inet 192.168.0.67
ifconfig eth0 up

#start iscsi target...
sh /mnt/jffs2/bulid_iscsi_env.sh
ietd start

#bulid links...
sh /mnt/jffs2/bulid_links.sh

sh /mnt/jffs2/kill_thttp.sh
/mnt/jffs2/thttpd -C /etc/thttpd.conf

#demon..
/mnt/jffs2/thttpd_demon.sh &

# /mnt/jffs2/thttpd -C thttpd.conf

# sync system time from RTC
# /mnt/jffs2/hwclock -s

# updata vsftpd configure file

rm /etc/vsftpd.conf
ln -s /mnt/jffs2/vsftpd.conf /etc/vsftpd.conf

/bin/busybox mknod /dev/mypipo p

/bin/busybox mkdir /sys/
# mount sysfs
/bin/busybox mount -t sysfs sysfs /sys/

/bin/busybox mount -o remount,rw /mnt/jffs2
/bin/busybox mkdir /mnt/md0/

#/mnt/jffs2/raid0.sh
ln -s /mnt/jffs2/mdadm.conf /etc/mdadm.conf
mdadm -As
#mount /dev/md0 /mnt/md0 


echo "start samba service:"
/bin/busybox rm /usr/local/samba/lib/smb.conf
/bin/busybox ln -s /mnt/jffs2/smb.conf /usr/local/samba/lib/smb.conf
/usr/bin/smbd
/usr/bin/nmbd

