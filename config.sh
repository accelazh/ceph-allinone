#!/bin/bash

####################
# This file contains config options similar to ceph.conf
# It is a shell script that will be executed. The config
# options then become variables.
# ref: http://ceph.com/docs/master/install/manual-deployment/
#
# This file is for you to config.
####################

# The code branch on ceph github. Firefly is the newest release now (March, 2014). 
git_branch=firefly

# The user of ceph serivces. Monitor and osd will be installed under this user account.
ceph_user=ceph_service

# Your hostname to install ceph all-in-one. You can use localhost 
host_name=localhost 

# Please replace it with another uuid. Use command uuidgen to generate a uuid.
fsid=0bcc96c7-444a-42da-bb16-77793160c072 

# Ceph supports setting custom custer name. On default it is 'ceph'.
cluster_name=clusterA 

# Monitor list. You can install multiple monitors on single node, at least 3.
# Use space, and only space to separate multiple monitors. Don't omit double quotes. 
mon_list="mon.0 mon.1 mon.2"  # The name of each monitor
mon_ip_list="127.0.0.1 127.0.0.1 127.0.0.1"
mon_port_list="6790 6791 6792"

# How many OSDs you want to install on all-in-one host
osd_count=3 

# Seems have no big effect on all-in-one condition
public_network=192.168.255.0/24

# this is used by test-all.sh. set to true will test whether service is working after restart. This is slow and, on the other hand, restarting sometimes (rarely) may cause trouble, see TODO-01.
#test_restart=true



