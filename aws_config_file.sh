#!/bin/bash

#USAGE: aws_config_file.sh [profile] [Access_key] [Secrect_key]

config () {
   cat >> ~/.aws/config << EOF
[profile $1]
aws_access_key_id=$2
aws_secret_access_key=$3
region=us-west-2
EOF
}


if [[ ! -e ~/.aws ]]; then
    mkdir ~/.aws
    touch ~/.aws/config
    echo "Directory and config File are Created"
    config $1 $2 $3
elif [[ -d ~/.aws ]] && [[ -f ~/.aws/config ]]; then
    echo "Directory and config File exists, so Appending Configs"
    config $1 $2 $3
fi
