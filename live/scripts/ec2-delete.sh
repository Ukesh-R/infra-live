#!/bin/bash

REGION="ap-south-1"

for VPC in $(aws ec2 describe-vpcs \
--region $REGION \
--query 'Vpcs[?IsDefault==`false`].VpcId' \
--output text)
do

echo "============================="
echo "Deleting VPC: $VPC"
echo "============================="

# terminate instances
INSTANCES=$(aws ec2 describe-instances \
--region $REGION \
--filters Name=vpc-id,Values=$VPC \
--query 'Reservations[].Instances[].InstanceId' \
--output text)

if [ ! -z "$INSTANCES" ]; then

aws ec2 terminate-instances \
--instance-ids $INSTANCES \
--region $REGION

echo "Waiting for EC2 termination..."

aws ec2 wait instance-terminated \
--instance-ids $INSTANCES \
--region $REGION

fi

echo "EC2 terminated"


# delete network interfaces
for ENI in $(aws ec2 describe-network-interfaces \
--region $REGION \
--filters Name=vpc-id,Values=$VPC \
--query 'NetworkInterfaces[].NetworkInterfaceId' \
--output text)
do

aws ec2 delete-network-interface \
--network-interface-id $ENI \
--region $REGION

done

echo "ENI deleted"


# detach and delete IGW
for IGW in $(aws ec2 describe-internet-gateways \
--region $REGION \
--filters Name=attachment.vpc-id,Values=$VPC \
--query 'InternetGateways[].InternetGatewayId' \
--output text)
do

aws ec2 detach-internet-gateway \
--internet-gateway-id $IGW \
--vpc-id $VPC \
--region $REGION

aws ec2 delete-internet-gateway \
--internet-gateway-id $IGW \
--region $REGION

done

echo "IGW deleted"


# delete subnets
for SUBNET in $(aws ec2 describe-subnets \
--region $REGION \
--filters Name=vpc-id,Values=$VPC \
--query 'Subnets[].SubnetId' \
--output text)
do

aws ec2 delete-subnet \
--subnet-id $SUBNET \
--region $REGION

done


# delete route tables
for RT in $(aws ec2 describe-route-tables \
--region $REGION \
--filters Name=vpc-id,Values=$VPC \
--query 'RouteTables[].RouteTableId' \
--output text)
do

aws ec2 delete-route-table \
--route-table-id $RT \
--region $REGION

done


# delete security groups
for SG in $(aws ec2 describe-security-groups \
--region $REGION \
--filters Name=vpc-id,Values=$VPC \
--query 'SecurityGroups[?GroupName!=`default`].GroupId' \
--output text)
do

aws ec2 delete-security-group \
--group-id $SG \
--region $REGION

done


# delete VPC

aws ec2 delete-vpc \
--vpc-id $VPC \
--region $REGION


echo "✅ VPC deleted: $VPC"

done