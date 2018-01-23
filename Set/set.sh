#!/usr/bin/env bash

#set -u
#set -o nounset

echo $not_exist
echo "set -u 脚本中遇到不存在变量,会停止执行."

set -x
echo "set -x 会输出脚本中执行的命令"

#set -e
set -o errexit
#暂时关闭set -e
set +e
error_commond
echo "set -e 只要脚本出错,就终止执行"
#重新打开set -e
#set -e
error_commond
echo "set -e 只要脚本出错,就终止执行"

error_commond | echo "Previous sub_commond is wrong."
echo "set -o pipefail 检测管道命令中的错误"

#set -eo pipefail
error_commond | echo "Previous sub_commond is wrong."
echo "set -o pipefail 检测管道命令中的错误"

#set参数组合使用
#method_first
set -euxo pipefail
#method_second
set -eux
set -o pipefail

error_commond | echo "Previous sub_commond is wrong."
echo "I won't be print on screen."

