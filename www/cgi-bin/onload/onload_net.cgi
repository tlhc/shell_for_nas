#!/bin/sh
#===============================================================================
#
#          FILE: onload_lun.sh
# 
#         USAGE: ./onload_lun.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: tongl (), 
#  ORGANIZATION: 
#       CREATED: 2012Äê09ÔÂ18ÈÕ 11ʱ40·Ö23Ãë CST
#      REVISION:  ---
#===============================================================================

get_r_path() {
	local _fp="/etc/thttpd.conf"
	local _prefix=""
	local _cgi_path=""
	local _wholepth=""
	local _tmpstr=""
	if [ -f $_fp ] && [ -r $_fp ]; then
	_prefix=`sed '/^$/d' $_fp | sed '/^#/d' | sed 's/^[[:space:]]*//g' | sed -n -e '/dir=/p' | awk -F = '{print $2}'` 
	_tmpstr=`sed '/^$/d' $_fp | sed '/^#/d' | sed 's/^[[:space:]]*//g' | sed -n -e '/cgipat/p' | awk -F = '{print $2}'`
	#echo $_cgi_path
	#sed '/'$_cgi_path'/a\\'
#	sed ''$_cgi_path'a\\'
#	echo -e $_prefix | sed 'a\'$_cgi_path''
	_cgi_path=`echo $_tmpstr | awk -F / '{print $2}'`
	_wholepth="$_prefix"/"$_cgi_path"
	echo $_wholepth
	return 0
	else
		return 1
	fi
}

R_PATH=""
unset R_PATH
R_PATH=`get_r_path`

. $R_PATH/comm/tools.sh
. $R_PATH/create_echo/c_tools.sh
. $R_PATH/create_echo/c_echo_header.sh
. $R_PATH/create_echo/c_echo_net.sh

#. ../create_echo/c_echo_header.sh
#. ../create_echo/c_echo_net.sh
getnetinfo_sc="$R_PATH/comm/get_net_info.sh"

export PATH=$PATH:/usr/sbin

echo $PATH >> /tmp/path
verify_net_files ()
{
	if [ -f "/tmp/net.file" ] && [ -r "/tmp/net.file" ] ; then
		if [ -f "/tmp/netd.file" ] && [ -r "/tmp/netd.file" ] ; then
			if [ -f "/tmp/netfinal.file" ] && [ -r "/tmp/netfinal.file" ] ; then
				return 0
			else
				echo "can't get net_f_info!!"
				return 1
			fi
		else
			echo "can't get netd_info!!"
			return 1
		fi
	else
		echo "can't get net_intf_info!!"
		return 1
	fi
}	# ----------  end of function verify_net_files  ----------



#
#create_echo_file $filename
#create_echo_header $filename xml
#
#gen_e_netinfo_h echo_net
#gen_e_netcardx echo_net eth1 192.178.1.1 255.255.255.0 0.0.0.0 
#gen_e_netcardx echo_net eth0 192.178.2.2 255.255.255.0 0.0.0.0 
#gen_e_netinfo_t echo_net
#
#cat /tmp/echo_net
#
#
#

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


onload_net ()
{
	$getnetinfo_sc                                  # call 
	echo_net="echo_net"
	lnum=1
	verify_net_files
	if [  $? -eq 0 ] ; then                                # verify the net files
		#cut the output and create echo for net files
		touch_file $echo_net
#		create_echo_file $echo_net
		create_echo_header $echo_net xml
		#gen_e_netcardx echo_net eth0 192.178.2.2 255.255.255.0 0.0.0.0 
		gen_e_netinfo_h $echo_net
		while true ; do
			if [ $lnum -gt `cat /tmp/netfinal.file | wc -l | sed 's/^[[:space:]]*//g'` ]; then
				break
			fi
			LINE=`sed -n -e ''$lnum','$lnum'p' /tmp/netfinal.file`
			inet_name=`echo $LINE | awk 'NF > 1' | awk '{printf $2}' | awk -F: '{printf $1}'`
			inet_address=`echo $LINE | awk 'NF > 1' | awk '{printf $4}' | awk -F: '{printf $2}'`
			inet_mask=`echo $LINE | awk 'NF > 1' | awk '{printf $6}' | awk -F: '{printf $2}'`
			inet_gateway=`echo $LINE | awk 'NF > 1' | awk '{printf $5}' | awk -F: '{printf $2}'`
			gen_e_netcardx $echo_net $inet_name $inet_address $inet_mask 0.0.0.0
			unset inet_name
			unset inet_address
			unset inet_mask
			unset inet_gateway
			unset LINE
			lnum=`expr $lnum + 1`
		done
		gen_e_netinfo_t $echo_net
#		cat /tmp/$echo_net
		#	resu=$(get_inet_name anana)
		#	echo $resu
		return 0
	else
		touch_file $echo_net
#		create_echo_file $echo_net
		create_echo_header $echo_net xml
		#	echo "can't request!!"
		return 1
	fi

}	# ----------  end of function onload_net  ----------

onload_net
#cat in pre_onload_net.sh !!!!!
#cat /tmp/echo_net
exit 0
