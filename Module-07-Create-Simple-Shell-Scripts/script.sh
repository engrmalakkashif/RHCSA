#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

directory="$1"

if [ ! -d "$directory" ]; then
    echo "Directory does not exist"
    exit 1
fi

echo "Processing files in: $directory"

for file in "$directory"/*
do
    if [ -f "$file" ]; then
        echo "File: $file"
    fi
done

echo "Disk usage:"
df -h /
