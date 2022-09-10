#!/bin/bash

#https://releases.ansible.com/ansible-tower/setup/?extIdCarryOver=true&sc_cid=701f2000001OH7YAAW

function must_be_root() {
if [[ $EUID -ne 0 ]]; then
   echo "You must be root to run this script." 1>&2
   exit 1
fi
}

function log() {
    echo "$1" >&2
}

function die() {
    log "$1"
    exit 1
}

function check_exist() {
    [ ! -z "$(command -v python3)" ] || die "THE 'python3' COMMAND IS MISSING - PLEASE INSTALL AND TRY AGAIN"
    [ ! -z "$(command -v ansible)" ] || die "THE 'ansible' COMMAND IS MISSING - PLEASE INSTALL AND TRY AGAIN"
}

function check_os_supported() {
must_be_root
case $(egrep '^(NAME)=' /etc/os-release|cut -d'=' -f2|sed 's|"||g') in
"Amazon Linux")
printf "THIS OS IS NOT SUPPORTED FOR ANSIBLE TOWER.."
echo " OK!"
printf "PLEASE TRY IN OTHER OS - RHEL (or) CENTOS.."
echo " OK!"
exit 1
;;
*)
:
;;
esac
}

function check_hardware_requirement() {
check_os_supported
[[ ! $(grep '^processor' /proc/cpuinfo | sort -u | wc -l) -ge 2 ]] && { echo "PLEASE UPGRADE YOUR SERVER WITH AT LEAST 2 CORE CPU - AND TRY AGAIN" ; exit 1 ; }
RAM_KB=$(grep MemTotal /proc/meminfo | awk '{print $2}')
RAM_GB=$(expr $RAM_KB / 1024 / 1024)
[[ ! $RAM_GB -ge 7 ]] &&  { echo "PLEASE UPGRADE YOUR SERVER WITH AT LEAST 8GB RAM - AND TRY AGAIN" ; exit 1 ; }
[[ ! $(df -h|grep -vE 'tmpfs|devtmpfs|docker'|sed '1d'|awk '{print $2}'|sed 's|G||g'|head -1) -ge 20 ]] &&  { echo "YOU NEED TO HAVE AT LEAST 20GB DISK SIZE FOR ANSIBLE TOWER TO RUN - CREATE AND TRY AGAIN" ; exit 1 ; }
}

function main() {
check_hardware_requirement
check_exist
DATA_DIR="/data"
TOWER_VERSION=${1:-ansible-tower-setup-3.7.0-4.tar.gz}
curl  https://releases.ansible.com/ansible-tower/setup/${TOWER_VERSION} -o /tmp/tower.tar.gz
[ ! -d $DATA_DIR ] && mkdir -p $DATA_DIR
cd $_ && tar xvzf /tmp/tower.tar.gz --strip 1
if [[ -f inventory ]] ;then
sed -i "/^admin_password=/s;=.*$;='password';" inventory
sed  -i "/^pg_password=/s;=.*$;='password';" inventory
fi
bash setup.sh
[ $? -eq 0 ] && \
echo -e '\n'
printf "ANSIBLE TOWER SETUP HAS BEEN DONE  - PLEASE TRY TO ACCESS IT VIA SERVER IP :- $(curl -s icanhazip.com)..."
echo " OK!"
printf "DEFAULT LOGIN ID IS :- admin.."
echo " OK!"
printf "DEFAULT LOGIN PASSWORD IS :- password.."
echo " OK!"
printf "PLEASE IMPORT LICENSE KEY IF YOU ALREADY HAVE - IF NOT REQUEST FOR TRAIL VERSION IN REDHAT SITE.."
echo " OK!"
}

main
