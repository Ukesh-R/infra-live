# Staging Environment – OpenStack

## Overview
This directory defines the staging infrastructure on OpenStack, deployed using reusable and cloud-agnostic Terraform modules.

The staging environment acts as a pre-production validation layer, where infrastructure changes are tested before being promoted to production.

---

## Architecture
The staging OpenStack environment provisions the following resources:

- Private network and subnet
- Router connected to external network
- Nova compute instance
- Security group with controlled ingress rules
- Cinder block storage volume attached to the instance
- Floating IP association

The overall architecture mirrors production, with reduced scale where required.

---

## Modules Used

### Network Module
- Source: `modules/network/openstack-network`
- Purpose:  
  Creates private networks, subnets, routers, ports, and floating IPs.

---

### Compute Module
- Source: `modules/compute/nova`
- Purpose:  
  Creates OpenStack Nova instances for staging workloads.

---

### Security Module
- Source: `modules/security/openstack-security`
- Purpose:  
  Manages OpenStack security groups and ingress rules.

---

### Storage Module
- Source: `modules/storage/volume`
- Purpose:  
  Creates and attaches Cinder block storage volumes.

---

### IAM Module
- Source: `modules/iam/openstack-iam`
- Purpose:  
  Manages OpenStack identity resources (users, roles).

---

## Role of Staging
- Validate Terraform module changes
- Test OpenStack-specific configurations
- Verify cloud portability with AWS
- Detect issues before production deployment

---

## Cloud-Agnostic Design
- Module interfaces are consistent across AWS and OpenStack
- Only provider-specific implementations differ
- Environment structure is identical across clouds

This allows seamless switching between cloud providers without rewriting Terraform logic.

---

## Inputs
Inputs are defined in:

terraform.tfvars
