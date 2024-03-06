#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
    echo 'This script must be run by root' >&2
    exit 1
fi

echo "Please Enter the USER to create and add in sudoers file :"
read RESULT

if id "$RESULT" >/dev/null 2>&1; then
    echo "User $RESULT Already Exists, Skipping Now ...."
else
    echo "User $RESULT Does Not Exist, Creating Now ...."
    useradd -m -g $RESULT -s /bin/bash "$RESULT"
    if [ $? -eq 0 ]; then
        echo "User $RESULT Created Successfully ...."
        # Add user to sudoers
        echo "$RESULT    ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
        echo "User $RESULT Added to sudoers file Successfully ...."
    else
        echo "Failed to create user $RESULT" >&2
        exit 1
    fi
fi

