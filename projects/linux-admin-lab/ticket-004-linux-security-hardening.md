# Ticket #004 - Linux Security Hardening

## Objective

Secure an Ubuntu Server by reducing attack surface, implementing stronger authentication methods, configuring firewall rules, and validating security settings.

---

## Tasks Completed

### Firewall Configuration

- Audited listening services using `ss`
- Reviewed exposed network ports
- Enabled UFW firewall
- Allowed SSH access before enabling firewall
- Tested firewall rule creation and removal
- Verified IPv4 and IPv6 firewall behavior

Commands used:

```bash
sudo ss -tulpn
sudo ufw status verbose
sudo ufw allow OpenSSH
sudo ufw allow 80/tcp
sudo ufw delete <rule>