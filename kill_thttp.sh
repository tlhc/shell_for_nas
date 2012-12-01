#!/bin/sh
var=`ps -ef | grep thttpd`
kill -9 `echo $var | awk '{print $1}'`
ps -ef | grep thttpd
