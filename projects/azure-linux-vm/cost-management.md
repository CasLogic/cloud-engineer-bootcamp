# Azure Cost Management

## Purpose

This document outlines the cost optimization practices used throughout the Azure Linux VM lab.

---

## VM Selection

- Selected a B2ts_v2 virtual machine to minimize monthly compute costs while meeting the requirements of the lab.
- Avoided larger VM sizes until additional resources are required.

---

## Resource Organization

- Resources are organized within a dedicated Resource Group to simplify management and cleanup.

---

## VM Lifecycle

When actively working:

- Start the VM before beginning lab work.

When finished:

- Deallocate the VM to stop compute charges.

Azure CLI:

```bash
az vm deallocate \
  --resource-group rg-cloud-lab-dev \
  --name vm-web01
```

Start again:

```bash
az vm start \
  --resource-group rg-cloud-lab-dev \
  --name vm-web01
```

---

## Resources That Continue to Incur Charges

Even when the VM is deallocated, some Azure resources continue to exist and may incur charges.

Examples include:

- Managed disks
- Static Public IP addresses (depending on SKU)
- Storage resources
- Backup services

---

## Cost Optimization Principles

- Choose the smallest VM that satisfies the workload.
- Deallocate lab virtual machines when not in use.
- Avoid creating unnecessary duplicate resources.
- Monitor resource utilization before increasing VM size.
- Regularly review Azure costs and resource usage.

---

## Lessons Learned

Cloud engineering is not only about building reliable infrastructure but also about operating it efficiently. Understanding Azure billing and resource lifecycle management is an important operational skill.