# RHCSA Module 3: Configure Local Storage
## Module Summary

This module provides a detailed reference, guided exercises, an index, and quick-reference commands for local partitions, LVM, persistent mounts, storage growth, and swap.

## Objective Coverage
- List, create, and delete GPT partitions.
- Create/remove physical volumes and assign PVs to volume groups.
- Create/delete logical volumes.
- Configure persistent mounts by UUID or label.
- Add storage and swap non-destructively.
- Extend logical volumes and the corresponding filesystems.

## Files
- `03_Configure_Local_Storage_Lab_Notes.md`: Topic explanations and workflows.
- `INDEX.md`: Navigation and learning paths.
- `Lab_Exercises.md`: Progressive storage exercises and verification.
- `Quick_Reference.txt`: Common LVM, partition, mount, and swap commands.
- `MODULE_3_DELIVERY_REPORT.txt`: Current file inventory and scope.
- `Module_3_Status.txt`: Status checklist.

## Safety and Verification
Use only a specifically identified disposable disk for partition-table changes. Inspect devices with `lsblk -f`, `fdisk -l`, and `wipefs -n` before modifying them. Never use `pvremove`, `vgremove`, or `lvremove` as generic troubleshooting; verify the PV/VG/LV is unused and contains no needed data first. Validate `/etc/fstab` with `mount -a` before rebooting.
