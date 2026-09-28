# RHCSA Exam Preparation Guide

Study notes, practical exercises, command references, and review checklists for the Red Hat Certified System Administrator (RHCSA/EX200) exam. The guide is organized into ten modules and is intended to support hands-on practice, not replace the official exam objectives or product documentation.

## Exam Details

| Item | Information |
|---|---|
| Exam | EX200: Red Hat Certified System Administrator |
| Format | Performance-based, hands-on system administration tasks |
| Platform | Red Hat currently identifies RHEL 10 as the exam basis; confirm the version for your appointment |
| Duration | Check the appointment and delivery details supplied by Red Hat; timing can depend on the exam offering and accommodations |
| Price | Varies by country, currency, taxes, and delivery or training bundle. Check the [Red Hat exam page](https://www.redhat.com/en/services/training/ex200-red-hat-certified-system-administrator-rhcsa-exam) or local Red Hat store for current pricing |
| Preparation | Red Hat recommends RH124 and RH134, RH199, or comparable RHEL administration experience |

The exam is practical: candidates complete tasks on a system rather than answer a conventional multiple-choice test. Red Hat can update objectives, platform versions, policies, and prices, so verify current details when booking.

## Module Outlines

### Module 1: Understand and Use Essential Tools
- Shell command syntax, history, and navigation
- Standard input/output/error, redirection, pipes, grep, and regular expressions
- SSH access, user switching, and privilege escalation basics
- tar and compression tools; text editing and file operations
- Hard/symbolic links, ugo/rwx permissions, and system documentation
- [Open Module 1 study index](Module-1/Module_01_Essential_Tools/INDEX.md)

### Module 2: Operate Running Systems
- Normal boot, reboot, shutdown, systemd targets, and boot recovery
- Process inspection, termination, priorities, and tuning profiles
- System logs, journal queries, and persistent journals
- Service state and secure file transfer
- [Open Module 2 study index](Module-2/Module_02_Operating_Systems/INDEX.md)

### Module 3: Configure Local Storage
- GPT partition inspection and management
- LVM physical volumes, volume groups, and logical volumes
- Persistent mounts by UUID or label
- Non-destructive storage growth and swap configuration
- [Open Module 3 study index](Module-3/INDEX.md)

### Module 4: Create and Configure Filesystems
- Create, mount, unmount, and use VFAT, ext4, and XFS
- NFS client mounts and autofs
- Extend logical volumes and grow filesystems
- Diagnose and correct file permission problems
- [Open Module 4 study index](Module-4/Module_04_Filesystems/INDEX.md)

### Module 5: Deploy, Configure, and Maintain Systems
- System time, chrony, hostname, and NetworkManager configuration
- at, cron, and systemd timers
- Service startup, boot targets, and GRUB/kernel parameters
- Package maintenance and system updates
- [Open Module 5 study index](Module-5/Module_05_Deploy_Systems/INDEX.md)

### Module 6: Manage Software
- Configure RPM repository access and inspect repository metadata
- Install, remove, query, and verify RPM packages with DNF/RPM
- Configure Flatpak remotes and install/remove applications
- [Open Module 6 study index](Module-6/Module_06_Manage_Software/INDEX.md)

### Module 7: Create Simple Shell Scripts
- Create and execute Bash scripts
- Use conditions and tests (`if`, `test`, `[ ]`, `[[ ]]`)
- Loop over files and command-line input
- Process positional parameters and command output
- [Open Module 7 study index](Module-7/Module_07_Create_Simple_Shell_Scripts/INDEX.md)

### Module 8: Manage Basic Networking
- Configure persistent IPv4/IPv6 with NetworkManager
- Configure hostname resolution and network service startup
- Restrict access with firewalld and firewall-cmd
- [Open Module 8 study index](Module-8/Module_08_Manage_Basic_Networking/INDEX.md)

### Module 9: Manage Users and Groups
- Create, modify, and delete local accounts and groups
- Set passwords, aging, and account expiration
- Manage primary and supplementary group membership
- Configure and verify privileged access with sudo
- [Open Module 9 study index](Module-9/Module_09_Manage_Users_Groups/INDEX.md)

### Module 10: Manage Security
- Manage default permissions with umask and configure SSH key authentication
- Set SELinux enforcing/permissive modes and inspect contexts
- Restore file contexts; manage SELinux port labels and booleans
- Review firewall policy and verify security settings persist
- [Open Module 10 study index](Module-10/Module_10_Manage_Security/INDEX.md)

## Module Status Summary

| Module | Study materials | Main package contents |
|---|---|---|
| 1. Essential tools | Available | Notes, index, exercises, quick reference, summary |
| 2. Running systems | Available | Notes, index, exercises, quick reference, summary |
| 3. Local storage | Available | Notes, index, exercises, quick reference, summary |
| 4. Filesystems | Available | Notes, index, exercises, quick reference, summary |
| 5. Deploy and maintain | Available | Notes, index, exercises, quick reference, summary |
| 6. Software | Available | Notes, index, exercises, quick reference, summary |
| 7. Shell scripts | Available | Notes, index, exercises, quick reference, summary |
| 8. Networking | Available | Notes, index, exercises, quick reference, summary |
| 9. Users and groups | Available | Notes, index, exercises, quick reference, summary |
| 10. Security | Available | Notes, index, exercises, quick reference, summary |

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