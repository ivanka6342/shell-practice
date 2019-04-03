#!/bin/bash
cp -f ~/Documents/bashCollection/codeRet.txt /home/vaka/Documents/bashCollection/codeRet.sh

echo "child process print:"
bash ~/Documents/bashCollection/codeRet.sh 35
echo "child returned code: $?"

exit