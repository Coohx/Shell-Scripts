#!/bin/bash
# Author:huangxin
# 破解RANDOM 随机数经md5sum计算后的字符串之前的RANDOM随机数

array=(
00205d1c 
a3da1677
1f6d12dd
)

for n in {0..32767}
do
	# 遍历整个MD5可输入数的范围
	MD5=`echo $n | md5sum |cut -c 1-8` &> /dev/null
	# 计算出一个数的md5值后与待求的md5比较
	for i in ${array[@]}
	do
		if [ "$MD5" = "$i"  ];then
			echo "$n and $i" >> ./test_log/char.log
			break
		else
			echo "$n no" > /dev/null
		fi
	done
done
