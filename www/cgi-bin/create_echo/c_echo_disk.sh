#!/bin/sh
#===============================================================================
#
#          FILE: c_echo_disk.sh
# 
#         USAGE: ./c_echo_disk.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: tongl (), 
#  ORGANIZATION: 
#       CREATED: 2012Äê09ÔÂ14ÈÕ 11ʱ03·Ö18Ãë CST
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

#. ../c_tools.sh

R_PATH=""
unset R_PATH
R_PATH=`get_r_path`

. $R_PATH/comm/tools.sh
. $R_PATH/create_echo/c_tools.sh
. $R_PATH/comm/get_disk_info.sh
. $R_PATH/comm/get_raid_info.sh

#<s_disk_group>
#	<s_disk_x>
#		<s_no>
#			dev/sda ....
#		</s_no>
#
#		<s_label>
#		</s_label>
#
#		<s_t_size>
#
#		</s_t_size>
#
#		<s_f_size>
#
#		</s_f_size>
#
#	</s_disk_x>
#
#</s_disk_group>

#-------------------------------------------------------------------------------
#  gen singal disk info
#-------------------------------------------------------------------------------

gen_s_disk_info ()                              # get whole info for s disk
{
	get_org_disk_info

	if [ $? -eq 0 ] ; then
		echo "" >/dev/null
	else
		gen_error_message "can't get org_disk info!"
		return 1
	fi

	get_disk_brief

	if [ $? -eq 0 ] ; then
		echo "" >/dev/null
	else
		gen_error_message "cat't get disk_brief info!"
		return 1
	fi

	local _filename=$1
	if [ -z $_filename ] ; then
		gen_error_message "get_s_disk_info error!!-no name"
		return 1
	fi
	gen_tag_h $_filename s_disk_group
	#get disk count
	local _dc=`get_disk_count`
	_res=`expr $_dc + 10`
	if [ $? -ne 0 ] ; then
		gen_error_message "_dc is not digtal"
		return 1
	fi

	if [ $? -eq 1 ] ; then
		return 1
	else
		for _indx in `seq $_dc`; do

			gen_tag_h $_filename s_disk_x

			gen_tag_h $_filename s_no
			gen_tag_value $_filename `get_disk_no $_indx`
			gen_tag_t $_filename s_no

			gen_tag_h $_filename s_label
			gen_tag_value $_filename `get_disk_label $_indx`
			gen_tag_t $_filename s_label

			gen_tag_h $_filename s_t_size
			gen_tag_value $_filename `get_disk_size $_indx`
			gen_tag_t $_filename s_t_size

			gen_tag_h $_filename s_f_size
			gen_tag_value $_filename `get_disk_fsize $_indx`
			gen_tag_t $_filename s_f_size

			gen_tag_t $_filename s_disk_x
		done

		gen_tag_t $_filename s_disk_group
	fi
	return 0
}	# ----------  end of function gen_s_disk_info  ----------

#-------------------------------------------------------------------------------
#  test 
#-------------------------------------------------------------------------------
#get_org_disk_info 
#get_disk_brief 
#get_disk_count 
#gen_s_disk_info aaasss

#<raid_disk_group>
#	<raid_disk_x>
#		<raid_label>
#
#		</raid_label>
#
#		<raid_level>
#		0 5
#		</raid_level>
#
#		<raid_no>
#			dev/md0 ....
#		</raid_no>
#
#		<raid_t_size>
#
#		</raid_t_size>
#
#		<raid_f_size>
#
#		</raid_f_size>
#
#		<raid_status>
#
#		</raid_status>
#	</raid_disk_x>
#</raid_disk_group>
#

#-------------------------------------------------------------------------------
#  gen raid disk info 
#-------------------------------------------------------------------------------
gen_r_disk_info ()
{
	local _filename=$1
	if [ -z $_filename ] ; then
		echo "no filename!!"
		return 1
	fi
	gen_tag_h $_filename raid_disk_group
	local _raidcount=`get_raid_count`
	local _raid_str=`get_raid_no_g`
#	echo $_raid_str
	local _r_no=0
	local _t_str=""
	if [ ! -z "$_raid_str" ] ; then
		for _r_no in `echo $_raid_str`; do
#			unset _r_no
#			_r_no=`expr $_indx - 1`
#			echo $_r_no
			gen_tag_h $_filename raid_disk_x
			gen_tag_h $_filename raid_no            
			gen_tag_value $_filename "/dev/md$_r_no"
			gen_tag_t $_filename raid_no

			gen_tag_h $_filename raid_label
			gen_tag_value $_filename "/dev/md$_r_no"
			gen_tag_t $_filename raid_label

			gen_tag_h $_filename raid_level
			gen_tag_value $_filename "`get_raid_lv "/dev/md$_r_no"`"
			gen_tag_t $_filename raid_level

			gen_tag_h $_filename raid_t_size
			gen_tag_value $_filename "`gen_md_dev_T_size "/dev/md$_r_no"`G"
			gen_tag_t $_filename raid_t_size

			gen_tag_h $_filename raid_f_size
			gen_tag_value $_filename none
			gen_tag_t $_filename raid_f_size

			gen_tag_h $_filename raid_status
			gen_tag_value $_filename "`get_raid_status "/dev/md$_r_no"`"
			gen_tag_t $_filename raid_status
			gen_tag_t $_filename raid_disk_x
		done
	else
			echo "" > /dev/null
			#gen_tag_h $_filename raid_disk_x
			#gen_tag_value $_filename raid_disk_x
			#gen_tag_t $_filename raid_disk_x
	fi
	gen_tag_t $_filename raid_disk_group
	return 0
}	# ----------  end of function gen_r_disk_info  ----------

#-------------------------------------------------------------------------------
#  for curr test.....
# 
#-------------------------------------------------------------------------------
#cat /tmp/r_disk
#touch_file testinfo
#gen_s_disk_info aaasssws
