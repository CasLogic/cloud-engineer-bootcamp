# Ticket #002 – Linux Identity & Access Management

## Objective

Configure secure user and group access for a shared development workspace using Linux users, groups, ownership, and permissions.

---

## Environment

- OS: Ubuntu Server 26.04
- Platform: UTM on Apple Silicon (M1)
- Administrator: casius

---

## Tasks Completed

### User Management

- Created a new user: `developer1`
- Verified user identity using:

```bash
id developer1
```

- Tested login using:

```bash
su - developer1
```

### Group Management

Created a new group:

```bash
sudo groupadd developers
```

Added `developer1` to the group:

```bash
sudo usermod -aG developers developer1
```

Verified membership:

```bash
groups developer1
```

### Shared Project Directory

Created a shared directory:

```bash
sudo mkdir /projects
```

Assigned group ownership:

```bash
sudo chown root:developers /projects
```

Configured permissions:

```bash
sudo chmod 775 /projects
```

Verified that `developer1` could create files inside `/projects`.

---

## Troubleshooting

### Issue

Initially created `projects` using a relative path instead of an absolute path.

Relative path:

projects

Absolute path:

/projects

Because of this, the directory was created under the administrator's home directory instead of the root filesystem.

### Resolution

Created the shared directory at `/projects`, reassigned ownership, configured permissions, and verified group access.

---

## Skills Demonstrated

- Linux user management
- Linux group management
- Group-based access control
- File ownership
- File permissions
- `chmod`
- `chown`
- `sudo`
- `su`
- Linux troubleshooting