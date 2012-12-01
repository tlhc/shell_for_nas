#!/bin/sh - 
#===============================================================================
#
#          FILE: get_elements.sh
# 
#         USAGE: ./get_elements.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: tongl (), 
#  ORGANIZATION: 
#       CREATED: 2012Äê09ÔÂ12ÈÕ 10ʱ45·Ö11Ãë CST
#      REVISION:  ---
#===============================================================================

array_name=$1
array_indx=$2                                   # array_indx 从1开始
file="/tmp/$array_name"


if [ -z $array_name ] || [ -z $array_indx ] ; then
	exit 1
fi






count=`cat $file | wc -l | sed 's/^[[:space:]]*//g'`

if [ $array_indx -gt $count ] ; then 
	exit 1
fi

if [ -f $file ] && [ -r $file ]; then
	sed -n ''$array_indx'p' $file
else
	exit 1
fi
