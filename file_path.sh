#!/bin/bash

#######################
# This file defines the file paths.
# They will be used by other files
#######################

CONF_FOLDER=/etc/ceph
#ceph config should be named as ${cluster_name}.conf . ceph.conf is the default. ref: http://ceph.com/docs/master/install/manual-deployment/
CONF_FILE=${CONF_FOLDER}/${cluster_name}.conf

TMP_MON_KEYRING=/tmp/ceph.mon.keyring
ADMIN_KEYRING=/etc/ceph/ceph.client.admin.keyring

TMP_MON_MAP=/tmp/monmap

VAR_RUN_CEPH=/var/run/ceph
VAR_LIB_CEPH=/var/lib/ceph

CEPH_LOG_FOLDER=/var/log/ceph
CEPH_GENERAL_LOG_FILE=${CEPH_LOG_FOLDER}/ceph.log
CEPH_GENERAL_CLUSTER_LOG_FILE=${CEPH_LOG_FOLDER}/${cluster_name}.log


