#!/bin/sh
#===============================================================================
#
#          FILE: getnetinfo.sh
# 
#         USAGE: ./getnetinfo.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: tongl
#  ORGANIZATION: 
#       CREATED: 2012Äê09ÔÂ06ÈÕ 11ʱ52·Ö59Ãë CST
#      REVISION:  ---
#===============================================================================

#netcards=`cat /proc/net/dev | awk '{printf $1}'`
#echo -e "$netcards"
#########

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


create_array="$R_PATH/array_emu/create_array.sh"
del_array="$R_PATH/array_emu/del_array.sh"
push_elements="$R_PATH/array_emu/push_elements.sh"
pop_elements="$R_PATH/array_emu/pop_elements.sh"
getlen="$R_PATH/array_emu/getlen.sh"
get_elements="$R_PATH/array_emu/get_elements.sh"
rm_elements="$R_PATH/array_emu/remove_elements.sh"
get_array="$R_PATH/array_emu/get_array.sh"

netcard_tmp=`cat /proc/net/dev | sed -n -e '3,$p' | awk '{printf $1}'`

#netcards=`echo $netcard_tmp | sed 's/:/\n/g'`

touch_file net.file
echo $netcard_tmp | sed 's/:/\n/g' > /tmp/net.file

$create_array nc_array
$create_array nc_line_arr


#process the last line and lo (remove lo intf)
sed -i '/^lo/d' /tmp/net.file 
sed -i '/^$/d' /tmp/net.file

#ava intf info (for all)
if [ -f /tmp/net.file ] ; then
	touch_file netd.file
	for NC in `cat /tmp/net.file`; do
		s_net_info=`/sbin/ifconfig $NC`
		echo "$s_net_info" >> /tmp/netd.file 
	done
fi

#remove inet6
#getline count 
sed -i '/inet6/d' /tmp/netd.file
lc_net=`sed -n '$=' /tmp/net.file`

#nc_array store all ava intfname
#i=0
if [ -f /tmp/net.file ] ; then
	for NCE in `cat /tmp/net.file`; do 
#		nc_array=("${nc_array[@]}" $NCE)
#		nc_array[$i]=$NCE
		$push_elements nc_array $NCE
#		let "i=$i+1"
	done
fi

#echo ${nc_array[@]}
#j for fun
for NCEE in `$get_array nc_array` ; do
	$push_elements nc_line_arr `sed -n -e '/'$NCEE'/=' /tmp/netd.file`
done
#echo ${nc_line_arr[@]}

#echo "nc_line_arr:::"
#echo ${nc_line_arr[@]}
#length=${#nc_line_arr[@]}
#echo "len=$length"
#

lc_netd=`sed -n '$=' /tmp/netd.file`

flag=1
arr_count=1
nc_count=1
nl_num=0


touch_file netfinal.file

#if [ -f /tmp/netfinal.file ] ; then
#	rm /tmp/netfinal.file
#	touch /tmp/netfinal.file
#	chmod ogu+rw /tmp/netfinal.file
#else
#	touch /tmp/netfinal.file
#	chmod ogu+rw /tmp/netfinal.file
#fi
#
#format the result then can use awk 
#let "la_num=${#nc_line_arr[@]} - 1"
#let "la_num=`$getlen nc_line_arr` - 1"
#echo $la_num
#echo $la_num

inc=1
for NCDE in `$get_array nc_line_arr`; do
	arr_count=`expr $arr_count + $inc`		    # index for the next element
	if [ $flag -eq 1 ] ; then                   # exec for first time
#		let "nl_num=${nc_line_arr[$arr_count]} - 1"
		nl_num=`$get_elements nc_line_arr $arr_count`
		nl_num=`expr $nl_num - $inc`
		fstr=`sed -n ''$NCDE','$nl_num'p' /tmp/netd.file | sed -n -e '/inet/p'`
		echo "net_card: " `$get_elements nc_array $nc_count` $fstr >> /tmp/netfinal.file
		flag=0
	else
		if  [ $arr_count -ge `$getlen nc_line_arr` ]; then # the last element
			fstr=`sed -n ''$NCDE','$lc_netd'p' /tmp/netd.file | sed -n -e '/inet/p'`
			echo "net_card: " `$get_elements nc_array $nc_count` $fstr >> /tmp/netfinal.file
			break
		else
			nl_num=`$get_elements nc_line_arr $arr_count`
			nl_num=`expr $nl_num - $inc` 
			fstr=`sed -n ''$NCDE','$nl_num'p' /tmp/netd.file | sed -n -e '/inet/p'`
			echo "net_card: " `$get_elements nc_array $nc_count` $fstr >> /tmp/netfinal.file
		fi
		nl_num=`$get_elements nc_line_arr $arr_count`
		nl_num=`expr $nl_num - $inc`
	fi
	nc_count=`expr $nc_count + $inc`
done

exit 0







#
#file="/tmp/netfinal.file"
#
#
#echo Content-type text/xml
#echo
##
#
#mask1=`sed -n -e '1p' $file | awk 'NF > 1' | awk '{printf $6}' | awk -F: '{printf $2}'`
#mask2=`sed -n -e '2p' $file | awk 'NF > 1' | awk '{printf $6}' | awk -F: '{printf $2}'`
#net1= sed '1p' /tmp/net.file
#net2= sed '2p' /tmp/net.file
#
#route -n | sed -n -e '/'$mask1'/p' #| sed '/'$net1'/'
#route -n | sed '/'$mask1' && 'sed '1p''/p'



#-------------------------------------------------------------------------------
# first create the echo file 
# then echo back to client
#-------------------------------------------------------------------------------
#
#echo_net_file="/tmp/echo_net_file"

#
#if [ -f $echo_net_file ] ; then
#	rm $echo_net_file
#	touch $echo_net_file
#	chmod a+rw $echo_net_file
#else
#	touch $echo_net_file
#	chmod a+rw $echo_net_file
#fi
#
#
#echo "<netcards>"
#	echo "<netcard_x>"
#		echo "<name>"
#			echo "fasdfas"
#		echo "</name>"
#	
#		echo "<ip_addr>"
#			sed -n -e '1p' $file | awk 'NF > 1' | awk '{printf $4}' | awk -F: '{printf $2}'
#		echo "</ip_addr>"
#	
#		echo "<ip_mask>"
#	
#			sed -n -e '1p' $file | awk 'NF > 1' | awk '{printf $6}' | awk -F: '{printf $2}'
#		echo "</ip_mask>"
#	
#		echo "<gateway>"
#			sed -n -e '1p' $file | awk 'NF > 1' | awk '{printf $5}' | awk -F: '{printf $2}'
#		echo "</gateway>"
#	echo "</netcard_x>"
#
#	echo "<netcard_x>"
#
#		echo "<name>"
#
#		echo "</name>"
#	
#		echo "<ip_addr>"
#			sed -n -e '2p' $file | awk 'NF > 1' | awk '{printf $4}' | awk -F: '{printf $2}'
#		echo "</ip_addr>"
#	
#		echo "<ip_mask>"
#			sed -n -e '2p' $file | awk 'NF > 1' | awk '{printf $6}' | awk -F: '{printf $2}'
#		echo "</ip_mask>"
#	
#		echo "<gateway>"
#			sed -n -e '2p' $file | awk 'NF > 1' | awk '{printf $5}' | awk -F: '{printf $2}'
#		echo "</gateway>"
#	echo "</netcard_x>"
#echo "</netcards>"
#



#awk '{printf $1}' $file

#awk 'NF > 1' $file | awk '{printf $4}'
#awk 'NF > 1' $file | awk '{printf $5}'
#awk 'NF > 1' $file | awk '{printf $6}'
#
#awk '{printf $1, $2 ,$3, $4, $5, $6 }' /tmp/netfinal.file
#echo ${nc_line_arr[0]}
#echo ${nc_line_arr[1]}

#echo ${nc_line_arr[@]}

#delete more info

#|echo $?| sed '/1,$/w/'/tmp/net.file

#lo="lo"
#for i in $netcards; do
#	if [ $i==$lo ] ; then
#		echo $i 
#	else
#		echo -e "wlan or eth"
#	fi
#done

