# RHCSA Module 9: Manage Users and Groups
## Comprehensive Lab Notes & Reference Guide

Local account changes affect login and ownership. Use the exact names, IDs, groups, and aging limits supplied by a task. Avoid changing or deleting the account currently providing administrative access.

## Contents
1. Local account files and identity lookup
2. Create and modify users
3. Passwords and password aging
4. Create and modify groups
5. Membership and primary groups
6. Configure privileged access with sudo
7. Verification and persistence

## 1. Local Account Files and Identity Lookup

Local account databases include `/etc/passwd`, `/etc/shadow`, `/etc/group`, and `/etc/gshadow`. Use commands rather than editing these files directly. NSS lookup tools can include directory services as well as local files:

```bash
getent passwd USER
getent group GROUP
id USER
whoami
```

`/etc/passwd` stores account metadata, not password hashes. Password hashes and aging data are protected in `/etc/shadow`.

## 2. Create and Modify Users

`useradd` creates a local account. On RHEL, `useradd -D` displays defaults. Specify a home directory, shell, UID, or primary group only when requested.

```bash
sudo useradd -m -s /bin/bash USER
sudo passwd USER
sudo usermod -c "Full Name" USER
sudo usermod -s /bin/bash USER
sudo usermod -u NEW_UID USER
sudo usermod -d /new/home -m USER
```

`-m` creates a home directory. `usermod -aG GROUP USER` appends a supplementary group; using `-G` without `-a` replaces the existing supplementary group list. `userdel USER` removes the account but usually leaves the home directory. `userdel -r USER` also removes home/mail data and is destructive; use only when explicitly required and after checking ownership/data.

## 3. Passwords and Aging

Set or change a password interactively with `passwd`. Avoid passwords in shell arguments or command history.

```bash
sudo passwd USER
sudo passwd -l USER                 # Lock password authentication
sudo passwd -u USER                 # Unlock password hash
sudo chage -l USER                  # Show aging policy
sudo chage -m 1 -M 90 -W 14 USER   # Min 1 day, max 90, warn 14
sudo chage -I 30 USER               # Inactive period after expiration
sudo chage -E 2027-12-31 USER       # Account expiration date
```

`passwd -l` locks password authentication; it is not a universal account-disable mechanism for all authentication methods. `chage -E` sets account expiration, distinct from password expiration. `PASS_MAX_DAYS`, `PASS_MIN_DAYS`, and `PASS_WARN_AGE` in `/etc/login.defs` influence newly created accounts; use `chage` to adjust an existing account.

## 4. Create and Modify Groups

```bash
sudo groupadd GROUP
sudo groupadd -g GID GROUP
sudo groupmod -n NEW_NAME OLD_NAME
sudo groupmod -g NEW_GID GROUP
sudo groupdel GROUP
getent group GROUP
```

A group cannot be removed while it remains a user's primary group. Check membership and dependencies first.

## 5. Membership and Primary Groups

A user's primary group is stored as the GID in passwd metadata. Supplementary memberships grant additional group access.

```bash
sudo usermod -g PRIMARY_GROUP USER
sudo usermod -aG SUPPLEMENTARY_GROUP USER
sudo gpasswd -a USER GROUP
sudo gpasswd -d USER GROUP
id USER
getent group GROUP
```

New group membership generally applies to new login sessions; start a new login or use `newgrp GROUP` when appropriate. Confirm that other supplementary groups were preserved after changing membership.

## 6. Configure Privileged Access with sudo

Use the `wheel` group or a narrowly scoped sudoers rule according to the task. Never edit `/etc/sudoers` with a normal editor; `visudo` validates syntax before saving.

```bash
sudo usermod -aG wheel USER
sudo visudo -c
sudo visudo -f /etc/sudoers.d/ops
```

Example drop-in rule granting the `ops` group standard sudo capability:

```sudoers
%ops ALL=(ALL) ALL
```

Keep the file root-owned and mode `0440` (or the mode required by system policy), then validate with `visudo -c`. Do not grant `NOPASSWD` unless explicitly requested. Test access in a second session before ending the administrative session.

## 7. Verification and Persistence

```bash
id USER
getent passwd USER
getent group GROUP
sudo chage -l USER
sudo passwd -S USER
sudo visudo -c
stat -c '%U %G %a %n' /etc/sudoers.d/ops
```

Verify expected home, shell, UID/GID, primary and supplementary groups, password state, aging limits, sudo rule, ownership, and permissions. Account and group databases persist across reboot, but an existing session may retain old group membership until re-login.

### Safety Notes
- Use `usermod -aG` to append supplementary groups without replacing existing ones.
- Do not delete a user or home directory until its files and services are reviewed.
- Keep a working privileged session while testing sudo changes.
- Protect `/etc/shadow`, sudoers files, and password data.
