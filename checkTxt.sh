#!/bin/bash
initFile=$1

# delete max-length substring including *. in initFile string
if [ "${initFile##*.}" = "txt" ]
then
    echo "$initFile IS .txt-file"
else     
    echo "$initFile ISN'T .txt-file"
fi

case "${initFile##*.}" in
     txt)   echo "its text file" ;;
     mp3)   echo "its music file" ;;
     cpp)   echo "its c++ file" ;;
     py)    echo "its python file" ;;
     sh)    echo "its bash file" ;;
     jpg)   echo "its image" ;;
     *)     echo "file format cant be recognized"
            exit
            ;;
esac