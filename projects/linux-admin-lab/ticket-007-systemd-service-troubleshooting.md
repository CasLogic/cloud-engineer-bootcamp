# Ticket 007 - systemd Service Deployment and Troubleshooting

## Objective

Create, deploy, and troubleshoot a custom Linux systemd service that runs a background monitoring script.

## Scenario

The operations team requested a lightweight monitoring service that continuously writes heartbeat messages to a log file. The service needed to:

* Run in the background.
* Start automatically after system boot.
* Restart automatically if it failed.
* Provide a way to monitor service health.

---

# Implementation

## Step 1: Create Application Directory

Created an application directory under `/opt`:

```bash
sudo mkdir -p /opt/inventory-monitor
```

`/opt` was selected because it is commonly used for optional or third-party application files.

---

## Step 2: Create Monitoring Script

Created:

```text
/opt/inventory-monitor/inventory-monitor.sh
```

Script contents:

```bash
#!/bin/bash

LOGFILE="/var/log/inventory-monitor.log"

while true
do
    echo "$(date): Inventory Monitor is healthy." >> "$LOGFILE"
    sleep 60
done
```

The script was manually tested before deployment to verify that it successfully created log entries.

---

## Step 3: Set Script Permissions

Made the script executable:

```bash
sudo chmod +x /opt/inventory-monitor/inventory-monitor.sh
```

Verified permissions:

```bash
ls -l /opt/inventory-monitor/inventory-monitor.sh
```

---

# systemd Service Configuration

Created:

```text
/etc/systemd/system/inventory-monitor.service
```

Service configuration:

```ini
[Unit]
Description=Inventory Monitor Service
After=network.target

[Service]
Type=simple
ExecStart=/opt/inventory-monitor/inventory-monitor.sh
Restart=always
RestartSec=5
User=root

[Install]
WantedBy=multi-user.target
```

---

## Load and Start Service

Reloaded systemd configuration:

```bash
sudo systemctl daemon-reload
```

Started the service:

```bash
sudo systemctl start inventory-monitor
```

Enabled the service at boot:

```bash
sudo systemctl enable inventory-monitor
```

Verified service status:

```bash
sudo systemctl status inventory-monitor
```

Result:

```text
Active: active (running)
```

The service successfully generated heartbeat logs.

---

# Simulated Incident

## Issue

The monitoring service stopped functioning after the script execution permissions were removed.

Changed permissions:

```bash
sudo chmod -x /opt/inventory-monitor/inventory-monitor.sh
```

Restarted the service:

```bash
sudo systemctl restart inventory-monitor
```

---

# Investigation

Checked service status:

```bash
sudo systemctl status inventory-monitor
```

Found:

```text
Active: activating (auto-restart)
Result: exit-code
status=203/EXEC
```

## Analysis

The `203/EXEC` error indicated that systemd was unable to execute the command specified in `ExecStart`.

Verified the script permissions:

```bash
ls -l /opt/inventory-monitor/inventory-monitor.sh
```

Found:

```text
-rw-r--r--
```

The script existed, but the execute permission was missing.

---

# Root Cause

The systemd service failed because the executable script defined in `ExecStart` did not have execute permissions.

The service configuration and file path were correct.

---

# Resolution

Restored execute permission:

```bash
sudo chmod +x /opt/inventory-monitor/inventory-monitor.sh
```

Restarted the service:

```bash
sudo systemctl restart inventory-monitor
```

Validated recovery:

```bash
sudo systemctl status inventory-monitor
```

Result:

```text
Active: active (running)
```

The service resumed normal operation.

---

# Skills Demonstrated

* Linux systemd service management
* Creating custom service units
* Service lifecycle management
* Bash scripting
* File permission troubleshooting
* Diagnosing systemd startup failures
* Interpreting service error codes
* Root cause analysis
* Service recovery and validation

---

# Key Takeaways

* Always test scripts manually before deploying them as services.
* Use `systemctl status` to identify service failures.
* `203/EXEC` commonly indicates an execution problem such as incorrect permissions or invalid paths.
* File permissions directly impact whether systemd can execute applications.
* Always verify the fix after making changes.
