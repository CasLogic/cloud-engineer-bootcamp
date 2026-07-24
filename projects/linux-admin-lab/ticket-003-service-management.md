## Troubleshooting Example

### Issue

SSH service was not running after initial server configuration.

### Investigation

Used systemctl to check service status:

systemctl status ssh

Reviewed service logs:

journalctl -u ssh

### Resolution

Started the SSH service and enabled it to launch automatically during system boot.

### Verification

Confirmed SSH was active and listening on port 22.