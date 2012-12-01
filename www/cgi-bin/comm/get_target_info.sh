#!/bin/sh
#===============================================================================
#
#          FILE: get_target_info.sh
# 
#         USAGE: ./get_target_info.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: tongl (), 
#  ORGANIZATION: 
#       CREATED: 2012Äê09ÔÂ18ÈÕ 12ʱ07·Ö38Ãë CST
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


R_PATH=`get_r_path`
. $R_PATH/comm/tools.sh
. $R_PATH/create_echo/c_tools.sh

create_array="$R_PATH/array_emu/create_array.sh"
del_array="$R_PATH/array_emu/del_array.sh"
push_elements="$R_PATH/array_emu/push_elements.sh"
pop_elements="$R_PATH/array_emu/pop_elements.sh"
getlen="$R_PATH/array_emu/getlen.sh"
get_elements="$R_PATH/array_emu/get_elements.sh"
rm_elements="$R_PATH/array_emu/remove_elements.sh"
get_array="$R_PATH/array_emu/get_array.sh"



#-------------------------------------------------------------------------------
#  get target_info brief
#-------------------------------------------------------------------------------
get_target_brief ()
{
	local _target_info=$1

	if [ -z $_target_info ] ; then
		_target_info=target_info
	fi

	local _filepn="/etc/iet/ietd.conf"
	if [ -f $_filepn ] ; then
		#delete # space
		touch_file $_target_info
		  sed '/^$/d' $_filepn | sed 's/^[[:space:]]*//g' | sed '/^#/d' >> /tmp/$_target_info 
		return 0
	else
		echo "can't get target config!!"
		return 1
	fi

}	# ----------  end of function get_target_info  ----------
#get_target_brief 

#-------------------------------------------------------------------------------
# get target count for use  
#-------------------------------------------------------------------------------
get_target_count ()
{
	local _filename=$1
	local _count=0	
	local _fp=""
	if [ -z $_filename  ] ; then
		_filename="target_info"
	fi
	_fp="/tmp/$_filename"
	_count=`sed -n -e '/^Target/p' $_fp | wc -l | sed 's/^[[:space:]]*//g'`
	echo $_count
#	return $_count
}	# ----------  end of function get_target_count  ----------

#-------------------------------------------------------------------------------
# fisrt get target_count then use this function to get name 
#-------------------------------------------------------------------------------
get_target_name ()
{
	local _filename=$1
	local _fp=""
	if [ -z $_filename  ] ; then
		_filename="target_info"
	fi
	_fp="/tmp/$_filename"
	sed -n -e '/^Target/p' $_fp | awk '{print $2}' 
#	return $_count
}	# ----------  end of function get_target_name  ----------

#-------------------------------------------------------------------------------
#  get_target_alias from brief info
#-------------------------------------------------------------------------------
get_target_alias()
{
#	local _target_name=$1
#	local _target_alias=$2
	get_target_brief 2>/dev/null
	local _filename=$1
	local _fp=""
	if [ -z $_filename  ] ; then
		_filename="target_info"
	fi
	_fp="/tmp/$_filename"
	sed -n -e '/^Alias/p' $_fp | awk '{print $2}' 
#
}




#-------------------------------------------------------------------------------
#  get target_ for spec target....
#-------------------------------------------------------------------------------
get_spec_target_alias ()
{
	get_target_brief 1>/dev/null 2>/dev/null
	if [ $? -ne 0 ] ; then
		return 1
	fi
	local _tgt_name=$1
	local _tgt_name_g=""
	local _tgt_indx=0
	local _alias=""
	if  [ -z "$_tgt_name" ]; then
		return 1
	else
		unset _tgt_name_g
		_tgt_name_g="`get_target_name`"

		#echo $_tgt_name_g
		#echo $_tgt_name

		for _name in `echo $_tgt_name_g`; do
			_tgt_indx=`expr $_tgt_indx + 1`
			if [ "$_tgt_name" = $_name ] ; then
				break
#				echo $_tgt_indx
			fi
		done
		unset _alias
		_alias=`get_target_alias`
		local _info=`echo $_alias | sed '/^$/d' | sed 's/^[[:space:]]*//g' | awk '{print $'$_tgt_indx'}'`
		echo $_info 
		return 0
	fi
}	# ----------  end of function get_spec_target_alias  ----------


get_target_luns ()
{
	local _res_str=""
	local _filename="target_info"
	local _count=0	
	local _fp=""
	_fp="/tmp/$_filename"

	if  [ -f $_fp ]; then
		local _cnt=`get_target_count`
		local _tst=`expr $_cnt + 1`
		if [ $? -ne 0 ] ; then
			gen_error_message "can't get target_cnt..."
			return 1
		fi
		local _t_name_g="`get_target_name`"
		local _t_name=""
		local _next_t_name=""
		local _d_name_c=0
		local _d_next_name_c=0

		local _ln_cnt_b=0
		local _ln_cnt_e=0
		for _indx in `seq $_cnt`; do
			unset _t_name
			_t_name=`echo $_t_name_g | awk '{print $'$_indx'}'`
			if [ -z $_t_name ] ; then
				gen_error_message "can't get target_name"
				return 1
			fi
			
			unset _next_t_name
			unset _d_name_c
			unset _d_next_name_c

			unset _ln_cnt_b
			unset _ln_cnt_e
			if [ $_indx -ge $_cnt ] ; then
				_next_t_name=`echo $_t_name_g | awk '{print $'$_indx'}'`
				_ln_cnt_e=`sed -n -e '/'$_next_t_name'$/=' $_fp`
				_lastl=`cat $_fp | wc -l | sed 's/^[[:space:]]*//g'`
				if [ $_cnt -le 1 ] ; then
					_res_str=`sed -n -e ''$_ln_cnt_e','$_lastl'p' $_fp  | sed -n -e '/^Lun/p'`
				else
					_res_str=$_res_str'|'`sed -n -e ''$_ln_cnt_e','$_lastl'p' $_fp  | sed -n -e '/^Lun/p'`  
				fi
			else
				_d_next_name_c=`expr $_indx + 1`
#				echo $_d_next_name_c aac_name
				_next_t_name=`echo $_t_name_g | awk '{print $'$_d_next_name_c'}'`
#				echo $_next_t_name aaname
				_ln_cnt_b=`sed -n -e '/'$_t_name'$/=' $_fp`
				_ln_cnt_e=`sed -n -e '/'$_next_t_name'$/=' $_fp`
#				echo $_ln_cnt_b aab
#				echo $_ln_cnt_e aae
				if [ -z $_res_str ] ; then
					_res_str=`sed -n -e ''$_ln_cnt_b','$_ln_cnt_e'p' $_fp  | sed -n -e '/^Lun/p'`
				else
					_res_str=$_res_str'|'`sed -n -e ''$_ln_cnt_b','$_ln_cnt_e'p' $_fp  | sed -n -e '/^Lun/p'`
				fi
			fi
#			echo $_ln_cnt_b b
#			echo $_ln_cnt_e e
#			echo $_lastl la
#			echo $_next_t_name
		done
		echo $_res_str #| sed 's/||*/|/g'
	fi

}	# ----------  end of function get_target_luns  ----------


#-------------------------------------------------------------------------------
#  if "" rb
#-------------------------------------------------------------------------------
get_access_mode ()
{
	get_target_brief 1>/dev/null 2>/dev/null
	if [ $? -ne 0 ] ; then
		return 1
	fi
	local _tgt_name=$1
	local _tgt_name_g=""
	local _tgt_indx=0
	local _luns=""
	if  [ -z "$_tgt_name" ]; then
		return 1
	else
		unset _tgt_name_g
		_tgt_name_g="`get_target_name`"
		for _name in `echo $_tgt_name_g`; do
			_tgt_indx=`expr $_tgt_indx + 1`
			if [ "$_tgt_name" = $_name ] ; then
				break
#				echo $_tgt_indx
			fi
		done
		unset _luns
		_luns=`get_target_luns`
		local _info=""
		_info=`echo $_luns | awk -F '|' '{print $'$_tgt_indx'}'`
		echo $_info | sed '/^$/d'| sed 's/^[[:space:]]*//g' | sed 's/Lun/\n/g' | awk -F 'IOMode=' '{print $2}' | sed '/^$/d'
	fi
}	# ----------  end of function get_access_mode  ----------


#get_access_mode "iqn.ispd.vme.cn:mars"

#if [ -z "`get_access_mode "iqn.ispd.vme.cn:mars"`" ] ; then
#	echo aaa
#fi

#-------------------------------------------------------------------------------
#  get all target chap
#-------------------------------------------------------------------------------

get_target_chap ()
{
	local _res_str=""
	local _filename="target_info"
	local _count=0	
	local _fp=""
	_fp="/tmp/$_filename"

	if  [ -f $_fp ]; then
		local _cnt=`get_target_count`
		local _tst=`expr $_cnt + 1`
		if [ $? -ne 0 ] ; then
			gen_error_message "can't get target_cnt..."
			return 1
		fi
		local _t_name_g="`get_target_name`"
		local _t_name=""
		local _next_t_name=""
		local _d_name_c=0
		local _d_next_name_c=0

		local _ln_cnt_b=0
		local _ln_cnt_e=0
		for _indx in `seq $_cnt`; do
			unset _t_name
			_t_name=`echo $_t_name_g | awk '{print $'$_indx'}'`
			if [ -z $_t_name ] ; then
				gen_error_message "can't get target_name"
				return 1
			fi
			
			unset _next_t_name
			unset _d_name_c
			unset _d_next_name_c

			unset _ln_cnt_b
			unset _ln_cnt_e

			if [ $_indx -ge $_cnt ] ; then
				_next_t_name=`echo $_t_name_g | awk '{print $'$_indx'}'`
				_ln_cnt_e=`sed -n -e '/'$_next_t_name'$/=' $_fp`
				_lastl=`cat $_fp | wc -l | sed 's/^[[:space:]]*//g'`
				if [ $_cnt -le 1 ] ; then
					_res_str=`sed -n -e ''$_ln_cnt_e','$_lastl'p' $_fp  | sed -n -e '/^IncomingUser/p'` 
				else
					_res_str=$_res_str'|'`sed -n -e ''$_ln_cnt_e','$_lastl'p' $_fp  | sed -n -e '/^IncomingUser/p'` 
				fi
			else
				_d_next_name_c=`expr $_indx + 1`
				_next_t_name=`echo $_t_name_g | awk '{print $'$_d_next_name_c'}'`
				_ln_cnt_b=`sed -n -e '/'$_t_name'$/=' $_fp`
				_ln_cnt_e=`sed -n -e '/'$_next_t_name'$/=' $_fp`

				if [ -z $_res_str ] ; then
					_res_str=`sed -n -e ''$_ln_cnt_b','$_ln_cnt_e'p' $_fp  | sed -n -e '/^IncomingUser/p'`
				else
					_res_str=$_res_str'|'`sed -n -e ''$_ln_cnt_b','$_ln_cnt_e'p' $_fp  | sed -n -e '/^IncomingUser/p'`
				fi
			fi
#			echo $_indx
#			echo $_t_name
		done
		echo $_res_str
		#if [ "$_res_str" = "|" ] ; then
		#	echo ""
		#else

		#fi
	fi

}	# ----------  end of function get_target_chap  ----------



#-------------------------------------------------------------------------------
#  get_spec_target_chap $1=target_name
#-------------------------------------------------------------------------------
get_spec_target_chap ()
{
	get_target_brief 1>/dev/null 2>/dev/null
	if [ $? -ne 0 ] ; then
		return 1
	fi
	local _tgt_name=$1
	local _tgt_name_g=""
	local _tgt_indx=0
	local _chap=""
	if  [ -z "$_tgt_name" ]; then
		return 1
	else
		unset _tgt_name_g
		_tgt_name_g="`get_target_name`"

		#echo $_tgt_name_g
		#echo $_tgt_name

		for _name in `echo $_tgt_name_g`; do
			_tgt_indx=`expr $_tgt_indx + 1`
			if [ "$_tgt_name" = $_name ] ; then
				break
#				echo $_tgt_indx
			fi
		done
		unset _chap
		_chap=`get_target_chap`
		local _info=`echo $_chap | sed '/^$/d' | awk -F '|' '{print $'$_tgt_indx'}'`
		echo $_info 
		return 0
	fi
}	# ----------  end of function get_spec_target_chap  ----------




contruct_usr_pass ()
{
	local _tgt_name=$1
	if [ -z $_tgt_name ] ; then
		return 1 
	fi
	local _res=`get_spec_target_chap "$_tgt_name"`
	#		echo $_str | sed '/^$/d' |sed 's/IncomingUser/\n/g' | sed 's/^[[:space:]]*//g' | sed 's/\ /|/g'
	 #| wc -l | sed 's/^[[:space:]]*//g'
	 #| wc -l | sed 's/^[[:space:]]*//g'
	local _cnt=`get_spec_t_chap_u_cnt "$_tgt_name"`
	local _name=""
	local _pass=""
	local _rv=""
	unset _rv
	for _indx in `seq $_cnt`; do
		unset _name
		unset _pass
		_name=`echo $_res | sed 's/IncomingUser/\n/g' | sed 's/^[[:space:]]*//g' | sed 's/\ /|/g' | awk -F '|' '{print $1}' | sed '/^$/d' | sed -n -e ''$_indx'p'`
		_pass=`echo $_res | sed 's/IncomingUser/\n/g' | sed 's/^[[:space:]]*//g' | sed 's/\ /|/g' | awk -F '|' '{print $2}' | sed '/^$/d' | sed -n -e ''$_indx'p'`
		_rv=$_rv@"$_name|$_pass" 
	done
	echo $_rv
}	# ----------  end of function contruct_usr_pass  ----------


#-------------------------------------------------------------------------------
#  $1=target_name
#-------------------------------------------------------------------------------
get_spec_t_chap_u_cnt ()
{
	if [ -z "$1" ] ; then
		return 1
	fi
	local _tgt_name=$1
	local _res=`get_spec_target_chap "$_tgt_name"`
	echo $_res | sed 's/IncomingUser/\n/g' | sed '/^$/d' | wc -l | sed 's/^[[:space:]]*//g'
}	# ----------  end of function get_spec_t_chap_u_cnt  ----------

is_target_chap ()
{
	get_target_brief 1>/dev/null 2>/dev/null
	local _res=`get_spec_target_chap "$1"`

	if [ -z "$_res" ] ; then
		echo 0
	else
		echo 1
	fi
	return 0
}	# ----------  end of function is_target_chap  ----------

#-------------------------------------------------------------------------------
#  for spec target...
#-------------------------------------------------------------------------------
get_spec_lun_no ()
{
	get_target_brief 1>/dev/null 2>/dev/null
	if [ $? -ne 0 ] ; then
		return 1
	fi
	local _tgt_name=$1
	local _tgt_name_g=""
	local _tgt_indx=0
	local _luns=""
	if  [ -z "$_tgt_name" ]; then
		return 1
	else
		unset _tgt_name_g
		_tgt_name_g="`get_target_name`"
		
		#echo $_tgt_name_g
		#echo $_tgt_name
		for _name in `echo $_tgt_name_g`; do
			_tgt_indx=`expr $_tgt_indx + 1`
			if [ "$_tgt_name" = $_name ] ; then
				break
			fi
		done
		unset _luns
		_luns=`get_target_luns`
		local _info=`echo $_luns | awk -F '|' '{print $'$_tgt_indx'}'`
		#echo $_luns
		#echo $_tgt_indx
#		local _info=`echo $_luns | awk -F '|' '{print $1}'`
		echo $_info | sed 's/\ /\n/g' | sed -n -e '/Path=/p' | awk -F 'Path=' '{print $2}' | awk -F ',' '{print $1}'
		return 0
	fi
}	# ----------  end of function get_spec_lun_no  ----------

#get_spec_lun_no "iqn.ispd.vme.cn:mars"

get_sepc_lun_table_id ()
{
	local _tgt_name=$1
	local _luns=""
	local _counts=0
	_luns=`get_spec_lun_no "$_tgt_name"`
	_counts=`get_spec_lun_no "$_tgt_name" | wc -l | sed 's/^[[:space:]]*//g'`
	if [ $? -ne 0 ] ; then
		return 1
	fi
	#echo $_luns
	#echo $_counts
	local _tmpstr=""
	local _escape_dev=""
	local _res_str=""

	if [ -z "$_luns" ] ; then
		return 1
	fi
	local _fp=""
	_fp="$R_PATH/data/lun_table.conf"
	if [ -f "$_fp" ] ; then
		touch_file lun_table.tmp
		sed '/^$/d' $_fp | sed '/^#/d' | sed 's/^[[:space:]]*//g' >> /tmp/lun_table.tmp
		for _indx in `seq $_counts`; do
			unset _tmpstr
			unset _escape_dev
			_tmpstr=`echo $_luns | awk '{print $'$_indx'}'`
			_escape_dev=`gen_escape_dev "$_tmpstr"`
			_res_str=$_res_str`sed -n -e '/'$_escape_dev'/p' "/tmp/lun_table.tmp" | awk -F '|' '{print $1}'`
		done
		echo $_res_str
	fi
}	# ----------  end of function get_sepc_lun_table_id  ----------

#get_sepc_lun_table_id "iqn.ispd.vme.cn:mars"

get_ava_lun_id ()
{
	get_target_brief
	touch_file in_use_lun
	local _tgt_breif="/tmp/target_info"
	local _escape_dev=""
	local _res_str=""
	sed '/^$/d' $_tgt_breif | sed '/^#/d' | sed 's/^[[:space:]]*//g' \
		| sed -n -e '/^Lun/p' | awk -F 'Path=' '{print $2}' | awk -F ',' '{print $1}'>> /tmp/in_use_lun

	touch_file ava_lun
	touch_file tgt_sw
	local _fp=""
	_fp="$R_PATH/data/lun_table.conf"
	sed '/^$/d' $_fp | sed '/^#/d' | sed 's/^[[:space:]]*//g' >> /tmp/tgt_sw
	for _dev in `cat /tmp/in_use_lun`; do
		unset _escape_dev
		_escape_dev=`gen_escape_dev $_dev`
		sed -i '/'$_escape_dev'/d' /tmp/tgt_sw
	done
	_res_str=$_res_str`cat /tmp/tgt_sw | awk -F '|' '{print $1}'`
	echo $_res_str #| sed  -n -e 's/\ /|/g'
	rm_file tgt_sw
	rm_file in_use_lun
	rm_file ava_lun
}	# ----------  end of function get_ava_lun_id  ----------

#get_ava_lun_id



get_target_ip ()
{
	get_target_brief 1>/dev/null 2>/dev/null
	if [ -f "/tmp/target_info" ] ; then
		sed -n -e '/iSNSServer/p' /tmp/target_info | awk '{print $2}'
	fi
}	# ----------  end of function get_target_ip  ----------


del_spec_tgt_conf ()
{
	local _tgt_name=$1
	if [ -z "$_tgt_name" ] ; then
		return 1
	else
		#find begin end lines.
		get_target_brief 1>/dev/null 2>/dev/null
		local _tgt_name_g=`get_target_name`
		local _tgt_count_g=""
		local _del_count_b=`sed -n -e '/'$_tgt_name'$/=' /tmp/target_info`
		local _del_count_e=""
		for _indx in `echo $_tgt_name_g`; do
			_tgt_count_g=$_tgt_count_g" "`sed -n -e '/'$_indx'$/=' /tmp/target_info`
		done

		local _flag=0
		for _indx_c in `echo $_tgt_count_g`; do

			if [ $_flag -eq 1 ] ; then
				_del_count_e=`expr $_indx_c - 1`
				break
			fi
			if [ $_indx_c -eq $_del_count_b ] ; then
				_flag=1
			fi
		done

		#echo $_del_count_b
		#echo $_del_count_e
		#echo $_tgt_count_g

		if [ "$_del_count_e" = ""  ] ; then
			_del_count_e=`cat /tmp/target_info | wc -l | sed 's/^[[:space:]]*//g'`
		fi
		sed -i ''$_del_count_b','$_del_count_e'd' /tmp/target_info 1>/dev/null 2>/dev/null
		if [ $? -ne 0 ] ; then
			return 1
		fi
	fi
	#cp etc to jffs2 and etc
	cp /tmp/target_info /$R_PATH/data/ietd.conf 
	cp /tmp/target_info /mnt/jffs2/iscsi/ietd.conf
	cp /tmp/target_info /etc/iet/ietd.conf

	chmod a+rw /$R_PATH/data/ietd.conf
	chmod a+rw /mnt/jffs2/iscsi/ietd.conf
	chmod a+rw /etc/iet/ietd.conf

	update_bl_target_del $_tgt_name
	return 0
}	# ----------  end of function del_spec_tgt_conf  ----------


#get_avalun_ref_dev "Lun0"
modify_spec_tgt_conf ()
{
	return 0
}	# ----------  end of function modify_spec_tgt_conf  ----------

gen_conf_tgt_name ()
{
	echo "Target $1" >> /etc/iet/ietd.conf
	return 0
}	# ----------  end of function gen_conf_tgt_name  ----------




#-------------------------------------------------------------------------------
#  modify_target_ip_for 2
#-------------------------------------------------------------------------------
gen_conf_tgt_ip ()
{
	local _fp="/etc/iet/ietd.conf"
	local new_ip=$1
	local new_ip2=$2
	chmod a+rw $_fp
	get_target_brief 1>/dev/null 2>/dev/null
#	local _r_ip=`sed -n -e '/iSNSServer/p' /tmp/target_info | awk -F 'iSNSServer' '{print $2}'`
#	local _ip=`echo $_r_ip | sed 's/^[[:space:]]*//g'`
#	sed -i 's/iSNSServer\ '$_ip'/iSNSServer\ '$new_ip'/' /tmp/target_info
#	if  [ ! -z "$new_ip2" ]; then
#		sed -i '/iSNSServer '$new_ip'/a\iSNSServer '$new_ip2'' /tmp/target_info
#	fi
#
	sed -i '/iSNSServer/d' /tmp/target_info 1>/dev/null 2>/dev/null
	sed -i '/iSNSAccessControl No/d' /tmp/target_info 1>/dev/null 2>/dev/null
	if  [ -z "$new_ip2" ]; then
		sed -i '1i\iSNSServer '$new_ip'' /tmp/target_info
		sed -i '2i\iSNSAccessControl No' /tmp/target_info

	else
		sed -i '1i\iSNSServer '$new_ip'' /tmp/target_info
		sed -i '2i\iSNSServer '$new_ip2'' /tmp/target_info
		sed -i '3i\iSNSAccessControl No' /tmp/target_info
#		sed -i '/iSNSServer '$new_ip'/a\iSNSServer '$new_ip2'' /tmp/target_info
	fi
#	cat /tmp/target_info
	cp /tmp/target_info /etc/iet/ietd.conf
	cp /tmp/target_info /$R_PATH/data/ietd.conf
	chmod a+rw /etc/iet/ietd.conf
	chmod a+rw /$R_PATH/data/ietd.conf

	return 0
}	# ----------  end of function gen_conf_tgt_ip  ----------

#gen_conf_tgt_ip 192.168.0.67 192.168.0.94

get_avalun_ref_dev ()
{
	local _lun=$1
	local _fp="$R_PATH/data/lun_table.conf"
	if  [ -z $_lun ]; then
		return 1
	fi

	if [ -f "$_fp" ] ; then
		sed -n -e '/'$1'/p' $_fp | awk -F 'vol=' '{print $2}' | awk -F '|' '{print $1}'
	else
		return 1
	fi
}	# ----------  end of function get_avalun_ref_dev  ----------


get_para_lun_count ()
{
	local _str=$1
	echo $_str | sed 's/^[[:space:]]*//g' | sed 's/,/\n/g' | wc -l | sed 's/^[[:space:]]*//g'
	return 0
}	# ----------  end of function get_para_lun_count  ----------


get_para_usr_count ()
{
	local _str=$1
	echo $_str | sed 's/^[[:space:]]*//g' | sed 's/,/\n/g' | wc -l | sed 's/^[[:space:]]*//g'
}	# ----------  end of function get_para_usr_count  ----------



get_para_usr_name ()
{
	local _str=$1	
	echo $_str | awk -F '@' '{print $1}'
}	# ----------  end of function get_para_usr_name  ----------



get_para_usr_pass ()
{
	local _str=$1	
	echo $_str | awk -F '@' '{print $2}'
}	# ----------  end of function get_para_usr_pass  ----------




update_bl_target ()
{
	local _lunid=$1
	local _target=$2
	local _fp="$R_PATH/data/lun_table.conf"
	local _org_target=`sed -n -e '/'$_lunid'/p' $_fp | awk -F 'bl_target=' '{print $2}' | awk -F '|' '{print $1}'`
	local _org_lun_cnt=`sed -n -e '/'$_lunid'/=' $_fp`
	if [ -z "$_org_target" ] ; then
		return 1
	fi
	_org_target=`echo $_org_target | sed 's/^[[:space:]]*//g'`
	_org_lun_cnt=`echo $_org_lun_cnt | sed 's/^[[:space:]]*//g'`
	_target=`echo $_target | sed 's/^[[:space:]]*//g'`

	#echo $_org_target
	#echo $_org_lun_cnt
	#echo $_target
	sed -i ''$_org_lun_cnt' s/'$_org_target'/'$_target'/' $_fp
	return 0
}	# ----------  end of function update_bl_targe  ----------



update_bl_target_del ()
{
	local _target=$1
	local _fp="$R_PATH/data/lun_table.conf"
	local _lines=`sed -n -e '/'$_target'/=' $_fp`
	if [ -z "$_lines" ] ; then
		return 1
	fi
	local _org_target=""
#	echo $_lines
	for _line in `echo $_lines`; do
		unset _org_target
		_org_target=`sed -n -e ''$_line'p' $_fp | awk -F 'bl_target=' '{print $2}' | awk -F '|' '{print $1}'`
#		echo $_org_target
		sed -i ''$_line' s/'$_org_target'/none/' $_fp
	done
}	# ----------  end of function update_bl_target_del  ----------

#update_bl_target_del aaa

#update_bl_target Lun0 fsdaa
#get_para_lun_count "Lun0,Lun1"
#iSNSServer 192.168.0.67
#iSNSAccessControl No
#Target iqn.ispd.vme.cn:mars1111
#IncomingUser someuser4 secret4
#IncomingUser someuser5 secret5
#IncomingUser someuser6 secret6
#Lun 0 Path=/dev/sdb,Type=fileio,IOMode=wb
#Alias ISCSI
#
add_spec_tgt_conf ()
{
	local _pcount=$#
	$create_array luns_array
	until [ $# -eq 0 ]
	do
		$push_elements luns_array $1
		shift
	done

	local _fp="/etc/iet/ietd.conf"
	chmod a+rw $_fp
	local _server_ip=`$get_elements luns_array 1`
	local _tgt_name=`$get_elements luns_array 2`
	local _ava_lun_id=`$get_elements luns_array 3`
	local _use_lun_id=`$get_elements luns_array 4`
	local _access_mode=`$get_elements luns_array 5`
	local _chap_flag=`$get_elements luns_array 6`
	local _usr_pass="" 
	if [ "$_chap_flag" = "1"  ] ; then
		_usr_pass=`$get_elements luns_array 7`
	fi

	#echo $_server_ip
	#echo $_tgt_name
	#echo $_ava_lun_id
	#echo $_use_lun_id
	#echo $_access_mode
	#echo $_chap_flag
	#echo $_usr_pass

	get_target_brief 1>/dev/null 2>/dev/null
	local _t_name_g="`get_target_name`"

	for __names in `echo $_t_name_g`; do
		if [ "$_tgt_name" = $__names ] ; then
			return 1
		fi
	done

	
	echo "Target $_tgt_name" >> $_fp
	local __usr=""
	local __pass=""
	local __org_usr_pass=""

	#echo _chap_flag:$_chap_flag
	#echo _usr_pass:$_usr_pass
	if [ "$_chap_flag" = "1" ] ; then
		if [ -z "$_usr_pass" ] ; then
			return 1
		fi
		unset _cnt
		_cnt=`get_para_usr_count "$_usr_pass"`
		for _indx_u in `seq $_cnt`; do
			unset __org_usr_pass
			unset __usr
			unset __pass
			__org_usr_pass=`echo $_usr_pass | awk -F ',' '{print $'$_indx_u'}'`
			__usr=`get_para_usr_name "$__org_usr_pass"`
			__pass=`get_para_usr_pass "$__org_usr_pass"`
			echo "IncomingUser $__usr $__pass" >> $_fp
		done
	fi

	local _cnt=`get_para_lun_count $_use_lun_id`
	expr $_cnt + 1 1>/dev/null 2>/dev/null
	if [ $? -ne 0 ] ; then
		return 1
	fi

	local _lun_cnt=0
	local __lun=""
	local __dev=""
	for _indx in `seq $_cnt`; do
		unset __lun
		__lun=`echo $_use_lun_id | awk -F ',' '{print $'$_indx'}'`
		__dev=`get_avalun_ref_dev "$__lun"`
		#Lun 0 Path=/dev/sdb,Type=fileio,IOMode=wb
		if [ -z "$_access_mode" ] ; then
			_access_mode="wb"
		fi
		echo "Lun $_lun_cnt Path=$__dev,Type=fileio,IOMode=$_access_mode" >> $_fp
		update_bl_target $__lun $_tgt_name
		_lun_cnt=`expr $_lun_cnt + 1`
	done
	echo "Alias Alias_$_tgt_name"Alias >> $_fp


	local t_count=0
	local new_ip=""
	local new_ip2=""
	t_count=`echo $_server_ip | awk -F '@' '{print $1}'`
#	new_ip=`echo $_server_ip | awk -F '@' '{print $2}'`
#	new_ip2=`echo $_server_ip | awk -F '@' '{print $3}'`

	expr $t_count + 1 1>/dev/null 2>/dev/null
	if [ $? -ne 0 ] ; then
		return 1
	else
		chmod a+rw $_fp
		sed -i '/iSNSServer/d' $_fp 
		sed -i '/iSNSAccessControl No/d' $_fp
		if  [ $t_count -eq 1 ] ; then
			new_ip=`echo $_server_ip | awk -F '@' '{print $2}'`
			sed -i '1i\iSNSServer '$new_ip'' $_fp
			sed -i '2i\iSNSAccessControl No' $_fp

		elif [ $t_count -eq 2 ] ; then
			new_ip=`echo $_server_ip | awk -F '@' '{print $2}'`
			new_ip2=`echo $_server_ip | awk -F '@' '{print $3}'`
			sed -i '1i\iSNSServer '$new_ip'' $_fp
			sed -i '2i\iSNSServer '$new_ip2'' $_fp
			sed -i '3i\iSNSAccessControl No' $_fp
			#		sed -i '/iSNSServer '$new_ip'/a\iSNSServer '$new_ip2'' /tmp/target_info
		fi
#		echo $t_count >> /tmp/spec_rec
#		if [ $t_count -eq 1 ] ; then
#			ip1=`echo $_server_ip | awk -F '@' '{print $2}'`
#			gen_conf_tgt_ip $ip1
#		fi
#
#		echo $ip >> /tmp/spec_rec
#		if [ $t_count -eq 2 ] ; then
#			ip1=`echo $_server_ip | awk -F '@' '{print $2}'`
#			ip2=`echo $_server_ip | awk -F '@' '{print $3}'`
#			gen_conf_tgt_ip $ip1 $ip2
#			echo $ip1 >> /tmp/spec_rec
#			echo $ip2 >> /tmp/spec_rec
#		fi
	fi



	return 0

}	# ----------  end of function add_spec_lungt_conf  ----------

#	local _fp="/etc/iet/ietd.conf"
#	local _server_ip=`$get_elements luns_array 1`
#	local _tgt_name=`$get_elements luns_array 2`
#	local _ava_lun_id=`$get_elements luns_array 3`
#	local _use_lun_id=`$get_elements luns_array 4`
#	local _access_mode=`$get_elements luns_array 4`
#	local _chap_flag=`$get_elements luns_array 6`
#	local _usr_pass=""
#	if [ "$_chap_flag" = "1"  ] ; then
#		_usr_pass=`$get_elements luns_array 7`
#	fi
#

#|server_ip="192.168.1.1"|target_name="iqn...."|ava_lun_id="Lun0,Lun1..."|use_lun_id="Lun2,Lun3"|accecc_mode="WB"|chap_flag="1"|usr_pass="feng@123,tong@456"|
#add_spec_tgt_conf "2@192.168.1.1@192.168.0.67" "tgtfsdafasd_namefasdfda_haha" "none" "Lun1" "wb" "1" "tong@123,feng@1234"

#del_spec_lungt_conf "iqn.ispd.vme.cn:mars"
#echo ------------------------
#cat /tmp/target_info
#get_target_ip
#-------------------------------------------------------------------------------
#  for test
#-------------------------------------------------------------------------------
#echo bri
#get_target_brief #> /dev/null
#echo count
#get_target_count #> /dev/null
#
#name=`get_target_name`
#name1=`echo $name | awk '{print $1}'`
#name2=`echo $name | awk '{print $2}'`
#echo $name
#echo ------
#echo $name1
#
#echo alias..
#get_target_alias #> /dev/null
#
#
#get_target_name 
#get_target_luns
#tgt=`get_target_luns`
#echo luns.....
#echo $tgt
#echo para
#echo $tgt | awk -F '|' '{print $1}'
#get_spec_lun_no "iqn.ispd.vme.cn:mars1111"
#
#echo ---------access_mode...
#get_access_mode "iqn.ispd.vme.cn:mars"
#get_target_alias
#
#echo aaa
#get_spec_target_alias "iqn.ispd.vme.cn:mars"
#
#get_target_brief
#echo target_chap... 
#get_target_chap 
#
#
#get_spec_target_chap "iqn.ispd.vme.cn:mars"
#echo ------
#get_spec_target_chap "iqn.ispd.vme.cn:mars1111"
#echo ++++++
#get_spec_t_chap_u_cnt "iqn.ispd.vme.cn:mars1111"
#
#get_spec_t_chap_u_cnt "iqn.ispd.vme.cn:mars"
#
#echo is_target_chap
#is_target_chap "iqn.ispd.vme.cn:mars1111"
#contruct_usr_pass "iqn.ispd.vme.cn:mars"
