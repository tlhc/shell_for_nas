#!/bin/sh
#===============================================================================
#
#          FILE: del_array.sh
# 
#         USAGE: ./del_array.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: tongl (), 
#  ORGANIZATION: 
#       CREATED: 2012Äê09ÔÂ11ÈÕ 16ʱ11·Ö40Ãë CST
#      REVISION:  ---
#===============================================================================

#set -o nounset                              # Treat unset variables as an error


if [ -z $1 ] ; then
	echo "array name empty"
	exit 1
fi
