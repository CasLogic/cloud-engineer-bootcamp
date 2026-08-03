# Ticket 009 - Web Service Outage Investigation

## Incident Summary

Users reported that the company website was unavailable.

Reported issue:

> "Unable to connect to the website."

The objective was to determine whether the issue was caused by:

* server availability,
* network connectivity,
* web service failure,
* or application configuration.

---

# Investigation

## Step 1: Verify Server Access

Attempted SSH access to the web server.

Command:

```bash
ssh admin@web01.company.local
```

Result:

Successfully connected to the server.

Findings:

* Server was reachable.
* SSH service was operational.
* Operating system was responsive.

This ruled out:

* complete server outage,
* loss of administrative access,
* basic network failure.

---

## Step 2: Test HTTP Connectivity

Tested whether the web service was responding locally.

Command:

```bash
curl -I http://localhost
```

Result:

```text
curl: (7) Failed to connect to localhost port 80: Connection refused
```

Findings:

* The server was online.
* No service was accepting HTTP connections on port 80.

---

## Step 3: Check Listening Ports

Checked active listening ports to determine whether a web service was running.

Command:

```bash
sudo ss -tulpn
```

Findings:

* SSH was listening on port 22.
* No service was listening on port 80 or 443.

Conclusion:

The issue was likely related to a missing or failed web server service.

---

## Step 4: Identify Web Server Service

Checked active systemd services.

Command:

```bash
systemctl list-units --type=service
```

Findings:

No web server service was active.

Next, checked installed service units:

```bash
systemctl list-unit-files --type=service
```

Result:

```text
apache2.service enabled enabled
```

Conclusion:

Apache was installed but not running.

---

## Step 5: Investigate Apache Failure

Checked Apache service status.

Command:

```bash
sudo systemctl status apache2
```

Finding:

Apache failed during startup.

Error:

```text
AH00526: Syntax error on line 18 of /etc/apache2/apache2.conf

Invalid command 'ServerNmae'
```

Root cause identified:

The Apache configuration file contained a typo.

Incorrect:

```apache
ServerNmae web01.company.local
```

Correct:

```apache
ServerName web01.company.local
```

---

# Resolution

## Step 1: Correct Apache Configuration

Edited the Apache configuration file:

```bash
sudo nano /etc/apache2/apache2.conf
```

Changed:

```apache
ServerNmae
```

to:

```apache
ServerName
```

---

## Step 2: Validate Configuration

Before restarting Apache, tested the configuration.

Command:

```bash
sudo apachectl configtest
```

Result:

```text
Syntax OK
```

---

## Step 3: Restart Apache

Restarted the web service.

Command:

```bash
sudo systemctl restart apache2
```

Verified service status:

```bash
sudo systemctl status apache2
```

Result:

```text
Active: active (running)
```

---

## Step 4: Validate Website Availability

Tested HTTP response:

```bash
curl -I http://localhost
```

Result:

```text
HTTP/1.1 200 OK
Server: Apache/2.4.58 (Ubuntu)
```

Verified Apache was listening:

```bash
sudo ss -tulpn | grep :80
```

Result:

Apache successfully listening on port 80.

---

# Root Cause

Apache was unavailable because a syntax error in the Apache configuration prevented the service from starting.

The typo:

```text
ServerNmae
```

caused Apache configuration parsing to fail.

---

# Skills Demonstrated

* Linux service troubleshooting
* systemd service management
* Apache administration
* Configuration debugging
* Log/error message analysis
* HTTP troubleshooting
* Network port validation
* Safe configuration changes
* Service recovery validation

---

# Key Takeaways

* A website outage does not always indicate a network problem.
* "Connection refused" usually means the host is reachable but no service is accepting connections.
* Identify the responsible component before making changes.
* Always validate configuration files before restarting production services.
* Successful troubleshooting requires verifying both the fix and the original user issue.

---

# Troubleshooting Pattern Used

```
User reports outage
        ↓
Verify server access
        ↓
Test application connectivity
        ↓
Check listening ports
        ↓
Identify responsible service
        ↓
Review service status/logs
        ↓
Fix root cause
        ↓
Validate configuration
        ↓
Restart service
        ↓
Confirm recovery
```
