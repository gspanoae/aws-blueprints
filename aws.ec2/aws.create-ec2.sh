#!/bin/bash

# ###########################################################
# Set setup config values
source aws.setup/aws.config.sh
# -----------------------------------------------------------
# Remove existing resources if exists
source aws.ec2/aws.remove-ec2.sh
# ###########################################################

# -----------------------------------------------------------
# Provisioning and launching EC2 instances

aws ec2 run-instances \
--image-id ami-e3051987 \
--instance-type t2.micro \
--count 1 \
--subnet-id $SUBNET_PUBLIC_2a_ID \
--monitoring Enabled=false \
--instance-initiated-shutdown-behavior stop \
--enable-api-termination \
--no-ebs-optimized \
--key-name devbox \
--security-group-ids $SECURITYGROUP_DEFAULT_ID \
--associate-public-ip-address \
--tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=web1}]'

aws ec2 run-instances \
--image-id ami-e3051987 \
--instance-type t2.micro \
--count 1 \
--subnet-id $SUBNET_PUBLIC_2a_ID \
--monitoring Enabled=false \
--instance-initiated-shutdown-behavior stop \
--enable-api-termination \
--no-ebs-optimized \
--key-name devbox \
--security-group-ids $SECURITYGROUP_DEFAULT_ID \
--associate-public-ip-address \
--tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=web2}]'
