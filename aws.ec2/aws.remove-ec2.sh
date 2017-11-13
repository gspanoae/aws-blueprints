#!/bin/bash

# Set setup config values
source aws.setup/aws.config.sh

# -----------------------------------------------------------
# Remove existing resources if exists

if [ -n "${EC2_INSTANCES_ID_LIST}" ]; then
    echo ">>> Existing EC2 instances detected"
    aws ec2 terminate-instances --instance-ids $EC2_INSTANCES_ID_LIST
    sleep 10
    echo ">>> Resource removed : ${EC2_INSTANCES_ID_LIST}"
fi