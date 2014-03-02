#!/bin/bash

##########################
# Connect to the ceph cluster for admin work
# Actually, it connects to the first monitor
# daemon
##########################

BASEDIR=$(dirname $0)
. ${BASEDIR}/config.sh
. ${BASEDIR}/file_path.sh
. ${BASEDIR}/functions.sh
common_init

mon_ip_array=($mon_ip_list)
mon_port_array=($mon_port_list)

# ${array} returns its first element
ceph -c $CONF_FILE -m ${mon_ip_array}:${mon_port_array}