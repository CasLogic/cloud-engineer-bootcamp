# Ticket #001 – Linux Server Provisioning and Baseline Configuration

## Objective

Provision an Ubuntu Server virtual machine, configure initial administrative access, enable remote management, and prepare the system for future cloud engineering labs.

---

# Environment

- Operating System: Ubuntu Server 26.04
- Virtualization Platform: UTM
- Host Machine: Apple Silicon M1 Mac
- Architecture: ARM64

---

# Tasks Completed

## Virtual Machine Deployment

Created a new Ubuntu Server virtual machine using UTM.

Configuration:

- Virtualization mode selected
- Ubuntu Server ISO attached
- CPU and memory allocated
- Virtual storage configured
- Ubuntu Server installed successfully

---

## Initial User Configuration

Created a non-root administrator account during installation.

Verified account:

```bash
whoami
```

Result:

```
casius
```

Verified user privileges:

```bash
id
```

Confirmed membership in:

- adm group
- sudo group

---

## SSH Configuration

Enabled OpenSSH Server during installation.

Verified SSH service:

```bash
systemctl status ssh
```

Result:

```
Active: active (running)
```

SSH will be used for remote server administration.

---

## Network Validation

Verified network configuration:

```bash
ip addr
```

Tested connectivity:

```bash
ping -c 4 google.com
```

Confirmed:

- Network interface availability
- IP assignment
- DNS resolution
- Internet connectivity

---

## System Baseline Configuration

Updated package repositories:

```bash
sudo apt update
```

Applied system updates:

```bash
sudo apt upgrade
```

Verified administrative privileges:

```bash
sudo whoami
```

Result:

```
root
```

---

## Installed Administration Tools

Installed common Linux administration utilities:

```bash
sudo apt install -y tree curl wget git vim
```

Verified installations:

```bash
git --version
```

```bash
curl --version
```

Installed tools:

| Tool | Purpose |
|---|---|
| Git | Version control and portfolio management |
| Curl | Network and API troubleshooting |
| Wget | File downloads |
| Tree | Directory visualization |
| Vim | Terminal text editing |

---

# Troubleshooting

## Issue: VM Booted Back Into Ubuntu Installer

### Symptoms

After installation completed, the VM restarted into the Ubuntu installation process again.

### Investigation

Identified that the Ubuntu installation ISO was still attached as a boot device.

### Resolution

Removed the installation media from UTM and restarted the VM.

The system successfully booted from the virtual disk.

### Lesson Learned

Virtual machines must boot from the correct storage device after operating system installation.

---

# Skills Demonstrated

- Virtual machine provisioning
- Linux installation
- Ubuntu Server administration
- SSH configuration
- Linux networking validation
- Package management using apt
- Sudo privilege management
- Git version control
- Infrastructure troubleshooting