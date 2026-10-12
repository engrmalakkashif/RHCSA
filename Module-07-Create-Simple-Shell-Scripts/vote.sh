#!/bin/bash

read -p "Enter your age: " age

if [ "$age" -ge 18 ]; then
    echo "You can vote"
else
    echo "You cannot vote"
fi
