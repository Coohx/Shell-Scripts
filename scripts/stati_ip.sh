#!/bin/bash
# 统计ip

awk '{print $1}' 1.log |sort -n|uniq -c|sort -n > ip_access.log
