#!/bin/bash

########################################
# Start all ceph processes
########################################

BASEDIR=$(dirname $0)

${BASEDIR}/start-mon.sh

# ensure that OSD starts after Monitors are working
${BASEDIR}/test-mon.sh
if [ $? != 0 ]; then
	echo "Monitor tests failed. Exiting startup process."
	exit 1
fi
${BASEDIR}/start-osd.sh