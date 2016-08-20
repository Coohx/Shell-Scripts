#!/bin/bash
# shell 函数练习
# 定义一个函数

mysum() {
	local sum=$(($1+$2))         #sum为局部变量，只在函数内起作用
	echo "sum=$sum"
}
a=1
b=2
mysum $a $b
