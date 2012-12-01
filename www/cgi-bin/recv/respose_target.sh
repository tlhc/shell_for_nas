#!/bin/sh 
#===============================================================================
#
#          FILE: respose_target.sh
# 
#         USAGE: ./respose_target.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: tongl (), 
#  ORGANIZATION: 
#       CREATED: 2012年09月20日 17时42分37秒 CST
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
. $R_PATH/comm/set_target_para.sh
. $R_PATH/create_echo/c_tools.sh
. $R_PATH/create_echo/c_echo_header.sh
. $R_PATH/create_echo/c_echo_iscsi.sh
. $R_PATH/comm/get_sys_log.sh
#start stop 
read var
if [ "$var" = "start" ] ; then
	start_ietd_srv
	if [ $? -eq 0 ] ; then
		gen_success_message "start success.." 
		rec_opt target "start ISCSI service"
	else
		gen_error_message "can't start service.."
		rec_opt target "ERROR:start ISCSI service"
	fi
elif [ "$var" = "stop" ] ; then
	kill_tgt_serv
	if [ $? -eq 0 ] ; then
		gen_success_message "kill service.."
		rec_opt target "kill ISCSI service"
	else
		gen_error_message "already killed"
		rec_opt target "ERROR:kill ISCSI service"
	fi
else
	gen_error_message "bad options.."
fi
exit 0
