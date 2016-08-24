定期清除系统日志脚本
===

> 思路：定期扫描 `/var/log`目录下日志文件的大小，将超过指定大小并且重要的日志打上时间戳放到日志备份目录`/data/sys_logback/`中，将超过指定大小但不重要的日志文件清空。

&emsp;&emsp;1. 脚本名称：logrotate.sh

> Usage: 创建计划任务，一分钟运行一次.

```
	*/1 * * * * /bin/bsah /root/Git/Shell-Scripts/logrotation/logrotate.sh &>/dev/null &

```
