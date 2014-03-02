#!/bin/bash

########################################
# Restart all ceph processes
########################################

BASEDIR=$(dirname $0)

${BASEDIR}/stop-all.sh
${BASEDIR}/start-all.sh