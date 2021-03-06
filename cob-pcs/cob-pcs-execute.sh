#!/usr/bin/env bash

# Script for executing commands on all cob-stud-pc's.

# checking input parameters
if [ "$#" -lt 1 ]; then
	echo "ERROR: Wrong number of parameters"
	echo "Usage: $0 command"
	exit 1
fi

#### retrieve client_list variables
source /u/robot/git/setup_cob4/helper_client_list.sh

for client in $client_list_hostnames; do
	echo "-------------------------------------------"
	echo "Executing <<"$*">> on $client"
	echo "-------------------------------------------"
	echo ""
	ssh $client "$*"
	ret=${PIPESTATUS[0]}
	if [ $ret != 0 ] ; then
		echo "command return an error (error code: $ret), aborting..."
		exit 1
	fi
	echo ""
done
