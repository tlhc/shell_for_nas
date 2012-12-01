#!/bin/sh
#===============================================================================
#
#          FILE: getlen.sh
# 
#         USAGE: ./getlen.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: tongl (), 
#  ORGANIZATION: 
#       CREATED: 2012Äê09ÔÂ11ÈÕ 16ʱ39·Ö14Ãë CST
#      REVISION:  ---
#===============================================================================

array_name=$1

getlength()
{
	if [ -z $array_name ] ; then	
		echo "must have array name!"
	else
		file="/tmp/$array_name"
		if  [ -f $file ] ; then
			retunv=`cat $file | wc -l | sed 's/^[[:space:]]*//g'`
		else
			echo "can't get array"
		fi
	fi
}	# ----------  end of function getlen  ----------

getlength
echo $retunv

