# Ticket 012 - DNS Resolution Failure Due to Invalid Configuration

## Incident Summary

Users reported that the internal application was unreachable by hostname.

Reported issue:

> "The application worked earlier today, but now `app.internal` won't load."

Additional observations:

* Users could still access the application by IP address.
* SSH connectivity remained functional.
* The application service was running normally.

The objective was to determine why hostname resolution failed and restore DNS functionality.

---

# Investigation

## Step 1: Identify the Responsible Component

Because users could reach the application by IP address but not by hostname, the issue was isolated to DNS resolution rather than general network connectivity.

The first step was checking the DNS resolver service.

Command:

```bash
sudo systemctl status systemd-resolved
```

Result:

```text
Active: failed (Result: exit-code)

Failed to parse DNS configuration.
```

Findings:

* The DNS resolver service had failed.
* The failure occurred during configuration parsing.

---

## Step 2: Review Service Logs

Inspected recent logs for the DNS resolver.

Command:

```bash
sudo journalctl -u systemd-resolved -n 25
```

Relevant output:

```text
/etc/systemd/resolved.conf:12:
Unknown key 'DNSSever'

Failed to read configuration file.
```

Findings:

The resolver could not start because of an invalid configuration directive.

---

## Step 3: Inspect Configuration

Reviewed the resolver configuration file.

Location:

```text
/etc/systemd/resolved.conf
```

Found:

```ini
DNSSever=10.0.0.10
```

The directive name contained a typo.

Correct configuration:

```ini
DNS=10.0.0.10
```

---

# Root Cause

A typographical error in `/etc/systemd/resolved.conf` prevented `systemd-resolved` from parsing its configuration.

Because the service failed during startup, hostname resolution was unavailable even though network connectivity and the application itself remained operational.

---

# Resolution

Corrected the configuration directive.

Changed:

```ini
DNSSever=10.0.0.10
```

to:

```ini
DNS=10.0.0.10
```

Restarted the resolver service.

Command:

```bash
sudo systemctl restart systemd-resolved
```

---

# Validation

Verified service health.

Command:

```bash
sudo systemctl status systemd-resolved
```

Result:

```text
Active: active (running)
```

Confirmed DNS resolution.

Commands:

```bash
resolvectl query app.internal
```

and

```bash
ping app.internal
```

Both successfully resolved the hostname.

Users confirmed the application was once again accessible by hostname.

---

# Skills Demonstrated

* DNS troubleshooting
* systemd service management
* Log analysis
* Configuration troubleshooting
* Root cause analysis
* Service recovery
* Incident validation

---

# Key Takeaways

* Always identify the component responsible for the reported symptom before troubleshooting.
* A failed service often provides the fastest path to the root cause through `systemctl status` and `journalctl`.
* Configuration validation is just as important as correcting the obvious error.
* Successful incident resolution includes verifying the original user problem, not just restarting the affected service.

---

# Troubleshooting Pattern Used

```text
Users report hostname failure
            ↓
Identify owning component
            ↓
Check service status
            ↓
Review service logs
            ↓
Locate configuration error
            ↓
Correct configuration
            ↓
Restart service
            ↓
Validate DNS resolution
            ↓
Confirm user recovery
```
