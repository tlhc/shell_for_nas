#!/bin/sh
#===============================================================================
#
#          FILE: get_rebuild_pg.sh
# 
#         USAGE: ./get_rebuild_pg.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: tongl (), 
#  ORGANIZATION: 
#       CREATED: 2012年11月07日 20时38分03秒 CST
#      REVISION:  ---
#===============================================================================

is_right_md_in_pg ()
{
	local _md=$1
	local res=`cat /proc/mdstat | grep $_md`

	if [ ! -z "$res" ] ; then
		return 0
	else
		return 1
	fi
}	# ----------  end of function is_right_md  ----------


get_md_rebuild_r_time ()
{
	local _md=$1
	is_right_md_in_pg $_md
	if  [ $? -ne 0 ] ; then
		return 1
	else
		local _l_cnt=` cat /proc/mdstat | sed -n -e '/'$_md'/='`
		local _real_cnt=`expr $_l_cnt + 2`
		cat /proc/mdstat | sed -n -e ''$_real_cnt'p' | awk -F 'finish=' '{print $2}' | awk '{print $1}'
		return 0
	fi
}	# ----------  end of function get_md_rebuid_r_time  ----------



get_md_rebuild_r_prg ()
{
	local _md=$1
	is_right_md_in_pg $_md
	if  [ $? -ne 0 ] ; then
		return 1
	else
		local _l_cnt=` cat /proc/mdstat | sed -n -e '/'$_md'/='`
		local _real_cnt=`expr $_l_cnt + 2`
		cat /proc/mdstat | sed -n -e ''$_real_cnt'p' | awk -F 'recovery =' '{print $2}' | awk '{print $1}'
		return 0
	fi
}	# ----------  end of function get_md_rebuid_r_prg  ----------


#is_right_md_in_pg md1
#echo $?
#
#get_md_rebuild_r_time md0
#
#get_md_rebuild_r_prg md0
