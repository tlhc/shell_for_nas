#!/bin/sh 
#===============================================================================
#
#          FILE: pop_elements.sh
# 
#         USAGE: ./pop_elements.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: tongl (), 
#  ORGANIZATION: 
#       CREATED: 2012Äê09ÔÂ11ÈÕ 16ʱ25·Ö51Ãë CST
#      REVISION:  ---
#===============================================================================

array_name=$1


if  [ -z $1 ] ; then
	echo "parameter empty!!"
	exit 1
fi

file="/tmp/$array_name"


if [ -f $file ] && [ -w $file ] ; then

else
	
fi
