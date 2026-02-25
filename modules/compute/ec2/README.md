# Compute Module – AWS EC2

## Purpose
Creates an AWS EC2 instance as part of a cloud-agnostic compute layer.

## Supported Cloud Providers
- AWS (EC2)

## Cloud-Agnostic Design
- Input and output interfaces are consistent with the OpenStack compute module.
- Cloud-specific resource implementation is handled internally within the module.
- Environment and orchestration layers remain unchanged across clouds.

## Inputs
- image_name – AMI ID for the EC2 instance
- vm_size – EC2 instance type
- subnet_id – Subnet where the instance is launched
- security_group_id – Security group attached to the instance
- keypair_name – SSH key pair name
- tags – Resource tags applied to the instance

## Outputs
- public_ip – Public IP address of the EC2 instance

## What Changes When Switching Clouds
- Provider configuration (AWS ↔ OpenStack)
- Image reference (AMI ↔ OpenStack image)
- Instance type / flavor
- Key pair and networking values
- Terraform backend and state

## What Does NOT Change
- Module interface (inputs and outputs)
- Module usage from the environment layer
- Overall infrastructure architecture

## Naming Convention
- Resources follow environment-based naming using standardized tags.

## Versioning
- Module follows semantic versioning.
- Breaking changes require a major version update.

## Known Limitations
- Instance types are cloud-specific
- Networking implementation differs per cloud
- IAM model is AWS-specific
- Terraform backend is not cloud-agnostic
