#!/bin/bash
# 统计ip

awk '{print $1}' ./test_log/1.log |sort -n|uniq -c|sort -n > ./test_log/ip_access.log
