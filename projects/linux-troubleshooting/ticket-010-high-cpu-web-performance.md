# Ticket 010 - High CPU Causing Slow Website Performance

## Incident Summary

Users reported that the company website was extremely slow.

Reported issue:

> "The website eventually loads, but pages take 20–30 seconds to respond."

Monitoring also generated a high CPU utilization alert around the same time.

The objective was to determine the cause of the performance degradation and restore normal service.

---

# Investigation

## Step 1: Verify Overall System Health

Since the issue was performance rather than availability, the first step was checking overall system resource utilization.

Command:

```bash
top
```

Findings:

* CPU utilization was approximately 97%.
* Load average was significantly higher than normal.
* One Python process was consuming over 90% of CPU resources.

Example output:

```text
PID    USER      %CPU    COMMAND
2411   www-data  92.7    python3
```

Conclusion:

A single process appeared to be responsible for the performance issue.

---

## Step 2: Identify the Process

Inspected the running process.

Command:

```bash
ps -fp 2411
```

Result:

```text
python3 /var/www/html/report_generator.py
```

Findings:

The process was running under the web server account (`www-data`) and executing a report generation script.

---

## Step 3: Inspect the Script

Reviewed the beginning of the script.

Command:

```bash
head -20 /var/www/html/report_generator.py
```

Relevant code:

```python
while True:
    for filename in os.listdir(REPORT_DIR):
        ...
```

Findings:

The script continuously scanned and processed files inside an infinite loop.

There was no delay (`time.sleep()`) between iterations.

Conclusion:

The script repeatedly processed the same directory as fast as the CPU allowed, creating a busy loop.

---

# Root Cause

A Python report generation script contained an infinite loop with no pause between iterations.

Because the script continuously rescanned the report directory without sleeping or exiting, CPU utilization remained above 90%, causing the web server to respond slowly.

---

# Immediate Mitigation

The priority during the incident was restoring service for users.

Verified that the process was not managed by another service.

Stopped the process:

```bash
kill 2411
```

---

# Validation

After stopping the process:

Checked system utilization:

```bash
top
```

Result:

* CPU utilization returned to normal.
* Load average dropped significantly.

Verified web server responsiveness:

```bash
curl -I http://localhost
```

Result:

```text
HTTP/1.1 200 OK
```

Users confirmed that website performance returned to normal.

---

# Permanent Resolution

The application required code changes to prevent excessive CPU utilization.

Possible improvements:

* Add an appropriate delay between iterations.

Example:

```python
while True:
    process_reports()
    time.sleep(60)
```

or redesign the script to execute on a schedule using:

* cron
* systemd timers
* scheduled automation

instead of running continuously.

---

# Skills Demonstrated

* Linux performance troubleshooting
* CPU utilization analysis
* Process investigation
* Using `top`
* Using `ps`
* Application inspection
* Root cause analysis
* Incident mitigation
* Service validation
* Performance recovery

---

# Key Takeaways

* High CPU usage can severely impact application performance even when services remain online.
* Identify the process consuming resources before taking corrective action.
* Restore service first, then investigate and implement a permanent fix.
* Infinite loops should include appropriate delays or be redesigned as scheduled jobs when continuous execution is unnecessary.

---

# Troubleshooting Pattern Used

```text
Users report slow website
        ↓
Check overall system health
        ↓
Identify high CPU process
        ↓
Determine what the process is doing
        ↓
Inspect application logic
        ↓
Identify root cause
        ↓
Mitigate user impact
        ↓
Verify service recovery
        ↓
Implement permanent fix
```
