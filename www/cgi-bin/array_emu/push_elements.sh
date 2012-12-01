#!/bin/sh  
#===============================================================================
#
#          FILE: push_elements.sh
# 
#         USAGE: ./push_elements.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: tongl (), 
#  ORGANIZATION: 
#       CREATED: 2012Äê09ÔÂ11ÈÕ 16ʱ18·Ö27Ãë CST
#      REVISION:  ---
#===============================================================================

#set -o nounset                              # Treat unset variables as an error

array_name=$1
elements=$2


if  [ -z $1 ] && [ -z $2 ] ; then
	echo "parameter empty!!"
	exit 1
fi

file="/tmp/$array_name"


if [ -f $file ] ; then
	echo $elements >> $file
	exit 0
else
	echo "can't push"
	exit 1
fi

