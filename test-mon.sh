#!/bin/bash

########################################
# This file tests whether monitor services 
# are properly installed and running
########################################

BASEDIR=$(dirname $0)
. ${BASEDIR}/config.sh
. ${BASEDIR}/file_path.sh
. ${BASEDIR}/functions.sh
common_init

mon_ip_array=($mon_ip_list)
mon_port_array=($mon_port_list)

echo "checking whether ceph-mon process exists ..."
proc_exist="$(ps cax | grep ceph-mon)"
if [ -z "$proc_exist" ]; then
	echo "monitor processes is not running"
	exit 1
fi

echo "grep ceph log to find errors ..."
if [ "$(has_log_error)" != "0" ]; then
	echo "log file has errors!"
	exit 1
fi

echo "Testing by ceph status ..."
ceph status -c ${CONF_FILE} -m "${mon_ip_array}:${mon_port_array}"
if [ $? != 0 ]; then
	echo "can not get ceph status!"
	exit 1
fi

echo "Successfully passed tests."
