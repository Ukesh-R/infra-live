module "network" {
  source = "../../../modules/network/openstack-network"

  subnet_cidr       = var.subnet_cidr
  network_name      = local.network_name
  subnet_name       = local.subnet_name
  external_id       = var.external_id
  security_group_id = module.security.security_group_id
}

module "compute" {
  source              = "../../../modules/compute/nova"
  vm_name             = local.vm_name
  image_name          = var.image_name
  vm_size             = var.vm_size
  network_id          = module.network.network_id
  floating_ip         = module.network.floating_ip_address
  keypair_name        = var.keypair_name
  security_group_name = module.security.security_group_name
  port_id             = module.network.port_id
}

module "security" {
  source              = "../../../modules/security/openstack-security"
  security_group_name = local.security_group_name
}

module "storage" {
  source      = "../../../modules/storage/volume"
  volume_name = local.volume_name
  volume_size = var.volume_size
  instance_id = module.compute.instance_id
}

module "iam" {
  source       = "../../../modules/iam/openstack-iam"
  iam_user     = local.iam_user
  group_name   = local.group_name
  project_name = local.project_name
  role_admin   = local.role_admin
  role_member  = local.role_member
  role_reader  = local.role_reader
  environment  = var.environment
}

module "autoscaling" {

 source = "../../../modules/scaling/openstack-scaling"
 env = "dev"
 image = var.image_name
 flavor = var.vm_size
 network = module.network.network_id

}
