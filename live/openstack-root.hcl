locals {
    project = "infra"
    env = "openstack-sandbox"
    region = "ap-south-1"

    tags = {
        Project = local.project
        Environment = local.env
        ManagedBy = "Terragrunt"
    }
}

remote_state {
    backend ="s3"

    config = {
        bucket = "infra-dev-terraform-state-openstack"
        key = "openstack/${local.env}/${path_relative_to_include()}/terraform.tfstate"
        region = local.region
        encrypt = true
        dynamodb_table = "infra-terraform-lock" 
    }
    
    generate = {
        path = "backend.tf"
        if_exists = "overwrite" 
    }
}



