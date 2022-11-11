#!/bin/bash
sudo apt install awscli -y
mkdir terraform && cd terraform

sudo apt install wget unzip -y
TER_VER=`curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest | grep tag_name | cut -d: -f2 | tr -d \"\,\v | awk '{$1=$1};1'`
sudo wget https://releases.hashicorp.com/terraform/${TER_VER}/terraform_${TER_VER}_linux_amd64.zip
sudo unzip terraform_${TER_VER}_linux_amd64.zip
sudo mv terraform /usr/local/bin/
