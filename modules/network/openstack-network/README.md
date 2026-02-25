# Network Module – OpenStack Neutron

## Purpose
Creates OpenStack networking components required for compute workloads as part of a cloud-agnostic network layer.

## Supported Cloud Providers
- OpenStack (Neutron)

## Cloud-Agnostic Design
- Input and output interfaces are aligned with the AWS network module.
- Cloud-specific networking resources are implemented internally.
- Environment and orchestration layers remain unchanged across clouds.

## Inputs
- network_name – Name of the private network
- subnet_name – Name of the subnet
- network_cidr – CIDR block for the subnet
- external_id – External network ID used by the router
- security_group_id – Security group applied to the network port

## Outputs
- network_id – ID of the created network
- subnet_id – ID of the created subnet
- port_id – ID of the created network port
- floating_ip – Floating IP allocated from the external network

## What Changes When Switching Clouds
- Provider configuration (OpenStack ↔ AWS)
- Networking resources (Neutron ↔ VPC)
- Router, port, and floating IP model
- Resource identifiers and backend state

## What Does NOT Change
- Module interface (inputs and outputs)
- Module usage from the environment layer
- Overall infrastructure architecture

## Naming Convention
- Network resources follow environment-based naming passed from the environment layer.

## Versioning
- Module follows semantic versioning.
- Breaking changes require a major version update.

## Known Limitations
- External network must already exist
- Floating IP pool name is cloud-specific
- Networking model differs from AWS
- Terraform backend is not cloud-agnostic
