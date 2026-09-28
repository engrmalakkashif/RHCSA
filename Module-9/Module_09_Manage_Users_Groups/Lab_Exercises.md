# Module 9 Lab Exercises: Manage Users and Groups

Use a disposable VM. Use a dedicated practice account and never alter the account you need to administer the VM.

## Lab 1: Inspect Identity and Defaults
1. Inspect `useradd -D`, `getent passwd`, `getent group`, and `id` for existing lab accounts.
2. Identify the primary group, supplementary groups, home directory, and login shell.
3. Inspect password aging with `chage -l USER`.

**Verify:** Explain which files store local account/group data and why commands are safer than direct edits.

## Lab 2: Create a Local User
1. Create `labuser` with a home directory and the task-specified shell.
2. Set its password interactively.
3. Verify identity, home ownership, shell, and password status.
4. Change the comment field and verify it.

**Verify:** `getent passwd labuser`, `id labuser`, and `stat` on the home directory show the requested state.

## Lab 3: Password Aging and Expiration
1. Set minimum, maximum, and warning days to the assigned values with `chage`.
2. Set an account expiration date in the disposable lab.
3. Review with `chage -l` and `passwd -S`.
4. Restore a non-expired state after the exercise if you need the account again.

**Verify:** Distinguish account expiration from password expiration/inactivity.

## Lab 4: Groups and Membership
1. Create `projecta` and `audit` groups.
2. Set one group as `labuser`'s primary group if required.
3. Append `audit` as a supplementary group using `usermod -aG`.
4. Add another test user to `projecta`; inspect results with `id` and `getent group`.
5. Remove only the intended supplementary membership.

**Verify:** Existing supplementary groups remain present after additions.

## Lab 5: Configure sudo Safely
1. Create an `ops` group and a dedicated test user.
2. Add the user to `ops` or create a sudoers drop-in granting the assigned access.
3. Use `visudo -f /etc/sudoers.d/ops` to create the rule, then verify root ownership and mode `0440`.
4. Run `visudo -c` and test `sudo -l -U USER`.
5. Test an actual sudo command from a separate login session before closing the admin session.

**Verify:** Do not grant passwordless access unless explicitly requested.

## Lab 6: Safe Account Removal
1. Inspect the user's processes, home directory, and owned files.
2. Remove a practice account without `-r`, then verify the account is gone and home data remains.
3. In a separate disposable test, use `userdel -r` only after confirming the home directory contains no needed data.

**Verify:** Describe exactly which data was removed or retained.

## Lab 7: Integrated Account Task
Create a task-specified user, group, password policy, supplementary membership, and sudo access. Verify all settings using `id`, `getent`, `chage`, `passwd -S`, and `visudo -c`. Start a fresh login session to test group membership.
