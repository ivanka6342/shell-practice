#!/bin/bash

firstParam=$1

exitCode=$(bash recursiveCrash.sh firstParam)

exit $exit_code
