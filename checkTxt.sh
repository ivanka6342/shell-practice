#!/bin/bash
initFile=$1

# delete max-length substring including *. in initFile string
if [ "${initFile##*.}" = "txt" ]
then
    echo "$initFile IS .txt-file"
else     
    echo "$initFile ISN'T .txt-file"
fi