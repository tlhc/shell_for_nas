#!/bin/sh
#===============================================================================
#
#          FILE: get_sys_log.sh
# 
#         USAGE: ./get_sys_log.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 2012年11月05日 10时50分59秒 CST
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
. $R_PATH/comm/get_raid_info.sh
#. $R_PATH/comm/set_raid_para.sh



#-------------------------------------------------------------------------------
#  rec_opt
#-------------------------------------------------------------------------------
rec_opt ()
{
	local _type=$1
	local _opt_info=$2
	local _time=""
	case $_type in
		net)
			if [ ! -f "/tmp/rec_opt_net"  ] ; then
				touch_file rec_opt_net
			fi
			_time=`date +%m/%d/%Y/%T`
			echo '['$_time']'--'['$_opt_info']' >> /tmp/rec_opt_net
			;;
		disk)
			if [ ! -f "/tmp/rec_opt_disk"  ] ; then
				touch_file rec_opt_disk
			fi
			_time=`date +%m/%d/%Y/%T`
			echo '['$_time']'--'['$_opt_info']' >> /tmp/rec_opt_disk
			;;
		raid)
			if [ ! -f "/tmp/rec_opt_raid"  ] ; then
				touch_file rec_opt_raid
			fi
			_time=`date +%m/%d/%Y/%T`
			echo '['$_time']'--'['$_opt_info']' >> /tmp/rec_opt_raid
			;;
		lun)
			if [ ! -f "/tmp/rec_opt_lun"  ] ; then
				touch_file rec_opt_lun
			fi
			_time=`date +%m/%d/%Y/%T`
			echo '['$_time']'--'['$_opt_info']' >> /tmp/rec_opt_lun
			;;
		target)
			if [ ! -f "/tmp/rec_opt_target"  ] ; then
				touch_file rec_opt_target
			fi
			_time=`date +%m/%d/%Y/%T`
			echo '['$_time']'--'['$_opt_info']' >> /tmp/rec_opt_target
			;;

		*)
			;;

	esac    # --- end of case ---
	return 0
}	# ----------  end of function rec_opt  ----------

get_sys_info ()
{
	touch_file info_tmp
	cat /proc/cpuinfo >> /tmp/info_tmp
	fdisk -l 2>/dev/null | sed -n -e '/^Disk\ \/dev\/sd/p' >> /tmp/info_tmp
	fdisk -l 2>/dev/null | sed -n -e '/^Disk\ \/dev\/md/p' >> /tmp/info_tmp
}	# ----------  end of function get_sys_info  ----------


get_sys_net_log ()
{
	#touch_file sys_net_log
	local intfs=`ls /sys/class/net/`
	intfs=`echo $intfs | sed -n -e 's/lo//p'`

	local mac_addr=""
	local lnk_status=""
	local speed=""
	local duplex=""
	for _devs in `echo $intfs`; do
		mac_addr=`cat /sys/class/net/$_devs/address`
		lnk_status=`cat /sys/class/net/$_devs/operstate`
		speed=`cat /sys/class/net/$_devs/speed`
		duplex=`cat /sys/class/net/$_devs/duplex`
		echo $_devs mac_addr:$mac_addr link_status:$lnk_status speed:$speed duplex:$duplex
	done

	if [ -f "/tmp/rec_opt_net"  ] ; then
		cat /tmp/rec_opt_net
	fi
	return 0
}	# ----------  end of function get_sys_net_log  ----------


get_sys_disk_log ()
{
	if [ -f "/tmp/rec_opt_disk" ] ; then
		cat /tmp/rec_opt_disk
	fi
	return 0
}	# ----------  end of function get_sys_disk_log  ----------


get_lun_log ()
{
	if [ -f "/tmp/rec_opt_lun"  ] ; then
		cat /tmp/rec_opt_lun
	fi
	return 0
}	# ----------  end of function get_lun_log  ----------


get_target_log ()
{
	if [ -f "/tmp/rec_opt_target"  ] ; then
		cat /tmp/rec_opt_target
	fi
	return 0
}	# ----------  end of function get_target_log  ----------


get_raid_log ()
{
	#touch /tmp/rec_opt_raid
	#chmod a+rw /tmp/rec_opt_raid
	if [ -f "/tmp/rec_opt_raid"  ] ; then
		#touch /tmp/raid_info.tmp
		#cat /tmp/rec_opt_raid > /tmp/raid_info.tmp
		#cat "" > /tmp/rec_opt_raid
		#cat /tmp/raid_info.tmp >> /tmp/rec_opt_raid
		#cat /tmp/_raid_status_ >> /tmp/rec_opt_raid
		#rm /tmp/raid_info.tmp
		cat /tmp/rec_opt_raid

	fi
	return 0
}	# ----------  end of function get_raid_log  ----------

get_sys_mb_log ()
{
	lspci | grep 8112 1>/dev/null 2>/dev/null
	if [ $? -ne 0 ] ; then
		echo "main board can't find bridge chip"
	else
		echo "main board work correct."
	fi

	lspci | grep 3512 1>/dev/null 2>/dev/null

	if [ $? -ne 0 ] ; then
		echo "carrier board can't find bridge chip."
	else
		echo "carrier board work correct."
	fi
	return 0
}	# ----------  end of function get_sys_mb_log  ----------

get_sys_log ()
{
	echo ================================
	echo -------sys_status_and_log-------
	echo ================================
	echo -------main_board_log-----------
	get_sys_mb_log
	echo -------net_status---------------
	get_sys_net_log
	echo -------disk_log-----------------
	get_sys_disk_log
	echo -------raid_log-----------------
	get_raid_log
	echo -------lun_log------------------
	get_lun_log
	echo -------target_log---------------
	get_target_log
	return 0
}	# ----------  end of function get_sys_log  ----------
#get_sys_log
