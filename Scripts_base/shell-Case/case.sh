#!/bin/bash
# case's usage

while :
do
	read -p "Please input a number: " num
	#####---%-对输入的变量值求余数#########
	tmp=`echo $num |sed 's/[0-9]//g'`
	if [ -z $tmp ];then
		m=$[$num % 2]
		echo "$m"
		case $m in
			0)
				echo "This number is a parity!"
				;;
			1)
				echo "This number is not a parity!"
				;;
			*)
				echo "This is not a number1"
				;;
		esac
		exit
	else
	echo "please retry!"
	fi
done
