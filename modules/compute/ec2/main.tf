resource "aws_instance" "tf_ec2" {

  ami = var.image_name
  instance_type=var.vm_size
  subnet_id= var.subnet_id
  vpc_security_group_ids=[var.security_group_id]
  associate_public_ip_address = true
  key_name = var.keypair_name

  tags = merge(
    var.tags,
    {
      created_at = tostring(var.created_at)
      ttl_days   = tostring(var.ttl_days)
      owner      = var.owner
    }
  )
}