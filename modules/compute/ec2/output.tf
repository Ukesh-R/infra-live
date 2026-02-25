output "instance_id" {
  value = aws_instance.tf_ec2.id
}

output "availability_zone" {
  value = aws_instance.tf_ec2.availability_zone
}

output "public_ip" {
  value = aws_instance.tf_ec2.public_ip
}
