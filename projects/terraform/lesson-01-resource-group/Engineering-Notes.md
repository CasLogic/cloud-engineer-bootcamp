# Engineering Note 01

## Building Azure Infrastructure with Terraform

### Summary

Deployed a complete Azure Linux environment using Terraform.

The lab demonstrated how Terraform compares desired state with actual state, builds resource dependency relationships, manages infrastructure through state, and provisions Azure resources using the AzureRM provider.

### Infrastructure Built

- Resource Group
- Virtual Network
- Subnet
- Network Security Group
- NSG Association
- SSH and HTTP security rules
- Public IP
- Network Interface
- Linux Virtual Machine

### Terraform Concepts Learned

- Infrastructure as Code
- Desired state
- Terraform state
- Resource dependencies
- Dependency graphs
- Resource references
- Idempotency
- Terraform lifecycle
- `terraform init`
- `terraform plan`
- `terraform apply`
- `terraform destroy`

### Troubleshooting

#### VM SKU Availability

The initial VM deployment failed because the selected VM SKU was unavailable in the East US region.

The Azure error was reviewed to identify that the problem was an Azure capacity/SKU restriction rather than an issue with the Terraform configuration.

The VM size was changed to an available SKU.

#### Azure vCPU Quota

The next deployment attempt failed because the subscription had a 2-vCPU quota for the Standard Bsv2 family.

The existing VM was consuming the available quota, preventing Terraform from creating another VM.

The existing VM was removed, freeing the required capacity.

A future quota increase will be requested to support larger labs.

### Validation

After Terraform successfully deployed the environment:

- Verified the Azure resources were created.
- Connected to the Linux VM using SSH.
- Verified the VM was operational.
- Ran `terraform destroy`.
- Confirmed all 8 Terraform-managed resources were successfully destroyed.

### Key Takeaways

Terraform allows Azure infrastructure to be defined as code and recreated through a repeatable deployment process.

Terraform determines resource creation and destruction order based on dependencies between resources.

Terraform configuration errors and Azure platform errors are different problems and should be diagnosed by reading the returned error before changing infrastructure code.
## Managed Data Disk Deployment

### Objective
Extend the Terraform-managed Azure VM with persistent data storage.

### Infrastructure Changes
- Created a 4 GB Azure Managed Disk using Terraform.
- Attached the managed disk to the existing Linux VM.
- Used Terraform dependencies to ensure the disk and VM existed before the attachment was created.

### Linux Configuration
After Terraform attached the raw disk, the VM detected it as `/dev/sdb`.

The disk was then configured inside Linux by:
- Creating the `/dev/sdb1` partition.
- Formatting the partition with the ext4 filesystem.
- Creating the `/data` mount point.
- Mounting the filesystem at `/data`.
- Using the disk UUID in `/etc/fstab` for persistent mounting.

### Validation
- Confirmed the disk and partition with `lsblk`.
- Confirmed `/dev/sdb1` was mounted at `/data`.
- Created a test file on the data disk.
- Rebooted the VM.
- Verified `/data` automatically remounted.
- Verified the test file persisted after reboot.

### Key Takeaway
Terraform managed the Azure infrastructure layer by creating and attaching the disk, while Linux configuration was required to partition, format, mount, and persist the filesystem inside the guest operating system.