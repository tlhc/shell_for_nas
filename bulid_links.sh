#!/bin/sh
#===============================================================================
#
#          FILE: bulid_links.sh
# 
#         USAGE: ./bulid_links.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 2012年10月24日 15时27分34秒 CST
#      REVISION:  ---
#===============================================================================


for _bin in `ls /usr/sbin/` ; do
	/bin/ln -s /usr/sbin/$_bin /bin/$_bin
done

for _ubin in `ls /usr/bin/` ; do
	/bin/ln -s /usr/bin/$_ubin /bin/$_ubin
done

ln -s /bin/busybox /bin/ifconfig
ln -s /mnt/jffs2/fuser /bin/fuser
ln -s /mnt/jffs2/pkill /bin/pkill

ln -s /bin/busybox /bin/reboot
ln -s /bin/busybox /bin/halt
