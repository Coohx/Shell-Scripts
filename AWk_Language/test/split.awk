# awk 字符串分隔函数

{
	print "\nField seperator = :"
	n = split($0, array, ":")
	for(k = 1; k <= n; k++)
	{
		print "array[k] = " array[k]
	}
}

