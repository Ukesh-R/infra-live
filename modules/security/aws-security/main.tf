resource "aws_security_group" "tf_sec_group" {
  name = var.security_group_name
  vpc_id = var.vpc_id
  
  lifecycle {
    create_before_destroy = true
  }
  
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port =0
    to_port=0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name= var.security_group_name
    created_at = var.created_at
    ttl_seconds   = var.ttl_seconds
    owner      = var.owner
  }
}




