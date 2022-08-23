#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
        echo 'This script must be run by root' >&2
        exit 1
fi

echo "Please Enter the USER to create and add in sudoers file :"
read RESULT

if id $RESULT  >/dev/null 2>&1; then
        echo "User $RESULT Already Exists, Skipping Now ...."
else
        echo "User $RESULT  Does Not Exist, Creating Now ...."
        groupadd $RESULT
        useradd -g $RESULT -G admin -s /bin/bash -d /home/$RESULT $RESULT
        mkdir -p /home/$RESULT
        cp -r /root/.ssh /home/$RESULT/.ssh
        chown -R $RESULT:$RESULT /home/$RESULT
        echo "ubuntu    ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
        echo "User $RESULT Created Successfully ...."
fi
