#!/usr/bin/env bash

export SERVICE=postgresql
export ENTRY_PATH=/usr/bin/postmaster
export CONSTABLE_CONFIG=/root/Constable/constable/minimal/constable.conf
export MEDUSA_CONFIG=/root/Constable/constable/minimal/clean.conf
export CONSTABLE_PATH=/root/Constable/constable

./run_service.sh
