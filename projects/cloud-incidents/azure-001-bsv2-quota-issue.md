# Azure Incident #001 - Unable to Deploy Bsv2 Virtual Machine

## Category

Azure Infrastructure

## Scenario

While deploying the first Ubuntu virtual machine for the Azure Linux lab, the deployment could not proceed because the desired Bsv2 virtual machine family was unavailable.

## Symptoms

- B-series virtual machines were unavailable during VM creation.
- The Azure portal displayed:
  - `NotAvailableForSubscription`
  - `0 of 0 vCPUs`
- East US and East US 2 both failed to provide Bsv2 virtual machines.
- Azure only recommended alternative VM families instead of B-series.

## Initial Hypotheses

- Incorrect VM image selected.
- Region lacked available capacity.
- Subscription quota issue.
- Pay-As-You-Go subscription restrictions.

## Investigation

- Verified Ubuntu image architecture (x64 Gen2).
- Tested multiple Azure regions.
- Reviewed VM family availability.
- Checked **Usage + Quotas**.
- Confirmed the Standard Bsv2 family showed `0 of 0 vCPUs`.
- Used the Azure quota troubleshooting workflow.

## Root Cause

The Pay-As-You-Go subscription did not have access to deploy Standard Bsv2 virtual machines in the selected region.

## Resolution

Submitted an Azure quota request for the Standard Bsv2 Family requesting 2 vCPUs in East US.

Microsoft approved the quota increase.

## Validation

Verified that the Standard Bsv2 Family quota was increased.

Successfully able to select Bsv2 virtual machines for deployment.

## Lessons Learned

- Always verify VM family availability before assuming a deployment problem.
- Check Azure quotas early when a VM family is unavailable.
- Read the full Azure error instead of immediately changing VM sizes.
- Cost optimization is part of cloud engineering—avoid selecting a larger VM family without understanding the reason.

## Skills Demonstrated

- Azure Virtual Machines
- Azure Quotas
- Azure Regions
- Cost Optimization
- Azure Support
- Troubleshooting Methodology