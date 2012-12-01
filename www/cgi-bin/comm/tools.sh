#!/bin/sh
#===============================================================================
#
#          FILE: tools.sh
# 
#         USAGE: ./tools.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: tongl (), 
#  ORGANIZATION: 
#       CREATED: 2012Äê09ÔÂ17ÈÕ 15ʱ40·Ö09Ãë CST
#      REVISION:  ---
#===============================================================================



#-------------------------------------------------------------------------------
# touch_file   
#-------------------------------------------------------------------------------

touch_file ()                                   # 0 for success
{
	local _filename=$1
	local _filepath=$2
	if [ -z $_filename ] ; then
		return 1
	else
		if [ -z $_filepath ] ; then
			_filepath="/tmp"
		fi
		if [ -f "$_filepath/$_filename" ] ; then
			   rm $_filepath/$_filename
			 touch $_filepath/$_filename
			 chmod a+rw $_filepath/$_filename
		else
			 touch $_filepath/$_filename
			 chmod a+rw $_filepath/$_filename
		fi
		return 0
	fi
}	# ----------  end of function touch_file  ----------



#-------------------------------------------------------------------------------
# rm files  
#-------------------------------------------------------------------------------

rm_file ()
{	
	local _filename=$1
	if [ -z $_filename ] ; then
		return 1
	else
		if [ -f "/tmp/$_filename" ] ; then
			  rm -f /tmp/$_filename
		fi
		return 0
	fi
	
}	# ----------  end of function rm_file  ----------


#-------------------------------------------------------------------------------
#  set runtime path for all scripts 
#-------------------------------------------------------------------------------
get_run_path_old ()
{
	local _result=""
	#local _filepath=/home/mars/Yunio/nas_svn/NAS/code/www/cgi-bin/sys.conf # tp
	local _filepath=/home/weiping/Yunio/nas_svn/NAS/code/www/cgi-bin/sys.conf
	# put the conf to etc
	_result=` sed '/^#/d'  $_filepath | sed -n -e '/RUN_PATH/p' | awk -F = {'printf $2'}`  
	echo $_result
}	# ----------  end of function set_run_path  ----------


#get_run_path_old

#-------------------------------------------------------------------------------
#  get run path from thttpd.conf  alternative function
#-------------------------------------------------------------------------------

#get_run_path ()
#{
#	local _result=""
#	local _conf="/etc/thttpd.conf"
#	
#	if  [ -f $_conf ]; then
#		#del the comment
#
#		_result=`sed -n -e '/dir=/p' $_conf`
#		echo $_result
#	else
#		echo "can't find thttpd.conf"
#		return 1
#	fi
##	echo $_result
#}	# ----------  end of function get_run_path  ----------
#
##get_run_path 


get_run_path ()
{
	local _filepn="/home/mars/Yunio/nas_svn/NAS/code/www/cgi-bin/"
	echo $_filepn
}	# ----------  end of function get_run_path  ----------

#get_run_path

#-------------------------------------------------------------------------------
#  format disk 
#-------------------------------------------------------------------------------

format_s_disk ()
{
	local _disk=$1
	local _blocksize=$2
	if [ -z "$_disk" ] ; then
		echo "disk empty!!"
		return 1
	fi

	if [ -z $_blocksize ] ; then
		_blocksize=65536
	fi
	  mkfs.ext2 $_disk -b$_blocksize <<EOF
y
y
EOF
	if [ $? -eq 0 ] ; then
		return 0
	else
		return 1
	fi
}	# ----------  end of function format_s_disk  ----------

#format_s_disk /dev/sda
#format_s_disk /dev/sdb
#format_s_disk /dev/sdc
#format_s_disk /dev/sdd

#-------------------------------------------------------------------------------
#  gen_escape_dev for /dev/sd... /dev/md...
#-------------------------------------------------------------------------------
gen_escape_dev ()
{
	local _dev=$1
	if [ -z "$_dev" ] ; then
		echo "para empty!!"
		return 1
	else
		local _h=`echo $_dev | awk -F '\/' '{print $2}'`
		local _t=`echo $_dev | awk -F '\/' '{print $3}'`
		local _res="\/$_h\/$_t"
		echo $_res
	fi
}	# ----------  end of function gen_seq_dev  ----------



#-------------------------------------------------------------------------------
#  get_dimision_count
#-------------------------------------------------------------------------------
get_dimi_count ()
{
	local _res_string=$1
	local _dimi=$2
	if [ -z $_res_string ]; then
		return 1
	else
		
		if  [ -z $_dimi ]; then
			_dimi="|"
		fi


		local _lnum=`echo $_res_string | sed 's/'$_dimi'/\n/g' | wc -l | sed 's/^[[:space:]]*//g'`
		_lnum=`expr $_lnum - 2`
		echo $_lnum
	fi
}	# ----------  end of function get_dimision_count  ----------

#get_dimision_count "|fdfsda|fa|sdd|af|"


#-------------------------------------------------------------------------------
#  trim comment blank space...
#-------------------------------------------------------------------------------
trim_c_s_b ()
{
	local _file_path=$1
	if [ -f "$_file_path" ] ; then
		  sed -i '/^$/d' $_file_path
		  sed -i '/^#/d' $_file_path
		  sed -i 's/^[[:space:]]*//g' $_file_path
		return 0
	else
		return 1
	fi
}	# ----------  end of function trim_c_s_b  ----------


addin_message ()
{
	local _filepath=$1
	local _value=$2
	
	if [ -z $_filepath ] || [ -z $_value  ] ; then
		return 1
	fi
	echo "$_value" >> /tmp/$_filepath 
}	# ----------  end of function addin_message  ----------




#-------------------------------------------------------------------------------
# format..
# year=2012
# mon=10
# date=10
# hour=23
# min=12
# sec=14
#-------------------------------------------------------------------------------
set_time ()
{
	local year=$1
	local mon=$2
	local date=$3
	local hour=$4
	local min=$5
	local sec=$6
	#check

	if [ -z "$year" ] || [ -z "$mon" ] || [ -z "$date" ] || [ -z "$hour" ] || [ -z "$min" ] || [ -z "$sec" ]; then
		return 1
	fi
	if [ -z "$sec" ] ; then
		date -s $mon$date$hour$min$year.00 1>/dev/null 2>/dev/null
	else
		date -s $mon$date$hour$min$year.$sec 1>/dev/null 2>/dev/null
	fi

	if [ $? -ne 0 ] ; then
		return 1
	else
		return 0
	fi
}	# ----------  end of function set_time  ----------


