output "subnet_ids" {
    value = aws_subnet.tf_aws_subnet[*].id
}

output "vpc_id" {
    value = aws_vpc.tf_vpc_network.id
}

output "availability_zone" {
  value = aws_subnet.tf_aws_subnet[*].availability_zone
}