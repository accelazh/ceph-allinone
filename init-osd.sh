#!/bin/bash

#########################
# Create and initialize OSDs.
# This should be run after monitors
# are installed and started.
# ref: http://ceph.com/docs/master/install/manual-deployment/
#########################

BASEDIR=$(dirname $0)
. ${BASEDIR}/config.sh
. ${BASEDIR}/file_path.sh
. ${BASEDIR}/functions.sh
common_init

mon_ip_array=($mon_ip_list)
mon_port_array=($mon_port_list)
OSD_ID_FILE=${BASEDIR}/osd_id.runtime.data

# add this node to CRUSH map
ceph osd crush add-bucket ${host_name} host -c ${CONF_FILE} -m "${mon_ip_array}:${mon_port_array}"
# place this node under the root default
ceph osd crush move ${host_name} root=default -c ${CONF_FILE} -m "${mon_ip_array}:${mon_port_array}"
# clean osd id file. I will use it later to keep a record of osd id
echo -n '' > $OSD_ID_FILE

n=1
while [ $n -le $osd_count ]; do
	# create OSD. return OSD id
	osd_id=$(ceph osd create -c ${CONF_FILE} -m "${mon_ip_array}:${mon_port_array}")
	echo $osd_id >> $OSD_ID_FILE

	# create data directory for osd. we will use 
	osd_data_dir="${VAR_LIB_CEPH}/osd/${cluster_name}-${osd_id}"
	sudo mkdir -p $osd_data_dir

	# initialize the OSD data directory.
	sudo ceph-osd -i ${osd_id} --cluster ${cluster_name} --mkfs --mkkey
	sudo chmod go-rwx ${osd_data_dir}/keyring

	# register the OSD authentication key.
	sudo ceph auth add osd.${osd_id} osd 'allow *' mon 'allow rwx' -i ${osd_data_dir}/keyring -c ${CONF_FILE} -m "${mon_ip_array}:${mon_port_array}"

	# add the OSD to the CRUSH map so that it can begin receiving data
	ceph osd crush add osd.${osd_id} 1.0 host=${host_name} -c ${CONF_FILE} -m "${mon_ip_array}:${mon_port_array}"

	# create log file with proper owner
	sudo touch "$(get_osd_log_file $osd_id)"
	sudo echo -n '' | sudo tee "$(get_osd_log_file $osd_id)" > /dev/null # clear the content of log, because there are some false error in it that will mess up tests.
	sudo chown ${ceph_user}:${ceph_user} "$(get_osd_log_file $osd_id)"

	n=$(( $n + 1 ))
done

# change owner of newly created folders to ${ceph_user}
sudo chown -R ${ceph_user}:${ceph_user} ${VAR_LIB_CEPH}/osd
