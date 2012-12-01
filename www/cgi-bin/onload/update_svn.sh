#!/bin/bash - 
#===============================================================================
#
#          FILE: update_svn.sh
# 
#         USAGE: ./update_svn.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 2012年09月24日 14时41分52秒 CST
#      REVISION:  ---
#===============================================================================


cd /home/weiping/Yunio/NAS/code/
  svn update /home/weiping/Yunio/NAS/code/www/transmitt.js

  svn update /home/weiping/Yunio/NAS/code/www/onload.js
  svn update /home/weiping/Yunio/NAS/code/www/onloadfeng.js
  svn update /home/weiping/Yunio/NAS/code/www/main.html
  svn update /home/weiping/Yunio/NAS/code/www/index.html

#  svn update /home/weiping/Yunio/NAS/code/www/jquery/IP/ip-input.css
#  svn update /home/weiping/Yunio/NAS/code/www/jquery/IP/jquery.ipInput.js
#  svn update /home/weiping/Yunio/NAS/code/www/jquery/jquery-1.7.2.min.js
#  svn update /home/weiping/Yunio/NAS/code/www/jquery/js/transmitt.js
#
#  svn update /home/weiping/Yunio/NAS/code/www/jquery/modaldiv/jquery.divbox.js
#  svn update /home/weiping/Yunio/NAS/code/www/jquery/modaldiv/jquery.js
#  svn update /home/weiping/Yunio/NAS/code/www/jquery/tab/easyui.css
#  svn update /home/weiping/Yunio/NAS/code/www/jquery/tab/easyui.min.js
#
#  svn update /home/weiping/Yunio/NAS/code/www/jquery/tab/icon.css
#  svn update /home/weiping/Yunio/NAS/code/www/jquery/tab/jquery 1.6.1.min.js
#  svn update /home/weiping/Yunio/NAS/code/www/jquery/tab/jquery-1.2.1.pack.js
#
#  svn update /home/weiping/Yunio/NAS/code/www/jquery/tab/ui.tabs.css
#  svn update /home/weiping/Yunio/NAS/code/www/jquery/tab/ui.tabs.js
  svn update /home/weiping/Yunio/NAS/code/www/jquery/*/*

  pkill thttpd
  thttpd -C /etc/thttpd.conf

echo Content-type:text/html
echo ""
echo "yes---update"
echo "thttpd_restart.."
