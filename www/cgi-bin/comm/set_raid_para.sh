#!/bin/sh
#===============================================================================
#
#          FILE: set_raid_para.sh
# 
#         USAGE: ./set_raid_para.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: tongl (), 
#  ORGANIZATION: 
#       CREATED: 2012年09月19日 14时34分39秒 CST
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


#-------------------------------------------------------------------------------
#  old version for array use eah.....
#-------------------------------------------------------------------------------

create_array="$R_PATH/array_emu/create_array.sh"
del_array="$R_PATH/array_emu/del_array.sh"
push_elements="$R_PATH/array_emu/push_elements.sh"
pop_elements="$R_PATH/array_emu/pop_elements.sh"
getlen="$R_PATH/array_emu/getlen.sh"
get_elements="$R_PATH/array_emu/get_elements.sh"
rm_elements="$R_PATH/array_emu/remove_elements.sh"
get_array="$R_PATH/array_emu/get_array.sh"


#-------------------------------------------------------------------------------
# build_raid p1 = /dev/md0 ---dev name  
#            p2 = level 
#            p3..... devices...
#-------------------------------------------------------------------------------
build_raid ()
{
#	echo $#
	# can't show parameter.. after 10
#	local _aa=1
#	for (( CNTR=0; CNTR<$#; CNTR+=1 )); do
#		eval echo \$$_aa
#		_aa=`expr $_aa + 1`
#	done
	local _pcount=$#
	local _disk_string=""
	$create_array raid_para
	until [ $# -eq 0 ]
	do
		$push_elements raid_para $1
#		echo "第一个参数为: $1 参数个数为: $#"
		shift
	done
	local _mdname=`$get_elements raid_para 1`
	local _mdlevel=`$get_elements raid_para 2`

	if [ -z "$_mdname" ] || [ -z "$_mdlevel" ] ; then
		return 1
	else
		#get dev name
		local _tcount=3
		unset _disk_string
		#for (( CNTR=3; CNTR<=$_pcount; CNTR+=1 )); do
		#	_disk_string="$_disk_string "`$get_elements raid_para $_tcount` # disk_string store devices...
		#	_tcount=`expr $_tcount + 1`
		#done
		for _tcount in `seq 3 $_pcount 2>/dev/null`; do
			_disk_string="$_disk_string "`$get_elements raid_para $_tcount` # disk_string store devices...
			#umount all
			mdadm --zero-superblock `$get_elements raid_para $_tcount` 1>/dev/null 2>/dev/null
		done
	fi
	local _devs_count=`expr $_pcount - 2 2>/dev/null`
	#此处umount 所有关联设备
	mdadm -S $_mdname 1>/dev/null 2>/dev/null
	mdadm -C $_mdname -l$_mdlevel -n$_devs_count $_disk_string <<EOF
y
EOF
	#echo _mdname$_mdname >> /tmp/ssaa
	#echo _mdleve$_mdlevel >> /tmp/ssaa
	#echo _devs_c$_devs_count >> /tmp/ssaa
	#echo _disk_s$_disk_string >> /tmp/ssaa
	if [ $? -ne 0 ] ; then
#		echo "can't create raid array.." >> /tmp/build_raid_o
		gen_error_message "can't create raid array.."
		return 1
	fi

#	format_s_disk "$_mdname" 
#	if [ $? -ne 0 ] ; then
#		gen_error_message "can't format raid_disk..."
##		echo "can't format raid disk..." >> /tmp/build_raid_o
#		return 1
#	fi
#	echo build_raid_success	>>/tmp/build_raid_o

	chmod a+rw /mnt/jffs2/mdadm.conf
	mdadm -Ds > /mnt/jffs2/mdadm.conf 2>/dev/null
#	gen_success_message
	return 0
}	# ----------  end of function build_raid  ----------


#-------------------------------------------------------------------------------
#  test...
#-------------------------------------------------------------------------------
#build_raid /dev/md0 0 /dev/sda /dev/sdb 

#build_raid /dev/md0 5 /dev/sda /dev/sdb /dev/sdc 

#-------------------------------------------------------------------------------
#  clear raid build
#-------------------------------------------------------------------------------
clear_raid ()
{
	local _raid_no=$1
	local _raid_relate_disk=`get_raid_releate_disk $_raid_no`

	if [ -z "$_raid_relate_disk" ] ; then
		return 1
	fi
	mdadm -S $_raid_no 1>/dev/null 2>/dev/null
	for __disk in `echo $_raid_relate_disk`; do
		mdadm --zero-superblock $__disk
	done
	chmod a+rw /mnt/jffs2/mdadm.conf
	mdadm -Ds > /mnt/jffs2/mdadm.conf 2>/dev/null
	return 0

	#-------------------------------------------------------------------------------
	#  not use
	#-------------------------------------------------------------------------------

	if [ -z $_raid_no ] ; then
		gen_error_message "clear_raid parameter.. empty"
#		addin_message "clear_raid parameter.. empty" clear_raid_std_o
		return 1
	else
		local _lno=`mdadm --detail "$_raid_no" 2>/dev/null | wc -l | sed 's/^[[:space:]]*//g'`
		if [ $? -ne 0  ] ; then
#			addin_message "can't get mdadm detail.." clear_raid_std_o
			gen_error_message "can't get mdadm detail.."
			return 1
		fi
		local _lnob=`mdadm --detail "$_raid_no" 2>/dev/null | sed -n -e '/Number/='`
		if [ $? -ne 0  ] ; then
			gen_error_message "can't get mdadm detail.."
#			addin_message "can't get mdadm detail.." clear_raid_std_o
			return 1
		fi
		local _devs_count=`expr $_lno - $_lnob 2>/dev/null` 
		if [ $? -ne 0 ] ; then
			gen_error_message "parameter.. error.."
#			addin_message "can't get mdadm detail" clear_raid_std_o
			return 1
		fi
		_lnob=`expr $_lnob + 1`

		if [ $? -ne 0 ] ; then
			gen_error_message "parameter.. error.."
#			addin_message "parameter.. error.." clear_raid_std_o
			return 1
		fi

		local _group_dev="`mdadm --detail "$_raid_no" 2>/dev/null | sed -n -e ''$_lnob','$_lno'p' | awk '{print $NF}'`"
		local _mount_stat=""
		local _devs=`gen_escape_dev $_raid_no`
		local _condition=`cat /etc/mtab | sed -n -e '/'$_devs'/p'`

		if [ -z "$_condition" ] ; then                   # not mount
			  mdadm -S "$_raid_no" 2>/dev/null
			if [ $? -ne 0 ] ; then
				gen_error_message "can't stop raid array"
#				addin_message "raid already clear_raid..." clear_raid_std_o
				return 1
			fi
			for _co in `seq $_devs_count 2>/dev/null`; do
#				  umount `echo $_group_dev | awk '{print$'$_co'}'` 2>/dev/null
				format_s_disk `echo $_group_dev | awk '{print$'$_co'}'` 
				if [ $? -ne 0 ] ; then
					gen_error_message "can't format_s_disk.."
#					addin_message "can't format_s_disk.."
					return 1
				fi
			done
			gen_success_message
#			addin_message "success" clear_raid_std_o
			return 0
		else                                             # mount
			local _mpos=`  df -hl | sed -n -e '/'$_devs'/p' | awk '{print $NF}'`
			  umount $_mpos
			if [ $? -ne 0 ] ; then
				gen_error_message "umount disk error.."
#				addin_message "umount disk error.." clear_raid_std_o
				return 1
			fi
			  mdadm -S "$_raid_no" 2>/dev/null
			if [ $? -ne 0 ] ; then
				gen_error_message "can't stop disk..."
#				addin_message "can't stop disk..."
				return 1
			fi
			for _co in `seq $_devs_count`; do
				  umount `echo $_group_dev | awk '{print$'$_co'}'` 2>/dev/null
				#format_s_disk `echo $_group_dev | awk '{print$'$_co'}'` 
				mdadm --zero-superblock `echo $_group_dev | awk '{print$'$_co'}'` 
				if [ $? -ne 0 ] ; then
		#			touch_file asasdisk
		#			echo $_raid_no >> /tmp/asasdisk
					gen_error_message "can't format_s_disk.."
					return 1
				fi
			done
			mdadm -Es > /mnt/jffs2/mdadm.conf 1>/dev/null 2>/dev/null
			gen_success_message
#			echo "success" clear_raid_std_o
			return 0
		fi
	fi
}	# ----------  end of function clear_raid  ----------


#-------------------------------------------------------------------------------
#  test...
#-------------------------------------------------------------------------------
#clear_raid /dev/md0
active_raid ()
{
	local _raid_no=$1
	if [ -z $_raid_no ] ; then
		echo "start"
	fi
}	# ----------  end of function start_raid  ----------


stop_raid ()
{
	if [ -z $1 ] ; then
		return 1
	fi
	local _raid_no=$1
	  mdadm -S "$_raid_no" 2>/dev/null

	if [ $? -eq 0 ] ; then
		return 0
	else
		return 0
	fi
}	# ----------  end of function stop_raid  ----------

