#!/bin/sh 
#===============================================================================
#
#          FILE: respose_disk.sh
# 
#         USAGE: ./respose_disk.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: tongl (), 
#  ORGANIZATION: 
#       CREATED: 2012年09月20日 17时42分49秒 CST
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

#build_raid /dev/md0 0 /dev/sda /dev/sdc
#exit 0

#echo $raid_para >> /tmp/read_test


#build_raid /dev/md0 0 /dev/sda /dev/sdc 

read var
touch_file tt
echo $var >> /tmp/tt

if [ -z "$var" ] ; then
	gen_error_message "can't get bulid_raid parameter.."
	exit 1
fi

raid_alias=`echo $var | awk -F '|' '{print $2}'`
raid_level=`echo $var | awk -F '|' '{print $3}'`
raid_devs_t=`echo $var | awk -F '|' '{print $4}'`
raid_devs=""

touch_file tp_devt
echo $raid_devs_t >> /tmp/tp_devt
trim_c_s_b "/tmp/tp_devt"
sed -i 's/,/ /g' /tmp/tp_devt
raid_devs=`cat /tmp/tp_devt`
rm_file tp_devt

echo $raid_alias >> /tmp/tt
echo $raid_level >> /tmp/tt
echo $raid_devs >> /tmp/tt

#tst=`echo $raid_devs | sed -n -e /sdc/p`
tst=""
raid_count=0
if  [ -z "$tst" ]; then
	echo 1 $raid_level >> /tmp/tt
	echo 2 $raid_devs >> /tmp/tt
#	touch_file build_raid_o
#	touch_file build_raid_i
	  umount $raid_devs 1>/dev/null 2>/dev/null
	raid_count=`get_raid_count`
	tst1=`expr $raid_count + 1`
	if [ $? -ne 0 ] ; then
		raid_count=0
	fi
	build_raid /dev/md$raid_count $raid_level $raid_devs 1>/dev/null 2>/dev/null 
	if  [ $? -eq 0 ]; then
		tsize=`gen_md_dev_T_size /dev/md$raid_count`
		md_status=`get_raid_status /dev/md$raid_count`
		gen_success_message "/dev/md$raid_count|$tsize"G"|$md_status|"
		rec_opt raid "dev: '$raid_devs' --> md_dev:/dev/md$raid_count L:$raid_level"
		exit 0
	else
		gen_error_message "can't bulid raid.."
		rec_opt raid "ERROR:dev: '$raid_devs' --> md_dev:/dev/md$raid_count L:$raid_level"
		exit 1
	fi
else
	gen_error_message "recv parameter.. empty"
	exit 1
fi
exit 0
