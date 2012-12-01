#!/bin/sh
#===============================================================================
#
#          FILE: onload_man_sys.sh
# 
#         USAGE: ./onload_man_sys.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: tongl (), 
#  ORGANIZATION: 
#       CREATED: 2012年11月05日 15时00分47秒 CST
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

#read date_str
#touch_file date_str
#echo $date_str >> /tmp/date_str
##date_str="2012|04|02|23|24|00"
#if [ -z "$date_str" ] ; then
#	exit 1
#else
#	year=`echo $date_str | awk -F '|' '{print $1}'`
#	mon=`echo $date_str | awk -F '|' '{print $2}'`
#	date=`echo $date_str | awk -F '|' '{print $3}'`
#	hour=`echo $date_str | awk -F '|' '{print $4}'`
#	min=`echo $date_str | awk -F '|' '{print $5}'`
#	sec=`echo $date_str | awk -F '|' '{print $6}'`
#
#	set_time $year $mon $date $hour $min $sec
#	touch_file set_time_log                     # the last time stauts..
#	if  [ $? -eq 0  ] ; then
#		gen_success_message "set time success"
#		echo set success >> /tmp/set_time_log
#	else
#		gen_error_message "set time fail"
#		echo set error >> /tmp/set_time_log
#	fi
#fi

#always success..
gen_success_message 
