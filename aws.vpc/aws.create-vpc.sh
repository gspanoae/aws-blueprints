#!/bin/bash

# Set VPC CIDR
VPC_CIDR=10.1.0.0/16
VPC_TAG_NAME=systemVpc

# Set VPC Subnets CIDR
SUBNET_PUBLIC_2a_CIDR=10.1.10.0/24
SUBNET_PUBLIC_2a_TAG_NAME=systemVpc-subnet-public2a
SUBNET_PRIVATE_2a_CIDR=10.1.11.0/24
SUBNET_PRIVATE_2a_TAG_NAME=systemVpc-subnet-private2a

SUBNET_PUBLIC_2b_CIDR=10.1.20.0/24
SUBNET_PUBLIC_2b_TAG_NAME=systemVpc-subnet-public2b
SUBNET_PRIVATE_2b_CIDR=10.1.21.0/24
SUBNET_PRIVATE_2b_TAG_NAME=systemVpc-subnet-private2b

# Get existing resources IDs
VPC_ID=$(aws ec2 describe-vpcs --filters Name=cidr,Values=$VPC_CIDR --query 'Vpcs[].VpcId' --output text)
SUBNET_PUBLIC_2a_ID=$(aws ec2 describe-subnets --filters Name=vpc-id,Values=$VPC_ID Name=cidr,Values=$SUBNET_PUBLIC_2a_CIDR --query 'Subnets[].SubnetId' --output text)
SUBNET_PRIVATE_2a_ID=$(aws ec2 describe-subnets --filters Name=vpc-id,Values=$VPC_ID Name=cidr,Values=$SUBNET_PRIVATE_2a_CIDR --query 'Subnets[].SubnetId' --output text)
SUBNET_PUBLIC_2b_ID=$(aws ec2 describe-subnets --filters Name=vpc-id,Values=$VPC_ID Name=cidr,Values=$SUBNET_PUBLIC_2b_CIDR --query 'Subnets[].SubnetId' --output text)
SUBNET_PRIVATE_2b_ID=$(aws ec2 describe-subnets --filters Name=vpc-id,Values=$VPC_ID Name=cidr,Values=$SUBNET_PRIVATE_2b_CIDR --query 'Subnets[].SubnetId' --output text)

# Remove existing resources if exists
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

# --------------------------------
# Define the VPC
echo ">>> Create new VPC"
aws ec2 create-vpc \
--cidr-block $VPC_CIDR \
--instance-tenancy default
# Get new VPC ID
VPC_ID=$(aws ec2 describe-vpcs --filters Name=cidr,Values=$VPC_CIDR --query 'Vpcs[].VpcId' --output text)
# Tag VPC with a Name
aws ec2 create-tags \
--resources \
$VPC_ID \
--tags \
Key=Name,Value=$VPC_TAG_NAME
echo ">>> Resource created : ${VPC_ID}"
# --------------------------------
# Define Subnets

echo ">>> Create new Subnets"

## Define SUBNET_PUBLIC_2a
aws ec2 create-subnet \
--vpc-id $VPC_ID \
--cidr-block $SUBNET_PUBLIC_2a_CIDR \
--availability-zone eu-west-2a
## Get subnet ID
SUBNET_PUBLIC_2a_ID=$(aws ec2 describe-subnets --filters Name=vpc-id,Values=$VPC_ID Name=cidr,Values=$SUBNET_PUBLIC_2a_CIDR --query 'Subnets[].SubnetId' --output text)
## Specify that all instances launched into this subnet are assigned a public IPv4  address
aws ec2 modify-subnet-attribute \
--subnet-id $SUBNET_PUBLIC_2a_ID \
--map-public-ip-on-launch
## Tag the subnet name
aws ec2 create-tags \
--resources \
$SUBNET_PUBLIC_2a_ID \
--tags \
Key=Name,Value=$SUBNET_PUBLIC_2a_TAG_NAME
echo ">>> Resource created : ${SUBNET_PUBLIC_2a_ID}"

## Subnet SUBNET_PRIVATE_2a
aws ec2 create-subnet \
--vpc-id $VPC_ID \
--cidr-block $SUBNET_PRIVATE_2a_CIDR \
--availability-zone eu-west-2a
## Get subnet ID
SUBNET_PRIVATE_2a_ID=$(aws ec2 describe-subnets --filters Name=vpc-id,Values=$VPC_ID Name=cidr,Values=$SUBNET_PRIVATE_2a_CIDR --query 'Subnets[].SubnetId' --output text)
## Tag the subnet name
aws ec2 create-tags \
--resources \
$SUBNET_PRIVATE_2a_ID \
--tags \
Key=Name,Value=$SUBNET_PRIVATE_2a_TAG_NAME
echo ">>> Resource created : ${SUBNET_PRIVATE_2a_ID}"

## Subnet SUBNET_PUBLIC_2b
aws ec2 create-subnet \
--vpc-id $VPC_ID \
--cidr-block $SUBNET_PUBLIC_2b_CIDR \
--availability-zone eu-west-2b
## Get subnet ID
SUBNET_PUBLIC_2b_ID=$(aws ec2 describe-subnets --filters Name=vpc-id,Values=$VPC_ID Name=cidr,Values=$SUBNET_PUBLIC_2b_CIDR --query 'Subnets[].SubnetId' --output text)
## Specify that all instances launched into this subnet are assigned a public IPv4  address
aws ec2 modify-subnet-attribute \
--subnet-id $SUBNET_PUBLIC_2b_ID \
--map-public-ip-on-launch
## Tag the subnet name
aws ec2 create-tags \
--resources \
$SUBNET_PUBLIC_2b_ID \
--tags \
Key=Name,Value=$SUBNET_PUBLIC_2b_TAG_NAME
echo ">>> Resource created : ${SUBNET_PUBLIC_2b_ID}"

## Subnet SUBNET_PRIVATE_2b
aws ec2 create-subnet \
--vpc-id $VPC_ID \
--cidr-block $SUBNET_PRIVATE_2b_CIDR \
--availability-zone eu-west-2b
## Get subnet ID
SUBNET_PRIVATE_2b_ID=$(aws ec2 describe-subnets --filters Name=vpc-id,Values=$VPC_ID Name=cidr,Values=$SUBNET_PRIVATE_2b_CIDR --query 'Subnets[].SubnetId' --output text)
## Tag the subnet name
aws ec2 create-tags \
--resources \
$SUBNET_PRIVATE_2b_ID \
--tags \
Key=Name,Value=$SUBNET_PRIVATE_2b_TAG_NAME
echo ">>> Resource created : ${SUBNET_PRIVATE_2b_ID}"
