# Staging Environment – AWS

## Overview
This directory defines the staging infrastructure on AWS, deployed using reusable and cloud-agnostic Terraform modules.

The staging environment is used to validate infrastructure changes, module upgrades, and configuration updates before promoting them to production.

---

## Architecture
The staging environment provisions the following AWS resources:

- VPC with subnet and routing
- EC2 compute instance
- Security group with controlled ingress rules
- EBS block storage attached to the instance

The architecture closely mirrors production, with differences limited to size, scale, or non-critical configuration values.

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
  Creates EC2 instances used for staging workloads and testing.

---

### Security Module
- Source: `modules/security/aws-security`
- Purpose:  
  Manages security groups and ingress/egress rules.

---

### Storage Module
- Source: `modules/storage/ebs`
- Purpose:  
  Creates and attaches EBS volumes for persistent storage.

---

## Role of Staging
- Validate Terraform module changes
- Test infrastructure upgrades
- Verify cloud portability between AWS and OpenStack
- Catch issues before production deployment

---

## Cloud-Agnostic Design
- Same module interfaces as dev and prod
- Only provider-specific implementations differ
- Environment structure is identical across clouds

This ensures smooth promotion from staging to production.

---

## Inputs
Inputs are defined in:

terraform.tfvars
