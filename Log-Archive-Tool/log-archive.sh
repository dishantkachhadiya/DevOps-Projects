#!/bin/bash 

## Check Weather the CLI consist the reqiure inputs
if [ $# -ne 1 ]
then 
    echo "Usage: ./log-archive.sh <log-directory>"
    exit 1 
fi
    
## Making the Variables and give it the inputs or the command to navigate

LOG_DIR=$1
ARCHIVE_DIR="archives"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
ARCHIVE_NAME="logs_$TIMESTAMP.tar.gz"


## Checks weather the provided dir exist or not 

if [ ! -d "$LOG_DIR" ]
then
    echo "Error: directory 'LOG_DIR' does not exist."
    exit 1 
fi

## First check the tar command is corrently working or not if worked properly it provided the below shown output

if tar -czf "$ARCHIVE_DIR/$ARCHIVE_NAME" "$LOG_DIR"
then
    echo "====================================="
    echo " Archive created successfully!"
    echo " Archive Name : $ARCHIVE_NAME"
    echo " Saved To     : $ARCHIVE_DIR/"
    echo "====================================="
else
    echo "Failed to create archive."
    exit 1
fi
