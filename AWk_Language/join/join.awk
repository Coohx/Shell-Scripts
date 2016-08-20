# 替换文件的域
BEGIN {
	# 指定输出分隔符
	OFS = ":"
	# 输入字段分隔符
	FS = ":"
}
# 执行体
NR <= FNR {        # 正在处理第一个输入文件shadow
	a[$1] = $2
}  
NR > FNR {         # 正在处理第二个输入文件passwd
	$2 = a[$1]
	# 输出一整条记录==print $0
	print $0
} 

