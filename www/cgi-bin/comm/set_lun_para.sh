#!/bin/sh
#===============================================================================
#
#          FILE: set_lun_para.sh
# 
#         USAGE: ./set_lun_para.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 2012年10月14日 16时19分11秒 CST
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
#. $R_PATH/create_echo/c_tools.sh


create_lun_table ()
{
	local _fp="$R_PATH/data/lun_table.conf"
	if  [ -f "$_fp" ]; then
		return 1
	else
		touch $R_PATH/data/lun_table.conf
		chmod a+rw $R_PATH/data/lun_table.conf
		if [  $? -ne 0 ] ; then
			return 1
		else
			return 0
		fi
	fi
}	# ----------  end of function create_lun_table  ----------


#create_lun_table 

delete_lun_table ()
{
	local _fp="$R_PATH/data/lun_table.conf"
	  rm -f $_fp
	if [  $? -ne 0 ] ; then
		return 1
	else
		return 0
	fi
}	# ----------  end of function delete_lun_table  ----------


clear_lun_table ()
{
	local _fp="$R_PATH/data/lun_table.conf"
	  rm -f $_fp
	if [  $? -ne 0 ] ; then
		return 1
	else
		return 0
	fi
	  touch $_fp
	if [  $? -ne 0 ] ; then
		return 1
	else
		return 0
	fi
	  chmod a+rw $_fp
	if [  $? -ne 0 ] ; then
		return 1
	else
		return 0
	fi
	return 0
}	# ----------  end of function clear_lun_table  ----------

#-------------------------------------------------------------------------------
#  add value to lun table...
#  res format...
#  |Lun0|alias=aaa|bl_target=none|vol=/dev/sda|lun_size=250G|lun_rmd_size=100G|"Lun 0 Path=/dev/md0,Type=fileio,"
#-------------------------------------------------------------------------------
add_value_to_lunT ()
{
	local _init_val="$1"
	local _fp="$R_PATH/data/lun_table.conf"

	if [ -z "$_init_val" ] ; then
		return 1
	else
#		echo $_init_val
		#-------------------------------------------------------------------------------
		#  all lun_values....
		#-------------------------------------------------------------------------------
		local _lun_id=`echo $_init_val | awk -F '|' '{print $2}'`
		local _lun_alias=`echo $_init_val | awk -F '|' '{print $3}'`
		local _bl_target=`echo $_init_val | awk -F '|' '{print $4}'`
		local _vol=`echo $_init_val | awk -F '|' '{print $5}'`
		local _lun_size=`echo $_init_val | awk -F '|' '{print $6}'`
		local _lun_rmd_size=`echo $_init_val | awk -F '|' '{print $7}'`
#		local _add_info="`echo $_init_val | awk -F '|' '{print $8}'`"
		

		if [ -z "$_lun_id" ] || [ -z "$_lun_alias" ] || [ -z "$_bl_target" ] || [ -z "$_vol" ] || [ -z "$_lun_size" ]; then
			return 1
		fi
		#echo $_lun_id
		#echo $_lun_alias
		#echo $_bl_target
		#echo $_vol
		#echo $_lun_size
		#echo $_lun_rmd_size
		#echo $_add_info
#		_lun_rmd_size="none"
		local _res_str=""
		_res_str=$_lun_id'|'$_lun_alias'|'$_bl_target'|'$_vol'|'$_lun_size'|'$_lun_rmd_size'|' #"$_add_info"
#		echo $_res_str
		echo $_res_str >> $_fp
		return 0
	fi
}	# ----------  end of function add_value_to_lunT  ----------



#-------------------------------------------------------------------------------
#  test...
#-------------------------------------------------------------------------------
#add_value_to_lunT "|Lun0|alias=aaa|bl_target=none|vol=/dev/sda|lun_size=250G|lun_rmd_size=100G|\"Lun 0 Path=/dev/md0,Type=fileio,\""
#add_value_to_lunT "|Lun0|alias=aaa|bl_target=none|vol=/dev/sda|lun_size=250G|lun_rmd_size=100G|"
#add_value_to_lunT "Lun0|alias=cccc|bl_target=undefined|vol=undefined|lun_size=1000.2GB|lun_rmd_size=none|"
#-------------------------------------------------------------------------------
#  del_value_ in lun table...
#-------------------------------------------------------------------------------
del_value_from_lunT ()
{
	local _fp="$R_PATH/data/lun_table.conf"
	local _lun_id=$1
	local _lun_devs=$2


	if [ -z "$_lun_id" ] ; then
		return 1
	fi
	if [ -z "$_lun_devs" ] ; then
		#just pass lun_id
		  cp $_fp /tmp/lun_table.tmp
		  chmod a+rw /tmp/lun_table.tmp
		trim_c_s_b "/tmp/lun_table.tmp"
		local _lines=`cat /tmp/lun_table.tmp | wc -l | sed 's/^[[:space:]]*//g'` 
		local _tst=`expr $_lines + 1`

		local _t_lun_id=""
		local _t_lun_devs=""
		if [ $? -ne 0 ] ; then
			return 1
		else
			for _indx in `seq $_lines`; do
				unset _t_lun_id
				_t_lun_id=`sed -n -e ''$_indx'p' /tmp/lun_table.tmp | awk -F '|' '{print $1}'`
				if [ "$_t_lun_id" = "$_lun_id" ] ; then
					  sed -i '/^'$_t_lun_id'/d' /tmp/lun_table.tmp
					return 0
				fi
			done
		fi
		return 0
	else
		#pass lun_id and lun_devs.
		return 0
	fi
	return 1
}	# ----------  end of function del_value_to_lunT  ----------

#del_value_from_lunT Lun0



#
## Example iscsi target configuration
#
## a first account
#IncomingUser jdoe YourSecurePwd1
## another one, for a windows user.
#IncomingUser iqn.1991-05.com.microsoft:JDOE-PC YourSecurePwd2
#
##If mutual CHAP shall be employed, you need
#OutgoingUser jack YourSecurePwd2
#
## The target name must be a globally unique name, the iSCSI
## standard defines the "iSCSI Qualified Name" as follows:
##
## iqn.yyyy-mm.<reversed domain name>[:identifier]
#
#Target iqn.2007-01.org.debian.foobar:mydisk1
#        IncomingUser joe YourSecurePwd1
#        OutgoingUser jim YourSecurePwd2
#        #make sure the partition isn't mounted :
#        #Lun 0 Path=/dev/sdh,Type=fileio
#
#
#Target iqn.2007-01.org.debian.foobar:CDs
#        IncomingUser joe YourSecurePwd1
#        OutgoingUser jim YourSecurePwd2
#        #make sure the partition isn't mounted :
#        Lun 0 Path=/dev/scd0,Type=fileio,IOMode=ro
#        Lun 1 Path=/dev/scd1,Type=fileio,IOMode=ro
#        #Lun 2 Path=/dev/hdX,Type=fileio,IOMode=ro
#        Lun 3 Path=/srv/debian-20070313-kfreebsd-i386-install.iso,Type=fileio,IOMode=ro
#
#


#-------------------------------------------------------------------------------
#  construct_lun_acc_str for access lun..
#-------------------------------------------------------------------------------
construct_lun_acc_str ()
{
	#"Lun 0 Path=/dev/md0,Type=fileio,IOMode=wb\""
#	IOMode wb ro
	local _lun_id=$1
	local _dev_no=$2
	local _access_mode=$3
	local _res_str="Lun $_lun_id Path=$_dev_no,Type=fileio,IOMode=$_access_mode"
	echo '"'$_res_str'"'
}	# ----------  end of function construct_lun_acc_str  ----------
#construct_lun_acc_str 0 /dev/sda wb
