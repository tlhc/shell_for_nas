#!/bin/sh 
#===============================================================================
#
#          FILE: get_s_disk_info.sh
# 
#         USAGE: ./get_s_disk_info.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: tongl (), 
#  ORGANIZATION: 
#       CREATED: 2012Äê09ÔÂ18ÈÕ 14ʱ04·Ö23Ãë CST
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
. $R_PATH/comm/get_raid_info.sh
#. $R_PATH/create_echo/c_echo_header.sh

#-------------------------------------------------------------------------------
#  get org info from fdisk
#-------------------------------------------------------------------------------
get_org_disk_info ()
{

	if [ -z $1 ] ; then
		local _filename="disk_info"
	else
		local _filename=$1
	fi
	touch_file $_filename 
	if [ $? -eq 1 ] ; then
		echo "can't touch_file!"
		return 1
	fi
	  fdisk -l | sed '/NTFS/d' | sed '/Device Boot/d' 1> /tmp/$_filename 2>/tmp/fdisk_err
#	  fdisk -l 1> /tmp/$_filename 2>/tmp/fdisk_err
#	  sed -i '/NTFS/d' /tmp/$_filename 1>/dev/null 2>/dev/null
#	  sed -i '/Device Boot/d' /tmp/$_filename 1>/dev/null 2>/dev/null
#	sed -n -e '/Disk \/dev\/sd/p' /tmp/$_filename |  awk '{print $0}'
#	sed -n -e '/Disk \/dev\/sd/p' ./finfo |  awk '{print $1}' 
#	sed -n -e '/Disk \/dev\/sd/p' ./finfo |  awk '{print $2}' 
#	sed -n -e '/Disk \/dev\/sd/p' ./finfo |  awk '{print $3}' 
	return 0
}	# ----------  end of function get_org_disk_info  ----------

#get_org_disk_info diskinfo

#-------------------------------------------------------------------------------
#  filter_in_md_dev remove disk message in raid dev...
#-------------------------------------------------------------------------------
filter_in_md_dev ()
{
	local _r_count=""
	_r_count=`get_raid_no_g`
#	echo $_r_count
#	echo $_r_count
	local _md_no=""
	local _escape_dev=""
#	expr $_r_count + 1 1>/dev/null 2>/dev/null
	if [ -z "$_r_count" ] ; then
		return 1
	else
		if [ -f "/tmp/bf_disk_info" ] ; then
			local _filter_s_dev=""
			for _md_no in `echo $_r_count`; do
#				unset _md_no
				unset _filter_s_dev
#				_md_no=`expr $_indx - 1`
				_filter_s_dev=`get_raid_releate_disk "/dev/md$_md_no"`
				if [ -z "$_filter_s_dev" ] ; then
					return 1
				fi
				for _s_dev in `echo $_filter_s_dev`; do
					unset _escape_dev
					_escape_dev=`gen_escape_dev "$_s_dev"`
					  sed -i '/'$_escape_dev'/d' /tmp/bf_disk_info 2>/dev/null
				done
			done
		else
			return 1
		fi
	fi
}	# ----------  end of function filter_in_md_dev  ----------

#-------------------------------------------------------------------------------
#  get_disk_brief infomation
#-------------------------------------------------------------------------------
get_disk_brief ()
{
	if  [ -z $1 ] ; then
		local _org_filename="disk_info"
	else
		local _org_filename=$1
	fi
	if  [ -z $2 ]; then
		local _bf_filename="bf_disk_info"
	else
		local _bf_filename=$2
	fi
	#if [ -z $_org_filename ] || [ -z $_bf_filename ] ; then
	#	echo "filename empty!!"
	#	return 1
	#fi
	#find sd dev and hd dev
	touch_file $_bf_filename
	sed -n -e '/Disk \/dev\/sd/p' /tmp/$_org_filename > /tmp/$_bf_filename  # get sd.. info
#	sed -n -e '/Disk \/dev\/hd/p' /tmp/$_org_filename >> /tmp/$_bf_filename  # get sd.. info
	#filter_in_md_dev that dev already in raid...
	filter_in_md_dev
	return 0
}	# ----------  end of function get_disk_brief  ----------

#get_disk_brief
#-------------------------------------------------------------------------------
#  get_disk_count info from disk brief
#-------------------------------------------------------------------------------
get_disk_count ()
{
	if [ -z $1 ] ; then
		local _filename="bf_disk_info"
	else
		local _filename=$1
	fi
	
	if [ -f /tmp/$_filename ] ; then
		sed -i '/^$/d' /tmp/$_filename          # remove blank line
		cat /tmp/$_filename | wc -l | sed 's/^[[:space:]]*//g'
		return 0
	else
		gen_error_message "can't find files when get_disk_count..."
		return 1
	fi
}	# ----------  end of function get_disk_count  ----------



#-------------------------------------------------------------------------------
#  get disk no
#-------------------------------------------------------------------------------
get_disk_no ()
{
	if [ -z $2 ] ; then
		local _filename="bf_disk_info"
	else
		local _filename=$2
	fi
	local _fp="/tmp/$_filename"

	if [ -z $1 ] ; then
		echo "invalid disk no!"
		return 1
	fi

	if [ -f $_fp ] ; then
		sed -n -e ''$1'p' $_fp | awk '{print $2}' | awk -F : '{print $1}'
		return 0
	else
		echo "file not exist!!"
		return 1
	fi
	return 1
}	# ----------  end of function get_disk_no  ----------


get_disk_size ()
{
	if [ -z $2 ] ; then
		local _filename="bf_disk_info"
	else
		local _filename=$2
	fi
	local _fp="/tmp/$_filename"

	if [ -z $1 ] ; then
		echo "invalid disk no!"
		return 1
	fi


	if [ -f $_fp  ] ; then
		local _size=`sed -n -e ''$1'p' $_fp | awk '{print $3}'`
		echo $_size"GB"
	else
		echo "file not exist!!"
		return 1
	fi
}	# ----------  end of function get_disk_size  ----------



#-------------------------------------------------------------------------------
#  get disk free size
#-------------------------------------------------------------------------------
get_disk_fsize ()
{
	local _return_info=""
	if [ -z $2 ] ; then
		local _filename="bf_disk_info"
	else
		local _filename=$2
	fi
	local _fp="/tmp/$_filename"

	if [ -z $1 ] ; then
		echo "invalid disk no!"
		return 1
	fi

	#_dno /dev/sda
	#_seq_dev dev
	#_seq_subdev sda
	#_res_seq \/dev\/sda
	#_res /dev/sda /mnt/sdb ext2 rw 0 0
	if [ -f $_fp  ] ; then
		local _dno=`sed -n -e ''$1'p' $_fp | awk '{print $2}' | awk -F : '{print $1}'`
		local _seq_dev=`echo $_dno | awk -F '\/' '{print $2}'`
		local _seq_subdev=`echo $_dno | awk -F '\/' '{print $3}'`
		local _res_seq=""
		local _res=""
		#`cat /etc/mtab | sed -n -e '/'$_res_seq'/p'`
		local _condition=""
		if [ -z $_seq_dev ] || [ -z $_seq_subdev ] ; then
			unset _res_seq
			unset _condition
			unset _res
			return 1
		else
			_res_seq="\/$_seq_dev\/$_seq_subdev"
			_res=`cat /etc/mtab | sed -n -e '/'$_res_seq'/p'`
			_condition=`echo $_res | awk '{print $1}'`
		fi
		#echo $_res_seq
		#echo $_condition
		#echo $_seq_subdev sss
		#echo $_seq_dev
		if [ -z $_condition ] ; then                  # not mount
			if [ -d /mnt/$_seq_subdev ] ; then  # don't have dir
				  mount $_dno /mnt/$_seq_subdev 2>/dev/null
				_return_info=`  df -h $_dno | awk '{print $3}' | sed -n -e '2p'`
				  umount /mnt/$_seq_subdev 2>/dev/null
				echo $_return_info
				return 0
	 		else
				  mkdir /mnt/$_seq_subdev 2>/dev/null
				  mount $_dno /mnt/$_seq_subdev 2>/dev/null
#				  df -lh $_dno
				_return_info=`  df -h $_dno | awk '{print $3}' | sed -n -e '2p'`
				  umount /mnt/$_seq_subdev 2>/dev/null
				echo $_return_info
				return 0
			fi
		else                                    # mount
			_return_info=`  df -h $_dno | awk '{print $3}' | sed -n -e '2p'`
			echo $_return_info
			return 0
		fi
#		df /dev/$_dno 2>/dev/null
#		echo $_size
	else
		echo "file not exist!!"
		return 1
	fi
}	# ----------  end of function get_disk_size  ----------

#get_org_disk_info
#get_disk_brief
#get_disk_fsize 1




#-------------------------------------------------------------------------------
#  if label exist return label if not exist return ""
#-------------------------------------------------------------------------------

get_disk_label ()
{
	if [ -z $2 ] ; then
		local _filename="bf_disk_info"
	else
		local _filename=$2
	fi
	local _fp="/tmp/$_filename"

	if [ -z $1 ] ; then
		echo "invalid disk no!"
		return 1
	fi

	if [ -f $_fp ] ; then
		local _dno=`sed -n -e ''$1'p' $_fp | awk '{print $2}' | awk -F : '{print $1}'`
		  e2label $_dno 2>/dev/null
		return 0
	else
		echo "file not exist!!"
		return 1
	fi
	return 1
}	# ----------  end of function get_disk_no  ----------

#
#get_org_disk_info
#get_disk_brief
#filter_in_md_dev
#

#get_disk_label 1

#get_disk_no 1
#get_disk_no 2
#get_disk_no 3
#-------------------------------------------------------------------------------
#  for test shs
#-------------------------------------------------------------------------------
#get_org_disk_info 
#get_disk_brief 
#cat /tmp/bf_disk_info
#cat /tmp/bf_disk_info
#get_disk_count 
