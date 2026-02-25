# Dev Environment – OpenStack

## Overview
This directory defines the development environment infrastructure on OpenStack, using reusable and cloud-agnostic Terraform modules.

The environment layer orchestrates network, compute, security, storage, and IAM modules while keeping cloud-specific implementations isolated inside modules.

---

## Architecture
This environment provisions the following OpenStack resources:

- Private network and subnet
- Router with external (public) network connectivity
- Nova compute instance
- Floating IP association
- Security group and rules
- Block storage volume attached to the instance
- IAM user configuration (OpenStack-specific)

All resources are created using modular Terraform design.

---

## Modules Used

### Network Module
- Source: `modules/network/openstack-network`
- Purpose:  
  Creates private network, subnet, router, router interface, floating IP, and network port.

---

### Compute Module
- Source: `modules/compute/nova`
- Purpose:  
  Creates a Nova virtual machine and associates a floating IP.

---

### Security Module
- Source: `modules/security/openstack-security`
- Purpose:  
  Creates security groups and ingress rules applied to the compute instance.

---

### Storage Module
- Source: `modules/storage/volume`
- Purpose:  
  Creates and attaches an OpenStack block storage volume to the compute instance.

---

### IAM Module
- Source: `modules/iam/openstack-iam`
- Purpose:  
  Manages OpenStack IAM user configuration.

---

## Cloud-Agnostic Design
- The same environment structure exists for AWS.
- Only module sources and provider implementations differ.
- Input variables, architecture, and naming conventions remain consistent.

This enables infrastructure portability across cloud providers without rewriting Terraform logic.

---

## Inputs
Inputs are defined in:
terraform.tfvars
