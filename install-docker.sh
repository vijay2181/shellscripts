#!/bin/bash
#author strider
rel=$(lsb_release -r -s)
if  [[ ( $rel != 16.10 && $rel != 16.04 && $rel != 14.04 ) ]] ; then
	echo "To install Docker, you need the 64-bit version of one of these Ubuntu versions:16.10,16.04 (LTS),14.04 (LTS)"
	exit 1
else
	echo "this will install docker in ubuntu $(lsb_release -r -s)"
fi
sudo apt-get install curl \
    linux-image-extra-$(uname -r) \
    linux-image-extra-virtual \
    apt-transport-https \
    ca-certificates
echo "adding docker GPG key"
curl -fsSL https://yum.dockerproject.org/gpg | sudo apt-key add -
sudo add-apt-repository \
       "deb https://apt.dockerproject.org/repo/ \
       ubuntu-$(lsb_release -cs) \
       main"
sudo apt-get update
sudo apt-get -y install docker-engine
echo "installing docker-compose"
sudo curl -L "https://github.com/docker/compose/releases/download/1.10.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
echo "adding docker to user group"
sudo usermod -aG docker $USER
echo "configuring docker to start on boot-time"
sudo systemctl enable docker
echo "do you need to reboot"
echo "press y/Y for yes"
#asking for user permission to reboot , only Y/y should work
read -p "" -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
	exec sudo /sbin/reboot > /dev/null
    #sudo reboot && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
fi
