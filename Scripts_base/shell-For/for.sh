#!/bin/bash
# for 语句求和

sum=0
#for i in {1..10}
for i in `seq 1 2 10`
do
	sum=$[$sum+$i]
	echo $i
	if [ $i -eq 4 ];then
		exit
	fi
	echo $i
done
echo $sum
