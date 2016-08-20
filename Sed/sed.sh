#!/bin/bash
# sed集合

# 替换
sed -e 's/Jon/Jonathan/g'  ./test.txt

# 删除前3行
sed -e '3d' ./test.txt

# 显示5~10行
sed -n '5,10p' ./test.txt

# 删除包含Lane的行
sed -e '/lane/d' ./test.txt

# 显示生日在11-12月之间的
# sed 中正则将特殊字符用[::]括起来
sed -n '/[:::]1[1-2][:/:]/p' ./test.txt

# 给以Fred开头的行添加三个*
sed -e 's/^Fred/***Fred/g' ./test.txt

# 用JOSE HAS RETIRED取代包含jose的行
sed -e 's/^.*jose.*$/JOSE HAS RETIRED/g' ./test.txt
sed -e '/jose/s/.*/JOSE HAS RETIRED/g' ./test.txt

# 把Pop的生日改为 11/14/16
sed -e '/Pop/s/:[0-9]\+\/[0-9]\+\/[0-9]\+:/:11\/14\/16:/g' ./test.txt

# 删除所有空白行
sed -e '/^$/d' ./test.txt

# 脚本实现： do.sed
#  - 在第一行之前插入 SED is beautiful!
#  - 删除以500结尾的工资
#  - 显示文件内容，把名和姓颠倒
#  - 在文件末尾添加End Sed

sed -f do.sed ./test.txt

