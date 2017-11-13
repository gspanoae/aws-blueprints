#!/bin/bash

# ###########################################################
# Set VPC CIDR and tags
VPC_CIDR=10.1.0.0/16
VPC_TAG_NAME=sys-vpc
# ###########################################################
# Set VPC Subnets CIDR and tags
SUBNET_PUBLIC_2a_CIDR=10.1.10.0/24
SUBNET_PUBLIC_2a_TAG_NAME=sys-vpc-net-public2a
SUBNET_PRIVATE_2a_CIDR=10.1.11.0/24
SUBNET_PRIVATE_2a_TAG_NAME=sys-vpc-net-private2a

SUBNET_PUBLIC_2b_CIDR=10.1.20.0/24
SUBNET_PUBLIC_2b_TAG_NAME=sys-vpc-net-public2b
SUBNET_PRIVATE_2b_CIDR=10.1.21.0/24
SUBNET_PRIVATE_2b_TAG_NAME=sys-vpc-net-private2b
# ###########################################################
# Set Route Table tags
ROUTE_TABLE_PUBLIC_TAG_NAME=sys-rtb-public
ROUTE_TABLE_PRIVATE_TAG_NAME=sys-rtb-private
# ###########################################################
# Set Internet Gateway
IGW_TAG_NAME=sys-igw
# ###########################################################

# -----------------------------------------------------------
# Get existing resources IDs
VPC_ID=$(aws ec2 describe-vpcs --filters Name=cidr,Values=$VPC_CIDR --query 'Vpcs[].VpcId' --output text)
SUBNET_PUBLIC_2a_ID=$(aws ec2 describe-subnets --filters Name=vpc-id,Values=$VPC_ID Name=cidr,Values=$SUBNET_PUBLIC_2a_CIDR --query 'Subnets[].SubnetId' --output text)
SUBNET_PRIVATE_2a_ID=$(aws ec2 describe-subnets --filters Name=vpc-id,Values=$VPC_ID Name=cidr,Values=$SUBNET_PRIVATE_2a_CIDR --query 'Subnets[].SubnetId' --output text)
SUBNET_PUBLIC_2b_ID=$(aws ec2 describe-subnets --filters Name=vpc-id,Values=$VPC_ID Name=cidr,Values=$SUBNET_PUBLIC_2b_CIDR --query 'Subnets[].SubnetId' --output text)
SUBNET_PRIVATE_2b_ID=$(aws ec2 describe-subnets --filters Name=vpc-id,Values=$VPC_ID Name=cidr,Values=$SUBNET_PRIVATE_2b_CIDR --query 'Subnets[].SubnetId' --output text)

# you can't remove the Main=true VPC route table
# ROUTE_TABLE_PUBLIC_MAIN_RTA_ID=$(aws ec2 describe-route-tables --filter Name=vpc-id,Values=$VPC_ID --query "RouteTables[].Associations[?Main=='true'].RouteTableAssociationId" --output text)
# ROUTE_TABLE_PUBLIC_ID=$(aws ec2 describe-route-tables --filters Name=vpc-id,Values=$VPC_ID Name=tag:Name,Values=$ROUTE_TABLE_PUBLIC_TAG_NAME --query 'RouteTables[].RouteTableId' --output text)
ROUTE_TABLE_PRIVATE_ID=$(aws ec2 describe-route-tables --filters Name=vpc-id,Values=$VPC_ID Name=tag:Name,Values=$ROUTE_TABLE_PRIVATE_TAG_NAME --query 'RouteTables[].RouteTableId' --output text)

SUBNET_PUBLIC_2a_RTA_ID=$(aws ec2 describe-route-tables --filter Name=association.subnet-id,Values=$SUBNET_PUBLIC_2a_ID --query "RouteTables[].Associations[?SubnetId=='$SUBNET_PUBLIC_2a_ID'].RouteTableAssociationId" --output text)
SUBNET_PRIVATE_2a_RTA_ID=$(aws ec2 describe-route-tables --filter Name=association.subnet-id,Values=$SUBNET_PRIVATE_2a_ID --query "RouteTables[].Associations[?SubnetId=='$SUBNET_PRIVATE_2a_ID'].RouteTableAssociationId" --output text)
SUBNET_PUBLIC_2b_RTA_ID=$(aws ec2 describe-route-tables --filter Name=association.subnet-id,Values=$SUBNET_PUBLIC_2b_ID --query "RouteTables[].Associations[?SubnetId=='$SUBNET_PUBLIC_2b_ID'].RouteTableAssociationId" --output text)
SUBNET_PRIVATE_2b_RTA_ID=$(aws ec2 describe-route-tables --filter Name=association.subnet-id,Values=$SUBNET_PRIVATE_2b_ID --query "RouteTables[].Associations[?SubnetId=='$SUBNET_PRIVATE_2b_ID'].RouteTableAssociationId" --output text)

IGW_ID=$(aws ec2 describe-internet-gateways --filters Name=attachment.vpc-id,Values=$VPC_ID --query 'InternetGateways[].InternetGatewayId' --output text)

# -----------------------------------------------------------
# Remove existing resources if exists
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

# -----------------------------------------------------------
# Define the VPC
echo ">>> Create new VPC"
VPC_ID=$(aws ec2 create-vpc --cidr-block $VPC_CIDR --instance-tenancy default --query 'Vpc.VpcId' --output text)

# Tag VPC with a Name
aws ec2 create-tags --resources $VPC_ID --tags Key=Name,Value=$VPC_TAG_NAME
echo ">>> Resource created (${VPC_TAG_NAME}) : ${VPC_ID}"

# -----------------------------------------------------------
# Define Subnets

echo ">>> Create new Subnets"

##########
## Define SUBNET_PUBLIC_2a
##########
SUBNET_PUBLIC_2a_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $SUBNET_PUBLIC_2a_CIDR --availability-zone eu-west-2a --query 'Subnet.SubnetId' --output text)

## Specify that all instances launched into this subnet are assigned a public IPv4  address
aws ec2 modify-subnet-attribute --subnet-id $SUBNET_PUBLIC_2a_ID --map-public-ip-on-launch

## Tag the subnet name
aws ec2 create-tags --resources $SUBNET_PUBLIC_2a_ID --tags Key=Name,Value=$SUBNET_PUBLIC_2a_TAG_NAME
echo ">>> Resource created (${SUBNET_PUBLIC_2a_TAG_NAME}) : ${SUBNET_PUBLIC_2a_ID}"

##########
## Subnet SUBNET_PRIVATE_2a
##########
SUBNET_PRIVATE_2a_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $SUBNET_PRIVATE_2a_CIDR --availability-zone eu-west-2a --query 'Subnet.SubnetId' --output text)

## Tag the subnet name
aws ec2 create-tags --resources $SUBNET_PRIVATE_2a_ID --tags Key=Name,Value=$SUBNET_PRIVATE_2a_TAG_NAME
echo ">>> Resource created (${SUBNET_PRIVATE_2a_TAG_NAME}) : ${SUBNET_PRIVATE_2a_ID}"

##########
## Subnet SUBNET_PUBLIC_2b
##########
SUBNET_PUBLIC_2b_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $SUBNET_PUBLIC_2b_CIDR --availability-zone eu-west-2b --query 'Subnet.SubnetId' --output text)

## Specify that all instances launched into this subnet are assigned a public IPv4  address
aws ec2 modify-subnet-attribute --subnet-id $SUBNET_PUBLIC_2b_ID --map-public-ip-on-launch

## Tag the subnet name
aws ec2 create-tags --resources $SUBNET_PUBLIC_2b_ID --tags Key=Name,Value=$SUBNET_PUBLIC_2b_TAG_NAME
echo ">>> Resource created (${SUBNET_PUBLIC_2b_TAG_NAME}) : ${SUBNET_PUBLIC_2b_ID}"

##########
## Subnet SUBNET_PRIVATE_2b
##########
SUBNET_PRIVATE_2b_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $SUBNET_PRIVATE_2b_CIDR --availability-zone eu-west-2b --query 'Subnet.SubnetId' --output text)

## Tag the subnet name
aws ec2 create-tags --resources $SUBNET_PRIVATE_2b_ID --tags Key=Name,Value=$SUBNET_PRIVATE_2b_TAG_NAME
echo ">>> Resource created (${SUBNET_PRIVATE_2b_TAG_NAME}) : ${SUBNET_PRIVATE_2b_ID}"

# -----------------------------------------------------------
# Define route tables

echo ">>> Create new route tables"

## Get default route table ID
ROUTE_TABLE_PUBLIC_ID=$(aws ec2 describe-route-tables --filters Name=vpc-id,Values=$VPC_ID Name=association.main,Values=true --query 'RouteTables[].RouteTableId' --output text)
echo ">>> Find default route table (${ROUTE_TABLE_PUBLIC_TAG_NAME}) : ${ROUTE_TABLE_PUBLIC_ID}"
## Tag the public route table
aws ec2 create-tags --resources $ROUTE_TABLE_PUBLIC_ID --tags Key=Name,Value=$ROUTE_TABLE_PUBLIC_TAG_NAME

## Associate public route table to public subnets
SUBNET_PUBLIC_2a_RTA_ID=$(aws ec2 associate-route-table --route-table-id $ROUTE_TABLE_PUBLIC_ID --subnet-id $SUBNET_PUBLIC_2a_ID --query 'AssociationId' --output text)
echo ">>> Resource created (route table association for ${SUBNET_PUBLIC_2a_TAG_NAME}) : ${SUBNET_PUBLIC_2a_RTA_ID}"
SUBNET_PUBLIC_2b_RTA_ID=$(aws ec2 associate-route-table --route-table-id $ROUTE_TABLE_PUBLIC_ID --subnet-id $SUBNET_PUBLIC_2b_ID --query 'AssociationId' --output text)
echo ">>> Resource created (route table association for ${SUBNET_PUBLIC_2b_TAG_NAME}) : ${SUBNET_PUBLIC_2b_RTA_ID}"

## Create private route table
ROUTE_TABLE_PRIVATE_ID=$(aws ec2 create-route-table --vpc-id $VPC_ID --query 'RouteTable.RouteTableId' --output text)
echo ">>> Resource created (${ROUTE_TABLE_PRIVATE_TAG_NAME}) : ${ROUTE_TABLE_PRIVATE_ID}"
## Tag the private route table
aws ec2 create-tags --resources $ROUTE_TABLE_PRIVATE_ID --tags Key=Name,Value=$ROUTE_TABLE_PRIVATE_TAG_NAME

## Associate private route table to public subnets
SUBNET_PRIVATE_2a_RTA_ID=$(aws ec2 associate-route-table --route-table-id $ROUTE_TABLE_PRIVATE_ID --subnet-id $SUBNET_PRIVATE_2a_ID --query 'AssociationId' --output text)
echo ">>> Resource created (route table association for ${SUBNET_PRIVATE_2a_TAG_NAME}) : ${SUBNET_PRIVATE_2a_RTA_ID}"
SUBNET_PRIVATE_2b_RTA_ID=$(aws ec2 associate-route-table --route-table-id $ROUTE_TABLE_PRIVATE_ID --subnet-id $SUBNET_PRIVATE_2b_ID --query 'AssociationId' --output text)
echo ">>> Resource created (route table association for ${SUBNET_PRIVATE_2b_TAG_NAME}) : ${SUBNET_PRIVATE_2b_RTA_ID}"

# -----------------------------------------------------------
# Define internet gateways

echo ">>> Create new internet gateway"

## Create new internet gateway
IGW_ID=$(aws ec2 create-internet-gateway --query 'InternetGateway.InternetGatewayId' --output text)
## Tag the internet gateway
aws ec2 create-tags --resources $IGW_ID --tags Key=Name,Value=$IGW_TAG_NAME
## Attach the Internet gateway to the VPC
aws ec2 attach-internet-gateway --internet-gateway-id $IGW_ID --vpc-id $VPC_ID
## Map the Internet gateway to the public route table
IGW_RT_STATUS=$(aws ec2 create-route --route-table-id $ROUTE_TABLE_PUBLIC_ID --destination-cidr-block 0.0.0.0/0 --gateway-id $IGW_ID)
echo ">>> Resource created (${IGW_TAG_NAME}) : ${IGW_ID}"
