## Infrastructure Details

| Component | Configuration |
|---|---|
| Hypervisor | UTM |
| Host Machine | MacBook Pro M1 |
| Guest OS | Ubuntu Server 24.04 LTS |
| Architecture | ARM64 |
| CPU | 2 cores |
| Memory | 4 GB |
| Storage | 30 GB |
## System Baseline Configuration

After installing Ubuntu Server, the following baseline configuration tasks were completed:

### System Updates

- Updated package repositories using `apt update`
- Applied available system updates using `apt upgrade`

### Administrative Access

Verified administrator privileges using sudo:

```bash
sudo whoami