#!/bin/sh
#===============================================================================
#
#          FILE: respose_login.sh
# 
#         USAGE: ./respose_login.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: tongl (), 
#  ORGANIZATION: 
#       CREATED: 2012年11月08日 12时01分18秒 CST
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
. $R_PATH/comm/get_user_info.sh

read var

if [ -z "$var" ] ; then
	gen_error_message "login para empty"
fi
_recvpass=`echo $var | awk -F '@' '{print $2}'`
_recvusr=`echo $var | awk -F '@' '{print $1}'`

is_usrpass_exist $_recvusr

if [ $? -eq 0 ] ; then
	_pass=`get_pass $_recvusr`
	if [ "$_pass" = $_recvpass ] ; then
		gen_success_message "login success"
	else
		gen_error_message "password error."
	fi
elif [ $? -eq 1 ] ; then 
	gen_error_message "user not found."
fi

