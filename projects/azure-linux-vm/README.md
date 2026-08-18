# Azure Linux VM Lab - Sprint 1

## Project Overview

This project documents the deployment and administration of an Ubuntu Linux virtual machine in Microsoft Azure. The goal was to build a secure, cost-conscious cloud environment while applying Linux administration and troubleshooting skills learned in previous labs.

---

## Objectives

- Deploy an Ubuntu Server virtual machine in Azure.
- Design a secure virtual network.
- Configure SSH key authentication.
- Implement least-privilege network security.
- Validate Linux services.
- Troubleshoot real cloud infrastructure issues.
- Document findings and resolutions.

---

## Architecture

```
Internet
    │
    ▼
Public IP
    │
    ▼
Network Security Group (nsg-web)
    │
    ▼
Network Interface
    │
    ▼
Ubuntu VM (vm-web01)
    │
    ▼
Subnet (10.0.1.0/24)
    │
    ▼
Virtual Network (10.0.0.0/16)
```

---

## Azure Resources

| Resource | Name |
|----------|------|
| Resource Group | rg-cloud-lab-dev |
| Virtual Network | vnet-cloud-lab |
| Subnet | snet-web |
| Network Security Group | nsg-web |
| Virtual Machine | vm-web01 |
| Public IP | pip-web01 |

---

## Security Configuration

- SSH key authentication
- Password authentication disabled
- SSH restricted to my public IP
- HTTP allowed on TCP port 80
- Least-privilege Network Security Group configuration

---

## Validation Performed

Successfully verified:

- VM deployment
- SSH connectivity
- Linux login
- Private IP assignment
- Apache installation
- Apache service status
- Local web server access
- External web server access

---

## Troubleshooting Completed

### Azure Incident #001

Bsv2 virtual machine quota unavailable.

Resolution:
- Investigated Azure quotas.
- Opened Microsoft support request.
- Quota approved.

---

### Azure Incident #002

SSH timed out.

Root Cause:
- Network Security Group rule used my workstation's private IP instead of my public IP.

Resolution:
- Updated the NSG rule with the correct public IP.

---

### Azure Incident #003

Website inaccessible externally.

Root Cause:
- Apache was functioning correctly.
- HTTP traffic was blocked by the Network Security Group.

Resolution:
- Added an inbound TCP 80 rule.

---

## Skills Demonstrated

### Azure

- Virtual Machines
- Resource Groups
- Virtual Networks
- Subnets
- Public IPs
- Network Security Groups
- Azure Support
- Azure Portal

### Linux

- Ubuntu Server
- OpenSSH
- Apache
- systemctl
- Networking
- Service validation

### Cloud Operations

- Infrastructure deployment
- Cost optimization
- Least privilege
- Layered troubleshooting
- Root cause analysis
- Documentation

---

## Key Lessons Learned

- Always troubleshoot from the application outward.
- Understand the difference between public and private IP addresses.
- Verify services locally before investigating cloud networking.
- Azure quotas can prevent deployments even when infrastructure is correctly configured.
- Build secure infrastructure first, then expose only the required services.

---

## Sprint Status

✅ Sprint 1 Complete

## Labs Completed

- Azure Virtual Machine Deployment
- SSH Key Authentication
- Apache Web Server Deployment
- Azure CLI Administration
- Azure Networking & NSG Troubleshooting
- Linux Service Troubleshooting
- Azure Managed Disk Administration
- Linux Storage Management
- Persistent Filesystem Mounting
- Azure Disaster Recovery with Managed Disk Snapshots
- Azure Cost Management