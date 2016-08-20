#!/bin/bash
# select选择语句的用法 ，适用于交互选择的情况

##########select会默认把序号和对应的命令列出来，每次输入一个数字，则会执行相应的命令，命令执行完后并不会退出脚本。它还会继续让我们再次输如序号###

echo -e "Please chose a number:\n  1:run w, 2:run top, 3:run free, 4:quit."
select command in w top free quit
do
	case $command in
		w)
			w;;
		top)
			top;;
		free)
			free;;
		quit)
			exit;;
	esac
done


##########序号前面的提示符，我们也是可以修改的，利用变量PS3即可，再次修改脚本如下###########################

#PS3用于修改命令提示符，默认为#?
PS3="Please select a number: "
echo -e "Please chose a number:\n1:run w, \n2:run top, \n3:run free, \n4:quit."

#注意输入的是数字1,2,3,4.并不是w，top，free，quit。
#select 会自动把1,2,3,4与循环列表对应起来
select command in w top free quit
do
	case $command in
		w)
			w;;
		top)
			top;;
		free)
			free;;
		quit)
			exit;;
		*)
			echo "Please input a number:(1-4)."
	esac
done

#如果想要脚本每次输入一个序号后就自动退出，则需要再次更改脚本如下:

PS3="Please select a number: "
echo -e "Please chose a number:\n1:run w, \n2:run top, \n3:run free, \n4:quit."
select command in w top free quit
do
	case $command in
		w)
			w;exit;;
		top)
			top;exit;;
		free)
			free;exit;;
		quit)
			exit;;
		*)
		# '*)'的执行体可以不添加;;结束符.
		echo "Please input a number:(1-4)."
	esac
done
