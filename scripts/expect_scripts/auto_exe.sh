#!/bin/bash
# 调用auto_exe.expect 实现批量执行命令
# ip.txt-----远程主机ip列表
# commands.sh------批量执行的命令脚本

for ip in `cat /root/ip.txt`
do
	./auto_exe.expect $ip "/bin/bash /root/shell/commands.sh"
done
