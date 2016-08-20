# printf & sprintf
{
	# 第一个字段
	x = $1
	b = "foo"
	# 格式化输出
	printf("%s got a %d on last test\n", "Jim", 83)
	# 将格式化的字符串赋给变量
	myout = sprintf("%s - %d", b, x)
	# 简单输出，自带换行
	print myout
}
