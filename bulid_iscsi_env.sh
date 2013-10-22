#!/bin/sh 
#===============================================================================
#
#          FILE: bulid_iscsi_env.sh
# 
#         USAGE: ./bulid_iscsi_env.sh 
# 
#   DESCRIPTION: init scsi
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: tong
#  ORGANIZATION: 
#       CREATED: 2012年09月27日 16时09分11秒 CST
#      REVISION:  ---
#===============================================================================

#-------------------------------------------------------------------------------
#  bulid_iscsi_env
#-------------------------------------------------------------------------------
path="/etc/iet"
mkdir $path

#-------------------------------------------------------------------------------
#  bulid_thttp
#-------------------------------------------------------------------------------
cp /mnt/jffs2/thttpd.conf /etc
cp /mnt/jffs2/thttpd /bin

cp /mnt/jffs2/iscsi/ietd.conf $path
cp /mnt/jffs2/iscsi/initiators.allow $path
cp /mnt/jffs2/iscsi/targets.allow $path

cp /mnt/jffs2/iscsi/ietd /usr/sbin/
cp /mnt/jffs2/iscsi/ietadm /usr/sbin/

insmod /mnt/jffs2/iscsi/iscsi_trgt.ko

#-------------------------------------------------------------------------------
#  bulid_mdadm
#-------------------------------------------------------------------------------
cp /mnt/jffs2/mdadm /bin

exit 0
