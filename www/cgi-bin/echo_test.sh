#!/bin/sh 
#===============================================================================
# #          FILE: echo_test.sh
# 
#         USAGE: ./echo_test.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: tongl (), 
#  ORGANIZATION: 
#       CREATED: 2012Äê09ÔÂ14ÈÕ 14ʱ50·Ö22Ãë CST
#      REVISION:  ---
#===============================================================================

. ./create_echo/c_echo_header.sh
. ./create_echo/c_echo_net.sh

filename="echo_net"
create_echo_file $filename
create_echo_header $filename xml

gen_e_netinfo_h echo_net
gen_e_netcardx echo_net eth1 192.178.1.1 255.255.255.0 0.0.0.0 
gen_e_netcardx echo_net eth0 192.178.2.2 255.255.255.0 0.0.0.0 
gen_e_netinfo_t echo_net

cat /tmp/echo_net


#test
