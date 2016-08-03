#!/bin/bash
# 乘法口诀
# Written by huangxin
for multiplier in {1..9}
do
	for multiplicand in `seq 1 $multiplier`
	do
		answer=$[$multiplier * $multiplicand]
		echo -n "$multiplicand x $multiplier = $answer"
		echo -ne "\t"
	done
	echo  -e "\n"
done	
