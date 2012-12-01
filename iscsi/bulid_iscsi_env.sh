#!/bin/sh 
#===============================================================================
#
#          FILE: bulid_iscsi_env.sh
# 
#         USAGE: ./bulid_iscsi_env.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 2012年09月27日 16时09分11秒 CST
#      REVISION:  ---
#===============================================================================



  
path="/etc/iet"
mkdir $path

cp /mnt/jffs2/iscsi/ietd.conf $path
cp /mnt/jffs2/iscsi/initiators.allow $path
cp /mnt/jffs2/iscsi/targets.allow $path

cp /mnt/jffs2/iscsi/ietd /usr/sbin/
cp /mnt/jffs2/iscsi/ietadm /usr/sbin/

insmod /mnt/jffs2/iscsi/iscsi_trgt.ko

exit 0
