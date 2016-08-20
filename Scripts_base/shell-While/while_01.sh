#!/bin/bash
# 
# ":"--->死循环条件

while :      #死循环，3秒打印一次当前日期
do
	date +%F
	sleep 3
done
