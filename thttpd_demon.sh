#!/bin/sh
#===============================================================================
#
#          FILE: thttpd_demon.sh
# 
#         USAGE: ./thttpd_demon.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: tongl (), 
#  ORGANIZATION: 
#       CREATED: 2012年11月07日 13时54分15秒 CST
#      REVISION:  ---
#===============================================================================

res=""
while true ; do
	res=`pidof thttpd`
#	sync 1>/dev/null 2>/dev/null
#	echo 3 > /proc/sys/vm/drop_caches 1>/dev/null 2>/dev/null
	if [ -z "$res" ] ; then
		thttpd -C /etc/thttpd.conf
	fi
	sleep 30
done
