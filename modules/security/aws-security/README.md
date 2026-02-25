# Security Module – AWS Security Groups

## Purpose
Creates AWS security groups to control inbound and outbound traffic for compute workloads as part of a cloud-agnostic security layer.

## Supported Cloud Providers
- AWS (Security Groups)

## Cloud-Agnostic Design
- Input and output interfaces are aligned with the OpenStack security module.
- Cloud-specific security group implementation is handled internally.
- Environment and orchestration layers remain unchanged across clouds.

## Inputs
- security_group_name – Name of the security group
- vpc_id – VPC ID where the security group is created

## Outputs
- security_group_id – ID of the created security group

## What Changes When Switching Clouds
- Provider configuration (AWS ↔ OpenStack)
- Security group implementation and rules
- Resource identifiers and backend state

## What Does NOT Change
- Module interface (inputs and outputs)
- Module usage from the environment layer
- Overall infrastructure architecture

## Naming Convention
- Security groups follow environment-based naming passed from the environment layer.

## Versioning
- Module follows semantic versioning.
- Breaking changes require a major version update.

## Known Limitations
- Rules are currently static (SSH and all egress)
- Rule definitions are cloud-specific
- Advanced rule management is not included
- Terraform backend is not cloud-agnostic
