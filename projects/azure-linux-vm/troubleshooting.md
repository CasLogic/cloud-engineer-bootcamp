# Troubleshooting Workflow

## Standard Process

1. Reproduce the issue.
2. Gather evidence.
3. Form a hypothesis.
4. Investigate the affected layer.
5. Identify the root cause.
6. Validate the proposed fix.
7. Implement the fix.
8. Verify service restoration.

---

## Useful Commands

systemctl status

journalctl -u <service>

apache2ctl configtest

curl -I

ss -tuln

systemctl restart