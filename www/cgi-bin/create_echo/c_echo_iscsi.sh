#!/bin/sh
#===============================================================================
#
#          FILE: c_echo_iscsi.sh
# 
#         USAGE: ./c_echo_iscsi.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: tongl (), 
#  ORGANIZATION: 
#       CREATED: 2012Äê09ÔÂ14ÈÕ 10ʱ57·Ö48Ãë CST
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
. $R_PATH/comm/get_target_info.sh
. $R_PATH/comm/set_target_para.sh
#iscsi_target_config
#	server_ip
#		read from logfile
#	/server_ip
#
#	target_name
#		name
#			read from ietd.conf	
#		/name
#
#		name
#			read from ietd.conf	
#		/name
#	/target_name
#	
#	curr_status
#		0
#	/curr_status
#/iscsi_target_config
#


#-------------------------------------------------------------------------------
#  in iscsi_target_config select
#-------------------------------------------------------------------------------

gen_iscsi_target_conf ()
{
	local _filename=$1
	if [ -z $_filename ] ; then
		echo "no filename!!"
		return 1
	fi
	
	gen_tag_h $_filename iscsi_target_config

	gen_tag_h $_filename server_ip              # in net config page
	gen_tag_value $_filename 192.168.1.1 
	gen_tag_t $_filename server_ip

	gen_tag_h $_filename target_name

	for _indx in `seq 2`; do                    # # read from config file
		gen_tag_h $_filename name
		gen_tag_value $_filename name_for_target
		gen_tag_t $_filename name
	done
	gen_tag_t $_filename target_name

	gen_tag_h $_filename curr_status
	gen_tag_value $_filename target_status...
	gen_tag_t $_filename curr_status

	gen_tag_t $_filename iscsi_target_config

	return 0	
}	# ----------  end of function gen_iscsi_target_conf  ----------


#iscsi_target_sel
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


#-------------------------------------------------------------------------------
#  gen_iscsi_target_sel for select iscsi
#-------------------------------------------------------------------------------
gen_iscsi_target_sel ()
{
	local _filename=$1
	local _tgt_name=$2
	if [ -z $_filename ] ; then
		echo "no filename!!"
		return 1
	fi

	if [ -z "$_tgt_name" ] ; then
		echo "no target_name"
		return 1
	fi
#	touch_file $_filename
	#get_ava_lun_id
	#get_sepc_lun_table_id $_tgt_name
	gen_tag_h $_filename iscsi_target_sel

	gen_tag_h $_filename target_relate_lun

	gen_tag_h $_filename ava_lun_id
	gen_tag_value $_filename "`get_ava_lun_id`"
	gen_tag_t $_filename ava_lun_id

	gen_tag_h $_filename use_lun_id
	gen_tag_value $_filename `get_sepc_lun_table_id $_tgt_name`
	gen_tag_t $_filename use_lun_id

	gen_tag_t $_filename target_relate_lun

	gen_tag_h $_filename chap
	#get tags and judge
	local _flag=`is_target_chap "$_tgt_name"`
	gen_tag_h $_filename flag
	gen_tag_value $_filename $_flag                  # 1 for chap
	gen_tag_t $_filename flag
	if [ $_flag -eq 1 ] ; then
		local _cnt=`get_spec_t_chap_u_cnt "$_tgt_name"`
		local _str=`contruct_usr_pass "$_tgt_name"`
		local _r_indx=1
		for _indx in `seq $_cnt`; do
			_r_indx=`expr $_r_indx + 1`
			gen_tag_h $_filename usr_pass
			gen_tag_value $_filename `echo $_str | awk -F '@' '{print $'$_r_indx'}'`
			gen_tag_t $_filename usr_pass
		done
	fi

	gen_tag_t $_filename chap

	gen_tag_h $_filename access_mode
	gen_tag_value $_filename `get_access_mode "$_tgt_name"`
	gen_tag_t $_filename access_mode

	gen_tag_t $_filename iscsi_target_sel

	return 0
}	# ----------  end of function gen_iscsi_target_edit  ----------


#gen_iscsi_target_sel tsel "iqn.ispd.vme.cn:mars"

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

#-------------------------------------------------------------------------------
#  gen info for iscsi_target_table when request
#-------------------------------------------------------------------------------
gen_iscsi_table ()
{
	local _filename=$1
	if [ -z $_filename ] ; then
		echo "no filename!!"
		return 1
	fi
	#-------------------------------------------------------------------------------
	#get_target_brief > /dev/null
	#get_target_count > /dev/null
	#name=`get_target_name`
	#name1=`echo $name | awk '{print $2}'`
	#get_target_alias > /dev/null
	#
	##get_target_name 
	#tgt=`get_target_luns`
	#echo $tgt | awk -F '|' '{print $1}'
	#echo $tgt | awk -F '|' '{print $2}'


	get_target_brief
	local _tgt_count=0
	local _tgt_name_g=""
	local _tgt_lun_g=""

	_tgt_count=`get_target_count`
	_tgt_name_g="`get_target_name`"
	_tgt_lun_g="`get_target_luns`"
	local _name=""
	local _lun=""

	#echo $_tgt_name_g
	#echo $_tgt_count
	#echo $_tgt_lun_g
	gen_tag_h $_filename iscsi_target_table

	local _ip=`get_target_ip`
	gen_tag_h $_filename server_ip
	gen_tag_value $_filename "$_ip"
	gen_tag_t $_filename server_ip

	local _serv_s=`is_ietd_run`
	gen_tag_h $_filename service_status
	gen_tag_value $_filename $_serv_s
	gen_tag_t $_filename service_status

	for _indx in `seq $_tgt_count`; do
		gen_tag_h $_filename table_row

		unset _name
		_name=`echo $_tgt_name_g | awk '{print $'$_indx'}'`
		gen_tag_h $_filename target_name
		gen_tag_value $_filename "$_name" 
		gen_tag_t $_filename target_name
		unset _lun
#		_lun=`echo $_tgt_lun_g | awk -F '|' '{print $'$_indx'}'`
#		echo $_lun
		_lun=`get_sepc_lun_table_id "$_name"`
#		_lun='"'$_lun'"'

		#echo $_lun
		gen_tag_h $_filename use_lun_id
		gen_tag_value $_filename $_lun
		gen_tag_t $_filename use_lun_id

		gen_tag_h $_filename access_mode
		gen_tag_value $_filename `get_access_mode "$_name"`
		gen_tag_t $_filename access_mode

		gen_tag_h $_filename chap_flag
		gen_tag_value $_filename `is_target_chap "$_name"`
		gen_tag_t $_filename chap_flag

		gen_tag_h $_filename curr_status
		gen_tag_value $_filename 0
		gen_tag_t $_filename curr_status

		gen_tag_t $_filename table_row
	done
#	gen_tag_value $_filename target1:target2
#	gen_tag_value $_filename 1,3,4:2,5,6
#	gen_tag_value $_filename 0:1
#	gen_tag_value $_filename 0:1
#	gen_tag_value $_filename 0:1
	gen_tag_t $_filename iscsi_target_table
	return 0
	
}	# ----------  end of function gen_for_iscsi_table  ----------




#-------------------------------------------------------------------------------
#  for target_sel
#-------------------------------------------------------------------------------
gen_iscsi_ava_lun ()
{
	local _filename=$1
	gen_tag_h $_filename ava_lun_id
	gen_tag_value $_filename "`get_ava_lun_id`"
	gen_tag_t $_filename ava_lun_id
	return 0
}	# ----------  end of function gen_iscsi_ava_lun  ----------

#-------------------------------------------------------------------------------
#  for test...
#-------------------------------------------------------------------------------
#touch_file iscsi_table
#gen_iscsi_table iscsi_table
#cat /tmp/iscsi_table
#gen_iscsi_target_sel echo_tgt_sel "iqn.ispd.vme.cn:mars1111"
#cat /tmp/echo_tgt_sel
