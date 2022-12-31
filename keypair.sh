#!/bin/bash
#To create a secure passphrase use "openssl rand -base64 10"
#key pair generator for ssh key based authentication "
set -e
echo "enter the username"
read username
if getent passwd $username > /dev/null 2>&1; then
	echo "the user exists!"
else
	echo "The user does not exist,create it first"
	exit 1
fi
#sudo -u $username
cd /home/$username
if [ -e /home/$username/.ssh ]
then
	echo "ls -la"
	if [ -e /home/$username/.ssh/authorized_keys ]
	then
		echo "ls -la"
	else
		echo "ls -la"
		sudo -u $username touch .ssh/authorized_keys
		sudo -u $username chmod 600 .ssh/authorized_keys
	fi
else
	sudo -u $username mkdir .ssh
	sudo -u $username chmod 700 .ssh
	sudo -u $username touch .ssh/authorized_keys
	sudo -u $username chmod 600 .ssh/authorized_keys
fi
echo "creating keypair"
echo "genreating a random strong passphrase of 10 charchter long, copy and paste it"
openssl rand -base64 10
sleep 2
ssh-keygen -f $username -t rsa -b 4096
sudo -u $username cat $username.pub >> .ssh/authorized_keys
mv $username $username.pem
echo "your pem file is in /home/$username"
