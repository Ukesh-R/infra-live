# Security Module – OpenStack Security Groups

## Purpose
Creates OpenStack security groups and security group rules to control inbound traffic for compute workloads as part of a cloud-agnostic security layer.

## Supported Cloud Providers
- OpenStack (Security Groups)

## Cloud-Agnostic Design
- Input and output interfaces are aligned with the AWS security module.
- Cloud-specific security group and rule implementation is handled internally.
- Environment and orchestration layers remain unchanged across clouds.

## Inputs
- security_group_name – Name of the security group to be created

## Outputs
- security_group_id – ID of the created security group

## What Changes When Switching Clouds
- Provider configuration (OpenStack ↔ AWS)
- Security group rule syntax and behavior
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
- Ingress rules are statically defined in the module
- Rule behavior differs between AWS and OpenStack
- Egress rules are not explicitly managed
- Terraform backend is not cloud-agnostic
