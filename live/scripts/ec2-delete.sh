#!/bin/bash

REGION="ap-south-1"

echo "========== START CLEANUP =========="

###################################
echo "1. Terminate EC2"
###################################

INSTANCES=$(aws ec2 describe-instances \
--region $REGION \
--query "Reservations[].Instances[].InstanceId" \
--output text)

if [ ! -z "$INSTANCES" ]; then
aws ec2 terminate-instances \
--region $REGION \
--instance-ids $INSTANCES
fi

sleep 20

###################################
echo "2. Delete EBS volumes"
###################################

VOLUMES=$(aws ec2 describe-volumes \
--region $REGION \
--query "Volumes[].VolumeId" \
--output text)

for VOL in $VOLUMES
do
aws ec2 delete-volume --volume-id $VOL --region $REGION || true
done

###################################
echo "3. Delete Network Interfaces"
###################################

ENIS=$(aws ec2 describe-network-interfaces \
--region $REGION \
--query "NetworkInterfaces[].NetworkInterfaceId" \
--output text)

for ENI in $ENIS
do
aws ec2 delete-network-interface \
--network-interface-id $ENI \
--region $REGION || true
done

###################################
echo "4. Delete Security Groups"
###################################

SGS=$(aws ec2 describe-security-groups \
--region $REGION \
--query "SecurityGroups[?GroupName!='default'].GroupId" \
--output text)

for SG in $SGS
do
aws ec2 delete-security-group \
--group-id $SG \
--region $REGION || true
done

###################################
echo "5. Delete Internet Gateways"
###################################

IGWS=$(aws ec2 describe-internet-gateways \
--region $REGION \
--query "InternetGateways[].InternetGatewayId" \
--output text)

for IGW in $IGWS
do

VPC=$(aws ec2 describe-internet-gateways \
--internet-gateway-ids $IGW \
--region $REGION \
--query "InternetGateways[].Attachments[].VpcId" \
--output text)

aws ec2 detach-internet-gateway \
--internet-gateway-id $IGW \
--vpc-id $VPC \
--region $REGION || true

aws ec2 delete-internet-gateway \
--internet-gateway-id $IGW \
--region $REGION || true

done

###################################
echo "6. Delete Route Tables"
###################################

RTS=$(aws ec2 describe-route-tables \
--region $REGION \
--query "RouteTables[].RouteTableId" \
--output text)

for RT in $RTS
do
aws ec2 delete-route-table \
--route-table-id $RT \
--region $REGION || true
done

###################################
echo "7. Delete Subnets"
###################################

SUBNETS=$(aws ec2 describe-subnets \
--region $REGION \
--query "Subnets[].SubnetId" \
--output text)

for SUB in $SUBNETS
do
aws ec2 delete-subnet \
--subnet-id $SUB \
--region $REGION || true
done

###################################
echo "8. Delete VPC"
###################################

VPCS=$(aws ec2 describe-vpcs \
--region $REGION \
--query "Vpcs[?IsDefault==\`false\`].VpcId" \
--output text)

for VPC in $VPCS
do
aws ec2 delete-vpc \
--vpc-id $VPC \
--region $REGION || true
done

###################################
echo "9. Delete DynamoDB Table"
###################################

aws dynamodb delete-table \
--table-name ukesh-table \
--region $REGION || true

###################################
echo "10. Delete S3 bucket (Terraform state)"
###################################

aws s3 rb s3://ukesh-s3-bucket-12 \
--force \
--region $REGION || true

echo "========== CLEANUP COMPLETE =========="