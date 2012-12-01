#!/bin/sh
#===============================================================================
#
#          FILE: chmod_for_all.sh
# 
#         USAGE: ./chmod_for_all.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 2012年09月17日 22时38分59秒 CST
#      REVISION:  ---
#===============================================================================

cd ..
find . -iname "*.cgi" -execdir  chmod 777 {} \;
find . -iname "*.sh" -execdir  chmod 777 {} \;
exit 0 

