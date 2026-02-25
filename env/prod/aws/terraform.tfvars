# ec2
region = "ap-south-1"
availability_zone = "ap-south-1a"
image_name = "ami-0f58b397bc5c1f2e8"
vm_size = "t3.micro"
keypair_name = "ukesh-dev-key"

# storage
volume_size = "20"


# network 
network_cidr = "10.20.0.0/16"
route_cidr = "0.0.0.0/0"

# names
project_name = "myproject"
environment = "prod"

desired_size = 1
min_size = 1
max_size = 2
cluster_version = "1.29"
instance_types = ["t3.small"]

# cluster names
cluster_name = "prod-eks-1"