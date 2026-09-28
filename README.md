# RHCSA Exam Preparation Guide

A practical study guide for preparing for the Red Hat Certified System Administrator (RHCSA/EX200) exam. The repository organizes study notes, hands-on exercises, command references, and review checklists around ten Linux administration areas.

RHCSA is a performance-based exam: candidates must complete tasks on a live system. Use these materials to build command fluency and troubleshooting skills, then verify every task in a RHEL-compatible lab. Consult Red Hat's current exam page for the objectives, platform version, and exam policies that apply to your booking.

## Study Areas

| Module | Area | Main Topics |
|---|---|---|
| [1](Module-1/Module_01_Essential_Tools/INDEX.md) | Essential tools | Shell commands, redirection, grep/regex, SSH, archives, files, links, permissions, documentation |
| [2](Module-2/Module_02_Operating_Systems/INDEX.md) | Operate running systems | Boot and targets, recovery, processes, tuning, logs, services, secure transfer |
| [3](Module-3/INDEX.md) | Local storage | GPT partitions, LVM, persistent mounts, expansion, swap |
| [4](Module-4/Module_04_Filesystems/INDEX.md) | Filesystems | VFAT, ext4, XFS, NFS, autofs, filesystem growth, permissions |
| [5](Module-5/Module_05_Deploy_Systems/INDEX.md) | Deploy and maintain | Time, scheduling, services, targets, package maintenance, GRUB |
| [6](Module-6/Module_06_Manage_Software/INDEX.md) | Manage software | RPM repositories, DNF/RPM, Flatpak |
| [7](Module-7/Module_07_Create_Simple_Shell_Scripts/INDEX.md) | Shell scripts | Conditions, tests, loops, arguments, command output |
| [8](Module-8/Module_08_Manage_Basic_Networking/INDEX.md) | Networking | IPv4/IPv6, NetworkManager, name resolution, startup, firewalld |
| [9](Module-9/Module_09_Manage_Users_Groups/INDEX.md) | Users and groups | Local accounts, passwords, aging, groups, sudo |
| [10](Module-10/Module_10_Manage_Security/INDEX.md) | Security | Permissions, SSH keys, SELinux modes, labels, ports, booleans, firewall review |

Most modules include detailed notes, an index, exercises, and a quick reference. Module folders also contain summaries or status notes where available. Start from a module index to find its learning path and materials.

## How to Study

1. **Review the objective.** Be able to explain the requested end state before choosing commands.
2. **Read the notes.** Focus on command purpose, configuration files, and how to verify results.
3. **Practice in a disposable lab.** Type commands yourself; repeat tasks without copying examples.
4. **Verify the result.** Check active state and saved configuration. Reboot when appropriate to confirm persistence.
5. **Review mistakes.** Use the quick reference after practice, not instead of practice.
6. **Time yourself.** Combine related objectives into short, exam-style tasks and leave time to verify.

Use an isolated RHEL-compatible virtual machine with console access. Storage, bootloader, account, firewall, and SELinux changes can disrupt access or destroy data; do not practice destructive procedures on production systems. Use the device names, repository details, addresses, and task requirements provided by your lab.

## Exam Practice Checklist

- [ ] Complete representative tasks from all ten study areas without following a walkthrough.
- [ ] Verify changes with the relevant tools and configuration files.
- [ ] Confirm required settings survive reboot without manual repair.
- [ ] Check service state, mounts, package state, account access, network rules, and SELinux labels as applicable.
- [ ] Revisit tasks that failed or took too long, then repeat them from a clean starting state.

Persistence is essential: a correct runtime change that disappears after reboot may not satisfy a system-administration task. Distinguish temporary state from saved configuration, such as runtime versus permanent firewall rules or an active mount versus an `/etc/fstab` entry.

## Scope and References

This repository is an independent study aid, not official Red Hat training material. Its module grouping follows the study outline represented here; the official exam objectives and platform requirements can change. Compare your preparation against the current [Red Hat RHCSA exam information](https://www.redhat.com/en/services/training/ex200-red-hat-certified-system-administrator-rhcsa-exam) and consult system documentation with `man`, `info`, and installed package documentation.

Examples should be tested against the RHEL release used in your lab. When behavior differs by release, follow the exam environment and current Red Hat documentation. Never disable a security control or bypass a destructive-operation warning merely to make an example work.

## Repository

- [Module 1: Essential Tools](Module-1/Module_01_Essential_Tools/INDEX.md)
- [Module 2: Operate Running Systems](Module-2/Module_02_Operating_Systems/INDEX.md)
- [Module 3: Configure Local Storage](Module-3/INDEX.md)
- [Module 4: Create and Configure Filesystems](Module-4/Module_04_Filesystems/INDEX.md)
- [Module 5: Deploy, Configure, and Maintain Systems](Module-5/Module_05_Deploy_Systems/INDEX.md)
- [Module 6: Manage Software](Module-6/Module_06_Manage_Software/INDEX.md)
- [Module 7: Create Simple Shell Scripts](Module-7/Module_07_Create_Simple_Shell_Scripts/INDEX.md)
- [Module 8: Manage Basic Networking](Module-8/Module_08_Manage_Basic_Networking/INDEX.md)
- [Module 9: Manage Users and Groups](Module-9/Module_09_Manage_Users_Groups/INDEX.md)
- [Module 10: Manage Security](Module-10/Module_10_Manage_Security/INDEX.md)

Use the module guides, practice deliberately, and verify every required configuration after reboot.