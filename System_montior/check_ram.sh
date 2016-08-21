#!/bin/bash
# The objective of this script is to check the Memory usage.
# Author: huangxin Date:2016-08-20

# maximum ratio of memory usage.
mem_quota=80

# fetch(提取) the ratio of memory usage.
# return 1：if larger than $mem_quota
#        0: if less than $mem_quota

watch_memory(){
	mem_total=`cat /proc/meminfo |grep MemTotal |awk '{print $2}'`
	mem_free=`cat /proc/meminfo |grep MemFree |awk '{print $2}'`
	#获取数值计算的结果: 用 $(())将运算公式扩起来
	mem_usage=$((100 - mem_free*100/mem_total))
	if [ $mem_usage -gt $mem_quota ];then
		mem_message="ALLERM!!! The memory usage is $mem_usage%!!!"
		flag_mem=1
	else
		flag_mem=0
	fi
}
#watch_memory
