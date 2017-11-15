#!/bin/bash

# ###########################################################
# Set setup config values
source aws.setup/aws.config.sh
# -----------------------------------------------------------
# Remove existing resources if exists
source aws.vpc/aws.remove-vpc.sh
# ###########################################################

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

# -----------------------------------------------------------
# Define security groups

echo ">>> Find VPC default security group"
# Get VPC default security group
SECURITYGROUP_DEFAULT_ID=$(aws ec2 describe-security-groups --filters Name=vpc-id,Values=$VPC_ID Name=group-name,Values=default --query 'SecurityGroups[].GroupId' --output text)

echo ">>> Set default security group SSH inbound rule (security-group: ${SECURITYGROUP_DEFAULT_ID} )"
# Set default security group SSH inbound rule (Note: all IPs are allowed)
aws ec2 authorize-security-group-ingress --group-id $SECURITYGROUP_DEFAULT_ID --protocol tcp --port 22 --cidr 0.0.0.0/0
# Set default security group RDP inbound rule (Note: all IPs are allowed)
aws ec2 authorize-security-group-ingress --group-id $SECURITYGROUP_DEFAULT_ID --protocol tcp --port 3389 --cidr 0.0.0.0/0

# -----------------------------------------------------------
# Define NAT gateway and Elastic IPs

# NATGATEWAY_2a_EIPALLOC_ID=$(aws ec2 allocate-address --domain vpc --query 'AllocationId' --output text)
# NATGATEWAY_2a_ID=$(aws ec2 create-nat-gateway --subnet-id $SUBNET_PUBLIC_2a_ID --allocation-id $NATGATEWAY_2a_EIPALLOC_ID --query 'NatGateway.NatGatewayId' --output text)
## Map the nat gateway to the private route table
# NGW_RT_STATUS=$(aws ec2 create-route --route-table-id $ROUTE_TABLE_PRIVATE_ID --destination-cidr-block 0.0.0.0/0 --nat-gateway-id $NATGATEWAY_2a_ID)

# TODO: the NAT Gateway is deployed in 1 public subnet and is mapped to a route table. For full HA we should create a second NGW in AZb and a second private route table
# NATGATEWAY_2b_EIPALLOC_ID=$(aws ec2 allocate-address --domain vpc --query 'AllocationId' --output text)
# NATGATEWAY_2b_ID=$(aws ec2 create-nat-gateway --subnet-id $SUBNET_PUBLIC_2b_ID --allocation-id $NATGATEWAY_2b_EIPALLOC_ID --query 'NatGateway.NatGatewayId' --output text)

