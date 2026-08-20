# Terraform Azure Infrastructure Lab

## Objective

Deploy a complete Azure Linux environment using Terraform instead of manually creating resources through the Azure Portal.

## Architecture

- Resource Group
- Virtual Network
- Subnet
- Network Security Group
- NSG Association
- SSH Rule
- HTTP Rule
- Public IP
- Network Interface
- Linux Virtual Machine

## Skills Demonstrated

- Infrastructure as Code (Terraform)
- Azure Resource Manager Provider
- Resource Dependencies
- Terraform State
- Terraform Planning
- Infrastructure Validation
- Azure CLI
- SSH Connectivity
- Infrastructure Cleanup

## Terraform Workflow

```text
terraform init
        ↓
terraform plan
        ↓
terraform apply
        ↓
Validate Infrastructure
        ↓
terraform destroy
```

## Validation

- Verified Terraform plan before deployment.
- Successfully provisioned Azure infrastructure.
- Connected to the VM using SSH.
- Verified the Ubuntu operating system.
- Destroyed all Terraform-managed resources.

## Issues Encountered

### Issue 1

**Error**

VM SKU unavailable in East US.

**Root Cause**

The selected VM size was unavailable for the subscription and region.

**Resolution**

Changed the VM size to an available SKU.

---

### Issue 2

**Error**

Exceeded Standard Bsv2 family vCPU quota.

**Root Cause**

The existing lab VM consumed the available regional quota.

**Resolution**

Removed the previous VM and redeployed using Terraform.

**Future Improvement**

Request an increase to 8 vCPUs for the Standard Bsv2 family.

## Key Concepts Learned

- Declarative Infrastructure
- Desired State
- Terraform State
- Dependency Graphs
- Resource References
- Idempotency
- Infrastructure Lifecycle

## Commands Used

```bash
terraform init
terraform plan
terraform apply
terraform destroy
az account show
az vm list-ip-addresses
ssh
```

## Outcome

Successfully deployed, validated, and destroyed an Azure Linux environment entirely through Terraform while troubleshooting real Azure platform constraints.