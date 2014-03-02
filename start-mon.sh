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

mon_array=($mon_list)

for m in "${mon_array[@]}"; do
	cmd="ceph-mon -i $m --cluster $cluster_name"
	sudo su ${ceph_user} -c "$cmd" -s /bin/bash
done
