#!/bin/bash
# check the usage of CPU
## cpu_total1=user+nice+system+idle+iowait+irq+softirq
## cpu_used1=user+nice+system+irq+softirq
##
# Maximum ratio of cpu usage
cpu_quota=80
# Time gap between two times fetching cpu status
time_gap=15

# This is a function to fetch cpu status at a time point.
# Format:used unused

get_cpu_info(){
    # 对多核cpu，将所有的cpu核心的数据项预先相加后再输出
	cat /proc/stat | grep -i '^cpu[0-9]\+' | \
                  awk '{used+=$2+$3+$4+$7+$8; unused+=$5+$6} \
					   END{print used,unused}' 
}

# This is the main function of watching cpu.
# Fetch cpu stat two times, with time gap, then calculate the average status.

watch_cpu(){
	# 将cpu信息以字符串的形式存到变量里,awk 输出分隔符默认空格
	time_point_1=`get_cpu_info`
	sleep $time_gap
	time_point_2=`get_cpu_info`
	# cpu总时间total 从开机起一直在累加
	cpu_usage=`echo "$time_point_1 $time_point_2" | \
		         awk '{used=$3-$1; total+=$3+$4-$1-$2; \
				       print used*100/total}' | cut -d'.' -f 1`
        #echo $cpu_usage
	if [ $cpu_usage -gt $cpu_quota ];then
		cpu_message=" ALARM!!! The cpu usage is over $cpu_usage!!!"
		flag_cpu=1
	else
		flag_cpu=0
	fi
}

watch_cpu
