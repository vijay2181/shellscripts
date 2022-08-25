#!/bin/bash

> pdi_resouce_utils.txt

pdi_stat () {
if [ -n "$(docker ps|grep bi|awk '{print $1}')" ];then
echo "Current time: \"$(date +%c)\"" >> pdi_resouce_utils.txt
docker container stats --no-stream $(docker ps|grep bi|awk '{print $1}') >> pdi_resouce_utils.txt
elif [ -z "$(docker ps|grep bi|awk '{print $1}')" ];then
exit 0
fi
}

while :
do
pdi_stat
sleep 60
done
