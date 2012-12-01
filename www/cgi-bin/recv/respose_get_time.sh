#!/bin/sh
#===============================================================================
#
#          FILE: respose_get_time.sh
# 
#         USAGE: ./respose_get_time.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: tongl (), 
#  ORGANIZATION: 
#       CREATED: 2012年11月05日 16时16分52秒 CST
#      REVISION:  ---
#===============================================================================
echo Content-type:text/xml
echo 
echo "<time>"
date +%m/%d/%Y/%T
echo "</time>"

