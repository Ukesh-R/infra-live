terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
  }
}
resource "openstack_orchestration_stack_v1" "autoscaling" {
  name = "${var.env}-autoscaling-tf"

  template_opts = {
    Bin = file("${path.module}/autoscaling.yaml")
  }

  environment_opts = {
    Bin = "\n"          
  }

  disable_rollback = true
  timeout          = 30

  parameters = {
    image   = var.image
    flavor  = var.flavor
    network = var.network
  }
}
