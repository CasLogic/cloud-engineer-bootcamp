# Azure Managed Disks

## Objective

Attach a new Azure Managed Disk to an existing Linux virtual machine, prepare it for use, configure persistent mounting, and verify functionality after a reboot.

---

## Environment

- Cloud Provider: Microsoft Azure
- Operating System: Ubuntu Server 24.04 LTS
- VM: vm-web01

---

## Skills Demonstrated

- Azure Managed Disk administration
- Linux block device identification
- Disk partitioning
- Filesystem creation
- Mount point configuration
- Linux permissions
- Persistent storage using /etc/fstab
- Filesystem validation
- Cloud cost management

---

## Deployment Workflow

### 1. Create and Attach Managed Disk

Azure Portal

Virtual Machine

→ Disks

→ Create and Attach New Disk

- Name: data-disk-01
- Size: 4 GiB

---

### 2. Verify Linux Detects the Disk

```bash
lsblk
```

Result:

```
sda
```

The new disk appeared as an unpartitioned block device.

---

### 3. Create a Partition

```bash
sudo fdisk /dev/sda
```

Commands used:

```
n
p
1


w
```

Verification:

```bash
lsblk
```

Result:

```
sda
└── sda1
```

---

### 4. Create an ext4 Filesystem

```bash
sudo mkfs.ext4 /dev/sda1
```

Verification:

```bash
lsblk -f
```

Result:

Filesystem type displayed as:

```
ext4
```

---

### 5. Create Mount Point

```bash
sudo mkdir /data
```

---

### 6. Mount Filesystem

```bash
sudo mount /dev/sda1 /data
```

Verification:

```bash
findmnt /data
```

---

### 7. Configure Permissions

Initial write attempt:

```bash
touch /data/test.txt
```

Result:

```
Permission denied
```

Ownership was updated:

```bash
sudo chown azureadmin:azureadmin /data
```

Verification:

```bash
touch /data/test.txt
```

Successful.

---

### 8. Configure Persistent Mount

Retrieve UUID:

```bash
sudo blkid /dev/sda1
```

Backup configuration:

```bash
sudo cp /etc/fstab /etc/fstab.backup
```

Add entry:

```
UUID=<UUID> /data ext4 defaults,nofail 0 2
```

Validate:

```bash
sudo mount -a
```

No errors returned.

---

### 9. Verify After Reboot

```bash
sudo reboot
```

Verification:

```bash
findmnt /data
```

Created new file:

```bash
touch /data/after-reboot.txt
```

Both files remained available after reboot.

---

## Lessons Learned

- Azure Managed Disks appear in Linux as raw block devices.
- A disk must be partitioned, formatted, mounted, and configured in /etc/fstab before it becomes usable.
- Device names may change, but UUIDs remain consistent.
- Always validate /etc/fstab with:

sudo mount -a

before rebooting.
- Mounting a filesystem does not automatically grant write permissions.
- Deleting unused managed disks prevents unnecessary Azure storage charges.

---

## Commands Used

```bash
lsblk

lsblk -f

fdisk

mkfs.ext4

mkdir

mount

findmnt

blkid

mount -a

chown

touch

df -h
```