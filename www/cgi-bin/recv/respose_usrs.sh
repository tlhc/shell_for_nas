#!/bin/sh
#===============================================================================
#
#          FILE: respose_usrs.sh
# 
#         USAGE: ./respose_usrs.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: tongl (), 
#  ORGANIZATION: 
#       CREATED: 2012年11月08日 16时33分15秒 CST
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
	exit 1
fi
opt=`echo $var | awk -F '|' '{print $1}'`
opt_str=`echo $var | awk -F '|' '{print $2}'`




_usr_name=`echo $opt_str | awk -F '@' '{print $1}'`
_pass=`echo $opt_str | awk -F '@' '{print $2}'`

case $opt in
	add)
		add_usr_pass $_usr_name $_pass
		if [ $? -eq 0 ] ; then
			gen_success_message 
		else
			gen_error_message "can't add user $_usr_name"
		fi
		;;
	del)
		_usr_cnt=`echo $opt_str | sed 's/@/\n/g' | wc -l | sed 's/^[[:space:]]*//g'`
		_usr_cnt=`expr $_usr_cnt - 1` 1>/dev/null 2>/dev/null
		if [ $? -ne 0 ] ; then
			gen_error_message "user cnt error"
			exit 1
		fi
		__name=""
		for __cnt in `seq $_usr_cnt` ; do 
			__name=`echo $opt_str | awk -F '@' '{print$'$__cnt'}'`
			del_usr_pass $__name
			if [ $? -ne 0 ] ; then
				gen_error_message "can't del user $__name"
				exit 1
			fi
		done
		gen_success_message 
		;;

	fetch)
		user_g=`get_user_g`
#		echo $user_g | sed 's/\ /@/g'
		gen_success_message `echo $user_g | sed 's/\ /@/g'`
		;;
	reset)
		init_user_account
		;;
	*)
		;;

esac    # --- end of case ---
