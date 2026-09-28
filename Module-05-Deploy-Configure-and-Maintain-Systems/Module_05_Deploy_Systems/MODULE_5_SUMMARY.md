# RHCSA Module 5: Deploy, Configure, and Maintain Systems
## Module Summary

This module provides detailed notes, topic navigation, quick-reference commands, and labs for system configuration and maintenance.

## Objective Coverage
- Schedule tasks with `at`, cron, and systemd timers.
- Manage services and configure startup behavior.
- Set default systemd targets.
- Configure time synchronization clients.
- Install/update packages from configured sources.
- Modify bootloader defaults and kernel arguments.

## Files
- `../05_Deploy_Configure_Maintain_Lab_Notes.md`: Detailed concepts and procedures.
- `INDEX.md`: Topic map and learning paths.
- `Lab_Exercises.md`: Eight exercise sections, including an integration task.
- `Quick_Reference.txt`: Commands for configuration and maintenance.
- `Module_5_Status.txt`: Status checklist.

## RHEL 8/9 Accuracy and Safety
Use DNF tooling; automatic updates, when required by a task or policy, use `dnf-automatic`. Regenerate GRUB with `/boot/grub2/grub.cfg` on BIOS and UEFI RHEL 8/9; do not overwrite the EFI forwarding stub. Keep SELinux enabled unless a task explicitly requires permissive mode. Do not blindly delete temporary files or logs; follow systemd-tmpfiles and logrotate policy.
