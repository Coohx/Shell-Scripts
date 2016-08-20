#!/bin/bsah
# 斐波那契数列
# Written by huangxin
while :
do
	read -p "Please input a number: " count
	temp=`echo $count |sed 's/[0-9]//g'`
	if [ -z "$temp" ];then
		seq1=0
 		seq2=1
		nextnumber=0
		if [ $count -eq 1 ];then
			echo "The sequeue's $count number is: $seq1"
			exit	
		elif [ $count -eq 2 ];then
			echo "The sequeue's $count number is: $seq2"
			exit
		else
 			for i in `seq 3 $count`
 			do
			   # 核心：下一个数等于它前面两个数的和
			   nextnumber=$[$seq1+$seq2]
	  		   seq1=$seq2
	  		   seq2=$nextnumber
	   	    done
			echo "The sequeue's $count number is: $nextnumber"
			exit
		fi
	else
		"please retry!"
	fi
done	
