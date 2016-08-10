#!/bin/bash
# shell 数组的使用

for i in `seq 0 9`
do 
	a[$i]=$RANDOM  #给属组赋值10个随机数
done
#将数组元素排序 sed用于将数组元素由一行变成一列
echo ${a[@]} |sed 's/ /\n/g'|sort -n

