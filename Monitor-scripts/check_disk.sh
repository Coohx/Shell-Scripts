#!/bin/bash
# Cacti自定义监控脚本监控磁盘使用情况

row=`df -h | wc -l`
for i in `seq 2 $row`
do
	# 过滤分区可用值大小 sed -n 'n'p 打印第n行 
	ava=`df -h |sed -n "$i"p |awk '{print $4}'`
	# 过滤分区使用百分比(去掉%号)
	u_per=`df -h |sed -n "$i"p |sed 's/\%//' |awk '{print $5}'`
	# 过滤分区名 -P=--portable(POSIX)	
	p_p=`df -hP |sed -n "$i"p |awk '{print $6}'`
	if [ "$u_per" -gt 97 ];then
		echo -en "$p_p CRITICAL! $u_per% $ava\n"
		sta[$i]=2
	elif [ "$u_per" -gt 95 ];then
		echo -en "$p_p WARNING! $u_per% $ava\n"
		sta[$i]=1
	else
		echo -en "$p_p OK $u_per% $ava\n"
		sta[$i]=0
	fi
done
retur_count=0
for j in `seq 2 $row`
do
	if [ "${sta[$j]}" -gt $retur_count ];then
		retur_count=${sta[$j]} 
	fi

done
# 返回最大状态值
exit $retur_count

