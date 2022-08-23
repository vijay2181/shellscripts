#!/bin/bash

sudo apt-get update
sudo apt install openjdk-8-jdk -y
sudo apt install gnupg rng-tools docker.io -y

# Install Jenkins
## Before install is necessary to add Jenkins to trusted keys and source list
wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins

#sudo sh +x jenkins-ubuntu-installation.sh 
#netstat -ntlp | grep 8080
#to get public-ip from command line use "curl ifconfig.me/ip"
