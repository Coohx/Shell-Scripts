#! /bin/bash
## -z 判断变量值为空
## Written bu huanxgin

read -p "Please input a number: " n
# 将输入变量中的数字全部替换为空
m=`echo $n|sed 's/[0-9]//g'`
# 判断m是否为空
if [ -z "$m" ]
then
    #为空
    echo $n
else
    #不为空
    echo "The character you input is not a number,please retry."
    read -p "Please input a number: " n
    echo "$n"
fi
