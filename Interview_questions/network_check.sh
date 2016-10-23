#! /bin/bash
# check the network status.
# Author: huangxin
# Date: 2016-09-21

# extract gateway
GATEWAY=`cat /etc/sysconfig/network-scripts/ifcfg-eth0 | grep 'GATEWAY=' | sed 's/.*GATEWAY=//g'`
# extract nameserver
NAMESERVER=$(cat /etc/resolv.conf | grep 'nameserver' | tail -2 | head -1 | sed 's/.*nameserver//g')
# The flag imply network is ok. 
flag=0

# First,check local interface
/bin/ping -c 5 127.0.0.1 >/dev/null 2>&1
if [ "$?" != "0" ];then
	echo "The interface error!"
	flag=1
fi

# second,check gateway
/bin/ping -c 5 $GATEWAY >/dev/null 2>&1
if [ "$?" != "0" ];then
	echo "The gateway is unreachable!"
	flag=2
fi

# third,check destination server
/bin/ping -c 5 $NAMESERVER >/dev/null 2>&1
if [ "$?" != "0" ];then
	echo "The remote host is unreachable!"
	flag=3
fi
if [ $flag -eq 0 ];then
	echo "The local host network is ok!"
fi
