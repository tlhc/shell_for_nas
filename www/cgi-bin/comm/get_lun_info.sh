#!/bin/sh 
#===============================================================================
#
#          FILE: get_lun_info.sh
# 
#         USAGE: ./get_lun_info.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: tongl (), 
#  ORGANIZATION: 
#       CREATED: 2012Äê09ÔÂ18ÈÕ 12ʱ05·Ö09Ãë CST
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
. $R_PATH/comm/get_disk_info.sh
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

#-------------------------------------------------------------------------------
#  create local lun table as db
#-------------------------------------------------------------------------------
c_local_lun_table ()
{
	local _filename=$1	
	if [ -z $_filename ] ; then
		_filename="lun_table.conf"
	fi
	local _fp=`get_r_prefix`
	touch_file $_filename $_fp
}	# ----------  end of function c_local_lun_table  ----------
#c_local_lun_table





#-------------------------------------------------------------------------------
#  just get count...
#-------------------------------------------------------------------------------
get_lun_table_count ()
{
	local _count=0
	local _fp=$R_PATH/data/lun_table.conf
	touch_file _lun_c.tmp
	sed -n -e '/^$/d' $_fp | sed -n -e '/^#/d' | sed -n -e 's/^[[:space:]]*//g' >> /tmp/_lun_c.tmp
	_count=`cat /tmp/lun_table.tmp | wc -l | sed 's/^[[:space:]]*//g' `
	rm_file _lun_c.tmp
	echo $_count
}	# ----------  end of function get_lun_table_count  ----------


#-------------------------------------------------------------------------------
#  get none reference disk 
#  $1=bf_disk_info
#-------------------------------------------------------------------------------
get_none_ref_disk ()
{
	local _res_str=""
	local _bf_d_path=""
	local _bf_file=""
	if [ -z $1 ] ; then
		if [ -f "/tmp/bf_disk_info"  ] ; then
			unset _bf_d_path
			_bf_d_path="/tmp/bf_disk_info"
			_bf_file="bf_disk_info"
		else
			return 1
		fi
	else
		if [ -f "/tmp/$1"  ] ; then
			unset _bf_d_path
			_bf_d_path="/tmp/$1"
			_bf_file=$1
		fi
	fi

	#-------------------------------------------------------------------------------
	#  create tmp file fo exchange...
	#-------------------------------------------------------------------------------
	if [ -f "$R_PATH/data/lun_table.conf"  ] ; then
		touch_file lun_exchange
		if [ $? -ne 0 ] ; then
			gen_error_message "can't create lun_exchange file... please clear tmp files"
			return 1
		fi
		local _d_count=`get_disk_count $_bf_file`
		local _test=`expr $_d_count + 10`

		if [ $? -ne 0 ] ; then
			return 1
		else
			local _dev_no=""
			touch_file none_ref_lun.tmp
			for _indx in `seq $_d_count` ; do
				unset _dev_no
				_dev_no=`sed -n -e ''$_indx'p' $_bf_d_path 2>/dev/null | awk -F ':' '{print $1}' | awk '{print $2}'`
				if [ -z "$_dev_no" ] ; then
					return 1
				else
					#search filter..
					local _lun_table=$R_PATH/data/lun_table.conf
					  rm -f /tmp/lun_table.tmp 2>/dev/null
					  cp $_lun_table /tmp/lun_table.tmp
					if [ $? -eq 0 ] ; then
						unset _lun_table
						_lun_table="/tmp/lun_table.tmp"
					fi
					trim_c_s_b "/tmp/lun_table.tmp"
					local _escape_dev=`gen_escape_dev $_dev_no`
#					local _res=`sed -n -e '/'$_escape_dev'/p' $_lun_table`
					local _count=`get_lun_table_count`
					if [ $? -ne 0 ] ; then
						return 1
					else
						local _fin_str=""
						for _indx_lun in `seq $_count`; do
							unset _fin_str
							_fin_str=`sed -n -e '/'$_escape_dev'/p' $_lun_table`
							if [ -z "$_fin_str" ] ; then
								continue
							else
								echo -e "$_fin_str" >> /tmp/none_ref_lun.tmp 
							fi
						done
					fi
				fi
			done
		fi
		touch_file none_ref_lun.fin
		cat /tmp/none_ref_lun.tmp | uniq >> /tmp/none_ref_lun.fin  # /tmp/none_ref_lun.tmp
		rm_file none_ref_lun.tmp
	else
		return 1
	fi
	return 1
}	# ----------  end of function get_none_ref_disk  ----------



#-------------------------------------------------------------------------------
#  for test....
#-------------------------------------------------------------------------------
#get_org_disk_info
#get_disk_brief
#get_none_ref_disk
#

