# RHCSA Module 2: Operate Running Systems
## Module Summary

This module provides notes, a quick reference, an index, and nine lab sections for operating and recovering a RHEL-family system.

## Objective Coverage
- Normal boot, reboot, and shutdown.
- Boot targets and manual target changes.
- GRUB boot interruption and root-password recovery, including SELinux relabeling.
- Process inspection, termination, priorities, and tuning profiles.
- System logs and persistent journals.
- Service management and secure file transfer.

## Files
- `02_Operate_Running_Systems_Lab_Notes.md`: Detailed explanations and examples.
- `Module_02_Operating_Systems/INDEX.md`: Navigation and study paths.
- `Module_02_Operating_Systems/Lab_Exercises.md`: Nine labs.
- `Module_02_Operating_Systems/Quick_Reference.txt`: Command reference.
- `COMPLETION_REPORT.md`: Deliverables and cautions.

## Safety and Verification
The boot-interruption lab is for a disposable VM with console access. Preserve SELinux and create `/.autorelabel` after a password reset. Do not use forceful process termination or alter boot configuration without a recovery path. Verify service and journal state with `systemctl` and `journalctl`.
