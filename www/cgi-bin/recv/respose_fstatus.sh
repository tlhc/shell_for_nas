#!/bin/sh
#===============================================================================
#
#          FILE: respose_fstatus.sh
# 
#         USAGE: ./respose_fstatus.sh 
# 
#   DESCRIPTION: 返回状态信息...暂时由前端实现
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 2012年10月18日 10时20分04秒 CST
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
#. $R_PATH/comm/get_disk_info.sh
. $R_PATH/create_echo/c_tools.sh
. $R_PATH/create_echo/c_echo_header.sh
. $R_PATH/create_echo/c_echo_disk.sh


read var
opt=`echo "$var" | awk -F '|' '{print $2}'`
count=`echo "$var" | awk -F '|' '{print $3}'`

get_format_status ()
{
	_filepath="/tmp/build_raid_o"
	if [ -f "$_filepath" ] ; then
		cat $_filepath
	else
		return 1
	fi
}	# ----------  end of function get_format_status  ----------

if [ -z $opt ] ; then
	exit 1
else
	if [ $opt = "D" ] ; then
		if [ -f "/tmp/DD" ] ; then
			echo $count >> /tmp/DD
		else
			touch_file DD
			echo $count >> /tmp/DD
		fi
		result=`get_format_status`
		gen_message "$result"
		exit 0
	else
		gen_error_message "unknown...opt"
		exit 1
	fi
fi

rm_file DD
exit 0
