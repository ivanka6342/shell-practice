#!/bin/sh

PROJECT_PATH=$1

if [ ! -n "$PROJECT_PATH" ]; then
    while [ ! -n "$PROJECT_PATH" ]
    do
        echo "Specify the location for new parcel project:"
        read PROJECT_PATH
    done
fi

echo "Creating new parcel project..."

if [ ! -d "$PROJECT_PATH" ]; then
    mkdir $PROJECT_PATH
fi

cd $PROJECT_PATH

yarn init -y
yarn add parcel-bundler

git init
touch .gitignore index.html index.js Readme.md

echo "node_modules/\n.cache\n" > .gitignore
echo "Done."