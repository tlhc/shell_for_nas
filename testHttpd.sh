#!/bin/sh

while true
do
	t=$(ps | wc -l)
	http=$(ps | grep http | wc -l)
	telnet=$(ps | grep telnet | wc -l)
	echo "t: $t, http: $http, telnet: $telnet"
	sleep 1
done
