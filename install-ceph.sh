#!/bin/bash

#########################
# This file git ceph, switch to firefly branch, 
# download necessary software, then build ceph,
# then make install ceph into your system.
# 
# ceph code will be downloaded into same folder
# of this script, in workspace/ceph. I use branch
# firefly to build
#
# No need to run as root, or sudo
#########################

BASEDIR=$(dirname $0)
. ${BASEDIR}/config.sh
set -x

CURRENT_USER=$(logname)
WORKSPACE=${BASEDIR}/workspace
CEPH_FOLDER=ceph
CEPH_GIT="https://github.com/ceph/ceph.git"
CEPH_BRANCH=${git_branch}

# make sure we have a clean environment
rm -rf ${WORKSPACE}/${CEPH_FOLDER}

# install ceph dependencies
. ${BASEDIR}/inst-ceph-dep.ubuntu.sh

# git clone the ceph source
mkdir -p ${WORKSPACE}
cd $WORKSPACE
git clone $CEPH_GIT
cd $CEPH_FOLDER 
git checkout $CEPH_BRANCH

# build ceph and build install
git submodule update --init
${BASEDIR}/autogen.sh
${BASEDIR}/configure
make
sudo make install

# make sure that path to dynamic libraries *.so are refreshed. ref: http://tldp.org/HOWTO/Program-Library-HOWTO/shared-libraries.html
sudo ldconfig