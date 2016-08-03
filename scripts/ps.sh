#! /bin/bash
# shell 参数传递演示，查看系统中某进程是否正在运行
# 记得使用chmod+x使ps.sh可运行

ps -aux |grep "$1"

