#!/bin/bash

#####################
# Stop all ceph-osd processes
#####################

BASEDIR=$(dirname $0)
. ${BASEDIR}/config.sh
. ${BASEDIR}/file_path.sh
. ${BASEDIR}/functions.sh
common_init

kill_osd
# give it time to cleanup
sleep 5
