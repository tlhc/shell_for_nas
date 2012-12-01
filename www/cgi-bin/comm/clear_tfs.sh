#!/bin/sh
#===============================================================================
#
#          FILE: clear_tfs.sh
# 
#         USAGE: ./clear_tfs.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: tongl (), 
#  ORGANIZATION: 
#       CREATED: 2012Äê09ÔÂ13ÈÕ 14ʱ44·Ö25Ãë CST
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


. "`get_r_path`/comm/tools.sh"                              # import

#-------------------------------------------------------------------------------
# clear tmp files 
#-------------------------------------------------------------------------------

rm_file net.file
if [ $? -eq 1 ] ; then
	echo "clear error!"
fi

rm_file netd.file
if [ $? -eq 1 ] ; then
	echo "clear error!"
fi

rm_file "netfinal.file"
if [ $? -eq 1 ] ; then
	echo "clear error!"
fi

#-------------------------------------------------------------------------------
# remove array_file 
#-------------------------------------------------------------------------------
rm_file nc_line_arr
if [ $? -eq 1 ] ; then
	echo "clear error!"
fi

rm_file nc_array
if [ $? -eq 1 ] ; then
	echo "clear error!"
fi



#-------------------------------------------------------------------------------
# remove echo file
#-------------------------------------------------------------------------------
rm_file echo_net
if [ $? -eq 1 ] ; then
	echo "clear error!"
fi

#rm_file "net*"
#rm_file "echo_*"
#rm_file "disk*"
#
  rm  /tmp/disk*
  rm  /tmp/lun*
  rm /tmp/echo_*
  rm /tmp/lun*
  rm /tmp/bf*
  rm /tmp/none_*
  rm /tmp/target_*



echo Content-type:text/html
echo ""
echo "clear sucess..."

