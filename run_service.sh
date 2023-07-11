#!/usr/bin/env bash

#  Copyright (C) 2023 Roderik Ploszek
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
tail -n1 /var/log/audit/audit.log > $dir/last_line_from_audit.log
echo Starting $SERVICE...
sudo systemctl start $SERVICE
sleep 5
echo Stopping $SERVICE...
sudo systemctl stop $SERVICE
sleep 1
sudo sync /var/log/audit/audit.log
audit_log_files=$(ls -t -r /var/log/audit/audit.log*)
$dir/read_from.py <(cat $audit_log_files) $dir/last_line_from_audit.log > $audit_logfile
# kill Constable
echo Killing Constable...
sudo kill $constable_pid
