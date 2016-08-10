#!/bin/bash
# Author:huangxin
# shell 数组实现批量检查多个网站地址是否正常

array=(
http://www.baidu.com
http://www.sina.com
http://www.xautkx.com
http://www.coohx.com
)
for vari in ${array[@]}
do
	#curl -m 指定测试时间
	URL=`curl -I -m 2 $vari 2> /dev/null |egrep "200|302|301" |wc -l`
	if [ "$URL" -eq 1 ];then
		echo "$vari is OK!"
	else
		echo "$vari is not OK!"
	fi
done
