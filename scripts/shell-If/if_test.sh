#!/bin/bash
# test 命令
# test Expression  等价于 [ Expression ],这里的[]必须被空白包围

echo  -n  "Please input username: "
read user
if
#多条指令,这些命令之间相当于“and”（与）
	grep $user /etc/passwd >/dev/null      
	who -u | grep $user
then            # 上边的指令都执行成功,返回值$?为0，0为真，运行then
	echo "$user has logged"
else            # 指令执行失败，$?为1，运行else                            
	echo "$user has not logged"
fi   
