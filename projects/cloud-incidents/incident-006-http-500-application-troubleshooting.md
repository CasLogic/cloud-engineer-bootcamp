# Cloud Incident #006 - HTTP 500 Internal Server Error

## Incident Summary

Users reported receiving an HTTP 500 Internal Server Error immediately after a new application deployment.

---

## Environment

- Microsoft Azure
- Ubuntu Server 24.04 LTS
- Apache2
- PostgreSQL
- Linux Systemd Services

---

## Initial Symptoms

Users were unable to access the application.

Browser response:

HTTP 500 Internal Server Error

---

## Investigation Process

### Step 1

Verified the issue could be reproduced.

Result:

HTTP 500 returned consistently.

---

### Step 2

Verified Apache service.

```bash
sudo systemctl status apache2
```

Result:

```
active (running)
```

Conclusion:

The web server was healthy.

---

### Step 3

Verified the issue locally.

```bash
curl http://localhost
```

Result:

```
500 Internal Server Error
```

Conclusion:

The issue was not caused by DNS, Azure networking, or the public endpoint.

---

### Step 4

Reviewed Apache logs.

```bash
sudo journalctl -u apache2
```

Result:

No significant errors.

Conclusion:

Apache was functioning correctly and forwarding requests.

---

### Step 5

Shifted investigation to the application layer.

Application logs reported:

```
Database connection failed.
Connection refused.
```

Conclusion:

The web server was operational, but the application could not communicate with its database.

---

### Step 6

Identified the database platform.

Application configuration indicated:

- PostgreSQL

---

### Step 7

Verified PostgreSQL service.

```bash
sudo systemctl status postgresql
```

Result:

```
active (running)
```

Conclusion:

Database service was online.

---

### Step 8

Reviewed PostgreSQL logs.

```bash
sudo journalctl -u postgresql
```

Result:

```
FATAL:
password authentication failed for user "appuser"
```

---

## Root Cause

The application credentials did not match the PostgreSQL credentials.

The database service was healthy, but authentication failed because the application was attempting to connect using an incorrect password.

---

## Resolution

Verify that:

- Database username
- Database password
- Application configuration
- Environment variables
- Secrets

all reference the correct credentials.

Restarting Apache or PostgreSQL would not resolve the issue because the root cause was an authentication mismatch.

---

## Lessons Learned

- A running web server does not guarantee a healthy application.
- Always isolate the failing layer before making changes.
- Logs should guide troubleshooting decisions.
- Avoid restarting services without evidence.
- Authentication failures should lead to configuration verification before remediation.

---

## Troubleshooting Workflow

User reports HTTP 500

↓

Verify issue

↓

Verify web server

↓

Review web server logs

↓

Investigate application

↓

Identify dependencies

↓

Verify dependency health

↓

Review dependency logs

↓

Determine root cause

↓

Implement targeted fix

---

## Commands Used

```bash
systemctl status apache2

curl http://localhost

journalctl -u apache2

systemctl status postgresql

journalctl -u postgresql
```