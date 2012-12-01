#!/bin/sh
#===============================================================================
#
#          FILE: get_user_info.sh
# 
#         USAGE: ./get_user_info.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: tongl (), 
#  ORGANIZATION: 
#       CREATED: 2012年11月08日 10时54分32秒 CST
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


R_PATH=`get_r_path`
. $R_PATH/comm/tools.sh
. $R_PATH/create_echo/c_tools.sh

is_usrpass_fp_exist ()
{
	local _fp="$R_PATH/data/user.conf"
	if [ -f "$_fp" ] ; then
		return 0
	else
		return 1
	fi
}	# ----------  end of function is_usrpass_exist  ----------


is_usrpass_exist ()
{
	local _usr=$1
	local _fp="$R_PATH/data/user.conf"
	is_usrpass_fp_exist
	if  [ $? -eq 0 ]; then
		local _res=`awk -F '@' '{print $1}' $_fp | sed -n -e '/'$_usr'/p'`
		if  [ -z "$_res" ]; then
			return 1
		else
			return 0
		fi
	fi
}	# ----------  end of function is_usrpass_exist  ----------


get_user_g ()
{
	local _fp="$R_PATH/data/user.conf"
	is_usrpass_fp_exist
	if  [ $? -eq 0 ]; then
		local _res=`awk -F '@' '{print $1}' $_fp`
		if  [ -z "$_res" ]; then
			return 1
		else
			echo $_res
			return 0
		fi
	fi
}	# ----------  end of function get_user_g  ----------


init_user_account ()
{
	local _fp="$R_PATH/data/"
	is_usrpass_fp_exist
	if [ $? -eq 1  ] ; then
		touch_file user.conf $_fp
		chmod a+wr $R_PATH/data/user.conf
		echo "admin@admin" >> $_fp
	else
		chmod a+rw $R_PATH/data/user.conf
		echo "" > $R_PATH/data/user.conf
		echo "admin@admin" >> $_fp
	fi
	return 0
}	# ----------  end of function init_user_account  ----------



add_usr_pass ()
{
	local _fp="$R_PATH/data/user.conf"
	local _usr=$1
	local _pass=$2

	if [ -z "$_usr" ] || [ -z "$_pass" ]; then
		return 1
	fi
	is_usrpass_fp_exist
	if [ $? -eq 1 ] ; then
		init_user_account
	fi
	is_usrpass_exist $_usr
	if  [ $? -eq 0 ] ; then
		return 1
	fi
	echo $_usr@$_pass >> $_fp
	if  [ $? -eq 0 ] ; then
		return 0
	else
		return 1
	fi
}	# ----------  end of function add_usr_pass  ----------

get_pass ()
{
	local _usr=$1
	if [ -z "$_usr" ] ; then
		return 1
	fi
	local _fp="$R_PATH/data/user.conf"
	is_usrpass_fp_exist
	if [ $? -eq 0 ] ; then
		local _usr_g=`awk -F '@' '{print $1}' $_fp`
		for __usr in `echo $_usr_g`; do
			if [ "$_usr" = $__usr ] ; then
				sed -n -e '/'$_usr'/p' $_fp | awk -F '@' '{print $2}'
			fi
		done
	else
		return 1
	fi
}	# ----------  end of function get_pass  ----------

del_usr_pass ()
{
	local _usr=$1
	if [ -z "$_usr" ] ; then
		return 1
	fi
	local _fp="$R_PATH/data/user.conf"
	is_usrpass_fp_exist
	if [ $? -eq 0 ] ; then
		local _usr_g=`awk -F '@' '{print $1}' $_fp`
		local _l_cnt=`echo $_usr_g | xargs -n1 | sed -n -e '/'$_usr'/='`
		echo $_l_cnt
		expr $_l_cnt + 1 1>/dev/null 2>/dev/null
		if [ $? -eq 0 ] ; then
			sed -i ''$_l_cnt'd' $_fp
			if [ $? -eq 0 ] ; then
				return 0
			else
				return 1
			fi
		else
			return 1
		fi
	else
		return 1
	fi
}	# ----------  end of function del_usr_pass  ----------

#init_user_account
#add_usr_pass tong 123
#add_usr_pass feng 456
#
#add_usr_pass feng 456
#is_usrpass_exist 
#echo $?
#get_pass feng

#is_usrpass_exist tong
#echo $?
#del_usr_pass tong
