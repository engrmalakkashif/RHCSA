# RHCSA Module 10: Manage Security
## Comprehensive Lab Notes & Reference Guide

This module covers default permissions, SSH key authentication, SELinux modes and contexts, file-context restoration, port labels, and SELinux booleans. Keep SELinux enforcing unless the task explicitly asks for permissive mode. Perform access-control changes in a disposable VM and retain console access.

## Contents
1. Default file permissions and umask
2. SSH key-based authentication
3. SELinux modes and status
4. File and process contexts
5. Restore and define file contexts
6. SELinux port labels
7. SELinux booleans
8. Firewall configuration review
9. Verification and persistence

## 1. Default File Permissions and umask

The umask removes permission bits from a program's requested defaults. Typical base modes are `666` for files and `777` for directories; the umask commonly removes write access for group/other. A umask of `027` commonly yields files `640` and directories `750`.

```bash
umask
umask -S
umask 027
```

A shell's `umask` change affects that shell and its child processes. For persistent user defaults, the appropriate shell profile/startup file depends on login type and distribution policy. Apply values only in the scope requested; do not change a system-wide profile casually. Existing file permissions do not change when the umask changes. Use `chmod` for existing objects.

## 2. SSH Key-Based Authentication

Generate a key pair as the login user, protect the private key, and install only the public key on the destination account:

```bash
ssh-keygen -t ed25519 -C "user@host"
ssh-copy-id USER@HOST
ssh USER@HOST
```

If `ssh-copy-id` is unavailable, append the public key to `~/.ssh/authorized_keys` on the target without altering other keys. On the target, ownership and restrictive permissions matter:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
chown -R USER:USER ~/.ssh
```

Never copy or transmit the private key. Test a new key in a second session before changing server authentication policy or closing the working session. Do not disable password authentication unless explicitly directed and key access has been verified.

## 3. SELinux Modes and Status

SELinux modes are enforcing, permissive, and disabled. `setenforce` changes runtime mode between enforcing and permissive; it cannot enable SELinux if booted disabled. Persistent mode is configured in `/etc/selinux/config` and takes effect at boot.

```bash
getenforce
sestatus
sudo setenforce 0                 # Runtime permissive (temporary)
sudo setenforce 1                 # Runtime enforcing
```

For persistent configuration, set `SELINUX=enforcing` or (only if task-requested) `SELINUX=permissive` in `/etc/selinux/config`, then reboot when safe. Disabled is not equivalent to permissive: disabled SELinux does not maintain normal enforcing policy state. Security context relabeling may be required when re-enabling a disabled system.

## 4. File and Process Contexts

SELinux labels typically contain user, role, type, and level. The type is often the key element for service access. Inspect files and processes:

```bash
ls -Z /path
ps -eZ | grep SERVICE
id -Z
```

Do not use `chcon` as a permanent fix: its change can be overwritten by relabeling or `restorecon`. Diagnose denials using the relevant audit logs and correct the context or policy rather than disabling SELinux.

## 5. Restore and Define File Contexts

`restorecon` restores the policy-default label for a path. Use recursive mode when the task applies to a tree:

```bash
sudo restorecon -v /path/file
sudo restorecon -Rv /path/directory
```

For a durable non-default path label, define a file-context rule with `semanage fcontext`, then apply it using `restorecon`:

```bash
sudo semanage fcontext -a -t httpd_sys_content_t '/srv/site(/.*)?'
sudo restorecon -Rv /srv/site
semanage fcontext -l | grep '/srv/site'
```

Use the type appropriate for the service and task. If `semanage` is unavailable, the package providing it may need to be installed from configured repos (commonly `policycoreutils-python-utils` on RHEL-family releases).

## 6. SELinux Port Labels

SELinux port types govern which labeled services can bind to port numbers. Inspect before changing:

```bash
sudo semanage port -l | grep http
sudo semanage port -l -C
```

Add a port mapping only when the policy and task require it:

```bash
sudo semanage port -a -t http_port_t -p tcp 8080
```

If the port already has a different mapping, inspect it before using `-m` to modify. Do not remove or relabel shared ports without understanding the impact. Verify with `semanage port -l` and the service's own configuration.

## 7. SELinux Booleans

Booleans toggle policy features. Inspect the exact boolean before changing it:

```bash
getsebool -a
getsebool httpd_can_network_connect
sudo setsebool httpd_can_network_connect on
sudo setsebool -P httpd_can_network_connect on
```

Without `-P`, a boolean change is runtime-only. `-P` persists the setting across reboot. Enable only the narrowly requested boolean; do not turn on broad access as a troubleshooting shortcut.

## 8. Firewall Configuration Review

Firewall access is part of both network administration and host security. Module 8 provides the complete firewalld workflow; for security tasks, inspect the active zone and allow only the explicitly required service or port:

```bash
sudo firewall-cmd --state
sudo firewall-cmd --get-active-zones
sudo firewall-cmd --zone=ZONE --list-all
sudo firewall-cmd --permanent --zone=ZONE --add-service=SERVICE
sudo firewall-cmd --reload
sudo firewall-cmd --zone=ZONE --list-all
```

Verify the permanent and runtime rules, and remove access that is no longer required. Do not disable firewalld or open broad port ranges as a troubleshooting shortcut.

## 9. Verification and Persistence

After every security change, verify both effective state and saved policy:

```bash
getenforce
sestatus
ls -Z /path
getsebool -a
sudo semanage fcontext -l -C
sudo semanage port -l -C
umask
```

Verify SSH key login in a new session. Verify persistent SELinux mode in `/etc/selinux/config`, persistent file-context rules with `semanage fcontext`, port mappings with `semanage port`, and persistent booleans with `getsebool` after reboot.

### Safety Notes
- Do not disable SELinux to resolve a denial; inspect and correct the label, boolean, port type, or policy.
- Do not expose private SSH keys or remove working access before testing a new key.
- Firewall service/port rules are covered in Module 8; use least privilege and verify persistence there.
