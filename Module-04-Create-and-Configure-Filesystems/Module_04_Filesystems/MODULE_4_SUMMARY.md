# RHCSA Module 4: Create and Configure Filesystems
## Module Summary

This module contains detailed notes, a navigation index, quick-reference commands, and guided labs for local and network filesystems.

## Objective Coverage
- Create, mount, unmount, and use VFAT, ext4, and XFS filesystems.
- Mount/unmount NFS shares and configure autofs.
- Extend logical volumes and grow their filesystems.
- Diagnose and correct filesystem permission problems.

## Files
- `../04_Create_Configure_Filesystems_Lab_Notes.md`: Filesystem concepts, mounting, NFS, autofs, and growth.
- `INDEX.md`: Topic navigation and study schedules.
- `Lab_Exercises.md`: Guided filesystem exercises.
- `Quick_Reference.txt`: Commands for creation, mounting, NFS/autofs, and growth.
- `NFS Server and Autofs Client — Complete Step-by-Step Lab Guide.md`: Supplementary server/client walkthrough.
- `Module_4_Status.txt`: Status checklist.

## Safety and Verification
Formatting overwrites filesystem data; verify the target device and use force options only when explicitly required on disposable media. NFS exports should default to `root_squash`; avoid world-writable directories and `no_root_squash` outside a deliberately isolated lab. Verify mounts with `findmnt`, `df -T`, and `mount -a` before rebooting.
