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

# Terminate EC2 instances
for EC2 in $(aws ec2 describe-instances \
--region $REGION \
--filters Name=vpc-id,Values=$VPC \
--query 'Reservations[].Instances[].InstanceId' \
--output text)
do
aws ec2 terminate-instances --instance-ids $EC2 --region $REGION
done

sleep 10

# Delete NAT gateways
for NAT in $(aws ec2 describe-nat-gateways \
--region $REGION \
--filter Name=vpc-id,Values=$VPC \
--query 'NatGateways[].NatGatewayId' \
--output text)
do
aws ec2 delete-nat-gateway --nat-gateway-id $NAT --region $REGION
done

sleep 10

# Release Elastic IPs
for EIP in $(aws ec2 describe-addresses \
--region $REGION \
--query 'Addresses[].AllocationId' \
--output text)
do
aws ec2 release-address --allocation-id $EIP --region $REGION
done

# Delete Network Interfaces
for ENI in $(aws ec2 describe-network-interfaces \
--region $REGION \
--filters Name=vpc-id,Values=$VPC \
--query 'NetworkInterfaces[].NetworkInterfaceId' \
--output text)
do
aws ec2 delete-network-interface --network-interface-id $ENI --region $REGION
done

# Detach and delete Internet Gateway
for IGW in $(aws ec2 describe-internet-gateways \
--region $REGION \
--filters Name=attachment.vpc-id,Values=$VPC \
--query 'InternetGateways[].InternetGatewayId' \
--output text)
do
aws ec2 detach-internet-gateway --internet-gateway-id $IGW --vpc-id $VPC --region $REGION
aws ec2 delete-internet-gateway --internet-gateway-id $IGW --region $REGION
done

# Delete subnets
for SUBNET in $(aws ec2 describe-subnets \
--region $REGION \
--filters Name=vpc-id,Values=$VPC \
--query 'Subnets[].SubnetId' \
--output text)
do
aws ec2 delete-subnet --subnet-id $SUBNET --region $REGION
done

# Delete route tables
for RT in $(aws ec2 describe-route-tables \
--region $REGION \
--filters Name=vpc-id,Values=$VPC \
--query 'RouteTables[].RouteTableId' \
--output text)
do
aws ec2 delete-route-table --route-table-id $RT --region $REGION
done

# Delete security groups
for SG in $(aws ec2 describe-security-groups \
--region $REGION \
--filters Name=vpc-id,Values=$VPC \
--query 'SecurityGroups[].GroupId' \
--output text)
do
aws ec2 delete-security-group --group-id $SG --region $REGION
done

# Delete VPC
aws ec2 delete-vpc --vpc-id $VPC --region $REGION

echo "VPC Deleted: $VPC"

done