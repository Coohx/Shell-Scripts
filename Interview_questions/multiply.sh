#!/bin/bash
# 乘法口诀
# Written by huangxin
# multiplicand 被乘数
# multiplier 乘数
for multiplier in {1..9}  # 循环1-9行
do
	for multiplicand in `seq 1 $multiplier`
	do
		answer=$[$multiplicand * $multiplier]
		echo -n "$multiplicand x $multiplier = $answer"
		echo -ne "\t"
	done
	echo  -e "\n"
done	
