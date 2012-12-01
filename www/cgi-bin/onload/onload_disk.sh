#!/bin/sh
#===============================================================================
#
#          FILE: onload_disk.sh
# 
#         USAGE: ./onload_disk.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: tongl (), 
#  ORGANIZATION: 
#       CREATED: 2012Äê09ÔÂ18ÈÕ 11ʱ38·Ö18Ãë CST
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

verify_disk_files ()
{

	if [ -z $1 ] ; then
		local _filename="echo_disk"
	else
		local _filename=$1
	fi
	if  [ -f /tmp/$_filename ]; then
		return 0
	fi
	return 1
}	# ----------  end of function verify_disk_files  ----------


response_info ()
{
	touch_file echo_disk
	if [ $? -eq 0 ] ; then
		echo "" > /dev/null
	else
		gen_error_message "can't touch_file..."
		return 1
	fi
	verify_disk_files echo_disk
	if [ $? -eq 1 ] ; then
		gen_error_message "disk file note exist!"
		return 1                                # can't find file
	fi

	create_echo_header echo_disk xml
	gen_tag_h echo_disk load_disk_test
	gen_s_disk_info echo_disk

	if [ $? -eq  1 ] ; then
		return 1
	fi

	#create_echo_header echo_disk_r xml
	gen_r_disk_info echo_disk
	gen_tag_t echo_disk load_disk_test
	if [ $? -eq  1 ] ; then
		return 1
	fi

	return 0
}	# ----------  end of function response_info  ----------

response_info
cat /tmp/echo_disk
