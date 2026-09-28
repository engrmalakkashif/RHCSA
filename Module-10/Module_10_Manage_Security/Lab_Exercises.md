# Module 10 Lab Exercises: Manage Security

Use disposable VMs and noncritical accounts. Retain console access. Do not weaken system security or change authentication policy on a production system.

## Lab 1: umask and Default Permissions
1. Record the current `umask` and symbolic view.
2. Set `umask 027` in the current shell.
3. Create a file and directory; inspect their modes with `stat`.
4. Restore the original shell umask.
5. In a test account, configure the requested persistent user default and test a new login shell.

**Verify:** Existing files are unchanged; only newly created files/directories reflect the umask.

## Lab 2: SSH Key Authentication
1. As a non-root user, generate an Ed25519 key pair.
2. Install the public key on a lab account using `ssh-copy-id` or a safe manual append.
3. Check target ownership and `.ssh`/`authorized_keys` modes.
4. Open a second SSH session using the key and verify identity.
5. Keep the original session open until key login is confirmed.

**Verify:** Private key stays on the client and is not copied to the server.

## Lab 3: SELinux Mode
1. Record `getenforce` and `sestatus`.
2. Change to permissive mode at runtime with `setenforce 0`; verify.
3. Return to enforcing with `setenforce 1`.
4. In the lab VM only, set the requested persistent mode in `/etc/selinux/config`; inspect the line and reboot only when authorized.

**Verify:** Distinguish runtime mode from boot-time configuration; do not set disabled.

## Lab 4: Context Inspection and Restore
1. Inspect labels on files under `/var/www` or another supplied path with `ls -Z`.
2. In the VM, change a test file label with `chcon` to demonstrate a temporary change.
3. Use `restorecon -v` and verify policy-default label returns.
4. Inspect service process labels with `ps -eZ`.

**Verify:** `chcon` is temporary; `restorecon` applies policy defaults.

## Lab 5: Persistent File Context
1. Use the lab's specified alternate content path and SELinux type.
2. Add a regular-expression mapping with `semanage fcontext -a`.
3. Apply it using `restorecon -Rv`.
4. Inspect the stored rule and resulting labels.

**Verify:** The label can be restored from policy after relabel/restorecon; don't rely on chcon alone.

## Lab 6: SELinux Port Label
1. Inspect existing port mappings for the relevant service type.
2. Add the task-specified unused port with `semanage port -a` in the lab VM.
3. Verify the mapping and service configuration.
4. Remove only the test mapping after recording results.

**Verify:** Do not overwrite an existing port type without confirming the task requires it.

## Lab 7: Boolean Settings
1. Inspect the assigned boolean with `getsebool` and `semanage boolean -l`.
2. Toggle it at runtime and verify.
3. Set it persistently with `setsebool -P` only if required.
4. Verify after reboot if persistence is part of the exercise; restore the original state.

**Verify:** Runtime and persistent changes are distinct.

## Lab 8: Integrated Security Verification
Configure a requested umask, SSH key login, enforcing SELinux mode, file-context mapping, service port label, and boolean. Capture before/after state, test access in a new session, and reboot only when authorized. Confirm all required configuration persists without disabling SELinux or opening unrelated firewall access.
