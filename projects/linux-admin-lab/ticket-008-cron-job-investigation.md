# Ticket 008 - Scheduled Task Investigation Using Cron and Journal Logs

## Objective

Investigate a reported failure of a scheduled backup job by validating the cron configuration, confirming job execution, reviewing system logs, and determining whether the issue originated on the Linux server.

---

# Scenario

Operations reported that the nightly backup did not run as expected. The objective was to determine whether the issue was caused by the scheduler, the backup script, or another component.

---

# Investigation

## Step 1: Verify Scheduled Task

Initially searched `/etc/crontab` for the scheduled backup job.

No matching entry was found.

Rather than assuming the job had been removed, continued investigating other cron configuration locations.

---

## Step 2: Search Alternate Cron Locations

Checked:

```text
/etc/cron.d
```

Located the scheduled task:

```text
project_backup
```

This demonstrated that application-specific scheduled jobs can be stored separately from the system-wide crontab.

---

## Step 3: Verify Scheduler Activity

Reviewed the cron service logs using `journalctl`.

Relevant entry:

```text
Aug 02 02:00:01 linux-admin-server CRON: (root) CMD (/usr/local/bin/project_backup.sh)
```

This confirmed:

* The cron service was healthy.
* The scheduled task executed at the expected time.
* Cron successfully launched the backup script.

---

## Step 4: Verify Script Execution

Reviewed the backup log:

```text
/var/log/project_backup.log
```

Recent entries:

```text
Backup started: 2026-08-02_02-00-01
Backup completed successfully: 2026-08-02_02-00-01
```

The log confirmed that the script executed successfully and completed without errors.

---

# Root Cause Analysis

No issues were found with:

* Cron configuration
* Cron service
* Backup script execution
* Script completion

The evidence indicated that the Linux server completed the scheduled backup successfully.

The reported issue likely originated in a downstream process, an incorrect assumption by the reporting user, or another system outside the backup server.

---

# Resolution

No changes were made to the server because the investigation found no fault within the scheduling or backup process.

The incident was documented with supporting evidence, and the next recommendation would be to investigate any downstream application responsible for consuming or displaying the backup.

---

# Skills Demonstrated

* Linux cron troubleshooting
* Understanding cron configuration locations
* Using `journalctl` to investigate scheduled jobs
* Correlating scheduler logs with application logs
* Validating scheduled task execution
* Evidence-based incident investigation
* Root cause analysis
* Determining when infrastructure is **not** the source of an issue

---

# Key Takeaways

* Scheduled jobs may exist in `/etc/crontab`, user crontabs, or `/etc/cron.d`.
* `journalctl` can confirm that cron executed a scheduled task.
* Application logs should always be reviewed to verify successful completion.
* A reported issue should never be accepted without verification.
* Effective troubleshooting follows evidence through each stage of execution before drawing conclusions.
