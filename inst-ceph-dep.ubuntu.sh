#!/bin/bash

####################
# This file downloads and install ceph dependencies
#
# Note I have only provided ubuntu version of this file 
####################

sudo apt-get update -y

# basic system utilities
sudo apt-get install -y gcc ssh curl wget python git xfsprogs xfslibs-dev 
# according to https://github.com/ceph/ceph
sudo apt-get install -y automake autoconf pkg-config gcc g++ make libboost-dev libedit-dev libssl-dev libtool libfcgi libfcgi-dev libfuse-dev linux-kernel-headers libcrypto++-dev libaio-dev libgoogle-perftools-dev libkeyutils-dev uuid-dev libblkid-dev libatomic-ops-dev libboost-program-options-dev libboost-thread-dev libexpat1-dev libleveldb-dev libsnappy-dev libcurl4-gnutls-dev python-argparse python-flask python-nose
# according to http://ceph.com/docs/master/install/build-ceph/
sudo apt-get install -y uuid-dev libkeyutils-dev libgoogle-perftools-dev libatomic-ops-dev libaio-dev libgdata-common libgdata13 libsnappy-dev libleveldb-dev

# make sure that path to dynamic libraries *.so are refreshed. ref: http://tldp.org/HOWTO/Program-Library-HOWTO/shared-libraries.html
sudo ldconfig
