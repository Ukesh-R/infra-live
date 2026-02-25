# Storage Module – OpenStack Cinder

## Purpose
Creates and attaches an OpenStack Cinder block storage volume to a compute instance as part of a cloud-agnostic storage layer.

## Supported Cloud Providers
- OpenStack (Cinder)

## Cloud-Agnostic Design
- Input and output interfaces are aligned with the AWS EBS storage module.
- Cloud-specific storage implementation is handled internally.
- Environment and orchestration layers remain unchanged across clouds.

## Inputs
- volume_name – Name of the storage volume
- volume_size – Size of the volume in GB
- instance_id – ID of the compute instance to attach the volume

## Outputs
- volume_id – ID of the created storage volume

## What Changes When Switching Clouds
- Provider configuration (OpenStack ↔ AWS)
- Storage service (Cinder ↔ EBS)
- Volume attachment mechanism
- Device mapping behavior
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
- Volume type is not configurable
- Single volume attachment per module invocation
- Device name is managed by OpenStack
- Terraform backend is not cloud-agnostic
