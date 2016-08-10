#!/bin/bash
# 查看用户是否登录
# 语法：user_login loginname
# source 此文件名 --->将此函数装入当前shell
# declare -F 查看当前shell有哪些函数被声明
function user_login () {
	if who |grep $1 &> /dev/null
	then
		echo "User $1 is on."
	else
		echo "User $1 is off."
	fi	
}
