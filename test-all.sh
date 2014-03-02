#!/bin/bash

########################################
# This file tests whether all services 
# are properly installed and running
########################################

BASEDIR=$(dirname $0)
. ${BASEDIR}/config.sh

${BASEDIR}/test-mon.sh
if [ $? != 0 ]; then
	echo "Monitor tests failed. Exiting configuration process."
	exit 1
fi

${BASEDIR}/test-osd.sh
if [ $? != 0 ]; then
	echo "OSD tests failed. Exiting configuration process."
	exit 1
fi

# to test whether working after restart
# TODO-01 re-start may causes errors sometime (i.e. won't pass my tests). It may because 'stop' uses kill to terminate processes. Avoiding re-start (i.e don't stop) will walkaround this problem. But I think re-start is still a needed feature. 
if [ "$test_restart" == "true" ]; then
	echo "Performing restart tests ..."
	${BASEDIR}/stop-all.sh
	${BASEDIR}/start-all.sh

	${BASEDIR}/test-osd.sh
	if [ $? != 0 ]; then
		echo "OSD tests failed. Exiting configuration process."
		exit 1
	fi

	${BASEDIR}/test-mon.sh
	if [ $? != 0 ]; then
		echo "Monitor tests failed. Exiting configuration process."
		exit 1
	fi
fi

echo "All tests have succeeded."
