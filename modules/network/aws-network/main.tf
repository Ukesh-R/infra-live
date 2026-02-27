resource "aws_vpc" "tf_vpc_network"{
  cidr_block = var.network_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = var.network_name
    created_at = var.created_at
    ttl_seconds   = var.ttl_seconds
    owner      = var.owner
  }
}

resource "aws_subnet" "tf_aws_subnet"{
  count =2 
  vpc_id = aws_vpc.tf_vpc_network.id
  cidr_block = cidrsubnet(var.network_cidr, 8 , count.index)
  availability_zone = element(["ap-south-1a","ap-south-1b"],count.index)
  map_public_ip_on_launch = true 
  tags = {
    Name = var.subnet_name
  }
}

resource "aws_internet_gateway" "tf_net_gateway" {
  vpc_id = aws_vpc.tf_vpc_network.id

  tags = {
    Name = var.net_gateway_name
  }
}

resource "aws_route_table" "tf_public_route" {
  vpc_id=aws_vpc.tf_vpc_network.id

  route {
    cidr_block = var.route_cidr
    gateway_id = aws_internet_gateway.tf_net_gateway.id

    }
    tags = {
      Name = var.public_router_name
  }
}

resource "aws_route_table_association" "tf_public_assoc" {
  count = 2
  subnet_id = aws_subnet.tf_aws_subnet[count.index].id
  route_table_id = aws_route_table.tf_public_route.id
}

