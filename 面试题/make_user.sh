#!/bin/bash
#批量创建用户user_00 ---user_10 ,并且给这些用户设置一个随机密码， 记录到日志文件中！
# 工具 mkpasswd useradd passwd

for count in `seq -w 0 10`
do
	useradd -M  user_$count
	password=`mkpasswd -s 0`
	echo $password |passwd --stdin user_$count >> /dev/null
	echo "$count $password" >> pass.log
done
	
