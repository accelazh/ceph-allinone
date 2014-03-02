#!/bin/bash

#####################
# Stop all ceph-mon processes
#####################

BASEDIR=$(dirname $0)
. ${BASEDIR}/config.sh
. ${BASEDIR}/file_path.sh
. ${BASEDIR}/functions.sh
common_init

kill_mon
# give it time to cleanup
sleep 5



