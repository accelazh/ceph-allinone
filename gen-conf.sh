#!/bin/bash

#########################
# This file generate the basic /etc/ceph.conf
# refer to http://ceph.com/docs/master/install/manual-deployment/
# You may modify it to customize.
#########################

BASEDIR=$(dirname $0)
. ${BASEDIR}/config.sh
. ${BASEDIR}/file_path.sh
. ${BASEDIR}/functions.sh
common_init

# create the ceph config file
sudo mkdir -p $CONF_FOLDER
sudo touch $CONF_FILE
sudo chmod a+r $CONF_FILE

# output default config file
sudo echo -e "" | sudo tee $CONF_FILE > /dev/null

sudo echo -e "[global]" | sudo tee -a $CONF_FILE > /dev/null
sudo echo -e "fsid = $fsid" | sudo tee -a $CONF_FILE > /dev/null
sudo echo -e mon initial members = $(list_add_comma "$mon_list") | sudo tee -a $CONF_FILE > /dev/null
sudo echo -e mon host = $(list_add_comma "$mon_ip_list") | sudo tee -a $CONF_FILE > /dev/null
sudo echo -e "public network = $public_network" | sudo tee -a $CONF_FILE > /dev/null

sudo echo -e "auth cluster required = cephx" | sudo tee -a $CONF_FILE > /dev/null
sudo echo -e "auth service required = cephx" | sudo tee -a $CONF_FILE > /dev/null
sudo echo -e "auth client required = cephx" | sudo tee -a $CONF_FILE > /dev/null

sudo echo -e "osd journal size = 1024 " | sudo tee -a $CONF_FILE > /dev/null
sudo echo -e "filestore xattr use omap = true" | sudo tee -a $CONF_FILE > /dev/null
sudo echo -e "osd pool default size = 2 " | sudo tee -a $CONF_FILE > /dev/null
sudo echo -e "osd pool default min size = 1 " | sudo tee -a $CONF_FILE > /dev/null
sudo echo -e "osd pool default pg num = 512 " | sudo tee -a $CONF_FILE > /dev/null
sudo echo -e "osd pool default pgp num = 512 " | sudo tee -a $CONF_FILE > /dev/null

# multiple osd on single node needs to set this to 0 (default is 1). ref: http://ceph.com/docs/dumpling/start/quick-ceph-deploy/ Single Node Quick Start
sudo echo -e "osd crush chooseleaf type = 0 " | sudo tee -a $CONF_FILE > /dev/null





