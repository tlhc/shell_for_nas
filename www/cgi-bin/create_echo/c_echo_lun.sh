#!/bin/sh
#===============================================================================
#
#          FILE: c_echo_lun.sh
# 
#         USAGE: ./c_echo_lun.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: tongl (), 
#  ORGANIZATION: 
#       CREATED: 2012Äê09ÔÂ14ÈÕ 10ʱ56·Ö59Ãë CST
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


#<iscsi_lun_res>
#	<disk_sel>
#		<disk_x>
#			name:tst | s_disk:dev/sda/ | size:250G|
#		</disk_x>
#
#		<disk_x>
#			name:tst | s_disk:dev/sda/ | size:250G|
#		</disk_x>
#	</disk_sel>
#</iscsi_lun_res>
#



#-------------------------------------------------------------------------------
#  gen iscsi lun info for select luns
#-------------------------------------------------------------------------------
gen_iscsi_lun_res ()
{
	local _filename=$1
	if [ -z $_filename ] ; then
		echo "no filename!!"
		return 1
	fi
	gen_tag_h $_filename iscsi_lun_res
	gen_tag_h $_filename disk_sel

	

	for _indx in `seq 3`; do
		gen_tag_h $_filename disk_x
		gen_tag_value $_filename "name:tst | s_disk:dev/sda/ | size:250G|"
		gen_tag_t $_filename disk_x
	done

	gen_tag_t $_filename disk_sel
	gen_tag_t $_filename iscsi_lun_res
	return 0
}	# ----------  end of function gen_iscsi_lun_res  ----------


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
#		</lun_size>
#
#		<lun_rmd_size>
#		</lun_rmd_size>
#
#	</table_row>
#
#</iscsi_lun_table>

#-------------------------------------------------------------------------------
#  gen iscsi table for loading....
#-------------------------------------------------------------------------------
gen_iscsi_lun_table ()
{
	local _filename=$1
	if [ -z $_filename ] ; then
		echo "no filename!!"
		return 1
	fi

	gen_tag_h $_filename iscsi_lun_table

	for _indx in `seq 5`; do

		gen_tag_h $_filename table_row
		
		gen_tag_h $_filename lun_alias          # lun_alias
		gen_tag_value $_filename  lun_aa_for_test
		gen_tag_t $_filename lun_alias


		gen_tag_h $_filename lun_bl_target      # lun_bl_target
		gen_tag_value $_filename lun_value_for_test
		gen_tag_t $_filename lun_bl_target


		gen_tag_h $_filename lun_volum
		gen_tag_value $_filename lun_volum_for_test
		gen_tag_t $_filename lun_volum

		gen_tag_h $_filename lun_size
		gen_tag_value $_filename 100G
		gen_tag_t $_filename lun_size


		gen_tag_h $_filename lun_rmd_size
		gen_tag_value $_filename 50G
		gen_tag_t $_filename lun_rmd_size

		gen_tag_t $_filename table_row
	done

	gen_tag_t $_filename iscsi_lun_table

	return 0
}	# ----------  end of function gen_iscsi_lun_table  ----------



