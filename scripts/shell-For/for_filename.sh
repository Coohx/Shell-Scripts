#!/bin/bash
#for 根据文件名循环

for file in `ls ./`
do
	echo $file
	du -sh $file
done
