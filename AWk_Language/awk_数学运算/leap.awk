# awk 脚本求闰年
BEGIN {
	print "Pick leap years:"
}
{
	# $1为记录的第一个字段
	year=$1
	if(( year % 4 == 0 && year % 100 != 0 )||year % 400 == 0)
		print year " is a leap year."
	else
		print year " is not a leap year."
}
END {
	print "Checking is over."
}
