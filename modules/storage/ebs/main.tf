resource "aws_ebs_volume" "tf_data_volume" {
  availability_zone = var.availability_zone
  size = var.volume_size
  type = "gp3"

  tags = {
    name = var.ebs_name
    created_at = var.created_at
    ttl_seconds   = var.ttl_seconds
    owner      = var.owner

  }
}

resource "aws_volume_attachment" "data_attach"  {
  device_name = "/dev/sdf"
  volume_id = aws_ebs_volume.tf_data_volume.id
  instance_id= var.instance_id
}