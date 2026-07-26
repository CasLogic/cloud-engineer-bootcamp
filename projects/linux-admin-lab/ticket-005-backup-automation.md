# Ticket 005 - Automated Project Backup

## Objective
Create an automated backup process for project files on the Linux server.

## Investigation

- Verified `/home/casius/projects` existed but contained no data.
- Created test data to validate backup functionality.
- Encountered permission denied errors when creating files.
- Determined the user was not a member of the `developers` group.
- Added the user to the group and verified access.

## Implementation

Created a Bash backup script that:

- Defines source and destination paths.
- Generates timestamp-based backup folders.
- Creates backup directories automatically.
- Copies project files.
- Logs backup activity.
- Reports success or failure.

## Automation

Configured cron to execute the backup script daily.

Cron configuration:
0 2 * * * root /usr/local/bin/project_backup.sh

## Validation

Verified:

- Manual script execution.
- Backup directory creation.
- File copying.
- Log output.
- Automated cron execution.

## Skills Demonstrated

- Linux file permissions
- User/group management
- Bash scripting
- Cron scheduling
- System administration troubleshooting
- Logging and validation