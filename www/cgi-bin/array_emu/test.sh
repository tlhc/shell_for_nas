#!/bin/bash - 
#===============================================================================
#
#          FILE: test.sh
# 
#         USAGE: ./test.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: tongl 
#  ORGANIZATION: 
#       CREATED: 2012年09月11日 22时07分42秒 CST
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

array_emu="array_emu"                           # functions fd

create_array="`get_r_path`/$array_emu/create_array.sh"
del_array="`get_r_path`/$array_emu/del_array.sh"
push_elements="`get_r_path`/$array_emu/push_elements.sh"
pop_elements="`get_r_path/`$array_emu/pop_elements.sh"
getlen="`get_r_path`/$array_emu/getlen.sh"
get_elements="`get_r_path`/$array_emu/get_elements.sh"
rm_elements="`get_r_path`/$array_emu/remove_elements.sh"

$create_array array

for i in $(seq 10); do

	if  [ $i -eq 5 ]; then
		$push_elements array fafaafa
	fi
	$push_elements array $i
done

$get_elements array 5

$getlen array

#$rm_elements array 5
echo "before"
cat /tmp/array

$rm_elements array 5 > /dev/null
$rm_elements array 6 > /dev/null
$rm_elements array 7 > /dev/null
$rm_elements array 8 > /dev/null
echo "after"
cat /tmp/array

