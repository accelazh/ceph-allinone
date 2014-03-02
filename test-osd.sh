#!/bin/bash

########################################
# This file tests whether OSD services 
# are properly installed and running
########################################

BASEDIR=$(dirname $0)
. ${BASEDIR}/config.sh
. ${BASEDIR}/file_path.sh
. ${BASEDIR}/functions.sh
common_init

mon_ip_array=($mon_ip_list)
mon_port_array=($mon_port_list)

TMP_OBJECT_FILE=/tmp/object-to-test-osd.data
TMP_OBJECT_GET_FILE=/tmp/object-to-test-osd-get.data
OBJECT_NAME="test-osd-$(uuidgen)"

echo "checking whether ceph-osd process exists ..."
proc_exist="$(ps cax | grep ceph-osd)"
if [ -z "$proc_exist" ]; then
	echo "OSD processes is not running"
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

# check object put and get
rm -rf ${TMP_OBJECT_FILE}
rm -rf ${TMP_OBJECT_GET_FILE}

uuidgen > ${TMP_OBJECT_FILE}
if [ -z "$(cat ${TMP_OBJECT_FILE})" ]; then
	echo "Failed to generate object file ${TMP_OBJECT_FILE} to test OSD."
	exit 1
fi
echo "*********** Below may stuck for a while or with 'wrong node' messages, please wait patiently ... ************"
rados -c ${CONF_FILE} -m "${mon_ip_array}:${mon_port_array}" put ${OBJECT_NAME} ${TMP_OBJECT_FILE} --pool=data
if [ $? != 0 ]; then
	echo "Failed to write object to RADOS pool."
	exit 1
fi
echo "*********** Below may stuck for a while or with 'wrong node' messages, please wait patiently ... ************"
rados -c ${CONF_FILE} -m "${mon_ip_array}:${mon_port_array}" get ${OBJECT_NAME} ${TMP_OBJECT_GET_FILE} --pool=data
if [ $? != 0 ]; then
	echo "Failed to get object from RADOS pool."
	exit 1
fi
if [ "$(cat ${TMP_OBJECT_GET_FILE})" != "$(cat ${TMP_OBJECT_FILE})" ]; then
	echo "Retrieved object has unmatched content."
	exit 1
fi

# redo the log check again
echo "grep ceph log to find errors ..."
if [ "$(has_log_error)" != "0" ]; then
	echo "log file has errors!"
	exit 1
fi

echo "Successfully passed tests."
