# Terraform Lesson 2 — Automated VM Configuration

## Overview

This lab builds on the Terraform infrastructure from Lesson 1 by adding automated Linux configuration with cloud-init.

The goal was to deploy a Linux VM that becomes operational without requiring manual configuration after provisioning.

## Infrastructure

Terraform provisions:

- Azure Resource Group
- Virtual Network
- Subnet
- Network Security Group
- NSG association
- Public IP address
- Network Interface
- Ubuntu Linux Virtual Machine
- 4 GB Azure Managed Disk
- Managed Disk attachment

## Automated VM Configuration

Terraform passes a cloud-init configuration to the Linux VM during deployment.

Cloud-init automatically:

- Updates available packages.
- Installs Nginx.
- Enables and starts the Nginx service.
- Creates a custom web page.
- Detects the attached Azure data disk.
- Creates a partition on the data disk.
- Formats the partition with ext4 if a filesystem does not already exist.
- Creates the `/data` mount point.
- Adds the filesystem UUID to `/etc/fstab`.
- Mounts the data disk.
- Creates a validation file on the mounted filesystem.

## Validation

The deployment was validated by confirming:

- The custom Nginx page was accessible through the VM's public IP.
- Nginx was running successfully.
- The managed disk appeared inside Linux.
- `/dev/sdb1` contained an ext4 filesystem.
- The filesystem was mounted at `/data`.
- `/etc/fstab` contained the persistent mount configuration.
- The cloud-init validation file existed on the mounted data disk.
- The complete environment could be destroyed and recreated from code.

## Troubleshooting

### Data Disk Was Partitioned but Not Formatted

The initial cloud-init configuration successfully created `/dev/sdb1`, but the data disk was not mounted at `/data`.

Running:

`findmnt /data`

returned no result even though the validation file existed inside `/data`.

Further inspection with `blkid` showed that `/dev/sdb1` had a `PARTUUID`, but did not have a filesystem `UUID` or `TYPE="ext4"`.

The original filesystem check used:

`blkid /dev/sdb1`

This returned successfully because the partition had a `PARTUUID`, causing the script to incorrectly assume that a filesystem already existed and skip `mkfs.ext4`.

The check was changed to specifically test for a filesystem type:

`blkid -s TYPE -o value /dev/sdb1`

After correcting the cloud-init configuration, the environment was destroyed and rebuilt. The new deployment successfully created the ext4 filesystem, mounted it at `/data`, and added the persistent mount to `/etc/fstab`.

## Key Takeaways

- Terraform provisions and manages the Azure infrastructure layer.
- cloud-init can bootstrap operating system configuration during VM creation.
- Terraform and cloud-init solve different layers of the deployment process.
- Automation should be designed to avoid destructive operations when resources already contain data.
- Successful script execution does not guarantee the desired system state.
- Infrastructure automation should be validated after deployment.
- Destroying and rebuilding the environment is an effective way to test Infrastructure as Code reproducibility.