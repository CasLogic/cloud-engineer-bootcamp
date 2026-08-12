# Incident: Apache Failed to Start

## Summary

Website unavailable.

## Symptoms

- curl returned an empty response.
- SSH connectivity was successful.
- Apache service was in a failed state.

## Investigation

- Verified VM accessibility.
- Checked Apache service status.
- Reviewed system logs.
- Identified syntax error within the Apache virtual host configuration.

## Root Cause

Misspelled Apache directive prevented the service from starting.

## Resolution

- Corrected the configuration.
- Validated configuration using:

apache2ctl configtest

- Restarted Apache.
- Verified website availability.

## Lessons Learned

Validate service configuration before restarting production services.