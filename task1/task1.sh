#!/bin/bash

cSource=$1
pyScript=$2

scriptsDir=$(find ~/ -name "$cSource" -execdir [ -e "$pyScript" ] \; -printf %h\\n)

gcc ${scriptsDir}/${cSource} -o taskC
chmod u+x $pyScript

while [ -n "${3}" ]
do
    echo -e "\nC-code execution result(arg = $3):"
    ./taskC ${3}
    
    echo -e "\nPy-code execution result(arg = $3):"
    python3 ${scriptsDir}/${pyScript} ${3}

    shift
done