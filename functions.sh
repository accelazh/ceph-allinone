#!/bin/bash

######################################
# Shared functions used across other scipts
######################################
BASEDIR=$(dirname $0)
. ${BASEDIR}/file_path.sh

function common_init(){
	# print command trace while executing
	set -x
}

# kill -9 all ceph process
function kill_ceph(){
	for pid in $(ps -ef | grep ceph | awk '{print $2}'); do
		if [ $pid != $$ ]; then
			echo "killing process $pid ..."
			sudo kill $pid > /dev/null 2>&1
		fi
	done
}

# kill -9 all ceph monitor process. 
# WARNING: kill may cause mon not to finish properly
function kill_mon(){
	for pid in $(ps -ef | grep ceph-mon | awk '{print $2}'); do
		if [ $pid != $$ ]; then
			echo "killing process $pid ..."
			sudo kill $pid > /dev/null 2>&1
		fi
	done
}

# kill -9 all ceph monitor process
# WARNING: kill may cause osd not to finish properly
function kill_osd(){
	for pid in $(ps -ef | grep ceph-osd | awk '{print $2}'); do
		if [ $pid != $$ ]; then
			echo "killing process $pid ..."
			sudo kill $pid > /dev/null 2>&1
		fi
	done
}

function has_log_error(){
	err_str="$(grep -ir error ${CEPH_LOG_FOLDER})"
	exclude_err_str="$(grep -ir '\.connect error' ${CEPH_LOG_FOLDER})"
	if [ -n "$err_str" -a "$err_str" != "$exclude_err_str" ]; then
		echo 1
	else
		echo 0
	fi
}

# remove all ceph config files
function purge_ceph_config(){
	sudo rm -rf $CONF_FOLDER
}

# remove all ceph data files
function purge_ceph_data(){
	sudo rm -rf $TMP_MON_MAP
	sudo rm -rf $TMP_MON_KEYRING

	sudo rm -rf $VAR_RUN_CEPH
	sudo rm -rf $VAR_LIB_CEPH
}

# remove all ceph log
function purge_ceph_log(){
	sudo rm -rf $CEPH_LOG_FOLDER
}

# pass into mon name, return mon log file path
function get_mon_log_file(){
	echo -n ${CEPH_LOG_FOLDER}/${cluster_name}-mon.${1}.log
}

# pass into osd id, return osd log file path
function get_osd_log_file(){
	echo -n ${CEPH_LOG_FOLDER}/${cluster_name}-osd.${1}.log
}

# pass into "a b c", return "a, b, c"
function list_add_comma(){
	arr=($1)
	last_pos=$(( ${#arr[*]} - 1 ))

	ret=""
	pos=0
	for e in "${arr[@]}"; do
		if [[ $pos == $last_pos ]]; then
			ret="${ret} $e" 
		else 
			ret="${ret} $e,"
		fi 
		pos=$(( $pos + 1 ))
  	done

  	echo -n "$ret"
  	return 0
}
