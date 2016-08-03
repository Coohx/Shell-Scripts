#!/bin/bash
# 批量删除用户 user_00 ---user_10

for count in `seq -w 0 10`
do
	userdel -r  user_$count &>/dev/null
done
