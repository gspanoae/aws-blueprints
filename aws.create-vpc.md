

# Table if Contents
1. [Define a VPC](#VPC)
1. [Create subnets](#Subnet)

##VPC <a name="VPC"></a>

Create an AWS VPC
```
aws ec2 create-vpc \
--cidr-block 10.1.0.0/16 \
--instance-tenancy default
```

To find the new vpc ID by cidr you can use:
```ec2 describe-vpcs --filters Name=cidr,Values=10.1.0.0/16 --query 'Vpcs[].VpcId' --output text```

Add a tag to the new AWS VPC
```
aws ec2 create-tags \
--resources \
$(aws ec2 describe-vpcs --filters Name=cidr,Values=10.1.0.0/16 --query 'Vpcs[].VpcId' --output text) \
--tags \
Key=Name,Value=systemVpc
```

##Subnet <a name="Subnet"></a>
 
Create 4 subnets (2 public and 2 private in two different AZs) and tag them

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

```
aws ec2 create-subnet \
--vpc-id $(aws ec2 describe-vpcs --filters Name=cidr,Values=10.1.0.0/16 --query 'Vpcs[].VpcId' --output text) \
--cidr-block 10.1.11.0/24 \
--availability-zone eu-west-2a
```

```
aws ec2 create-tags \
--resources \
$(aws ec2 describe-subnets --filters Name=cidr,Values=10.1.11.0/24 --query 'Subnets[].SubnetId' --output text) \
--tags \
Key=Name,Value=systemVpc-subnet-private2a
```

```
aws ec2 create-subnet \
--vpc-id $(aws ec2 describe-vpcs --filters Name=cidr,Values=10.1.0.0/16 --query 'Vpcs[].VpcId' --output text) \
--cidr-block 10.1.20.0/24 \
--availability-zone eu-west-2b
```

```
aws ec2 create-tags \
--resources \
$(aws ec2 describe-subnets --filters Name=cidr,Values=10.1.20.0/24 --query 'Subnets[].SubnetId' --output text) \
--tags \
Key=Name,Value=systemVpc-subnet-public2b
```

```
aws ec2 create-subnet \
--vpc-id $(aws ec2 describe-vpcs --filters Name=cidr,Values=10.1.0.0/16 --query 'Vpcs[].VpcId' --output text) \
--cidr-block 10.1.21.0/24 \
--availability-zone eu-west-2b
```

```
aws ec2 create-tags \
--resources \
$(aws ec2 describe-subnets --filters Name=cidr,Values=10.1.21.0/24 --query 'Subnets[].SubnetId' --output text) \
--tags \
Key=Name,Value=systemVpc-subnet-private2b

```


