# Production Environment – AWS

## Overview
This directory defines the production-grade infrastructure on AWS, provisioned using reusable and cloud-agnostic Terraform modules.

The production environment follows strict controls around stability, security, and change management while maintaining architectural parity with lower environments.

---

## Architecture
This environment provisions the following AWS resources:

- VPC with public subnet and routing
- EC2 compute instance
- Security group with controlled ingress rules
- EBS block storage attached to the instance

All resources are created using modular Terraform design to ensure consistency and repeatability.

---

## Modules Used

### Network Module
- Source: `modules/network/aws-network`
- Purpose:  
  Creates VPC, subnet, internet gateway, route table, and routing configuration.

---

### Compute Module
- Source: `modules/compute/ec2`
- Purpose:  
  Creates EC2 instances for production workloads.

---

### Security Module
- Source: `modules/security/aws-security`
- Purpose:  
  Creates security groups and manages ingress/egress rules.

---

### Storage Module
- Source: `modules/storage/ebs`
- Purpose:  
  Creates and attaches EBS volumes for persistent storage.

---

## Production Design Principles
- Infrastructure parity with dev and staging
- Minimal changes allowed directly in production
- All changes must be validated in lower environments first
- Resource naming and tagging enforced consistently

---

## Cloud-Agnostic Design
- Identical module interfaces are used across clouds
- Only provider-specific module implementations differ
- Environment structure remains consistent across AWS and OpenStack

This enables cloud portability without re-architecting infrastructure.

---

## Inputs
Inputs are defined in:
terraform.tfvars
