# Ticket 011 - Application Upload Failure Due to Permission Denied

## Incident Summary

Users reported that document uploads were failing on the company website.

Reported issue:

> "The homepage loads, but uploading documents returns a 500 Internal Server Error."

The development team reported that the application worked correctly in staging.

The objective was to identify why uploads failed and restore application functionality while maintaining proper security practices.

---

# Investigation

## Step 1: Review Application Errors

Since the website was returning a 500 Internal Server Error, the first step was reviewing service logs.

Command:

```bash
sudo journalctl -u apache2 -n 25
```

Relevant error:

```text
PHP Warning: move_uploaded_file(/var/www/html/uploads/report.pdf):
Failed to open stream: Permission denied

PHP Warning: move_uploaded_file():
Unable to move uploaded file to /var/www/html/uploads/report.pdf
```

Findings:

* Apache was running successfully.
* The application was executing.
* The failure occurred when writing uploaded files.

Conclusion:

The issue was likely related to filesystem permissions.

---

# Step 2: Inspect Upload Directory Permissions

Checked ownership and permissions of the upload directory.

Command:

```bash
ls -ld /var/www/html/uploads/
```

Result:

```text
drwxr-xr-x 2 root root 4096 Aug 04 11:35 /var/www/html/uploads/
```

Findings:

Directory ownership:

```text
Owner: root
Group: root
```

Permissions:

```text
Owner: read/write/execute
Group: read/execute
Others: read/execute
```

The directory was not writable by the web application.

---

# Step 3: Identify Application Service Account

Verified which user Apache worker processes were running as.

Command:

```bash
ps aux | grep apache2
```

Result:

```text
root      2148  apache2 -k start
www-data  3278  apache2 -k start
www-data  3279  apache2 -k start
www-data  3280  apache2 -k start
```

Findings:

Apache worker processes run as:

```text
www-data
```

This is the account executing PHP requests.

Conclusion:

The application required write access to the upload directory, but the service account did not own the directory.

---

# Root Cause

The upload directory ownership was incorrect after deployment.

The application ran as:

```text
www-data
```

but the upload directory was owned by:

```text
root:root
```

Because the web application did not have write permissions, PHP failed when attempting to save uploaded files.

---

# Resolution

Changed ownership of the upload directory to the application service account.

Command:

```bash
sudo chown www-data:www-data /var/www/html/uploads
```

Verified the change:

```bash
ls -ld /var/www/html/uploads
```

Result:

```text
drwxr-xr-x 2 www-data www-data 4096 Aug 04 12:15 /var/www/html/uploads
```

---

# Validation

Monitored Apache error logs while testing a new upload.

Command:

```bash
sudo tail -f /var/log/apache2/error.log
```

Test upload completed successfully.

Result:

```text
Upload completed successfully: report.pdf
```

Confirmed:

* No permission errors appeared.
* Files were successfully written to the upload directory.
* Users could upload documents again.

---

# Security Considerations

The issue could have been resolved with:

```bash
chmod 777 /var/www/html/uploads
```

However, this would violate the principle of least privilege.

A `777` permission grants all users on the system:

* read access
* write access
* execute access

This creates unnecessary security risk.

The correct solution was assigning ownership to the required service account only:

```text
www-data → /var/www/html/uploads
```

This provided the application the minimum required access while maintaining system security.

---

# Skills Demonstrated

* Linux filesystem permissions
* Ownership management
* Service account troubleshooting
* Apache/PHP troubleshooting
* Application log analysis
* Least privilege security practices
* Root cause analysis
* Production-safe remediation

---

# Key Takeaways

* Permission errors are often caused by mismatches between application users and filesystem ownership.
* Always identify which user actually runs a service before modifying permissions.
* Avoid insecure permission changes like `chmod 777`.
* Service accounts should receive only the permissions required for their function.
* Troubleshooting requires understanding both application behavior and operating system security.

---

# Troubleshooting Pattern Used

```text
Application returns error
        ↓
Review service/application logs
        ↓
Identify failing operation
        ↓
Check filesystem permissions
        ↓
Identify service account
        ↓
Compare required access vs current access
        ↓
Apply least privilege fix
        ↓
Validate application recovery
```
