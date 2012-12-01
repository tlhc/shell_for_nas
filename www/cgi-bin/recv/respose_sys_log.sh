#!/bin/sh
#===============================================================================
#
#          FILE: respose_sys_log.sh
# 
#         USAGE: ./respose_sys_log.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 2012年11月05日 10时30分52秒 CST
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
#. $R_PATH/comm/get_disk_info.sh
. $R_PATH/create_echo/c_tools.sh
. $R_PATH/create_echo/c_echo_header.sh
. $R_PATH/create_echo/c_echo_disk.sh
. $R_PATH/comm/set_raid_para.sh
. $R_PATH/comm/get_sys_log.sh

read var
echo $var >> /tmp/logtmp

case $var in
	log)
		touch_file sys_log_
		create_echo_header sys_log_ xml
		gen_tag_h sys_log_ sys_log
		get_sys_log >> /tmp/sys_log_
		gen_tag_t sys_log_ sys_log
		cat /tmp/sys_log_
		rm_file sys_log_
		;;
	info)
		get_sys_info
		touch_file sys_info
		create_echo_header sys_info xml
		gen_tag_h sys_info sys_info
		sed -i 's/: 0/: 1/g' /tmp/info_tmp
		cat /tmp/info_tmp >> /tmp/sys_info
		gen_tag_t sys_info sys_info
		cat /tmp/sys_info
		cp /tmp/sys_info /tmp/sys_info_bk
		rm_file sys_info
		rm_file info_tmp
		;;
	*)
		;;
esac    # --- end of case ---
