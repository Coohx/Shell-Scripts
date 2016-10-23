#!/bin/bash
# 写一个scripth，检测 192.168.0.0-192.168.255.255 网络是否可达.
# 利用ping，注意ping的次数.

for i in `seq 0 2`
do
	for j in `seq 0 2`
	do
		#stat=`ping -c 4 192.168."$i"."$j" | grep 'transmmitted' | awk -F" " '{print $6}' | sed 's/%//g'`
		ping -c 5 192.168."$i"."$j" >/dev/null 2>&1
		if [ "$?" != "0" ];then
			echo "The host 192.168."$i"."$j" is reachable!"
		else
			echo "The host 192.168."$i"."$j" is unreachable!"
		fi
	done
done
