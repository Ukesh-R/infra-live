# Network Module – AWS VPC

## Purpose
Creates AWS networking components required for compute workloads as part of a cloud-agnostic network layer.

## Supported Cloud Providers
- AWS (VPC)

## Cloud-Agnostic Design
- Input and output interfaces are aligned with the OpenStack network module.
- Cloud-specific networking resources are implemented internally.
- Environment and orchestration layers remain unchanged across clouds.

## Inputs
- network_cidr – CIDR block for the VPC
- subnet_cidr – CIDR block for the subnet
- availability_zone – Availability zone for the subnet
- network_name – Name of the VPC
- subnet_name – Name of the subnet
- net_gateway_name – Internet Gateway name
- route_cidr – Route destination CIDR (e.g., 0.0.0.0/0)

## Outputs
- vpc_id – ID of the created VPC
- subnet_id – ID of the created subnet

## What Changes When Switching Clouds
- Provider configuration (AWS ↔ OpenStack)
- Networking resources (VPC ↔ Neutron network)
- Internet gateway and routing implementation
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
- Single subnet and single availability zone
- Routing model is cloud-specific
- Advanced networking features are not included
- Terraform backend is not cloud-agnostic
