#! /bin/bash
## if 语句
## Written by huangxin


##############整数变量表达式##################
a=5
if [ $a -gt 10 ]
then 
	echo "a>10"
else 
	echo "a<=10"
fi

##############文件表达式######################
# -s 文件存在且非空
if [ -s 1.txt  ];then 
	echo "OK!"
else
	echo "false!"
fi

#############字符串变量表达式#################
var1=huangxin
var2=coohx
#字符串变量判断相等时,等号与左右两边的变量有空格,否则条件表达式‘$var="string"’会被识别为一个变量，即变量 $var="string"
if  [ $var2 = "huangxin" ]
then
	echo "var2=huangxin"
else
	exit 1
fi
# -a 等价于逻辑与&& -z 字符串为空
if [ -z $1 -a  $var2 = "huangxin" ];then
#if [ -z $1 ] && [ $var2 != "huangsdfxin" ];then
	echo "OK!"
else
	echo "false!"
fi

##############字符串变量表达式##############
string=notnull
# $string 等价于 -n $string,即 不为空时返回0,为真！
if [ $string ];then 
	echo "not null!"
else
	echo "null!"
fi
echo $string

##############if 简化语句 用&& || 替换then ############
# [ ] && 若成立，就执行&&后面的命令
[ -f 1.txt ] && rm -f 1.txt 2>/dev/null
# [] ||  若不成立，就执行||后面的命令
[ -f 1.txt ] || touch  1.txt > /dev/tty



