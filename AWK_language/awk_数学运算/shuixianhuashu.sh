#! /bin/bash
## 水仙花数
## Written by huangxin
# 水仙花数是指一个 n 位数 ( n≥3 )，它的每个位上的数字的 n 次幂之和等于它本身。（例如：1^3 + 5^3+ 3^3 = 153）


# 题目要求依次输入两组范围数
read -p "" range01
read -p "" range02

i=1
while true
do
	# 动态变量range循环两组范围数
	if [ $i -eq 1 ];then
		range=$range01
	fi
	if [ $i -eq 2 ];then
		range=$range02
	fi
	min=`echo $range | awk '{print $1}'`
	max=`echo $range | awk '{print $2}'`
	seq $min $max | awk  'BEGIN{FS=""} {if(($1^3 + $2^3 + $3^3) == $0) { flag=1;printf("%d ",$0)} if(flag != 1) flag=2;} \
								END{if(flag == 2) printf("no\n"); if(flag==1) printf("\n");}'
	if [ $i -eq 2 ];then
		break
	fi
	let i+=1
done
