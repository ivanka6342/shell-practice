#!/bin/bash
source=$1
dest=$2

if [[ "$source" -eq "$dest" ]]
    then
        echo "Приемник ($dest) и источник ($source) - один и тот же файл!"
        exit 1
    else
        cp $source $dest
        echo "Удачное копирование!"
fi