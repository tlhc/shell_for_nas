#!/bin/sh 
#===============================================================================
#
#          FILE: respose_net.sh
# 
#         USAGE: ./respose_net.sh 
# 
#   DESCRIPTION: get net set
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: tongl (), 
#  ORGANIZATION: 
#       CREATED: 2012年09月20日 17时39分14秒 CST
#      REVISION:  ---
#===============================================================================

get_r_path() {
	local _fp="/etc/thttpd.conf"
	local _prefix=""
	local _cgi_path=""
	local _wholepth=""
	local _tmpstr=""
	if [ -f $_fp ] && [ -r $_fp ]; then
	_prefix=`sed '/^$/d' $_fp |   sed '/^#/d' | sed 's/^[[:space:]]*//g' | sed -n -e '/dir=/p' | awk -F = '{print $2}'` 
	_tmpstr=`sed '/^$/d' $_fp |   sed '/^#/d' | sed 's/^[[:space:]]*//g' | sed -n -e '/cgipat/p' | awk -F = '{print $2}'`
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
. $R_PATH/comm/get_sys_log.sh



#|wlan2|192.168.1.109|255.255.255.0|0.0.0.0|
read var
#ex_test="|eth0|192.168.0.2|255.255.255.0|0.0.0.0|"

nc_id=""
nc_inet_address=""
nc_mask=""
nc_getway=""

echo $var >> /tmp/res_net

if [ -z $var ] ; then
	gen_error_message 'set ip fault..'
	rec_opt net "set para empty"
	exit 1
else
	#nc_id=`echo $ex_test | awk -F '|' '{print $2}'`
	#nc_inet_address=`echo $ex_test | awk -F '|' '{print $3}'`
	#nc_mask=`echo $ex_test | awk -F '|' '{print $4}'`
	#nc_getway=`echo $ex_test | awk -F '|' '{print $5}'`
	nc_id=`echo $var | awk -F '|' '{print $2}'`
	nc_inet_address=`echo $var | awk -F '|' '{print $3}'`
	nc_mask=`echo $var | awk -F '|' '{print $4}'`
	nc_getway=`echo $var | awk -F '|' '{print $5}'`

	if [ -z $nc_id ] || [ -z $nc_inet_address ] || [ -z $nc_mask  ] || [ -z $nc_getway ]; then
		exit 1
	else
		ifconfig $nc_id down
		ifconfig $nc_id inet $nc_inet_address netmask $nc_mask up 2>/dev/null
		#  ifconfig $nc_id inet $nc_inet_address netmask $nc_mask gw $nc_getway up
		#if [ $? -ne 0 ] ; then
#		#	echo $? >> /tmp/res_net
		#	gen_error_message "can't change ip...."
		#else
		#	gen_success_message 
		#fi
		route add default gw $nc_getway dev $nc_id 2>/dev/null
		gen_success_message
		rec_opt net "set $nc_id ip_address $nc_inet_address netmask $nc_mask"
	fi
fi

#nc_id=`echo $ex_test | awk -F '|' '{print $1}'`
#nc_id=`echo $ex_test | awk -F '|' '{print $1}'`
#echo $nc_id 
#echo $nc_inet_address 
#echo $nc_mask 
#echo $nc_getway
#
#echo $ex_test | awk -F '|' '{print $2}'
#echo $ex_test | awk -F '|' '{print $3}'
#echo $ex_test | awk -F '|' '{print $4}'
#echo $ex_test | awk -F '|' '{print $5}'
