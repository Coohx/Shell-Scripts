#! /bin/bash
## -n 判断变量值不为空
## Written by huangxin

while :
do
    read -p "Please input a number: " n
    # 将输入变量中的数字全部替换为空
    m=`echo $n|sed 's/[0-9]//g'`
    # 判断m是否不为空
    if [ -n "$m" ]
    then
        #不为空
        echo "The character you input is not a number,please retry."
        #read -p "Please input a number: " n
        #echo "$n"
    else
        #为空
        echo "OK!"
        echo $n
	exit
    fi
done
