# Azure Monitoring Fundamentals

## Objective

Learn how Azure Monitor helps administrators observe infrastructure health, configure alerts, and prioritize incidents based on business impact rather than infrastructure metrics alone.

---

## Environment

- Azure Virtual Machine
- Ubuntu Linux
- Azure Portal
- Azure Monitor

---

## Monitoring Areas Explored

Within the Azure VM Monitoring blade, reviewed:

- Insights
- Alerts
- Metrics
- Logs
- Diagnostic Settings
- Dashboards (Grafana)
- Workbooks

---

## Key Concepts

### Infrastructure Monitoring

Monitors the health of the virtual machine itself.

Examples:

- CPU Utilization
- Available Memory
- Disk Performance
- Network Traffic

---

### Service Monitoring

Verifies critical services are running.

Examples:

- Apache
- PostgreSQL
- SSH

---

### Application Monitoring

Determines whether users can successfully use the application.

Examples:

- HTTP Status Codes
- Error Rate
- Response Time
- Failed Requests

---

### Business Monitoring

Measures customer impact.

Examples:

- Successful Logins
- Orders Processed
- Revenue
- User Transactions

---

## Monitoring Pyramid

Business Health

- Orders
- Revenue
- User Activity

↓

Application Health

- HTTP Status
- Error Rate
- Response Time

↓

Service Health

- Apache
- Database
- SSH

↓

Infrastructure Health

- CPU
- Memory
- Disk
- Network

---

## Azure Metrics Reviewed

- Percentage CPU
- Available Memory
- Data Disk Latency
- Data Disk IOPS
- CPU Credits Remaining

Notes:

CPU Credits are specific to Azure burstable (B-Series) virtual machines and represent temporary CPU performance credits accumulated while the VM is idle.

---

## Alerting Concepts

Learned the difference between:

### Immediate Alerts

Used for events requiring immediate attention.

Examples:

- VM Unavailable
- Web Server Stopped
- Backup Failure
- Website Returning Errors

### Threshold Alerts

Used for sustained conditions.

Examples:

- CPU > 90% for 10 minutes
- Memory > 90%
- Disk Usage > 85%

This helps reduce alert fatigue by avoiding unnecessary notifications for temporary spikes.

---

## Incident Prioritization

Established the following troubleshooting priority:

Customer Impact

↓

Application

↓

Services

↓

Infrastructure

When presented with healthy infrastructure metrics but increasing HTTP 500 errors, the investigation should begin with the application layer because customer functionality is already affected.

---

## Engineering Takeaways

- Infrastructure health does not guarantee application health.
- Application availability is more important than individual infrastructure metrics.
- Monitoring should focus on actionable alerts.
- Alert thresholds should minimize unnecessary notifications.
- Azure Monitor provides infrastructure visibility, while application monitoring typically requires additional tools such as Application Insights.

---

## Skills Demonstrated

- Azure Monitor Navigation
- Monitoring Strategy
- Operational Thinking
- Alert Design
- Incident Prioritization
- Infrastructure vs Application Monitoring