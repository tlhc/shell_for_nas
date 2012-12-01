#!/bin/sh
#===============================================================================
#
#          FILE: create_echo_header.sh
# 
#         USAGE: ./create_echo_header.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: tongl (), 
#  ORGANIZATION: 
#       CREATED: 2012Äê09ÔÂ13ÈÕ 16ʱ59·Ö00Ãë CST
#      REVISION:  ---
#===============================================================================

html_type="html"
xml_type="xml"
text_type="text"


create_echo_file ()
{
	#$1 filename
	if  [ -z $1 ]; then
		return 1
	fi

	if  [ -f "/tmp/$1" ]; then
		  rm "/tmp/$1"
		  touch "/tmp/$1"
		  chmod a+rw "/tmp/$1"
	else
		  touch "/tmp/$1"
		  chmod a+rw "/tmp/$1"
	fi
}	# ----------  end of function create_echo_file  ----------


create_echo_header ()
{
	#$1 file
	#$2 echo_type
	if [ -z $2 ] || [ -z $1 ]; then
		return 1
	fi

	if [ $2 = $html_type ] ; then
		echo Content-type:text/html >> "/tmp/$1"
		echo "" >> "/tmp/$1"
	elif [ $2 = $xml_type ] ; then
		echo Content-type:text/xml >>  "/tmp/$1"
		echo "" >> "/tmp/$1"
	elif [ $2 = $xml_type ] ; then
		echo Content-type:text/text >>  "/tmp/$1"
		echo "" >> "/tmp/$1"
	else
		echo Content-type:text/xml >>  "/tmp/$1"
		echo "" >> "/tmp/$1"
		echo "<error>"  >> "/tmp/$1"
		echo "error_string...." >> "/tmp/$1"
		echo "</error>" >> "/tmp/$1"
	fi
}	# ----------  end of function create_echo_header  ----------


create_tag_header ()
{

	if  [ -z $1 ] || [ -z $2 ]; then            # $1 = tag_name $2=filename
		return 1
	fi
	echo "<$1>" >> "/tmp/$2"
}	# ----------  end of function create_tag_header  ----------




create_tag_tail ()
{
	if  [ -z $1 ] || [ -z $2 ]; then            # $1 = tag_name $2=filename
		return 1
	fi
	echo "</$1>" >> "/tmp/$2"
}	# ----------  end of function create_tag_tail  ----------

