#!/bin/bash

aws ec2 run-instances \
--image-id ami-e3051987 \
--instance-type t2.micro \
--count 1 \
--subnet-id subnet-35d0844e \
--monitoring Enabled=false \
--instance-initiated-shutdown-behavior stop \
--disable-api-termination \
--no-ebs-optimized \
--key-name devbox \
--security-group-ids sg-0f04d767 \
--associate-public-ip-address \
--tag-specifications 'ResourceType=instance,Tags=[{Key=webserver,Value=production}]'
