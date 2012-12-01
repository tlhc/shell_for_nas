#!/bin/sh
#===============================================================================
#
#          FILE: respose_tgt_sel.sh
# 
#         USAGE: ./respose_tgt_sel.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 2012年10月12日 14时50分29秒 CST
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
. $R_PATH/create_echo/c_echo_iscsi.sh
. $R_PATH/comm/get_sys_log.sh
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

tgt_name=""
tgt_opt=""

read var 
#var="sel|tgt_name"
touch_file tgt_ss
echo $var >>/tmp/tgt_ss
if [ -z "$var" ] ; then
	exit 1
else
	tgt_opt=`echo $var | awk -F '|' '{print $1}'`
	tgt_name=`echo $var | awk -F '|' '{print $2}'`

	echo $tgt_opt >> /tmp/tgt_ss
	echo $tgt_name >> /tmp/tgt_ss

	if [ -z $tgt_opt ]  || [ -z $tgt_name ]; then
		exit 1
	else
		if [ "$tgt_opt" = "sel" ] ; then
			if [ -z "$tgt_name" ] ; then
				exit 1
			else
				# get target_select and lun and access and user
				touch_file echo_tgt_sel
				create_echo_header echo_tgt_sel xml
				gen_iscsi_target_sel echo_tgt_sel "$tgt_name"                   
				cat /tmp/echo_tgt_sel  
				exit 0
			fi fi
		if [ $tgt_opt = "new" ] ; then
			touch_file echo_new_tgt
			create_echo_header echo_new_tgt xml
			gen_iscsi_ava_lun echo_new_tgt
			cat /tmp/echo_new_tgt

#			echo new.....
		fi
#
#		if [ $tgt_opt = "add" ] ; then
#			_ip=`echo $tgt_opt | awk -F '|' '{print $2}' | awk -F 'server_ip=' '{print $2}'`
#			_tgt_name=`echo $tgt_opt | awk -F '|' '{print $3}' | awk -F 'target_name=' '{print $2}'`
#			_ava_lun_id=`echo $tgt_opt | awk -F '|' '{print $4}' | awk -F 'ava_lun_id=' '{print $2}'`
#			_use_lun_id=`echo $tgt_opt | awk -F '|' '{print $5}' | awk -F 'use_lun_id=' '{print $2}'`
#			_access_mode=`echo $tgt_opt | awk -F '|' '{print $6}' | awk -F 'accecc_mode=' '{print $2}'`
#			_chap_flag=`echo $tgt_opt | awk -F '|' '{print $7}' | awk -F 'chap_flag=' '{print $2}'`
#			_usr_pass=`echo $tgt_opt | awk -F '|' '{print $8}' | awk -F 'usr_pass=' '{print $2}'`
#
#			if [ -z "$_ip" ] || [ -z "$_tgt_name" ] || [ -z "$_ava_lun_id" ] || [ -z "$_use_lun_id" ] || [ -z "$chap_flag" ]; then
#				gen_error_message "para, error.."
#			fi
#			#add_spec_tgt_conf "192.168.1.1" "tgt_name_haha" "none" "Lun1" "wb" "1" "tong@123,feng@1234"
#			add_spec_tgt_conf "$_ip" "$_tgt_name" "$_ava_lun_id" "$_use_lun_id" "$_access_mode" "$_chap_flag" "$_usr_pass"
#		#	touch_file echo_new_tgt
#		#	create_echo_header echo_new_tgt xml
#		#	gen_iscsi_ava_lun echo_new_tgt
#		#	cat /tmp/echo_new_tgt
##		#	echo new.....
#		fi
#
	fi
	exit 1
fi

