# Ticket 006 - Disk Usage Investigation and Resolution

## Objective

Investigate a report that the Linux server was out of disk space and determine the root cause.

## Problem

Users reported they were unable to save files because the server was allegedly out of disk space.

## Investigation

### Step 1: Verify Disk Utilization

Checked overall filesystem usage using:

```bash
df -h
```

The root filesystem (`/`) was only 45% utilized with approximately 7 GB of free space remaining. This indicated that the reported issue could not be immediately reproduced.

### Step 2: Identify Disk Usage by Directory

Examined top-level directory sizes:

```bash
sudo du -xh --max-depth=1 / | sort -h
```

Findings:

* `/usr` was the largest directory.
* Usage appeared consistent with installed operating system packages and applications.
* No abnormal storage consumption was identified.

### Step 3: Investigate `/var`

Reviewed disk usage within `/var`:

```bash
sudo du -xh --max-depth=1 /var | sort -h
```

No excessive usage was initially found in common problem locations such as:

* `/var/log`
* `/var/cache`
* `/var/lib`

## Simulated Incident

To simulate a real-world storage issue, a large application log file was created:

```text
/var/log/application.log
```

After recreating the issue, filesystem utilization increased as expected.

Repeating the investigation identified:

* `/var/log` as the directory consuming additional space.
* `/var/log/application.log` as the specific file responsible.

## Resolution

Instead of deleting the log file, it was safely truncated:

```bash
sudo truncate -s 0 /var/log/application.log
```

This preserved the file, permissions, ownership, and application access while immediately reclaiming disk space.

## Validation

Verified that:

* The log file size returned to 0 bytes.
* Root filesystem utilization returned to its original level.
* No additional issues were observed after remediation.

## Skills Demonstrated

* Linux filesystem analysis
* Disk usage investigation (`df`, `du`)
* Log file identification
* Safe log maintenance using `truncate`
* Evidence-based troubleshooting
* Root cause analysis
* Validation of corrective actions

## Key Takeaways

* Always verify reported issues before implementing a fix.
* Large system directories such as `/usr` are not necessarily indicators of a problem.
* Investigate storage usage methodically before deleting files.
* Use `truncate` instead of `rm` for active log files when appropriate to avoid disrupting running applications.
* Validate that corrective actions resolve the issue and restore expected system behavior.
