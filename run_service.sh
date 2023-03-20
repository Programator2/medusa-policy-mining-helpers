#!/usr/bin/env bash

# This script runs some service and gets audit data.

: ${SERVICE:=postgresql}
: ${ENTRY_PATH:=/usr/bin/pg_ctlcluster}
: ${CONSTABLE_CONFIG:=/home/roderik/Constable/constable/minimal/constable.conf}
: ${MEDUSA_CONFIG:=/home/roderik/Constable/constable/minimal/clean.conf}
: ${CONSTABLE_PATH:=/home/roderik/Constable/constable}

# ${SERVICE:=sshd}
# ${ENTRY_PATH:=/usr/sbin/sshd}
#
# ${SERVICE:=mariadb}
# ${ENTRY_PATH:=/usr/sbin/sshd}

dir=$PWD
sudo systemctl stop $SERVICE
# modify Constable config
cp constable.conf $CONSTABLE_CONFIG
sed s+{{{entry_path}}}+$ENTRY_PATH+ medusa.conf > $MEDUSA_CONFIG
# run Constable
cd $CONSTABLE_PATH
echo Starting Constable...
sudo ./constable minimal/constable.conf > /dev/null &
constable_pid=$!
sleep 1
# check audit
audit_logfile=$dir/$(date +%Y-%m-%dT%H%M%S)-$SERVICE.log
sudo bash -c "tail -F /var/log/audit/audit.log > $audit_logfile" &
echo Starting $SERVICE...
sudo systemctl start $SERVICE
sleep 5
echo Stopping $SERVICE...
sudo systemctl stop $SERVICE
sleep 1
sudo sync /var/log/audit/audit.log
sync $audit_logfile
kill $!
# kill Constable
echo Killing Constable...
sudo kill $constable_pid
