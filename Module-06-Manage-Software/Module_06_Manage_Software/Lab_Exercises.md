# Module 6 Lab Exercises: Manage Software

Use a disposable RHEL-compatible VM. Repository URLs, GPG keys, Flatpak app IDs, and entitlements must come from the lab environment. Do not add an untrusted repo or disable package signature checks.

## Lab 1: Inspect Package Sources
**Objective:** Identify enabled repositories and package availability.

1. Record the OS release with `cat /etc/os-release`.
2. List enabled and all repositories with `dnf repolist`.
3. Search for a harmless installed or available package such as `bash`.
4. Inspect its metadata with `dnf info` and `rpm -qi`.
5. Record the repository that provides it, if shown.

**Verify:** You can distinguish installed packages (`rpm -q`) from packages available from enabled repos (`dnf list`).

## Lab 2: Configure a Task-Provided Local Repository
**Objective:** Create a persistent repository entry from supplied values.

1. In a lab VM, use the repository path and GPG key supplied by your instructor or provisioned lab. Do not use guessed paths.
2. Create `/etc/yum.repos.d/training.repo` with a unique ID, name, `baseurl`, `enabled=1`, `gpgcheck=1`, and the provided `gpgkey`.
3. Refresh metadata with `dnf clean all` and `dnf makecache`.
4. Query only that repo with `dnf --disablerepo='*' --enablerepo=training list available`.
5. Check the repo after a reboot or a fresh shell; do not remove existing repo files.

**Verify:** `dnf repolist --enabled` shows the repo and metadata can be read without signature bypasses.

## Lab 3: RPM Install, Query, Verify, and Remove
**Objective:** Use DNF and RPM safely.

1. Choose an approved small package available in the configured repo.
2. Preview details with `dnf info PACKAGE`; install with `sudo dnf install PACKAGE`.
3. Verify with `rpm -q`, `rpm -qi`, `rpm -ql`, and `rpm -V`.
4. Find which package owns a file using `rpm -qf /path/to/file`.
5. Remove only the package you installed with `sudo dnf remove PACKAGE` and verify its state.

**Verify:** DNF handles dependencies; no `--nodeps` or force options are used.

## Lab 4: Flatpak Application Lifecycle
**Objective:** Manage a Flatpak remote and application at the requested scope.

1. Check whether Flatpak is installed and list configured remotes.
2. Use the approved lab remote (or provided `.flatpakrepo` file); inspect its details.
3. Search for the assigned app ID; install it as either the current user or system-wide as directed.
4. Verify with `flatpak list` and `flatpak info APP_ID`.
5. Update and then uninstall the assigned app. Remove a remote only if this lab added it and no other app depends on it.

**Verify:** You can state the difference between a user and system installation.

## Lab 5: Persistence and Scope Review
**Objective:** Verify repositories, RPMs, and Flatpaks at their correct scope.

1. Confirm the repository from Lab 2 remains enabled after a fresh login or authorized reboot.
2. Verify the package installed in Lab 3 remains installed with `rpm -q`.
3. Verify the Flatpak from Lab 4 with `flatpak list`, checking whether it was installed per-user or system-wide.
4. Remove only the exercise package/application and repo entry if the lab instructions require cleanup.

**Verify:** Repository configuration, RPM package state, and Flatpak scope are independent; do not confuse their persistence mechanisms.
