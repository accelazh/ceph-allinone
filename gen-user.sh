#!/bin/bash

######################
# This file add a new user $ceph_user, according to config.sh.
# ceph services will be run in this user.
# However ceph source, library and executable files are not installed to 
# belong to $ceph_user. Only services belong to $ceph_user
######################

BASEDIR=$(dirname $0)
. ${BASEDIR}/config.sh
. ${BASEDIR}/file_path.sh
. ${BASEDIR}/functions.sh
common_init

sudo useradd -s /usr/sbin/nologin $ceph_user

