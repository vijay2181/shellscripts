#!/bin/bash
set -e
#TBD pub key password should be propmted from user
#ssh-keygen -t rsa
if [ -e $HOME/.ssh/id_rsa.pub ]
then
	echo "Pub key already present not creating a new" 
else
        echo "no pub key found , creating one"
        ssh-keygen -t rsa
fi
echo "Enter server ip :"
read ip
echo "Username of remote user:"
read name
ssh $name@$ip mkdir -p .ssh
echo "Copying of pub key in progress"
cat $HOME/.ssh/id_rsa.pub | ssh $name@$ip 'cat >> .ssh/authorized_keys'
echo "Changing  permission of file on remote machine"
ssh $name@$ip "chmod 700 .ssh; chmod 640 .ssh/authorized_keys"

echo "Now you can login in to "$ip" server with "$name" user without password."
