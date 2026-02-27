locals {
    project = "infra"
    env = basename(get_terragrunt_dir())
    region = "ap-south-1"
    request_id = get_env("REQUEST_ID", "default")

    tags = {
        Project = local.project
        Environment = local.env
        ManagedBy = "Terragrunt"
    }
}

remote_state {
    backend ="s3"

    config = {
        bucket = "ukesh-s3-bucket-12"
        key = "ephemeral/${local.request_id}/${path_relative_to_include()}/terraform.tfstate"
        region = local.region
        encrypt = true
        dynamodb_table = "ukesh-table" 
    }
    
    generate = {
        path = "backend.tf"
        if_exists = "overwrite" 
    }
}


