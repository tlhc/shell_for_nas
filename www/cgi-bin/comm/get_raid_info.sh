#!/bin/sh 
#===============================================================================
# #          FILE: get_raid_info.sh
# 
#         USAGE: ./get_raid_info.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 2012年10月08日 15时46分23秒 CST
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
#. $R_PATH/create_echo/c_tools.sh
#. $R_PATH/comm/set_raid_para.sh

get_raid_count ()
{
	local _var=0
	_var=`cat /proc/mdstat | sed -n -e '/^md/p' | wc -l | sed 's/^[[:space:]]*//g'`
	if [ -z $_var ] ; then
		return 1
	else
		local _tst=`expr $_var + 1`
		if [ $? -ne 0 ] ; then
			echo 0
			return 1
		else
			echo $_var
			return 1
		fi
	fi
	return 0
}	# ----------  end of function get_raid_count  ----------


get_raid_no_g ()
{
#	local _r_count=`get_raid_count`
#
#	if [ $_r_count -eq 0 ] ; then
#		return 1
#	fi
#	for _indx in `seq $_r_count`; do
#		echo gaga
#	done
#
	cat /proc/mdstat | sed -n -e '/^md/p' | awk -F 'md' '{print $2}' | awk -F ':' '{print $1}'
	return 0	
}	# ----------  end of function get_raid_no  ----------

#get_raid_no_g

#-------------------------------------------------------------------------------
#  get_raid_releate_disk for determin dev
#-------------------------------------------------------------------------------
get_raid_releate_disk ()
{
	local _raid_no=$1
	if [ -z $_raid_no ] ; then
		return 1
	else
		local _lno=`mdadm --detail "$_raid_no" 2>/dev/null | wc -l | sed 's/^[[:space:]]*//g'`
		if [ $? -ne 0  ] ; then
			return 1
		fi
		local _lnob=`mdadm --detail "$_raid_no" 2>/dev/null | sed -n -e '/Number/='`
		if [ $? -ne 0  ] ; then
			return 1
		fi
		local _devs_count=`expr $_lno - $_lnob 2>/dev/null` 
		if [ $? -ne 0 ] ; then
			return 1
		fi

		_lnob=`expr $_lnob + 1`
		if [ $? -ne 0 ] ; then
			return 1
		fi
		local _group_dev="`mdadm --detail "$_raid_no" 2>/dev/null | sed -n -e ''$_lnob','$_lno'p' | awk '{print $NF}'`"
		echo $_group_dev
	fi
}	# ----------  end of function get_raid_releate_disk  ----------

#get_raid_releate_disk /dev/md0
#get_raid_releate_disk /dev/md1


gen_md_dev_T_size ()
{
	if [ -z "$1" ] ; then
		return 1
	fi
	local _escape_dev=`gen_escape_dev $1`
	local _tmpstr=""
	_tmpstr=`  fdisk -l 2>/dev/null | sed -n -e '/'$_escape_dev'/p'`
	if [ -z "$_tmpstr" ]; then
		return 1
	else
		echo "$_tmpstr" | awk '{print $3}'
	fi
}	# ----------  end of function gen_md_dev_T_size  ----------


#-------------------------------------------------------------------------------
#  for test...
#-------------------------------------------------------------------------------
#gen_md_dev_T_size /dev/md0


#-------------------------------------------------------------------------------
# get status... 
#-------------------------------------------------------------------------------
get_raid_status ()
{
	local _md_dev=$1
	if [ -z "$_md_dev" ] ; then
		return 1
	fi
	local _status=""
	_status=`  mdadm --detail $_md_dev | sed -n -e '/State/p' | awk -F ':' '{print $2}'`
	echo $_status
}	# ----------  end of function get_raid_status  ----------

#get_raid_status /dev/md0

get_raid_label ()
{
	local _md_dev=$1
	if [ -z "$_md_dev" ] ; then
		return 1
	fi

}	# ----------  end of function get_raid_label  ----------


get_raid_lv ()
{
	local _md_dev=$1

	if [ -z "$_md_dev" ]; then
		return 1
	fi
	local _lv=""
	 _lv=`  mdadm --detail $_md_dev | sed -n -e '/Raid\ Level/p' | awk -F ':' '{print $2}'`
	echo $_lv | awk -F 'raid' '{print $2}'

}	# ----------  end of function get_raid_lv  ----------


#-------------------------------------------------------------------------------
#  get raid group dev count..
#-------------------------------------------------------------------------------
get_raid_g_dev_count ()
{
	local _md_dev=$1

	if [ -z "$_md_dev" ]; then
		return 1
	fi
	local _count=""
	 _count=`  mdadm --detail $_md_dev | sed -n -e '/Raid\ Devices/p' | awk -F ':' '{print $2}'`
	echo $_count 
}	# ----------  end of function get_raid_g_dev_count  ----------
