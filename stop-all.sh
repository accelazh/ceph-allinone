#!/bin/bash

########################################
# Stop all ceph processes
########################################

BASEDIR=$(dirname $0)

${BASEDIR}/stop-osd.sh
${BASEDIR}/stop-mon.sh