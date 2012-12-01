#!/bin/sh
#===============================================================================
#
#          FILE: set_target_para.sh
# 
#         USAGE: ./set_target_para.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 2012年10月26日 17时48分20秒 CST
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


kill_tgt_serv ()
{
	local pid=`ps -ef | sed -n -e '/ietd\ start/p' | awk '{print $1}'`
	expr $pid + 1 1>/dev/null 2>/dev/null
	if  [ $? -eq 0 ]; then
		kill -9 $pid 1>/dev/null 2>/dev/null
		return 0
	else
		return 1
	fi
}	# ----------  end of function kill_tgt_serv  ----------

start_ietd_srv ()
{
	ietd start
	local pid=`ps -ef | sed -n -e '/ietd\ start/p' | awk '{print $1}'`
	if  [ -z "$pid" ]; then
		return 1
	else
		return 0
	fi
}	# ----------  end of function start_ietd_srv  ----------


is_ietd_run ()
{
	local pid=`ps -ef | sed -n -e '/ietd\ start/p' | awk '{print $1}'`
	if  [ -z "$pid" ]; then
		echo 1
		return 1
	else
		echo 0
		return 0
	fi
}	# ----------  end of function is_ietd_run  ----------

