#!/bin/bash

echo -n "User input:"

for i in "$@"
do
    echo -n " ${i}"
done

echo -e "\n"

for f in ~/*
do
    if [ -d "$f" ] 
    then
      echo "[dir] $f"
    else
      echo "$f"
    fi
done

echo -en "\n"

myvar=0
while [ $myvar -ne 5 ]
do
    myvar=$(( $myvar + 1 ))
    echo -n "$myvar "
done

echo -en "\n"