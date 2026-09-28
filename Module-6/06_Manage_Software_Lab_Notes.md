# RHCSA Module 6: Manage Software
## Comprehensive Lab Notes & Reference Guide

This module covers repository configuration and RPM/Flatpak package operations. Shell scripting is covered separately in [Module 7](../Module-7/07_Create_Simple_Shell_Scripts_Lab_Notes.md). Package availability and repository names depend on the lab image and subscription; verify before installing.

## Contents
1. Repository and package concepts
2. DNF repository configuration
3. Installing and removing RPM packages
4. RPM queries and verification
5. Flatpak remotes and applications
6. Verification and persistence

## 1. Repository and Package Concepts

RPM is the package format and database used by RHEL-family systems. DNF resolves dependencies and installs packages from enabled repositories. A repository is a metadata-backed source of RPM packages. A system may use Red Hat Content Delivery Network (CDN), an organization mirror, local media, or a lab-provided repository. Do not invent repository URLs or credentials: use values supplied by the exam or lab.

```bash
cat /etc/os-release
sudo dnf repolist --enabled
sudo dnf repolist --all
sudo dnf info bash
```

RHEL registration and entitlement are normally managed with `subscription-manager`. Use it only when the environment provides valid entitlement:

```bash
sudo subscription-manager status
sudo subscription-manager repos --list
```

The presence or absence of a repo is not evidence that the host should be registered. In a controlled exam environment, repository configuration details will be provided.

## 2. DNF Repository Configuration

Repository definitions are usually `.repo` files under `/etc/yum.repos.d/`. A definition needs a unique section ID, human-readable name, and a valid `baseurl`, `metalink`, or `mirrorlist`.

```ini
[training]
name=Training Repository
baseurl=file:///srv/repos/training
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-training
```

Use the provided GPG key and correct repository path. Do not disable signature checking to work around a key problem. After editing, check DNF's view and metadata access:

```bash
sudo dnf clean all
sudo dnf makecache
sudo dnf repolist --enabled
sudo dnf --disablerepo='*' --enablerepo=training list available
```

To temporarily use a repo for one operation, use `--enablerepo`/`--disablerepo`; this does not persist configuration. To make a repo available after reboot, ensure its `.repo` file has `enabled=1` and valid access.

## 3. Installing and Removing RPM Packages

Use DNF for normal package operations because it resolves dependencies and updates the RPM database consistently.

```bash
sudo dnf install PACKAGE
sudo dnf remove PACKAGE
sudo dnf reinstall PACKAGE
sudo dnf update PACKAGE
sudo dnf check
rpm -q PACKAGE
```

Install a local RPM through DNF so dependencies can be resolved from configured repos:

```bash
sudo dnf install ./package-file.rpm
```

Preview transaction details and confirm the exact package name before accepting a transaction. Avoid `rpm -e --nodeps` and forced RPM installs; they can leave an inconsistent system. Package groups can be inspected and installed with `dnf group list` and `dnf group install`, when available.

## 4. RPM Queries and Verification

`rpm` is useful for querying the local package database and inspecting an RPM file. It does not resolve dependencies.

```bash
rpm -qa | sort
rpm -q bash
rpm -qi bash
rpm -ql bash
rpm -qf /bin/bash
rpm -q --whatprovides /usr/bin/bash
rpm -qp package-file.rpm
rpm -K package-file.rpm
rpm -V bash
```

`rpm -V` compares installed files to package metadata; output indicates differences, not automatically that a file is malicious. Read the verification symbols and investigate the named file. An empty result means no reported differences.

## 5. Flatpak Remotes and Applications

Flatpak applications come from configured remotes, commonly Flathub in a practice environment. Configure only the remote URL and trust details supplied for the lab. System-wide installs use `sudo`; `--user` installs belong to the current account.

```bash
flatpak remotes --show-details
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak search APP
flatpak install flathub APP_ID
flatpak list
flatpak info APP_ID
flatpak update APP_ID
flatpak uninstall APP_ID
flatpak remote-delete REMOTE
```

For offline or controlled environments, a remote may be provided as a `.flatpakrepo` file. Confirm whether the task asks for system-wide or per-user installation. Flatpak is separate from RPM/DNF and has its own app IDs and remotes.

## 6. Verification and Persistence

1. Identify whether the task asks for RPM/DNF or Flatpak.
2. Inspect enabled repos and package availability before installation.
3. Configure the persistent source before installing from it.
4. Verify package state with DNF and RPM queries.
5. Re-run queries to confirm package and repository state; package installs should be repeatable.
6. System repository definitions under `/etc/yum.repos.d/` persist across reboot. User Flatpak remotes and installs are scoped to that user; system installs/remotes are system-wide.

### Safety Notes
- Package removal can affect dependencies; practice only in a disposable VM and inspect DNF's proposed transaction.
- Use exact repository and GPG-key data provided by the task.
- Never assume a network connection or third-party repository is available.
