#!/bin/sh
#===============================================================================
#
#          FILE: respose_modify_server_ip.sh
# 
#         USAGE: ./respose_modify_server_ip.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 2012年10月29日 18时37分08秒 CST
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
. $R_PATH/create_echo/c_echo_iscsi.sh
. $R_PATH/comm/get_sys_log.sh
t_count=0
ip1=""
ip2=""
read var 
t_count=`echo $var | awk -F '@' '{print $1}'`

expr $t_count + 1 &>/dev/null

if  [ $? -ne 0 ]; then
	gen_error_message "ip_count_error.."
fi

if [ $t_count -eq 1 ] ; then
	ip1=`echo $var | awk -F '@' '{print $2}'`
	gen_conf_tgt_ip $ip1
	rec_opt target "change ISCSI_SERVER_IP:$ip1"
elif [ $t_count -eq 2 ] ; then
	ip1=`echo $var | awk -F '@' '{print $2}'`
	ip2=`echo $var | awk -F '@' '{print $3}'`
	gen_conf_tgt_ip $ip1 $ip2
	rec_opt target "change ISCSI_SERVER_IP:$ip1 and $ip2"
fi
#gen_conf_tgt_ip $var
if [ $? -eq 0 ] ; then
	gen_success_message 
fi
