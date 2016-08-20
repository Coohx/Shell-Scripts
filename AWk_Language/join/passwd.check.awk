# check passwd
BEGIN {
	FS = ":"
}
# 执行体
NF != 7 {
	printf("line %d, does not have 7 fields: %s\n", NR, $0)
}
$1 !~ /[a-zA-Z0-9]/{
	printf("line %d, non alpha and nnumeric user id: %s\n", NR, $0)
}
$2 == "*" {
	printf("line %d, no password: %s\n", NR, $0)
}
