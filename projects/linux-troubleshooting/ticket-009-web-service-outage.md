# Ticket 009 - Web Service Outage Investigation

## Incident Summary

Users reported that the company website was unavailable.

Reported issue:

> "Unable to connect to the server."

No maintenance window or planned changes were reported.

The goal was to determine whether the issue was related to:

* server availability,
* networking,
* web service availability,
* or application failure.

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
* network connectivity failure preventing administration,
* system unavailability.

---

## Step 2: Test Local Web Connectivity

Tested whether the web service was responding locally.

Command:

```bash
curl -I http://localhost
```

Result:

```text
curl: (7) Failed to connect to localhost port 80 after 0 ms: Connection refused
```

Findings:

The server was running, but nothing was accepting connections on HTTP port 80.

This indicated the issue was likely related to a missing or failed web service.

---

## Step 3: Verify Listening Ports

Because the specific web server software was unknown, checked active listening ports instead of assuming a service.

Command:

```bash
sudo ss -tulpn
```

Result:

```text
tcp   LISTEN 0 4096 0.0.0.0:22 0.0.0.0:* users:(("sshd",pid=812,fd=3))
tcp   LISTEN 0 4096 [::]:22    [::]:*    users:(("sshd",pid=812,fd=4))
```

Findings:

Only SSH was listening.

No services were listening on:

* TCP port 80 (HTTP)
* TCP port 443 (HTTPS)

---

# Root Cause Investigation Status

The investigation determined:

* The server was online.
* SSH access was functioning.
* The operating system was healthy.
* No web service was actively listening.

The next investigation step would be identifying whether the expected web service was:

* stopped,
* missing,
* disabled,
* or failing during startup.

Potential next commands:

```bash
systemctl list-units --type=service
```

to identify available web server services.

---

# Skills Demonstrated

* Incident response workflow
* Service troubleshooting methodology
* Using SSH for remote administration
* Testing network services with curl
* Inspecting listening ports with ss
* Avoiding assumptions about installed services
* Building evidence before making changes

---

# Key Takeaways

* Always verify server accessibility before troubleshooting applications.
* A closed port does not automatically mean a networking problem.
* "Connection refused" usually means the host is reachable but no process is accepting connections.
* Use discovery tools before assuming a specific service exists.
* Troubleshooting should move from symptoms toward the responsible component.
