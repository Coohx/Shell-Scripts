#!/bin/bash
# 监测80端口、httpd服务是否开启，并实现自动开启、邮件报警
# 3秒钟检测一次

mail=huangxin2028@gmail.com
while true
do
	#先检测80端口是否开启,若开启。则退出脚本.
	if netstat -lnp |grep ':80' |grep -q 'LISTEN';then
		exit
	#没有开启，重启httpd服务
	else
		/etc/init.d/httpd restart > /dev/null 2>/dev/null
		#发送告警邮件
		echo "The 80 port is dowm." |mail -s 'check_80' $mail
		#检查是否重启成功  grep -c 计算匹配行数 -v 匹配与指定内容相反的内容
		n=`ps aux |grep httpd |grep -cv grep`
		#如果重启失败，记录失败原因，再次发送告警邮件
		if [ $n -eq 0 ];then
			/etc/init.d/httpd start 2> /tmp/apache_start.err
		fi
		if [ -s /tmp/apache_start.err ];then
			mail -s 'apache_start.err' $mail < /tmp/apache_start.err
		fi
	fi 
	sleep 3
done
