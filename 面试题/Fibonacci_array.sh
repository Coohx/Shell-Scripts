#!/bin/bash
# Fibonacci 数组实现

Fibonacci[1]=0
Fibonacci[2]=1
i=3
while [ $i -le 100 ]
do
	#Fibonacci[$i]=$((${Fibonacci[i-1]} + ${Fibonacci[i-2]}))
	Fibonacci[$i]=$[${Fibonacci[i-1]} + ${Fibonacci[i-2]}]
	((i++))
done
echo ${Fibonacci[100]}

