#! /bin/bash
## 查询系统用户apache是否存在

if grep -q '^apache:' /etc/passwd
then
    echo "apache exist."
fi
