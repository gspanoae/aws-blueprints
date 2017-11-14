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
ROUTE_TABLE_PUBLIC_ID=$(aws ec2 describe-route-tables --filters Name=vpc-id,Values=$VPC_ID Name=tag:Name,Values=$ROUTE_TABLE_PUBLIC_TAG_NAME --query 'RouteTables[].RouteTableId' --output text)
ROUTE_TABLE_PRIVATE_ID=$(aws ec2 describe-route-tables --filters Name=vpc-id,Values=$VPC_ID Name=tag:Name,Values=$ROUTE_TABLE_PRIVATE_TAG_NAME --query 'RouteTables[].RouteTableId' --output text)

SUBNET_PUBLIC_2a_RTA_ID=$(aws ec2 describe-route-tables --filter Name=association.subnet-id,Values=$SUBNET_PUBLIC_2a_ID --query "RouteTables[].Associations[?SubnetId=='$SUBNET_PUBLIC_2a_ID'].RouteTableAssociationId" --output text)
SUBNET_PRIVATE_2a_RTA_ID=$(aws ec2 describe-route-tables --filter Name=association.subnet-id,Values=$SUBNET_PRIVATE_2a_ID --query "RouteTables[].Associations[?SubnetId=='$SUBNET_PRIVATE_2a_ID'].RouteTableAssociationId" --output text)
SUBNET_PUBLIC_2b_RTA_ID=$(aws ec2 describe-route-tables --filter Name=association.subnet-id,Values=$SUBNET_PUBLIC_2b_ID --query "RouteTables[].Associations[?SubnetId=='$SUBNET_PUBLIC_2b_ID'].RouteTableAssociationId" --output text)
SUBNET_PRIVATE_2b_RTA_ID=$(aws ec2 describe-route-tables --filter Name=association.subnet-id,Values=$SUBNET_PRIVATE_2b_ID --query "RouteTables[].Associations[?SubnetId=='$SUBNET_PRIVATE_2b_ID'].RouteTableAssociationId" --output text)

IGW_ID=$(aws ec2 describe-internet-gateways --filters Name=attachment.vpc-id,Values=$VPC_ID --query 'InternetGateways[].InternetGatewayId' --output text)

SECURITYGROUP_DEFAULT_ID=$(aws ec2 describe-security-groups --filters Name=vpc-id,Values=$VPC_ID Name=group-name,Values=default --query 'SecurityGroups[].GroupId' --output text)

EC2_INSTANCES_ID_LIST=$(aws ec2 describe-instances --filters Name=vpc-id,Values=$VPC_ID --query 'Reservations[].Instances[].InstanceId' --output text)

NAT_GATEWAYS_ID_LIST=$(aws ec2 describe-nat-gateways --filter Name=vpc-id,Values=vpc-6ea48307 Name=state,Values=available --query 'NatGateways[].NatGatewayId' --output text)
EIP_ID_LIST=$(aws ec2 describe-addresses --filter Name=domain,Values=vpc --query 'Addresses[].AllocationId' --output text)