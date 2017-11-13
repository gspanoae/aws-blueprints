#!/bin/bash

# Set setup config values
source aws.setup/aws.config.sh

# -----------------------------------------------------------
# Remove existing resources if exists

source aws.ec2/aws.remove-ec2.sh

if [ -n "${IGW_ID}" ]; then
    echo ">>> Existing IGW detected"
    aws ec2 detach-internet-gateway --internet-gateway-id $IGW_ID --vpc-id $VPC_ID
    echo ">>> Resource removed : ${IGW_ID}"
fi

if [ -n "${SUBNET_PUBLIC_2a_RTA_ID}" ]; then
    echo ">>> Existing SUBNET_PUBLIC_2a_RTA detected"
    aws ec2 disassociate-route-table --association-id $SUBNET_PUBLIC_2a_RTA_ID
    echo ">>> Resource removed : ${SUBNET_PUBLIC_2a_RTA_ID}"
fi
if [ -n "${SUBNET_PRIVATE_2a_RTA_ID}" ]; then
    echo ">>> Existing SUBNET_PRIVATE_2a_RTA detected"
    aws ec2 disassociate-route-table --association-id $SUBNET_PRIVATE_2a_RTA_ID
    echo ">>> Resource removed : ${SUBNET_PRIVATE_2a_RTA_ID}"
fi
if [ -n "${SUBNET_PUBLIC_2b_RTA_ID}" ]; then
    echo ">>> Existing SUBNET_PUBLIC_2b_RTA detected"
    aws ec2 disassociate-route-table --association-id $SUBNET_PUBLIC_2b_RTA_ID
    echo ">>> Resource removed : ${SUBNET_PUBLIC_2b_RTA_ID}"
fi
if [ -n "${SUBNET_PRIVATE_2b_RTA_ID}" ]; then
    echo ">>> Existing SUBNET_PRIVATE_2b_RTA detected"
    aws ec2 disassociate-route-table --association-id $SUBNET_PRIVATE_2b_RTA_ID
    echo ">>> Resource removed : ${SUBNET_PRIVATE_2b_RTA_ID}"
fi

if [ -n "${ROUTE_TABLE_PRIVATE_ID}" ] && [ "$ROUTE_TABLE_PRIVATE_ID" != "None" ]; then
    echo ">>> Existing ROUTE_TABLE_PRIVATE detected"
    aws ec2 delete-route-table --route-table-id $ROUTE_TABLE_PRIVATE_ID
    echo ">>> Resource removed : ${ROUTE_TABLE_PRIVATE_ID}"
fi

if [ -n "${SUBNET_PUBLIC_2a_ID}" ]; then
    echo ">>> Existing SUBNET_PUBLIC_2a detected"
    aws ec2 delete-subnet --subnet-id $SUBNET_PUBLIC_2a_ID
    echo ">>> Resource removed : ${SUBNET_PUBLIC_2a_ID}"
fi
if [ -n "${SUBNET_PRIVATE_2a_ID}" ]; then
    echo ">>> Existing SUBNET_PRIVATE_2a detected"
    aws ec2 delete-subnet --subnet-id $SUBNET_PRIVATE_2a_ID
    echo ">>> Resource removed : ${SUBNET_PRIVATE_2a_ID}"
fi
if [ -n "${SUBNET_PUBLIC_2b_ID}" ]; then
    echo ">>> Existing SUBNET_PUBLIC_2b detected"
    aws ec2 delete-subnet --subnet-id $SUBNET_PUBLIC_2b_ID
    echo ">>> Resource removed : ${SUBNET_PUBLIC_2b_ID}"
fi
if [ -n "${SUBNET_PRIVATE_2b_ID}" ]; then
    echo ">>> Existing SUBNET_PRIVATE_2b detected"
    aws ec2 delete-subnet --subnet-id $SUBNET_PRIVATE_2b_ID
    echo ">>> Resource removed : ${SUBNET_PRIVATE_2b_ID}"
fi
if [ -n "${VPC_ID}" ]; then
    echo ">>> Existing VPC detected"
    aws ec2 delete-vpc --vpc-id $VPC_ID
    echo ">>> Resource removed : ${VPC_ID}"
fi
