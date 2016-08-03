#!/bin/bash
# 监控网站是否正常,不正常时发邮件.
# tools----curl,mail
# Author:huangxin

URL=http://coohx.edu.cn
ip1=192.168.8.112
ip2=2.2.2.2
argu="--connect-timeout 3 -I"
check() {
	curl  $argu -x$1:80 $URL  >./curl.log 2>/dev/null
	#curl 执行成功，但网站不一定通
	if [ $? != "0" ];then
		tag=1
	else
		code=`head -1 ./curl.log |awk '{print $2}'`
		if [ $code = "200" -o $code = "301" ];then
			tag=0
		else
			tag=2
		fi
	fi
	if [ $tag -ne 0 ];then
		echo "$1 failed"
		echo "$1 failed" |mail -s coohx_$1 1085331197@qq.com 2>/dev/null
	fi
}
#调用函数，测试
check $ip1
check $ip2

