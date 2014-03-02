#!/bin/bash

##########################
# Start all monitor service 
# in a separeted $ceph_user specified in 
# config.sh
# View log in /var/log/ceph
##########################

BASEDIR=$(dirname $0)
. ${BASEDIR}/config.sh
. ${BASEDIR}/file_path.sh
. ${BASEDIR}/functions.sh
common_init

OSD_ID_FILE=${BASEDIR}/osd_id.runtime.data
mon_ip_array=($mon_ip_list)
mon_port_array=($mon_port_list)

for osd_id in $(cat $OSD_ID_FILE); do
	cmd="ceph-osd -i ${osd_id} --cluster ${cluster_name} -m ${mon_ip_array}:${mon_port_array}"
	sudo su ${ceph_user} -c "$cmd" -s /bin/bash
	n=$(( $n + 1 ))
done