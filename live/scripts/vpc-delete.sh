#!/bin/bash

REGION="ap-south-1"

echo "Deleting EC2 instances..."
aws ec2 describe-instances \
  --region $REGION \
  --query "Reservations[].Instances[].InstanceId" \
  --output text | \
xargs -r aws ec2 terminate-instances --region $REGION --instance-ids

sleep 10

echo "Deleting EBS volumes..."
aws ec2 describe-volumes \
  --region $REGION \
  --query "Volumes[].VolumeId" \
  --output text | \
xargs -r -I {} aws ec2 delete-volume --region $REGION --volume-id {}

echo "Deleting Security Groups..."
aws ec2 describe-security-groups \
  --region $REGION \
  --query "SecurityGroups[?GroupName!='default'].GroupId" \
  --output text | \
xargs -r -I {} aws ec2 delete-security-group --region $REGION --group-id {}

echo "Deleting Internet Gateways..."
for igw in $(aws ec2 describe-internet-gateways --region $REGION --query "InternetGateways[].InternetGatewayId" --output text)
do
  vpc=$(aws ec2 describe-internet-gateways --region $REGION --internet-gateway-ids $igw --query "InternetGateways[].Attachments[].VpcId" --output text)

  aws ec2 detach-internet-gateway --region $REGION --internet-gateway-id $igw --vpc-id $vpc

  aws ec2 delete-internet-gateway --region $REGION --internet-gateway-id $igw
done

echo "Deleting Subnets..."
aws ec2 describe-subnets \
  --region $REGION \
  --query "Subnets[].SubnetId" \
  --output text | \
xargs -r -I {} aws ec2 delete-subnet --region $REGION --subnet-id {}

echo "Deleting VPCs..."
aws ec2 describe-vpcs \
  --region $REGION \
  --query "Vpcs[?IsDefault==\`false\`].VpcId" \
  --output text | \
xargs -r -I {} aws ec2 delete-vpc --region $REGION --vpc-id {}

echo "Cleanup completed!"