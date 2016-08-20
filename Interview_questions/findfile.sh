#!/bin/bash

for file in `ls /root/Git`
do
	# du -s 显示指定文件所占的磁盘大小  -k 以k为单位显示
	size=`du -sk /root/Git/$file |awk '{print $1}'`
	if [ $size -gt 1000 ]
	then
		/bin/cp -r /root/Git/$file /tmp/
	fi
done	
