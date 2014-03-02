#!/bin/bash

###################################
# This file generate keyrings for admin user,
# monitor and osd.
# ref: rhttp://ceph.com/docs/master/install/manual-deployment/
###################################

BASEDIR=$(dirname $0)
. ${BASEDIR}/config.sh
. ${BASEDIR}/file_path.sh
. ${BASEDIR}/functions.sh
common_init
# exit on error
set -e

CURRENT_USER=$(logname)

# ============ Add keyrings for admin. ==============

sudo ceph-authtool --create-keyring $ADMIN_KEYRING --gen-key -n client.admin --set-uid=0 --cap mon 'allow *' --cap osd 'allow *' --cap mds 'allow'
# here I changed the owner of admin keyring file to your user, not $ceph_user. So that you can admin ceph.
sudo chown ${CURRENT_USER}:${CURRENT_USER} $ADMIN_KEYRING
sudo chmod go-rwx $ADMIN_KEYRING

# ============ Add Keyrings for monitor =============

sudo ceph-authtool --create-keyring $TMP_MON_KEYRING --gen-key -n mon. --cap mon 'allow *'
sudo chown ${ceph_user}:${ceph_user} $TMP_MON_KEYRING
sudo chmod go-rwx $TMP_MON_KEYRING

sudo ceph-authtool $TMP_MON_KEYRING --import-keyring $ADMIN_KEYRING

# ============ Add keyrings for OSD ==============

# This will be performed in init-osd.sh. Because it relys on that monitors services are already running