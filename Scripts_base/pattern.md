#### Shell 模式匹配符语法

```

#!/bin/bash
# 模式匹配符语法
# shell 模式匹配
# #--最短的开头  ##-最长的开头
# %--最短的结尾  %%-最长的结尾
# /P/S--替换匹配到的第一部分  //P/s--替换匹配的所有部分
path=/home/prince/desktop/prince/log.file.name

echo "删除最短的/*/-->/home/"
echo ${path#/*/}
echo
echo "删除了最长的/*/-->/home/prince/desktop/prince/"
echo ${path##/*/}
echo
echo "删除最短的结尾.*-->.name"
echo ${path%.*}
echo
echo "删除了最长的结尾.*-->.file.name"
echo ${path%%.*}
echo
echo "替换匹配到的第一个prince"
echo ${path/prince/coohx}
echo
echo "替换匹配到的所有prince"
echo ${path//prince/coohx} 

line="arg=123"
echo $line
echo
echo ${line#*=}
echo
echo ${line%\=*}

```


