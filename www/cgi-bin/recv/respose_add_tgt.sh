#!/bin/sh
#===============================================================================
#
#          FILE: respose_add_tgt.sh
# 
#         USAGE: ./respose_add_tgt.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 2012年10月29日 15时01分39秒 CST
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
#response_info ()
#{
#	local _fp=$1
#	local _tmp_fp="/tmp/iscsi_table.tmp"
#	if [ -z $_fp ] ; then
#		_fp="$R_PATH/data/iscsi_table.conf"
#	else
#		_fp="$R_PATH/data/$1"
#	fi
#
#	touch_file echo_iscsi_table
#	create_echo_header echo_iscsi_table xml
#	gen_iscsi_table echo_iscsi_table
#	return 0
#}	# ----------  end of function response_info  ----------
#
#
read var

touch_file add_tgt
echo $var >> /tmp/add_tgt

_ip=`echo $var | awk -F '|' '{print $2}' | awk -F 'server_ip=' '{print $2}'`
_tgt_name=`echo $var | awk -F '|' '{print $3}' | awk -F 'target_name=' '{print $2}'`
_ava_lun_id=`echo $var | awk -F '|' '{print $4}' | awk -F 'ava_lun_id=' '{print $2}'`
_use_lun_id=`echo $var | awk -F '|' '{print $5}' | awk -F 'use_lun_id=' '{print $2}'`
_access_mode=`echo $var | awk -F '|' '{print $6}' | awk -F 'accecc_mode=' '{print $2}'`
_chap_flag=`echo $var | awk -F '|' '{print $7}' | awk -F 'chap_flag=' '{print $2}'`
_usr_pass=`echo $var | awk -F '|' '{print $8}' | awk -F 'usr_pass=' '{print $2}'`

echo $_ip >> /tmp/add_tgt
echo $_tgt_name  >> /tmp/add_tgt
echo $_ava_lun_id >> /tmp/add_tgt
echo $_use_lun_id >> /tmp/add_tgt
echo $_access_mode >> /tmp/add_tgt
echo $_chap_flag >> /tmp/add_tgt
echo $_usr_pass >> /tmp/add_tgt

_ip=`echo $_ip | sed 's/"/\ /g' | sed 's/^[[:space:]]*//g'`

_tgt_name=`echo $_tgt_name | sed 's/"/\ /g' | sed 's/^[[:space:]]*//g'`
_ava_lun_id=`echo $_ava_lun_id | sed 's/"/\ /g' | sed 's/^[[:space:]]*//g'`
_use_lun_id=`echo $_use_lun_id | sed 's/"/\ /g' | sed 's/^[[:space:]]*//g'`
_access_mode=`echo $_access_mode | sed 's/"/\ /g' | sed 's/^[[:space:]]*//g'`
_chap_flag=`echo $_chap_flag | sed 's/"/\ /g' | sed 's/^[[:space:]]*//g'`
_usr_pass=`echo $_usr_pass | sed 's/"/\ /g' | sed 's/^[[:space:]]*//g'`


if [ -z "$_ip" ] || [ -z "$_tgt_name" ] || [ -z "$_ava_lun_id" ] || [ -z "$_use_lun_id" ] || [ -z "$_chap_flag" ]; then
	gen_error_message "para, error.."
fi
#add_spec_tgt_conf "192.168.1.1" "tgt_name_haha" "none" "Lun1" "wb" "1" "tong@123,feng@1234"
echo $_ip >> /tmp/speca
add_spec_tgt_conf "$_ip" $_tgt_name $_ava_lun_id $_use_lun_id $_access_mode $_chap_flag $_usr_pass
if [ $? -eq 0 ] ; then
	gen_success_message "add success."
	rec_opt target "add target $_tgt_name"
	cp /etc/iet/ietd.conf /mnt/jffs2/iscsi/ietd.conf
else
	gen_error_message "add fail."
	rec_opt target "ERROR:add target $_tgt_name"
fi

#	touch_file echo_new_tgt
#	create_echo_header echo_new_tgt xml
#	gen_iscsi_ava_lun echo_new_tgt
#	cat /tmp/echo_new_tgt
#		#	echo new.....

