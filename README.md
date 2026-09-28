# RHCSA Exam Preparation Guide

Study notes, practical exercises, command references, and review checklists for the Red Hat Certified System Administrator (RHCSA/EX200) exam. The guide is organized into ten modules and is intended to support hands-on practice, not replace the official exam objectives or product documentation.

## Exam Details

| Detail | Information |
|---|---|
| Exam | EX200: Red Hat Certified System Administrator |
| Format | Performance-based, hands-on system administration tasks |
| Platform | Red Hat currently identifies RHEL 10 as the exam basis; confirm the version for your appointment |
| Duration | Check your Red Hat appointment and delivery details; timing may vary by exam offering or accommodation |
| Price | Varies by country, currency, taxes, and delivery/training bundle. Check the [Red Hat exam page](https://www.redhat.com/en/services/training/ex200-red-hat-certified-system-administrator-rhcsa-exam) or local store for current pricing |
| Preparation | RH124 and RH134, RH199, or comparable RHEL administration experience |

The exam is practical: candidates complete tasks on a system rather than answer a conventional multiple-choice test. Red Hat can update objectives, platform versions, policies, and prices, so verify current details when booking.

## Module Outlines

| Module | Topic outline | Study index |
|---|---|---|
| 1. Essential Tools | Shell syntax and navigation; redirection and pipes; grep/regex; SSH and user switching; archives; text editing and file operations; links; permissions; system documentation | [Module 1](Module-01-Understand-and-Use-Essential-Tools/Module_01_Essential_Tools/INDEX.md) |
| 2. Operate Running Systems | Boot/shutdown and targets; recovery; process inspection, priorities, and tuning; logs and persistent journals; services; secure transfer | [Module 2](Module-02-Operate-Running-Systems/Module_02_Operating_Systems/INDEX.md) |
| 3. Local Storage | GPT partitions; LVM PV/VG/LV; persistent UUID/label mounts; non-destructive expansion; swap | [Module 3](Module-03-Configure-Local-Storage/INDEX.md) |
| 4. Filesystems | VFAT/ext4/XFS; mounts; NFS and autofs; LV/filesystem growth; permission troubleshooting | [Module 4](Module-04-Create-and-Configure-Filesystems/Module_04_Filesystems/INDEX.md) |
| 5. Deploy and Maintain | Time and hostname; NetworkManager; task scheduling; service startup; targets; package updates; GRUB/kernel settings | [Module 5](Module-05-Deploy-Configure-and-Maintain-Systems/Module_05_Deploy_Systems/INDEX.md) |
| 6. Software | RPM repositories; DNF/RPM install, removal, queries, verification; Flatpak remotes and applications | [Module 6](Module-06-Manage-Software/Module_06_Manage_Software/INDEX.md) |
| 7. Shell Scripts | Bash script creation; conditions and tests; loops; positional parameters; command output | [Module 7](Module-07-Create-Simple-Shell-Scripts/Module_07_Create_Simple_Shell_Scripts/INDEX.md) |
| 8. Networking | Persistent IPv4/IPv6; NetworkManager; hostname resolution; network service startup; firewalld | [Module 8](Module-08-Manage-Basic-Networking/Module_08_Manage_Basic_Networking/INDEX.md) |
| 9. Users and Groups | Local accounts; passwords and aging; groups and memberships; sudo privileges | [Module 9](Module-09-Manage-Users-and-Groups/Module_09_Manage_Users_Groups/INDEX.md) |
| 10. Security | umask; SSH keys; SELinux modes and contexts; restorecon; port labels; booleans; firewall review | [Module 10](Module-10-Manage-Security/Module_10_Manage_Security/INDEX.md) |

## Module Status Summary

| Modules | Status | Materials |
|---|---|---|
| 1–5 | Study packages available | Notes, index, exercises, and quick reference; summaries/status files where maintained |
| 6–10 | Study packages available | Notes, index, exercises, quick reference, summary, and status file |

“Available” means the study package exists in the repository; it is not a claim that every candidate has mastered the material or that Red Hat endorses this guide.

## How to Use This Guide

1. Review the relevant current exam objective and open the module index.
2. Read the notes, then perform the exercises in a disposable RHEL lab.
3. Use the quick reference to review commands after attempting tasks unaided.
4. Verify both active state and saved configuration; reboot when appropriate to test persistence.
5. Repeat missed tasks from a clean state and practice under time limits.

Configuration persistence matters. For example, distinguish a temporary mount from an `/etc/fstab` entry and runtime firewall changes from permanent rules. Use console access for recovery-prone tasks. Never practice destructive storage, boot, or account operations on production systems.

## ⚠️ Disclaimer

This is an independent educational resource, not official Red Hat training or exam content. Red Hat, Inc. does not endorse this guide. Objectives, commands, and behavior may differ by RHEL release and exam environment. Follow the instructions and permitted documentation available during your exam, and use the current official Red Hat objectives as the source of truth. Practice commands only on systems you own or are authorized to administer; protect data and retain a recovery path when changing storage, boot, security, or network settings.