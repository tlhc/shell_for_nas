#!/bin/sh
#===============================================================================
#
#          FILE: bg_get_rd_info.sh
# 
#         USAGE: ./bg_get_rd_info.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: tongl (), 
#  ORGANIZATION: 
#       CREATED: 2012年11月09日 10时17分08秒 CST
#      REVISION:  ---
#===============================================================================

while true ; do
	cat /proc/mdstat > /tmp/_raid_status_
	sleep 30
done

