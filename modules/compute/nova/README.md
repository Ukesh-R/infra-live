# Compute Module – OpenStack Nova

## Purpose
Creates an OpenStack Nova virtual machine as part of a cloud-agnostic compute layer.

## Supported Cloud Providers
- OpenStack (Nova)

## Cloud-Agnostic Design
- Input and output interfaces are consistent with the AWS EC2 compute module.
- Cloud-specific resource implementation is handled internally within the module.
- Environment and orchestration layers remain unchanged across clouds.

## Inputs
- vm_name – Name of the virtual machine
- image_name – OpenStack image name for the VM
- vm_size – OpenStack flavor for the VM
- keypair_name – SSH key pair name
- security_group_name – Security group attached to the VM
- port_id – Network port ID attached to the VM
- floating_ip – Floating IP address to associate with the VM

## Outputs
- public_ip – Floating IP address associated with the VM

## What Changes When Switching Clouds
- Provider configuration (OpenStack ↔ AWS)
- Image reference (OpenStack image ↔ AMI)
- Flavor / instance type
- Networking model and port attachment
- Key pair and security group configuration
- Terraform backend and state

## What Does NOT Change
- Module interface (inputs and outputs)
- Module usage from the environment layer
- Overall infrastructure architecture

## Naming Convention
- Resources follow environment-based naming passed from the environment layer.

## Versioning
- Module follows semantic versioning.
- Breaking changes require a major version update.

## Known Limitations
- Flavor names are OpenStack-specific
- Networking model differs from AWS
- Floating IP must exist before association
- Terraform backend is not cloud-agnostic
