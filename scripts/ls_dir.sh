#!/bin/bash
# 列出当前目录下的目录

for dir in `ls $PWD`
do
	if [ -d $dir ];then
		echo $dir
	fi
done
