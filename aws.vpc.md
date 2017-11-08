

# Table of Contents
1. [Define a VPC](#VPC)
1. [Create subnets](#Subnet)

<a name="VPC"></a>
## VPC

Create an AWS VPC
```
aws ec2 create-vpc \
--cidr-block 10.1.0.0/16 \
--instance-tenancy default
```

To find the new VPC ID by CIDR you can use:
```ec2 describe-vpcs --filters Name=cidr,Values=10.1.0.0/16 --query 'Vpcs[].VpcId' --output text```

Add a tag to the new AWS VPC
```
aws ec2 create-tags \
--resources \
$(aws ec2 describe-vpcs --filters Name=cidr,Values=10.1.0.0/16 --query 'Vpcs[].VpcId' --output text) \
--tags \
Key=Name,Value=systemVpc
```

<a name="Subnet"></a>
## Subnet
 

```
aws ec2 create-subnet \
--vpc-id $(aws ec2 describe-vpcs --filters Name=cidr,Values=10.1.0.0/16 --query 'Vpcs[].VpcId' --output text) \
--cidr-block 10.1.10.0/24 \
--availability-zone eu-west-2a
```

```
aws ec2 create-tags \
--resources \
$(aws ec2 describe-subnets --filters Name=cidr,Values=10.1.10.0/24 --query 'Subnets[].SubnetId' --output text) \
--tags \
Key=Name,Value=systemVpc-subnet-public2a
```

