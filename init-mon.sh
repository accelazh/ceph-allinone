#!/bin/bash

#####################
# This file initialize the data files needed by monitor.
# refer to http://ceph.com/docs/master/install/manual-deployment/
# for the process of initializing monitor
# This file won't start monitor service.
#####################

BASEDIR=$(dirname $0)
. ${BASEDIR}/config.sh
. ${BASEDIR}/file_path.sh
. ${BASEDIR}/functions.sh
common_init

mon_array=($mon_list)
mon_ip_array=($mon_ip_list)
mon_port_array=($mon_port_list)

# ========== Create folders needed for ceph ============

sudo mkdir -p $VAR_RUN_CEPH
sudo chown -R ${ceph_user}:${ceph_user} $VAR_RUN_CEPH

sudo mkdir -p $VAR_LIB_CEPH
sudo chown -R ${ceph_user}:${ceph_user} $VAR_LIB_CEPH

sudo mkdir -p $CEPH_LOG_FOLDER
sudo touch ${CEPH_GENERAL_LOG_FILE}
sudo touch ${CEPH_GENERAL_CLUSTER_LOG_FILE}
for m in "${mon_array[@]}"; do
	sudo touch "$(get_mon_log_file $m)"
done
sudo chown -R ${ceph_user}:${ceph_user} $CEPH_LOG_FOLDER

# ========== Create or add to the monitor map for all monitors ===========
pos=0
last_pos=$(( ${#mon_array[*]} - 1 ))
for m in "${mon_array[@]}"; do
	if [ $pos == 0 ]; then
		sudo monmaptool --create --add ${mon_array[$pos]} ${mon_ip_array[$pos]}:${mon_port_array[$pos]} --fsid $fsid $TMP_MON_MAP
	else
		sudo monmaptool --add ${mon_array[$pos]} ${mon_ip_array[$pos]}:${mon_port_array[$pos]} --fsid $fsid $TMP_MON_MAP
	fi
	pos=$(( $pos + 1 ))
done
sudo chown ${ceph_user}:${ceph_user} $TMP_MON_MAP

# ========= Populate the monitor services with the monitor map and keyring =========
for m in "${mon_array[@]}"; do
	sudo mkdir -p ${VAR_LIB_CEPH}/mon/${cluster_name}-${m}
done

pos=0
last_pos=$(( ${#mon_array[*]} - 1 ))
for m in "${mon_array[@]}"; do
	sudo ceph-mon --mkfs -i ${mon_array[$pos]} --monmap $TMP_MON_MAP --keyring $TMP_MON_KEYRING --mon-data ${VAR_LIB_CEPH}/mon/${cluster_name}-${mon_array[$pos]} -c $CONF_FILE
	pos=$(( $pos + 1 ))
done

sudo chown -R ${ceph_user}:${ceph_user} $VAR_LIB_CEPH
for m in "${mon_array[@]}"; do
	sudo chmod go-rwx ${VAR_LIB_CEPH}/mon/${cluster_name}-${m}/keyring
done


