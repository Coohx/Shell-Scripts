#!/bin/bash
# while 实现用户交互
#
key=1
while [ -n "$key" ]
do
	read -p "Please input a number: " number
	if [ -z "$number" ];then                     #拒绝直接回车
		echo "Please input a number!"
		continue
	else
		key=`echo $number |sed 's/[0-9]//g'`
		if [ ! -z "$key" ];then
			echo "Your input is not a number!"
		else	
			echo "OK! $number"
			exit
		fi
	fi
done
