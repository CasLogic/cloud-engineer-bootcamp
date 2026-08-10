# Azure Incident #002 - SSH Connection Timed Out

## Category

Azure Networking

## Scenario

After successfully deploying the Ubuntu virtual machine, I attempted to connect over SSH from my Mac using an SSH key.

## Symptoms

- SSH connection timed out.
- No authentication prompt appeared.
- SSH debug output stopped while connecting to port 22.

## Initial Hypotheses

- Incorrect SSH key.
- Incorrect username.
- VM not running.
- Network Security Group blocking SSH.
- Incorrect public IP.

## Investigation

- Verified VM was running.
- Confirmed the correct public IP address.
- Verified SSH key permissions.
- Confirmed the Network Security Group was attached to the network interface.
- Reviewed the inbound security rules.

## Root Cause

The SSH rule in the Network Security Group used my workstation's private LAN IP address instead of my public Internet IP address.

Because Azure only sees the public IP, the SSH traffic matched the default deny rule and timed out.

## Resolution

Updated the inbound SSH rule to allow my current public IP address.

Verified successful SSH access.

## Validation

Successfully connected to the virtual machine using SSH key authentication.

## Lessons Learned

- Understand the difference between private and public IP addresses.
- Azure Network Security Groups evaluate the public source IP of Internet traffic.
- Timeouts indicate packets are being dropped before reaching the service.

## Skills Demonstrated

- Azure Network Security Groups
- SSH
- Network Troubleshooting
- Public vs Private IP
- Root Cause Analysis

## Incident Status

Resolved