BEGIN {
    # 没有显式调用srand()设置种子，awk使用默认常量作为参数传入srand()设置固定的种子
    print rand()
    print rand()
    # srand()适应当前时间作为参数上设置种子
    srand()
    print rand()
    print rand()
}
{}
