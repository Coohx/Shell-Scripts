#!/bin/bash
# 求fibonacci数列的第n项

while true
do
	read -p "Please input the sequence of Fibonacci: " number
	count=`echo $number |sed 's/[0-9]//g'`
	if [ -z $count ]
	then
		echo "$number"  | awk -f fibonacci.awk
		exit 1
	else
		echo "Please retry again!"
	fi
done
