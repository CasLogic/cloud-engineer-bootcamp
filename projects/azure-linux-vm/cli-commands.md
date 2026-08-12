# Azure CLI Commands

## Authentication

### Login

Purpose:
Authenticate to Azure.

Command:
az login

---

## Virtual Machines

### List VMs

Purpose:
Display all virtual machines.

Command:
az vm list --output table

---

### Show VM Details

Purpose:
Retrieve configuration and runtime details for a VM.

Command:
az vm show \
  --resource-group rg-cloud-lab-dev \
  --name vm-web01 \
  --show-details \
  --output table

---

### Get VM Size

Purpose:
Return only the VM size.

Command:
az vm show \
  --resource-group rg-cloud-lab-dev \
  --name vm-web01 \
  --query hardwareProfile.vmSize \
  --output tsv

---

### Get VM IP Addresses

Purpose:
Display public and private IP addresses.

Command:
az vm list-ip-addresses \
  --resource-group rg-cloud-lab-dev \
  --name vm-web01 \
  --output table

---

### Start VM

Purpose:
Start a deallocated virtual machine.

Command:
az vm start \
  --resource-group rg-cloud-lab-dev \
  --name vm-web01

---

### Stop (Deallocate) VM

Purpose:
Stop compute billing while preserving resources.

Command:
az vm deallocate \
  --resource-group rg-cloud-lab-dev \
  --name vm-web01