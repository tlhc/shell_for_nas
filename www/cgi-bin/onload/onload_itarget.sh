#!/bin/sh
#===============================================================================
#
#          FILE: onload_itarget.sh
# 
#         USAGE: ./onload_itarget.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: tongl (), 
#  ORGANIZATION: 
#       CREATED: 2012Äê09ÔÂ18ÈÕ 11ʱ41·Ö22Ãë CST
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
. $R_PATH/create_echo/c_echo_header.sh
. $R_PATH/create_echo/c_echo_disk.sh
. $R_PATH/create_echo/c_echo_iscsi.sh
#. $R_PATH/comm/get_target_info.sh

verify_disk_files ()
{
	return 1
}	# ----------  end of function verify_disk_files  ----------


#//for the target_select echo return
#<iscsi_target_sel>
#	//for echo return
#	<target_relate_lun>
#		<ava_lun_id>
#			id...
#		</ava_lun_id>
#
#		<use_lun_id>
#			1,2,3	
#		</use_lun_id>
#	</target_relate_lun>
#
#	//for echo return
#	<chap>
#		<flag>
#			1
#		</flag>
#
#		<usr_pass>
#			joe|123456
#		</usr_pass>
#
#		<usr_pass>
#			joe|123456
#		</usr_pass>
#	</chap>
#
#
#	<accecc_mode>
#		type....
#	</accecc_mode>
#</iscsi_target_sel>
#


#
#<iscsi_target_table>
#	<target_name>
#		target1:target2
#	</target_name>
#
#	<use_lun_id>
#		1,2,3:4,5,6
#	</use_lun_id>
#	
#	<access_mode>
#		0:1
#	</access_mode>
#
#	<chap_flag>
#		0:1
#	</chap_flag>
#
#	<curr_status>
#		0:1
#	</curr_status>
#
#
#</iscsi_target_table>
#
response_info ()
{
	local _fp=$1
	local _tmp_fp="/tmp/iscsi_table.tmp"
	if [ -z $_fp ] ; then
		_fp="$R_PATH/data/iscsi_table.conf"
	else
		_fp="$R_PATH/data/$1"
	fi

	touch_file echo_iscsi_table
	create_echo_header echo_iscsi_table xml
	gen_iscsi_table echo_iscsi_table
	return 0
}	# ----------  end of function response_info  ----------

response_info
cat /tmp/echo_iscsi_table

