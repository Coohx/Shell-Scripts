#!/bin/bash
# The objective of this script is to monitor the disk.
# Author:huangxin  Date 2016-08-21

# maximum ratio of hard disk usage
hd_quota=80

# fetch the ratio of hard disk usage
# return 1: if larger than $hd_quota
#           0:  if less than $hd_quota

watch_hd(){
	# 提取磁盘使用率
	hd_usage=`df | grep '/dev/sda1' | awk '{print $5}' | sed 's/%//g'`
	if [ $hd_usage -gt $hd_quota ];then
		hd_message=" AlARM!!! The hard disk usage is $hd_usage%!!!"
		flag_hd=1
	else
		flag_hd=0
	fi	
}
