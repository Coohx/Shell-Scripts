#!/bin/bash
# 求闰年
while true
do
	read -p "Please input a number about years: " year
	count=`echo "$year" | sed 's/[0-9]//g'`
	if [ ! -n "$count" ]
	then
		echo "$year" | awk -f ./leap.awk
		exit 0
	else
		echo "please retry!"
	fi
done
