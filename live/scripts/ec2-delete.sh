for vpc in $(aws ec2 describe-vpcs --region ap-south-1 --query 'Vpcs[*].VpcId' --output text); do

  echo "Processing VPC: $vpc"

  # Detach and delete internet gateways
  for igw in $(aws ec2 describe-internet-gateways --region ap-south-1 \
    --filters Name=attachment.vpc-id,Values=$vpc \
    --query 'InternetGateways[*].InternetGatewayId' --output text); do

    aws ec2 detach-internet-gateway \
      --internet-gateway-id $igw \
      --vpc-id $vpc \
      --region ap-south-1

    aws ec2 delete-internet-gateway \
      --internet-gateway-id $igw \
      --region ap-south-1

  done

  # Delete subnets
  for subnet in $(aws ec2 describe-subnets --region ap-south-1 \
    --filters Name=vpc-id,Values=$vpc \
    --query 'Subnets[*].SubnetId' --output text); do

    aws ec2 delete-subnet \
      --subnet-id $subnet \
      --region ap-south-1

  done

  # Delete non-main route tables
  for rt in $(aws ec2 describe-route-tables --region ap-south-1 \
    --filters Name=vpc-id,Values=$vpc \
    --query 'RouteTables[?Associations[0].Main!=`true`].RouteTableId' \
    --output text); do

    aws ec2 delete-route-table \
      --route-table-id $rt \
      --region ap-south-1

  done

  # Delete VPC
  aws ec2 delete-vpc \
    --vpc-id $vpc \
    --region ap-south-1

done