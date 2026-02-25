# Production Environment – OpenStack

## Overview
This directory defines the production infrastructure deployed on OpenStack, using reusable and cloud-agnostic Terraform modules.

The production OpenStack environment mirrors the AWS production architecture to ensure cloud portability, consistency, and operational reliability.

---

## Architecture
This environment provisions the following OpenStack resources:

- Private network and subnet
- Router connected to external network
- Floating IP for public access
- Nova compute instance
- Security group with controlled ingress rules
- Cinder block storage attached to the instance
- OpenStack IAM (user / access management)

All resources are created using standardized Terraform modules.

---

## Modules Used

### Network Module
- Source: `modules/network/openstack-network`
- Purpose:  
  Creates private network, subnet, router, router interface, floating IP, and ports.

---

### Compute Module
- Source: `modules/compute/nova`
- Purpose:  
  Creates Nova compute instances for production workloads.

---

### Security Module
- Source: `modules/security/openstack-security`
- Purpose:  
  Creates security groups and ingress rules.

---

### Storage Module
- Source: `modules/storage/volume`
- Purpose:  
  Creates and attaches Cinder block storage volumes.

---

### IAM Module
- Source: `modules/iam/openstack-iam`
- Purpose:  
  Manages OpenStack IAM users and access controls.

---

## Production Design Principles
- Identical architecture across AWS and OpenStack
- Only provider-specific implementations differ
- No environment-specific logic inside modules
- Naming and tagging handled centrally using locals

---

## Cloud-Agnostic Design
- Module interfaces are consistent across clouds
- Environment layer remains unchanged
- Enables seamless migration between AWS and OpenStack
- Infrastructure logic does not depend on provider-specific IDs

---

## Inputs
Production inputs are defined in:

text
terraform.tfvars
