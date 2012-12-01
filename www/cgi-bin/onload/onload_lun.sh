#!/bin/sh
#===============================================================================
#
#          FILE: onload_lun.sh
# 
#         USAGE: ./onload_lun.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: tongl (), 
#  ORGANIZATION: 
#       CREATED: 2012Äê09ÔÂ18ÈÕ 11ʱ40·Ö23Ãë CST
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
. $R_PATH/comm/get_disk_info.sh
. $R_PATH/comm/get_raid_info.sh

#<iscsi_lun_table>
#	<table_row>
#		<lun_alias>
#		</lun_alias>
#
#		<lun_bl_target>
#		</lun_bl_target>
#
#		<lun_volum>
#			as id
#		</lun_volum>
#
#		<lun_size>
#
#		</lun_size>
#
#		<lun_rmd_size>
#
#		</lun_rmd_size>
#
#	</table_row>
#
#</iscsi_lun_table>
#


response_lun ()
{
	local _fp=$1
	local _tmp_fp="/tmp/lun_table.tmp"
	if [ -z $_fp ] ; then
		_fp="$R_PATH/data/lun_table.conf"
	else
		_fp="$R_PATH/data/$1"
	fi

	#process tmp files
	  rm $_tmp_fp 2>/dev/null
	  rm /tmp/lun_table.tmp 2>/dev/null
	  cp $_fp /tmp/lun_table.tmp 
	  chmod a+rw /tmp/lun_table.tmp 

	  sed -i '/^$/d' $_tmp_fp 1>/dev/null
	  sed -i '/^#/d' $_tmp_fp 1>/dev/null
	  sed -i 's/^[[:space:]]*//g' $_tmp_fp 1>/dev/null
	
	if [ -f $_tmp_fp ]  && [ -r $_tmp_fp ]; then
		touch_file echo_lun_table
		create_echo_header echo_lun_table xml
		gen_tag_h echo_lun_table lun_whole
		gen_tag_h echo_lun_table iscsi_lun_table
#		local _cnt=`sed '/^$/d' $_fp | sed '/^#/d' | sed 's/^[[:space:]]*//g' | wc -l`
		local _cnt=`cat $_tmp_fp | wc -l | sed 's/^[[:space:]]*//g'`
		for _indx in `seq $_cnt` ; do
			gen_tag_h echo_lun_table table_row
#			awk -F '|' '{print $1}' /tmp/lun_table.tmp | sed -n -e '2p' # LunID
			gen_tag_h echo_lun_table lun_alias
			gen_tag_value echo_lun_table ` awk -F '|' '{print $2}' /tmp/lun_table.tmp | sed -n -e ''$_indx'p' | awk -F '=' '{print $2}'`
			gen_tag_t echo_lun_table lun_alias

			gen_tag_h echo_lun_table lun_bl_target
			gen_tag_value echo_lun_table `awk -F '|' '{print $3}' /tmp/lun_table.tmp | sed -n -e ''$_indx'p' | awk -F '=' '{print $2}'` # bl_target
			gen_tag_t echo_lun_table lun_bl_target


			gen_tag_h echo_lun_table lun_volum
			gen_tag_value echo_lun_table `awk -F '|' '{print $4}' /tmp/lun_table.tmp | sed -n -e ''$_indx'p' | awk -F '=' '{print $2}'` # vol
			gen_tag_t echo_lun_table lun_volum

			gen_tag_h echo_lun_table lun_size	
			gen_tag_value echo_lun_table `awk -F '|' '{print $5}' /tmp/lun_table.tmp | sed -n -e ''$_indx'p' | awk -F '=' '{print $2}'`
			gen_tag_t echo_lun_table lun_size

			gen_tag_h echo_lun_table lun_rmd_size
			gen_tag_value echo_lun_table `awk -F '|' '{print $6}' /tmp/lun_table.tmp | sed -n -e ''$_indx'p' | awk -F '=' '{print $2}'`
			gen_tag_t echo_lun_table lun_rmd_size

			gen_tag_t echo_lun_table table_row

		done
		gen_tag_t echo_lun_table iscsi_lun_table

		#	<disk_sel>
		#		<disk_x>
		#			name:tst | s_disk:dev/sda/ | size:250G|
		#		</disk_x>
		#
		#		<disk_x>
		#			name:tst | s_disk:dev/sda/ | size:250G|
		#		</disk_x>
		#	</disk_sel>
		gen_tag_h echo_lun_table disk_sel
		
		#eh....
		get_org_disk_info 
		get_disk_brief 
		local _d_count=`get_disk_count`
		local _d_r_count=0                      # for test
		local _md_dev=0
		local _test_num=`expr $_d_count + 10`   # get s_disk count
		if [ $? -ne 0 ] ; then
			gen_tag_h echo_lun_table disk_x
			gen_tag_t echo_lun_table disk_x
			gen_tag_t echo_lun_table disk_sel
		else
			#add s disk_info
			local _res_str=""
			for _indx_c in `seq $_d_count`; do
				gen_tag_h echo_lun_table disk_x
				unset _res_str
#				_res_str=`get_disk_no $_indx_c`'|'`get_disk_no $`
				gen_tag_value echo_lun_table `get_disk_no $_indx_c` 
				gen_tag_t echo_lun_table disk_x
			done

			#add r_disk_info                    #  tst..
			_d_r_count=`get_raid_count`
			expr "$_d_r_count + 1" 1>/dev/null 2>/dev/null
			if [ $? -ne 0 ] ; then
				return 1
			fi
			for _indx_r in `seq $_d_r_count`; do
				unset _md_dev
				_md_dev=`expr $_indx_r - 1`
				gen_tag_h echo_lun_table disk_x
				gen_tag_value echo_lun_table "/dev/md$_md_dev"
				gen_tag_t echo_lun_table disk_x
			done
			gen_tag_t echo_lun_table disk_sel
		fi
		#-------------------------------------------------------------------------------
		#  gen_lun_sel
		#-------------------------------------------------------------------------------
		gen_tag_t echo_lun_table lun_whole
		return 0
	else
		return 1
	fi

}	# ----------  end of function response_lun  ----------


#-------------------------------------------------------------------------------
#  for test
#-------------------------------------------------------------------------------
response_lun
cat /tmp/echo_lun_table
