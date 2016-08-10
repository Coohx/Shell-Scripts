#!/bin/bash
# 
n=1
while [ $n -le 10 ]     #n<=10
do
	echo $n
	#n=$(($n+1))         #n++  
    n=$[$n+1]
done
