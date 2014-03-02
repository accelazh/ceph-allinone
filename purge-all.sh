#!/bin/bash

##########################
# Terminate ceph service, delete ceph config files and data files. 
# ceph source files, library files and executable files will not be 
# touched. So that you could easily reinstall the serivces.
##########################

# ======== Initializing =========

BASEDIR=$(dirname $0)
. ${BASEDIR}/config.sh
. ${BASEDIR}/file_path.sh
. ${BASEDIR}/functions.sh
common_init

# ======== Kill all ceph processes ========

kill_ceph

# ======== Remove all ceph config and data files. Source, library and executable files remains ========

purge_ceph_config
purge_ceph_data
purge_ceph_log

# ======== Remove ceph user. ceph user is used to run services. Source, library and executable files don't belong to it ========

sudo userdel -r $ceph_user > /dev/null 2>&1