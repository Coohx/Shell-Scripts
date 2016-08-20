#!/usr/bin/awk -f
# 生成数据报表
BEGIN {
	FS = ":"; 
	OFS = "\t"
	print "\t\t Report tables" 
	print "name\tphone\t\tJan\tFeb\tMar\t\tTotal"
	print "——————————————————————————————————————————————————————"
}
# 球客户3个月的业绩和
{$6 = $3 + $4 + $5}
#{printf "%-8s%-15s%-9s%-8s%-15s%-12s\n", $1,$2,$3,$4,$5,$6}
{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t\t"$6}
{total3 +=$3}
{total4 +=$4}
{total5 +=$5}
END {
	print "_______________________________________________________"
	print "This is Jan total: " total3
	print "This is Feb total: " total4
	print "This is Mar total: " total5
}

