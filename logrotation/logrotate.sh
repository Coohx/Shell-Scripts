#!/bin/bash
# Author:huangxin Date:2016-08-24

# Maximum log directory size(MB)
alarm_value=500
# The max size log file can reach(MB)
file_max_size=5
# This is the directory where fresh log are originally written.
log_ram_dir=/var/log
# This is the directory where backup logs are kept.
working_dir=/data/sys_logback
# This is the frequency our program runs.
SLEEPTIME=60


# Append Year.Month.Day and timestamp to log file.
# 备份的日志统一打时间戳
filenameConvert(){
#	timestamp=$(date +%Y%m%d%H%M%S)
	timestamp=`date +%Y%m%d%H%M%S`
	RetVal=$1.$timestamp
}

# Search dir to fetch the oldest log
# 在备份文件夹中寻找最旧的日志
searchdir(){
	# -tr 按时间倒序
	oldestlog=`ls -tr | head -n1 | awk '{print $1}'`
}

# This function clean old logs under working dir if it reaches it's size limitation,say 500M.
clear_old_log_under_working_dir(){
	cd $working_dir
	while 1
	do
		# 若日志备份文件夹超过限额，则删除最旧的日志
		log_dir_size=`du -sm $working_dir | awk '{print $1}'`
		if [ $log_dir_size -gt $alarm_value ];then
			searchdir
			rm -rf $oldestlog
		else
			break
		fi
	done
}

# This is the main process of our log backup activity.
# 主备份程序

backuplog_process(){
	cd $log_ram_dir
	for i in `find . -maxdepth 1 -type f -print`
	do
		# 判断单个日志文件是否大于限额
		file_size=`du -ms $i | awk '{print $1}'`
		case $i in
		# 重要日志
		messages | mail.log | anaconda* | secure* |cron* | maillog* | dmesg* |dmesg.old)
			if [ ! -d /data/sys_logback ];then
				mkdir -p /data/sys_logback
			fi
			if [ $file_size -ge $file_max_size ];then
				filenameConvert $i
				# 将过大的单个日志备份
				cp $log_ram_dir/$i $working_dir/$RetVal
				# 清空已备份的日志
				echo "" > $log_ram_dir/$i >/dev/null 2>&1
				# 若备份文件在添加新的备份后超出限额，则删除最旧的日志
				clear_old_log_under_working_dir
			fi
			;;
		# 无用日志	
		*)
			if [ $file_size -ge $file_max_size ];then
				echo "" > $log_ram_dir/$i >/dev/null 2>&1
			fi
		esac
	done				
}

# 定期轮询系统日志文件夹
while true
do
	backuplog_process
	sleep $SLEEPTIME
done
