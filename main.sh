#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "$0: Введите 2 аргумента: входная директория и выходная директория"
    exit 1
fi

if [ ! -d "$1" ] || [ ! -d "$2" ]; then
    echo "$0: Оба аргумента должны быть директориями"
    exit 1
fi

mkdir -p "$2"

files=$(find "$1" -maxdepth 1 -type f)
directories=$(find "$1" -maxdepth 1 -mindepth 1 -type d)
for dir in $directories; do
    files+=" $(find "$dir" -type f)"
done

find "$1" -type f | while read file; do
    filename=$(basename "$file")
    extension="${filename##*.}"
    filename="${filename%.*}"
    counter=0
    new_filename="$filename.$extension"
    while [ -e "$2/$new_filename" ]; do
        counter=$((counter + 1))
        new_filename="$filename-$counter.$extension"
    done
    cp "$file" "$2/$new_filename"
done