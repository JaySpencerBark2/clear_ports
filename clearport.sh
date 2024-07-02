#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <port>"
    exit 1
fi


read -p "Are you sure to clear port $1? [y/n]" -n 1 -r

#check if the command is being ran in sudo 

if [ "$EUID" -ne 0 ]
  then echo "Please run with root privileges"
  exit
fi

#Get the PID of the process that is using the port

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo

    echo "Clearing port $1"
    
    pid=$(lsof -ti:$1)
    if [ -z "$pid" ]; then
        echo "Port $1 is not being used"
        exit 1
    fi

    echo "Killing process $pid"

    #Kill the process
    kill -9 $pid

    #check if its working or not
    pid=$(lsof -ti:$1)
    if [ -z "$pid" ]; then
        echo "Port $1 has been cleared"
    else
        echo "Failed to clear port $1"
    fi
fi
