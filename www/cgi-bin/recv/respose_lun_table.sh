#!/bin/sh
#===============================================================================
#
#          FILE: respose_lun.sh
# 
#         USAGE: ./respose_lun.sh 
# 
#   DESCRIPTION: recive info from client
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: tongl (), 
#  ORGANIZATION: 
#       CREATED: 2012年09月20日 17时20分37秒 CST
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
. $R_PATH/comm/set_raid_para.sh
. $R_PATH/comm/set_lun_para.sh
. $R_PATH/comm/get_sys_log.sh
read var

touch_file lun_rec                              # for tst

echo $var >> /tmp/lun_rec

if [ -z "$var" ] ; then
	exit 1
fi

_rows=0
#_segment=0
_lines_var=0

#_lun_id=""
#_lun_alias=""
#_lun_size=""
#_bl_target=""
#_vol=""
#-------------------------------------------------------------------------------
#  for test...
#-------------------------------------------------------------------------------
#|Lun0|alias=aaa|bl_target=none|vol=/dev/sda|lun_size=250G|lun_rmd_size=100G|"Lun 0 Path=/dev/md0,Type=fileio,"
#|Lun0|cccc|Target:none/LUN:/dev/sdc|1000.2GB|
#var="10&var&va1&aaaa&aaab"
_rows=`echo $var | awk -F '&' '{print $1}'`

expr "$_rows + 1" 1>/dev/null 2>/dev/null

if  [ $? -ne 0 ]; then
	return 1
fi

if [ -f "$R_PATH/data/lun_table.conf" ] ; then
	echo "" >/dev/null
else
	echo file not exist >> /tmp/lun_rec
	create_lun_table
fi

echo row$_rows >> /tmp/lun_rec


if [ "$_rows" = "0" ] ; then
	rm -f $R_PATH/data/lun_table.conf
	touch $R_PATH/data/lun_table.conf
	chmod a+rw $R_PATH/data/lun_table.conf
	rec_opt lun "clear lun table"
else
	rm -f $R_PATH/data/lun_table.conf
	touch $R_PATH/data/lun_table.conf
	chmod a+rw $R_PATH/data/lun_table.conf
	for _cnt in `seq $_rows`; do
		_segment=`expr $_cnt + 1`
		_lines_var=`echo $var | awk -F '&' '{print $'$_segment'}' # lines`

		echo segment$_segment >> /tmp/lun_rec              # for tst
		echo line_var$_lines_var >> /tmp/lun_rec            # for tst
		#	create_lun_table
		add_value_to_lunT "$_lines_var"

		if [ $? -ne 0 ] ; then
			rec_opt lun "ERROR:add $_lines_var to lun table"
			exit 1
		else
			gen_success_message
			rec_opt lun "add $_lines_var to lun table"
		fi

		#	unset _segment
		#	unset _lines_var
		#	unset _lun_id
		#	unset _lun_alias
		#	unset _lun_size
		#	unset _bl_target
		#	unset _vol

		#	if [ -z "$_lines_var" ] ; then
		#		return 1
		#	fi
		#	_lun_id=`echo $_lines_var | awk -F '|' '{print $2}'`
		#	_lun_alias=`echo  $_lines_var | awk -F '|' '{print $3}'`
		#	_bl_target=`echo $_lines_var | awk -F '|' '{print $4}'`
		#	_vol=`echo $_lines_var | awk -F '|' '{print $5}'`
		#	_lun_size=`echo $_lines_var | awk -F '|' '{print $6}'`
	done
fi
exit 0
