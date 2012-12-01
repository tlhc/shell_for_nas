#!/bin/sh
#===============================================================================
#
#          FILE: c_tools.sh
# 
#         USAGE: ./c_tools.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: tongl (), 
#  ORGANIZATION: 
#       CREATED: 2012Äê09ÔÂ17ÈÕ 11ʱ39·Ö25Ãë CST
#      REVISION:  ---
#===============================================================================

clear_echo_tmpfs ()
{
	rm -f /tmp/echo_net
	return 0
}	# ----------  end of function clear_echo_tmpfs  ----------


gen_tag_h ()                                    # gen header 
{
	local _filename=$1
	local _header=$2
	if [ -z $_filename ] || [ -z $_header ] ; then
		return 1
	fi
	echo "<$_header>" >> /tmp/$_filename
	return 0
}	# ----------  end of function gen_tag_h  ----------


gen_tag_t ()                                    # gen tail
{
	local _filename=$1
	local _header=$2
	if [ -z $_filename ] || [ -z $_header ] ; then
		return 1
	fi
	echo "</$_header>" >> /tmp/$_filename
	return 0
}	# ----------  end of function gen_tag_t  ----------


gen_tag_value ()
{
	local _filename=$1
	local _value=$2
	if [ -z "$_filename" ] || [ -z "$_value" ] ; then
		return 1
	fi
	echo $_value >> /tmp/$_filename
	return 0
}	# ----------  end of function gen_tag_value  ----------



#-------------------------------------------------------------------------------
#  for error
#-------------------------------------------------------------------------------
gen_error_message ()
{
	if [ -z "$1" ] ; then
		return 1
	else
		echo Content-type:text/xml
		echo "" 
		echo "<r_value>"
		echo "<value>"
		echo 1
		echo "</value>"
		echo "<info>"
		echo "$1"
		echo "</info>"
		echo "</r_value>"
		return 0
	fi
}	# ----------  end of function gen_error_message  ----------

gen_success_message ()
{
	echo Content-type:text/xml
	echo "" 
	echo "<r_value>"
	echo "<value>"
	echo 0
	echo "</value>"
	if  [ -z "$1" ]; then
		echo "<info>"
		echo "none"
		echo "</info>"
	else
		echo "<info>"
		echo "$1"
		echo "</info>"
	fi
	echo "</r_value>"
	return 0
}	# ----------  end of function gen_success_message  ----------


gen_message ()
{
	echo Content-type:text/xml
	echo "<value>"
	echo $1
	echo "</value>"
	return 0
}	# ----------  end of function gen_success_message  ----------
