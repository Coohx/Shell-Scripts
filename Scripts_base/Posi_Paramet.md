###Shell 位置参数


```
#! /bin/bash
## system variables
## Written by huangxin
# $0 脚本的名称 或 bash名称
# $1 第一个位置参数 $2 第二个位置参数 ....$9 第九个位置参数
# ${10} 从第10个位置变量开始要用{}括起来
# $# 代表传入参数的个数
# $@ 代表所有参数
# $* 代表所有参数
echo "\$0=$0"
echo "\$1=$1"
echo "\$2=$2"
echo "\$3=$3"
echo "\$#=$#"
echo "\$@=$@"
echo "\$*=$*"

```
