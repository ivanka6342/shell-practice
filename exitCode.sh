#!/bin/bash
cp -f ~/Documents/bashCollection/codeRet.txt /home/vaka/Documents/bashCollection/codeRet.sh

get_code=$(~/Documents/bashCollection/codeRet.sh 35)
echo "returned code: $get_code"

exit