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
--image-id $AMI_AMAZON_LINUX_ID \
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
--tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=aws-linux-public-2a}]'

aws ec2 run-instances \
--image-id $AMI_AMAZON_LINUX_ID \
--instance-type t2.micro \
--count 1 \
--subnet-id $SUBNET_PUBLIC_2b_ID \
--monitoring Enabled=false \
--instance-initiated-shutdown-behavior stop \
--enable-api-termination \
--no-ebs-optimized \
--key-name devbox \
--security-group-ids $SECURITYGROUP_DEFAULT_ID \
--associate-public-ip-address \
--tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=aws-linux-public-2b}]'

# aws ec2 run-instances \
# --image-id $AMI_WINDOWS_2016_ID \
# --instance-type t2.micro \
# --count 1 \
# --subnet-id $SUBNET_PUBLIC_2a_ID \
# --monitoring Enabled=false \
# --instance-initiated-shutdown-behavior stop \
# --enable-api-termination \
# --no-ebs-optimized \
# --key-name devbox \
# --security-group-ids $SECURITYGROUP_DEFAULT_ID \
# --associate-public-ip-address \
# --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=win-2016-public-2a}]'

aws ec2 run-instances \
--image-id $AMI_AMAZON_LINUX_ID \
--instance-type t2.micro \
--count 1 \
--subnet-id $SUBNET_PRIVATE_2a_ID \
--monitoring Enabled=false \
--instance-initiated-shutdown-behavior stop \
--enable-api-termination \
--no-ebs-optimized \
--key-name devbox \
--security-group-ids $SECURITYGROUP_DEFAULT_ID \
--no-associate-public-ip-address \
--tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=aws-linux-private-2a}]'

aws ec2 run-instances \
--image-id $AMI_AMAZON_LINUX_ID \
--instance-type t2.micro \
--count 1 \
--subnet-id $SUBNET_PRIVATE_2b_ID \
--monitoring Enabled=false \
--instance-initiated-shutdown-behavior stop \
--enable-api-termination \
--no-ebs-optimized \
--key-name devbox \
--security-group-ids $SECURITYGROUP_DEFAULT_ID \
--no-associate-public-ip-address \
--tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=aws-linux-private-2b}]'

# aws ec2 run-instances \
# --image-id $AMI_WINDOWS_2016_ID \
# --instance-type t2.micro \
# --count 1 \
# --subnet-id $SUBNET_PRIVATE_2a_ID \
# --monitoring Enabled=false \
# --instance-initiated-shutdown-behavior stop \
# --enable-api-termination \
# --no-ebs-optimized \
# --key-name devbox \
# --security-group-ids $SECURITYGROUP_DEFAULT_ID \
# --no-associate-public-ip-address \
# --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=win-2016-private-2a}]'


