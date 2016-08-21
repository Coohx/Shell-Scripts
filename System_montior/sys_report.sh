#/bin/bash
# The objective of this script is to monitor the cpu/ram/disk/processes of servers.

# Generate report every 10 minutes.
runtime_gap=10

# Ddeclaring the functions that are defined in other files.
source ./check_ram.sh
source ./check_disk.sh
source ./check_cpu.sh
source ./check_process.sh

while true
do
	# 采集系统内存、硬盘、CPU信息.
	watch_memory
	watch_hd
	watch_cpu
	level="Important!!!"
	if [  $flag_mem -eq 1 ];then
		echo -e "$level \n $mem_message" | mail -s "Server Report" 1085331197@qq.com
	fi
	if [ $flag_hd -eq 1 ];then
		echo -e "$leval \n $hd_message" | mail -s "Server Report" 1085331197@qq.com 
	fi
	if [ $flag_cpu -eq 1 ];then
		echo -e "$level \n $cpu_message \n" `proc_cpu_top10` | mail -s "Server Report" 1085331197@qq.com
	fi
	sleep $((runtime_gap - time_gap))
done

