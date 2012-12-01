#!/bin/sh
#===============================================================================
#
#          FILE: c_echo_net.sh
# 
#         USAGE: ./c_echo_net.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: tongl (), 
#  ORGANIZATION: 
#       CREATED: 2012Äê09ÔÂ14ÈÕ 10ʱ56·Ö31Ãë CST
#      REVISION:  ---
#===============================================================================

#. ./c_echo_header.sh
#filename="echo_net"
#create_echo_file $filename
#create_echo_header $filename xml


gen_e_netinfo_h ()
{

	if [ -z $1 ] ; then
		return 1
	fi
	echo "<net_info>" >> "/tmp/$1"
	return 0
}	# ----------  end of function gen_e_netinfo_h  ----------



gen_e_netinfo_t ()
{
	if [ -z $1 ] ; then
		return 1
	fi
	echo "</net_info>" >> "/tmp/$1"
}	# ----------  end of function gen_e_netinfo_t  ----------


gen_e_netcardx ()
{
	#do not check this params
#	filename="/tmp/$1"
	net_name=$2
	ip_addr=$3
	mask=$4
	gateway=$5

	echo "<netcard_x>" >> "/tmp/$1"
		echo "<name>" >> "/tmp/$1"
			echo $net_name >> "/tmp/$1" 
		echo "</name>" >> "/tmp/$1"

		echo "<ip_addr>" >> "/tmp/$1"
			echo $ip_addr >> "/tmp/$1"
		echo "</ip_addr>" >> "/tmp/$1"

		echo "<ip_mask>" >> "/tmp/$1"
			echo $mask >> "/tmp/$1"
		echo "</ip_mask>" >> "/tmp/$1"

		echo "<gateway>" >> "/tmp/$1"
			echo $gateway >> "/tmp/$1"
		echo "</gateway>" >> "/tmp/$1"
	echo "</netcard_x>" >> "/tmp/$1"
}	# ----------  end of function gen_e_netcardx  ----------


#echo "<netcards>"
#	echo "<netcard_x>"
#		echo "<name>"
#			echo "fasdfas"
#		echo "</name>"
#	
#		echo "<ip_addr>"
#			sed -n -e '1p' $file | awk 'NF > 1' | awk '{printf $4}' | awk -F: '{printf $2}'
#		echo "</ip_addr>"
#	
#		echo "<ip_mask>"
#	
#			sed -n -e '1p' $file | awk 'NF > 1' | awk '{printf $6}' | awk -F: '{printf $2}'
#		echo "</ip_mask>"
#	
#		echo "<gateway>"
#			sed -n -e '1p' $file | awk 'NF > 1' | awk '{printf $5}' | awk -F: '{printf $2}'
#		echo "</gateway>"
#	echo "</netcard_x>"




get_inet_name ()
{
	local _inet_name=$1

	for iname in `cat /tmp/net.file`; do
		if [ $iname = $_inet_name ]; then
			local l_num=`sed ''`
		fi
	done
	echo $_inet_name
#	return 1
}	# ----------  end of function get_inet_name  ----------




#-------------------------------------------------------------------------------
#  implement in echo_net
#-------------------------------------------------------------------------------

#get_inet_address ()
#{
#	
#	return 1
#}	# ----------  end of function get_inet_address  ----------
#
#
#get_inet_gateway ()
#{
#	
#	return 1
#}	# ----------  end of function get_inet_gateway  ----------
#
#
#get_inet_mask ()
#{
#	
#	return 1
#}	# ----------  end of function get_inet_mask  ----------
#


