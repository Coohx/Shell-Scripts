#!/bin/bash
# /dev/tty 的用法
while :
do
	printf "Enter new passwd: "   #提示输入
	stty -echo                    #关闭自动打印输入字符的功能
	read passwd < /dev/tty        #从当前终端读取密码
	echo " "
	printf "Enter again: "   
	read passwd2 < /dev/tty      
	echo " "
	stty echo                     #重新打开自动打印输入字符功能
	if [ ! "$passwd" == "$passwd2" ];then
		echo "Please retry!"
	else
		exit
	fi
done
