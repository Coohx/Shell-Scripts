#!/bin/bash
# 用/etc/shadow密码文件中的密码替换passwd的用户的密码字段

awk -f join.awk /etc/shadow /etc/passwd > passwd.pub
