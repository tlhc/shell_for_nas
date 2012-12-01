#!/bin/sh  
#===============================================================================
#
#          FILE: remove_elements.sh
# 
#         USAGE: ./remove_elements.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: tongl (), 
#  ORGANIZATION: 
#       CREATED: 2012Äê09ÔÂ12ÈÕ 11ʱ17·Ö36Ãë CST
#      REVISION:  ---
#===============================================================================

array_name=$1
array_indx=$2

file="/tmp/$array_name"

if [ -z $array_name ] || [ -z $array_indx ] ; then
	exit 1
fi

len=`cat $file | wc -l | sed 's/^[[:space:]]*//g'`

if  [ $array_indx -gt $len ]; then
	exit 1
else
	sed  -i ''$array_indx'd' $file
fi
