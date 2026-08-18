# Azure Disaster Recovery Using Managed Disk Snapshots

## Objective

Create a point-in-time recovery of an Azure Linux virtual machine using a Managed Disk Snapshot and successfully restore the VM by replacing the operating system disk.

---

## Environment

- Cloud Provider: Microsoft Azure
- Operating System: Ubuntu Server 24.04 LTS
- VM: vm-web01
- Resource Group: rg-cloud-lab-dev

---

## Skills Demonstrated

- Azure Managed Disk Snapshots
- Disaster Recovery Planning
- Point-in-Time Recovery
- Managed Disk Restoration
- OS Disk Replacement
- Recovery Validation
- Change Management
- Rollback Strategy
- Azure Cost Management

---

## Scenario

Prior to performing a high-risk system change, a recovery point was created to allow rapid rollback if the deployment failed.

---

## Deployment Workflow

### 1. Create Snapshot

Azure Portal

Virtual Machine

→ Disks

→ OS Disk

→ Create Snapshot

Snapshot Name:

```
snap-vm-web01-prechange
```

---

### 2. Verify Snapshot

Confirmed snapshot creation within the resource group.

Result:

```
snap-vm-web01-prechange
```

---

### 3. Restore Managed Disk

Opened the snapshot resource.

Selected:

```
Create Disk
```

Created a new managed disk:

```
disk-vm-web01-restored
```

---

### 4. Prepare for Recovery

Before replacing the operating system disk:

- Deallocated the virtual machine.
- Preserved the original OS disk.
- Verified the restored managed disk was available.

---

### 5. Replace OS Disk

Azure Portal

VM

→ Disks

→ Swap OS Disk

Selected:

```
disk-vm-web01-restored
```

---

### 6. Boot Recovery

Started the virtual machine.

Verified:

- Successful boot
- SSH connectivity
- Operating system health

---

### 7. Validate Services

Verified:

```bash
systemctl status apache2
```

Verified website functionality:

```bash
curl http://localhost
```

Confirmed application availability through the browser.

---

### 8. Recovery Complete

The restored operating system successfully replaced the original OS disk.

The workload returned to a healthy operational state.

The original disk was retained until recovery validation was complete.

---

## Lessons Learned

- Azure snapshots operate at the managed disk level rather than the virtual machine level.
- A snapshot is not bootable.
- Recovery requires creating a new managed disk from the snapshot.
- OS disks can only be swapped while the VM is deallocated.
- Recovery validation should include infrastructure and application testing.
- Original recovery resources should not be removed until successful validation.
- Managed Disk Snapshots provide rapid rollback before risky production changes.

---

## Recovery Workflow

```
Healthy VM

↓

Create Snapshot

↓

Deployment

↓

Failure

↓

Create Managed Disk

↓

Deallocate VM

↓

Swap OS Disk

↓

Boot VM

↓

Validate Services

↓

Recovery Complete
```

---

## Commands Used

```bash
systemctl status apache2

curl http://localhost

hostnamectl

df -h
```

---

## Operational Takeaways

This lab demonstrated a complete disaster recovery workflow using Azure Managed Disk Snapshots.

Unlike traditional backups, snapshots provide fast point-in-time recovery and are best suited for:

- Operating system upgrades
- Kernel updates
- Application deployments
- Configuration changes
- Planned maintenance

Long-term retention and historical recovery should be handled with Azure Backup rather than Managed Disk Snapshots.