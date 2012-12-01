#!/bin/sh
#===============================================================================
#
#          FILE: create_array.sh
# 
#         USAGE: ./create_array.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: tongl (), 
#  ORGANIZATION: 
#       CREATED: 2012Äê09ÔÂ11ÈÕ 16ʱ01·Ö47Ãë CST
#      REVISION:  ---
#===============================================================================

#set -o nounset                              # Treat unset variables as an error


if  [ -z $1 ]; then
	echo "empty"
	exit 1
fi

array_name=$1
file="/tmp/$array_name"
create_array ()
{
	if  [ -f $file ]; then
		  rm $file
		touch $file
		chmod a+rw $file
	else
		touch $file
		chmod a+rw $file
	fi
}	# ----------  end of function create_array  ----------

create_array
