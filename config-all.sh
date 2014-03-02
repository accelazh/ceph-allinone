#!/bin/bash

##########################
# This file configures ceph,
# according to the configuration you 
# set in config.sh
# 
# WARNING: it will earse oriiginal
# ceph configuration data files
# 
# after configuration, service will
# already be started
##########################

BASEDIR=$(dirname $0)

# make sure we have a clean start
${BASEDIR}/purge-all.sh 

${BASEDIR}/gen-user.sh
${BASEDIR}/gen-conf.sh 
${BASEDIR}/gen-keyrings.sh
${BASEDIR}/init-mon.sh

# to config OSD we need monitors running
${BASEDIR}/start-mon.sh
${BASEDIR}/test-mon.sh
if [ $? != 0 ]; then
	echo "Monitor tests failed. Exiting configuration process. You can use purge-all.sh to cleanup."
	exit 1
fi

${BASEDIR}/init-osd.sh
${BASEDIR}/start-osd.sh
${BASEDIR}/test-osd.sh
if [ $? != 0 ]; then
	echo "OSD tests failed. Exiting configuration process. You can use purge-all.sh to cleanup."
	exit 1
fi

${BASEDIR}/test-all.sh
if [ $? != 0 ]; then
	echo "Final tests failed. Exiting configuration process. You can use purge-all.sh to cleanup."
	exit 1
fi

echo ""
echo "###########################################################################"
echo "The configuration has succeeded! Services already started."
echo "Use connect.py to get into ceph command line."
echo "Use start-all.sh, stop-all, restart-all to manage ceph services."
echo "Use test-all.sh to check whether services are working normally."
echo "Use purge-all.sh to remove all and cleanup."
echo "Use config-all.sh again (don't need purge-all.sh before it) to get a fresh clean re-install. It includes tests to ensure services are properly installed."
echo "###########################################################################"
echo ""


