#!/bin/sh
#===============================================================================
#
#          FILE: respose_clear_raid.sh
# 
#         USAGE: ./respose_clear_raid.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 2012年10月15日 16时31分21秒 CST
#      REVISION:  ---
#===============================================================================
get_r_path() {
	local _fp="/etc/thttpd.conf" local _prefix=""
	local _cgi_path=""
	local _wholepth=""
	local _tmpstr=""
	if [ -f $_fp ] && [ -r $_fp ]; then
	_prefix=`sed '/^$/d' $_fp | sed '/^#/d' | sed 's/^[[:space:]]*//g' | sed -n -e '/dir=/p' | awk -F '=' '{print $2}'` 
	_tmpstr=`sed '/^$/d' $_fp | sed '/^#/d' | sed 's/^[[:space:]]*//g' | sed -n -e '/cgipat/p' | awk -F '=' '{print $2}'`
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
. $R_PATH/create_echo/c_echo_disk.sh
. $R_PATH/comm/set_raid_para.sh
. $R_PATH/comm/get_raid_info.sh
. $R_PATH/comm/get_sys_log.sh
#build_raid /dev/md0 0 /dev/sda /dev/sdc



#echo $SERVER_NAME >> /tmp/var_read
#echo $SERVER_SOFTWARE >> /tmp/var_read
#echo $GATEWAY_INTERFACE >> /tmp/var_read
#echo $SERVER_PROTOCOL >> /tmp/var_read
#echo $SERVER_PORT >> /tmp/var_read
#echo $REQUEST_METHOD >> /tmp/var_read
#echo $HTTP_ACCEPT >> /tmp/var_read
#echo $HTTP_USER_AGENT >> /tmp/var_read
#echo $HTTP_REFERER >> /tmp/var_read
#echo $PATH_INFO >> /tmp/var_read
#echo $PATH_TRANSLATED >> /tmp/var_read
#echo $SCRIPT_NAME >> /tmp/var_read
#echo $QUERY_STRING >> /tmp/var_read
#echo $REMOTE_HOST >> /tmp/var_read
#echo $REMOTE_ADDR >> /tmp/var_read
#echo $REMOTE_USER >> /tmp/var_read
#echo $REMOTE_IDENT >> /tmp/var_read
#echo $CONTENT_TYPE >> /tmp/var_read
#echo $CONTENT_LENGTH >> /tmp/var_read
#



read var
touch_file dda
opt=`echo "$var" | awk -F '|' '{print $2}'`
devs=`echo "$var" | awk -F '|' '{print $3}'`
echo $opt >> /tmp/dda
echo $devs >> /tmp/dda


echo `get_raid_releate_disk $devs` >> /tmp/dda
#clear_raid "/dev/md0"
#
#devs1=`sed -n -e '2p' /tmp/dda`
#
#echo devs1::$devs1 >> /tmp/dda
#echo myself::----/dev/md0
# 
#if [ -z "$devs1" ] ; then
#	echo exit >> /tmp/dda
#	exit 1
#else
#	echo before_exec:$devs1 >> /tmp/dda
#fi
#

#if [ $devs1 = "/dev/md0" ] ; then
#	echo in..... >> /tmp/dda
#	  mdadm -S $devs1 2>> /tmp/dda
#	format_s_disk /dev/sda
#
#	if  [ $? -ne 0 ]; then
#		gen_error_message "aaa"
#	fi
#
#	format_s_disk /dev/sdc
#
#	if  [ $? -ne 0 ]; then
#		gen_error_message "bbb"
#	fi
#fi
#
#  mdadm -S /dev/md0 

#-------------------------------------------------------------------------------
#  
#-------------------------------------------------------------------------------
#clear_raid "/dev/md0"



relate_disk=""
if [ -z "$opt" ] || [ -z "$devs" ]; then
	exit 1
fi
if [ "$opt" = "D" ] ; then
	relate_disk=`get_raid_releate_disk $devs` 
	touch_file realtea
	echo $relate_disk >> /tmp/realtea
	clear_raid $devs 1>/raid_clear 2>/tmp/raid_clear
	#clear_raid $devs 1>/dev/null 2>/dev/null
	if [ $? -ne 0 ] ; then
		gen_error_message "oh....my...god..."
	else
		gen_success_message "$relate_disk"
		rec_opt raid "clear raid for $devs release_dis: $relate_disk"

	fi
elif [ "$opt" = "F" ]; then
	umount $devs 1>>/dev/null 2>>/dev/null 
	format_s_disk $devs 1>/dev/null 2>>/tmp/ferror &

	if [ $? -ne 0 ] ; then
		gen_error_message "format error.."
		rec_opt disk "ERROR:$devs format_error"
		exit 1
	else
		rec_opt disk "$devs format_success"
		gen_success_message
		exit 0
	fi
fi
exit 0

