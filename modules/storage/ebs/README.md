# Storage Module – AWS EBS

## Purpose
Creates and attaches an AWS EBS volume to a compute instance as part of a cloud-agnostic storage layer.

## Supported Cloud Providers
- AWS (EBS)

## Cloud-Agnostic Design
- Input and output interfaces are aligned with the OpenStack storage module.
- Cloud-specific storage implementation is handled internally.
- Environment and orchestration layers remain unchanged across clouds.

## Inputs
- availability_zone – Availability zone for the EBS volume
- volume_size – Size of the EBS volume in GB
- ebs_name – Name tag for the EBS volume
- instance_id – ID of the EC2 instance to attach the volume

## Outputs
- volume_id – ID of the created EBS volume
- device_name – Device name used for attachment

## What Changes When Switching Clouds
- Provider configuration (AWS ↔ OpenStack)
- Storage service (EBS ↔ Cinder)
- Volume attachment mechanism
- Device naming conventions
- Resource identifiers and backend state

## What Does NOT Change
- Module interface (inputs and outputs)
- Module usage from the environment layer
- Overall infrastructure architecture

## Naming Convention
- Storage resources follow environment-based naming passed from the environment layer.

## Versioning
- Module follows semantic versioning.
- Breaking changes require a major version update.

## Known Limitations
- Volume type is fixed to gp3
- Single volume attachment per module invocation
- Device name is static
- Terraform backend is not cloud-agnostic
