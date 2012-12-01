#!/bin/sh 
#===============================================================================
#
#          FILE: get_array.sh
# 
#         USAGE: ./get_array.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: tongl (), 
#  ORGANIZATION: 
#       CREATED: 2012Äê09ÔÂ12ÈÕ 17ʱ15·Ö07Ãë CST
#      REVISION:  ---
#===============================================================================

array_name=$1


if  [ -z $array_name ]; then
	exit 1
fi

file="/tmp/$array_name"


if [ -f $file ] ; then
	cat $file
else
	exit 1
fi
