#! /bin/bash
## This script is used to find a systemuser.
## Written by huangxin

read -p "Please input a username what you want to find: " username
if grep -q "^"$username":" /etc/passwd
then 
    echo "This user exist!"
    echo "$username"
else
    echo "This user not exist"
fi
