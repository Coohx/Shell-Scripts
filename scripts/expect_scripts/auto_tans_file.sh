#! /bin/bash
# 调用auto_tans_file.expect实现文件分发
# 要求：所有脚本位于统一路径下

# 根据主机ip进行循环，每一个ip一次性分发完所有文件
for ip in `cat /root/ip.txt`
do
	#同步的文件列表是/root/1.txt的内容
	./auto_tans_file.expect  $ip /root/1.txt
done
