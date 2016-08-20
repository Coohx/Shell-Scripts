# fibonacci sequence

function fibonacci(array,n,  nth)
{
	#从第三项开始每一项等于前两项的和
	nth=3
	while(nth <= n)
	{
		array[nth] = array[nth-1] + array[nth-2]  # 递归数组
		nth++
	}	
}
# 执行体
{
	array[1] = 1
	array[2] = 1
	n=$1
	# 地址传递，数组名
	fibonacci(array,n)
	printf(" %dth of fabonacci sequence is: %d\n", n, array[n])
}
