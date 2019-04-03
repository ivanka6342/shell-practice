#!/bin/bash

initFile=$1

# first function
tarview() {
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
}

tarview


# example with rewriting global variables by local ones
myVar="hello"

myFunc() {

    myVar="one two three"
    for x in $myVar
    do
        echo $x
    done
}

myFunc

echo $myVar $x

# corrected previous example
newVar="hello"

correctedFunc() {
    local y
    local newVar="one two three"
    for y in $newVar
    do
        echo $y
    done
}

correctedFunc

echo $newVar $y

