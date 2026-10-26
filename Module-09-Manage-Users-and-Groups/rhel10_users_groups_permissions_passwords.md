# RHEL 10: Users, Groups, Permissions, and Password Management

A simple practical guide for Linux administration and RHCSA practice.

## 1. Create and manage users

| Task | Command |
|---|---|
| Create a user | `sudo useradd Khan` |
| Create a user with a home directory | `sudo useradd -m Khan` |
| Set or change a password | `sudo passwd Khan` |
| View user information | `id Khan` |
| View the user's UID | `id -u Khan` |
| View the user's groups | `groups Khan` |
| Change the user's login shell | `sudo usermod -s /bin/bash Khan` |
| Lock the user's password | `sudo passwd -l Khan` |
| Unlock the user's password | `sudo passwd -u Khan` |
| Delete a user but keep their home directory | `sudo userdel Khan` |
| Delete a user and their home directory | `sudo userdel -r Khan` |

### Example: Create a user

```bash
sudo useradd -m Khan
sudo passwd Khan
id Khan
```

`-m` creates the user's home directory, usually `/home/Khan`.

> Linux usernames are case-sensitive. `Khan` and `khan` are different usernames.

## 2. Create and manage groups

Groups let you grant several users the same access to files and directories.

| Task | Command |
|---|---|
| Create a group | `sudo groupadd developers` |
| Add a user to a supplementary group | `sudo usermod -aG developers Khan` |
| Check group membership | `groups Khan` |
| Remove a user from a group | `sudo gpasswd -d Khan developers` |
| Delete a group | `sudo groupdel developers` |

Example:

```bash
sudo groupadd developers
sudo usermod -aG developers Khan
groups Khan
```

**Important:** Use `-aG` together when adding a supplementary group. Using `-G` without `-a` can replace the user's existing supplementary group list.

## 3. Grant and remove sudo privileges

On RHEL, the `wheel` group is commonly used to grant administrative privileges through `sudo`, provided the sudoers configuration allows it.

### Grant sudo access through `wheel`

```bash
sudo usermod -aG wheel Khan
```

### Remove sudo access through `wheel`

```bash
sudo gpasswd -d Khan wheel
```

This removes Khan from `wheel`, but does not remove any other sudo privileges granted through separate sudoers rules.

### Verify sudo access

```bash
groups Khan
sudo -l -U Khan
```

### Edit sudo permissions safely

Edit the main sudoers file:

```bash
sudo visudo
```

Or create/edit a separate rule file:

```bash
sudo visudo -f /etc/sudoers.d/Khan
```

Example rule granting full sudo access:

```text
Khan ALL=(ALL) ALL
```

Use `visudo` so the syntax is checked. Grant full administrative access only when needed.

## 4. File and directory permissions

Linux permissions control who can read, write, or execute a file.

- `u` = owner (user)
- `g` = group
- `o` = others
- `r` = read
- `w` = write
- `x` = execute

| Task | Command |
|---|---|
| View file permissions | `ls -l file.txt` |
| Give the owner execute permission | `chmod u+x file.txt` |
| Remove write permission from others | `chmod o-w file.txt` |
| Set permissions to `755` | `chmod 755 script.sh` |
| Set permissions to `644` | `chmod 644 file.txt` |
| Change file owner | `sudo chown Khan file.txt` |
| Change file group | `sudo chgrp developers file.txt` |
| Change owner and group | `sudo chown Khan:developers file.txt` |
| Change permissions recursively | `sudo chmod -R 755 /path/to/dir` |

### Numeric permissions

| Number | Permission |
|---|---|
| `7` | Read + write + execute (`rwx`) |
| `6` | Read + write (`rw-`) |
| `5` | Read + execute (`r-x`) |
| `4` | Read only (`r--`) |
| `0` | No permissions (`---`) |

Example:

```bash
chmod 750 script.sh
```

- Owner (`7`): read, write, execute.
- Group (`5`): read and execute.
- Others (`0`): no access.

Be careful with recursive permission changes, especially on system directories.

## 5. Password expiration and aging

Use `chage` to manage password aging and account expiration.

| Task | Command |
|---|---|
| View password aging settings | `sudo chage -l Khan` |
| Set maximum password age to 90 days | `sudo chage -M 90 Khan` |
| Require at least 7 days between changes | `sudo chage -m 7 Khan` |
| Warn 7 days before password expiration | `sudo chage -W 7 Khan` |
| Force a password change at next login | `sudo chage -d 0 Khan` |
| Set an account expiration date | `sudo chage -E 2026-12-31 Khan` |
| Expire the password immediately | `sudo passwd -e Khan` |

Example:

```bash
sudo chage -M 90 -m 7 -W 7 Khan
sudo chage -l Khan
```

This sets a maximum password age of 90 days, a minimum age of 7 days, and a warning period of 7 days.

**Password expiration vs. account expiration:**
- Password expiration means the user must change their password.
- Account expiration disables the account after the configured date.

## 6. Lock and unlock accounts

```bash
# Lock the user's password
sudo passwd -l Khan

# Unlock the user's password
sudo passwd -u Khan

# Check password status
sudo passwd -S Khan
```

The status commonly shows:
- `P`: a password is set.
- `L`: the password is locked.
- `NP`: no password is set.

Locking a password does not necessarily block every authentication method. SSH keys or other methods may still work, depending on the system configuration.

## 7. Set default password aging for new users

On RHEL, common defaults are configured in `/etc/login.defs`:

```bash
sudo vi /etc/login.defs
```

Look for settings such as:

```text
PASS_MAX_DAYS   90
PASS_MIN_DAYS   7
PASS_WARN_AGE   7
```

- `PASS_MAX_DAYS`: maximum password age.
- `PASS_MIN_DAYS`: minimum days between password changes.
- `PASS_WARN_AGE`: warning period before expiration.

These defaults primarily apply to newly created users. To change an existing user's settings, use `chage`.

## 8. RHCSA practice lab

Run these commands in order on a test RHEL virtual machine.

```bash
# 1. Create a group
sudo groupadd developers

# 2. Create a user with a home directory
sudo useradd -m Khan

# 3. Set the user's password
sudo passwd Khan

# 4. Add the user to the developers group
sudo usermod -aG developers Khan

# 5. Grant sudo access through wheel
sudo usermod -aG wheel Khan

# 6. Configure password aging
sudo chage -M 90 -m 7 -W 7 Khan

# 7. Create a shared directory
sudo mkdir -p /shared

# 8. Set the directory's group
sudo chown root:developers /shared

# 9. Give owner and group full access; deny others
#    The leading 2 sets the setgid bit.
sudo chmod 2770 /shared

# 10. Verify
id Khan
sudo chage -l Khan
ls -ld /shared
sudo -l -U Khan
```

The `2770` permissions give the directory owner and group full access, deny access to others, and set the setgid bit. New files and directories created inside `/shared` will normally inherit the `developers` group.

Run this lab on a test machine and use a non-sensitive test password. The user `Khan` must be available; if it already exists, skip `useradd`.

## 9. Quick revision sheet

| Task | Main command |
|---|---|
| Create a user | `useradd` |
| Modify a user | `usermod` |
| Delete a user | `userdel` |
| Create a group | `groupadd` |
| Remove a user from a group | `gpasswd -d` |
| Grant sudo through `wheel` | `usermod -aG wheel` |
| Change permissions | `chmod` |
| Change ownership | `chown` |
| Change a password | `passwd` |
| Manage password aging | `chage` |
| Safely edit sudo rules | `visudo` |

**Remember:**
- `chmod` changes permissions.
- `chown` changes ownership.
- `usermod` changes user account settings and group membership.
- `passwd` changes or locks passwords.
- `chage` manages password aging and account expiration.
