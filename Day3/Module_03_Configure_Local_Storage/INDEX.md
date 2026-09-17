# RHCSA Module 3: Configure Local Storage
## Complete Navigation & Study Guide

---

## Quick Navigation

### By Learning Path
- **[Beginner Path](#beginner-learning-path)** - Start here if new to storage/LVM
- **[Intermediate Path](#intermediate-learning-path)** - For experienced users
- **[Advanced Path](#advanced-learning-path)** - Exam-focused speed learning

### By File Type
- **[Lab Notes](03_Configure_Local_Storage_Lab_Notes.md)** - Detailed explanations with commands
- **[Quick Reference](Quick_Reference.txt)** - Command cheat sheet
- **[Lab Exercises](Lab_Exercises.md)** - Hands-on practice

### By Topic
1. [Disk Partitioning (GPT)](#topic-1-disk-partitioning)
2. [Physical Volumes](#topic-2-physical-volumes)
3. [Volume Groups](#topic-3-volume-groups)
4. [Logical Volumes](#topic-4-logical-volumes)
5. [Mounting Systems](#topic-5-mounting-systems)
6. [Non-Destructive Expansion](#topic-6-non-destructive-expansion)
7. [Swap Management](#topic-7-swap-management)

---

## Study Schedules

### Beginner Learning Path
**Duration:** 8-10 hours over 2-3 days

**Day 1 (3-4 hours):**
1. Read Lab Notes: Partitioning section (30 min)
2. Read Lab Notes: Physical Volumes section (30 min)
3. Lab Exercise 1: Disk Partitioning (1-2 hours)
4. Lab Exercise 2: Create PVs (1 hour)

**Day 2 (3-4 hours):**
1. Read Lab Notes: Volume Groups section (30 min)
2. Lab Exercise 3: VG Creation (1-2 hours)
3. Read Quick Reference (30 min)
4. Review and practice basics (1 hour)

**Day 3 (2-3 hours):**
1. Read Lab Notes: LV section (1 hour)
2. Lab Exercise 4: Create LVs (1-2 hours)

**Day 4 (2-3 hours):**
1. Read Lab Notes: Mounting section (1 hour)
2. Lab Exercise 5: Mounting with UUIDs (1-2 hours)

### Intermediate Learning Path
**Duration:** 5-6 hours over 1-2 days

**Day 1 (3-4 hours):**
1. Skim Lab Notes (all sections) (30 min)
2. Lab Exercise 3: VG Creation (30 min)
3. Lab Exercise 4: LV Management (1 hour)
4. Lab Exercise 5: Mounting (1 hour)
5. Lab Exercise 6: Expansion (30-45 min)

**Day 2 (2-3 hours):**
1. Lab Exercise 7: Swap (1 hour)
2. Review Quick Reference (30 min)
3. Practice commands (30-60 min)

### Advanced Learning Path (Exam Focused)
**Duration:** 2-3 hours

**Hour 1:**
1. Scan Lab Notes topics
2. Review Quick Reference commands
3. Focus on: pvmove, lvextend, resize2fs, xfs_growfs

**Hour 2:**
1. Lab Exercise 6: Non-Destructive Expansion (focus)
2. Lab Exercise 8: Integration Lab (partial)

**Hour 3:**
1. Lab Exercise 8: Complete Integration Lab
2. Practice failure scenarios and recovery

---

## Topic Deep Dives

### Topic 1: Disk Partitioning

**Key Concepts:**
- GPT vs MBR (GPT for RHCSA)
- Partition tables and partition entries
- Physical extents and sectors

**Essential Commands:**
```bash
lsblk                          # View block devices
sudo fdisk -l                  # List disks
sudo fdisk /dev/sda            # Interactive partitioning
sudo parted /dev/sda           # Advanced partitioning
sudo partprobe /dev/sda        # Notify kernel
```

**Exam Objectives:**
- List partitions on disks ✓
- Create partitions (using fdisk or parted) ✓
- Delete partitions ✓
- Verify GPT partition table ✓

**Practice:**
- [Lab Exercise 1](Lab_Exercises.md#lab-exercise-1-disk-partitioning-with-gpt)
- [Lab Notes - Partitioning](03_Configure_Local_Storage_Lab_Notes.md#list-create-and-delete-partitions-on-gpt-disks)

**Common Mistakes:**
- Using MBR instead of GPT (use `g` in fdisk for GPT)
- Forgetting to run `partprobe` after creating partitions
- Not backing up important data before partitioning

---

### Topic 2: Physical Volumes

**Key Concepts:**
- PV as LVM building block
- Physical extents (PE) allocation
- PV metadata and labels

**Essential Commands:**
```bash
sudo pvcreate /dev/sda3        # Create PV
sudo pvs                       # List PVs
sudo pvdisplay                 # Detailed info
sudo pvmove /dev/sda3          # Move data
sudo pvremove /dev/sda3        # Remove PV
```

**Exam Objectives:**
- Create physical volumes ✓
- Remove physical volumes ✓
- View PV information ✓
- Understand PV in LVM hierarchy ✓

**Practice:**
- [Lab Exercise 2](Lab_Exercises.md#lab-exercise-2-create-physical-volumes)
- [Lab Notes - PV](03_Configure_Local_Storage_Lab_Notes.md#create-and-remove-physical-volumes)

**Common Mistakes:**
- Creating PV on unpartitioned disk (should partition first)
- Not using pvmove before removing PV with data
- Confusing PV with partition

---

### Topic 3: Volume Groups

**Key Concepts:**
- VG as pool of PVs
- Extent size (affects allocation granularity)
- VG expansion and reduction

**Essential Commands:**
```bash
sudo vgcreate vg_name /dev/sda3            # Create VG
sudo vgs                                   # List VGs
sudo vgdisplay                            # Detailed info
sudo vgextend vg_name /dev/sdb1           # Add PV
sudo vgreduce vg_name /dev/sdb1           # Remove PV
sudo vgremove vg_name                     # Remove VG
```

**Exam Objectives:**
- Create volume groups ✓
- Assign PVs to VGs ✓
- Extend VGs with new PVs ✓
- Remove VGs ✓

**Practice:**
- [Lab Exercise 3](Lab_Exercises.md#lab-exercise-3-create-and-extend-volume-groups)
- [Lab Notes - VG](03_Configure_Local_Storage_Lab_Notes.md#assign-physical-volumes-to-volume-groups)

**Common Mistakes:**
- Creating VG without verifying PV exists
- Reducing VG without moving data first
- Not understanding that free space must exist for reduction

---

### Topic 4: Logical Volumes

**Key Concepts:**
- LV as virtual partition
- LV sizing (fixed, percentage-based, or extent-based)
- LV expansion and reduction (with risks)

**Essential Commands:**
```bash
sudo lvcreate -L 20G -n lv_name vg_name   # Create LV
sudo lvs                                  # List LVs
sudo lvdisplay                           # Detailed info
sudo lvextend -L +10G /dev/vg/lv         # Grow LV
sudo lvreduce -L 10G /dev/vg/lv          # Shrink LV
sudo lvremove /dev/vg/lv                 # Delete LV
```

**Exam Objectives:**
- Create logical volumes ✓
- Delete logical volumes ✓
- Extend logical volumes ✓
- Understand LV filesystem relationship ✓

**Practice:**
- [Lab Exercise 4](Lab_Exercises.md#lab-exercise-4-create-and-manage-logical-volumes)
- [Lab Notes - LV](03_Configure_Local_Storage_Lab_Notes.md#create-and-delete-logical-volumes)

**Common Mistakes:**
- Extending LV without extending filesystem (lvextend alone insufficient)
- Trying to shrink XFS (impossible - ext4 only)
- Not backing up before shrinking LV

---

### Topic 5: Mounting Systems

**Key Concepts:**
- UUID vs device names (UUID is reliable)
- Labels for easy reference
- /etc/fstab for persistent mounts
- Mount options (defaults, nofail, etc.)

**Essential Commands:**
```bash
sudo blkid                                # Show UUIDs
lsblk -f                                 # Show filesystems
sudo e2label /dev/sda1 label             # Set label (ext4)
sudo xfs_admin -L label /dev/sda2        # Set label (xfs)
sudo mount UUID=xyz /mount/point         # Mount by UUID
sudo mount LABEL=xyz /mount/point        # Mount by label
sudo mount -a                            # Test /etc/fstab
```

**Exam Objectives:**
- Configure mounts with UUID ✓
- Configure mounts with labels ✓
- Add entries to /etc/fstab ✓
- Test mount configuration ✓

**Practice:**
- [Lab Exercise 5](Lab_Exercises.md#lab-exercise-5-create-filesystems-and-mount-by-uuid)
- [Lab Notes - Mounting](03_Configure_Local_Storage_Lab_Notes.md#configure-mount-points-with-uuidlabel)

**fstab Format:**
```
UUID=abc123 /mount/point ext4 defaults,nofail 0 2
LABEL=data /mount/point ext4 defaults 0 2
/dev/vg/lv /mount/point ext4 defaults 0 2

# Columns: Device UUID/Label/Path | MountPoint | FSType | Options | Dump | Pass
```

**Common Mistakes:**
- Using device names instead of UUIDs (devices can change)
- Forgetting to test fstab before rebooting
- Setting wrong mount options (ro vs rw, nofail needed for non-critical)
- Not creating mount point directory first

---

### Topic 6: Non-Destructive Expansion

**Key Concepts:**
- Adding storage without downtime
- Expanding VG with new disk
- Expanding LV and filesystem
- pvmove for data migration

**Workflow:**
1. Add new disk/partition
2. Create PV
3. Extend VG
4. Extend LV
5. Extend filesystem (resize2fs or xfs_growfs)
6. Verify with df -h

**Essential Commands:**
```bash
sudo vgextend vg_name /dev/new_pv        # Extend VG
sudo lvextend -L +20G /dev/vg/lv         # Grow LV
sudo resize2fs /dev/vg/lv                # Extend ext4 fs
sudo xfs_growfs /mount/point             # Extend xfs fs
sudo pvmove /dev/sda3 /dev/sdb1          # Migrate data
```

**Exam Objectives:**
- Add new partitions non-destructively ✓
- Add new LVs non-destructively ✓
- Add new swap non-destructively ✓
- Extend existing filesystems ✓

**Practice:**
- [Lab Exercise 6](Lab_Exercises.md#lab-exercise-6-non-destructive-storage-expansion)
- [Lab Notes - Expansion](03_Configure_Local_Storage_Lab_Notes.md#add-new-storage-non-destructively)

**Critical Points:**
- XFS can only grow, NOT shrink (ext4 can shrink)
- Always extend filesystem AFTER extending LV
- Verify free space in VG before extending LV
- Use nofail in fstab for non-critical filesystems

---

### Topic 7: Swap Management

**Key Concepts:**
- Swap as virtual memory
- Swap on partition vs file vs LV
- Swap sizing guidelines
- Swap priority

**Sizing Guidelines:**
```
< 2GB RAM:   2 x RAM
2-8GB RAM:   1-1.5 x RAM
> 8GB RAM:   0.5 x RAM (may not be needed)
```

**Essential Commands:**
```bash
sudo mkswap /dev/sda3                    # Create swap
sudo swapon /dev/sda3                    # Enable swap
sudo swapoff /dev/sda3                   # Disable swap
swapon -s                                # Show active swap
free -h                                  # Show swap usage
sudo swapon -p 100 /dev/sda3            # Set priority
```

**Exam Objectives:**
- Create swap space ✓
- Enable/disable swap ✓
- Make swap persistent (/etc/fstab) ✓
- Understand swap sizing ✓

**Practice:**
- [Lab Exercise 7](Lab_Exercises.md#lab-exercise-7-swap-space-creation-and-management)
- [Lab Notes - Swap](03_Configure_Local_Storage_Lab_Notes.md#swap-space-management)

**Common Mistakes:**
- Creating swap on ext4 filesystem (use partition or LV)
- Not setting permissions correctly (should be 600)
- Forgetting to add to /etc/fstab
- Wrong swap sizing for system

---

## Key Concepts Tier List

### Tier 1 (Must Know - Exam Critical)
1. GPT partitioning with fdisk
2. LVM hierarchy: PV → VG → LV
3. Creating PVs and VGs
4. Creating and extending LVs
5. Mounting with UUID (not device names)
6. Adding /etc/fstab entries
7. Swap creation and enabling
8. Using mount -a to test fstab

### Tier 2 (Important - Exam Likely)
1. Extending VG with new PVs
2. Extending filesystem (resize2fs)
3. XFS vs ext4 differences
4. Labels vs UUIDs
5. pvmove for data migration
6. fstab options (defaults, nofail, ro, acl)
7. Swap on LV vs partition
8. Checking swap with free and swapon

### Tier 3 (Good to Know - Exam Possible)
1. Reducing LV (and risks)
2. xfs_growfs vs resize2fs
3. PE (physical extent) size
4. vgremove and lvremove
5. Extent-based LV sizing
6. Striped/mirrored LVs
7. Filesystem checking (e2fsck, xfs_repair)
8. Swap priority

### Tier 4 (Advanced - Exam Unlikely)
1. Advanced parted features
2. fdisk partition types
3. LVM snapshots
4. thin provisioning
5. Striping across multiple PVs
6. Advanced mirroring
7. LVM cache
8. VG metadata backup/restore

---

## Pre-Exam Checklist

### Knowledge Verification
- [ ] Understand MBR vs GPT
- [ ] Know fdisk commands: g, n, d, p, w, q
- [ ] Know LVM commands: pvcreate, vgcreate, lvcreate
- [ ] Know mounting: UUID, label, fstab
- [ ] Know expansion: vgextend, lvextend, resize2fs
- [ ] Know swap: mkswap, swapon, swapoff
- [ ] Understand non-destructive expansion workflow
- [ ] Know fstab format and options

### Hands-On Skills Verification
- [ ] Can partition disk with fdisk (all steps)
- [ ] Can create PV, VG, LV from scratch
- [ ] Can extend VG with new disk
- [ ] Can extend LV and filesystem
- [ ] Can mount by UUID with fstab
- [ ] Can create and enable swap
- [ ] Can verify configuration with mount -a
- [ ] Can troubleshoot mount failures

### Command Mastery
```bash
# Quick verification - can you explain these?
lsblk -f
sudo pvs -o +pv_used,pv_free
sudo vgdisplay -m
sudo lvs -o +devices
sudo blkid -s UUID -o value /dev/vg/lv
sudo e2label /dev/vg/lv label
sudo mount -a
free -h
swapon -s
```

### Real-World Scenarios
- [ ] Can add 50GB to full /home without unmounting
- [ ] Can migrate data from failing disk
- [ ] Can set up new system storage from scratch
- [ ] Can troubleshoot boot failures due to fstab
- [ ] Can identify and fix UUID mismatch issues

---

## Practice Scenarios

### Scenario 1: Emergency Expansion
**Situation:** /home is 95% full, users complaining
**Requirements:** Add space without downtime
**Steps:** vgextend → lvextend → resize2fs → verify

### Scenario 2: Failed Disk Replacement
**Situation:** /dev/sdb1 (in LV) is failing, new disk available
**Requirements:** Move data and replace disk
**Steps:** pvmove → vgreduce → pvremove → new disk → pvcreate → vgextend

### Scenario 3: New Server Storage
**Situation:** 3x 100GB disks to set up storage
**Requirements:** Organize with partitions, LVM, multiple filesystems
**Steps:** partition → pvcreate → vgcreate → lvcreate → mkfs → mount → fstab

### Scenario 4: Boot Recovery
**Situation:** Server won't boot, /etc/fstab has wrong UUID
**Requirements:** Boot into rescue, fix fstab, reboot
**Steps:** Boot into recovery → get correct UUID → update fstab → reboot

---

## Quick Reference by Task

### "I need to partition a new disk"
→ [Partitioning Section](03_Configure_Local_Storage_Lab_Notes.md#list-create-and-delete-partitions-on-gpt-disks)
→ [Lab Exercise 1](Lab_Exercises.md#lab-exercise-1-disk-partitioning-with-gpt)
→ Quick Ref: fdisk, parted, partprobe

### "I need to expand /var with more space"
→ [Expansion Section](03_Configure_Local_Storage_Lab_Notes.md#add-new-storage-non-destructively)
→ [Lab Exercise 6](Lab_Exercises.md#lab-exercise-6-non-destructive-storage-expansion)
→ Commands: vgextend, lvextend, resize2fs

### "I need to set up new filesystems with UUIDs"
→ [Mounting Section](03_Configure_Local_Storage_Lab_Notes.md#configure-mount-points-with-uuidlabel)
→ [Lab Exercise 5](Lab_Exercises.md#lab-exercise-5-create-filesystems-and-mount-by-uuid)
→ Commands: mkfs, blkid, mount, /etc/fstab

### "I need to create swap space"
→ [Swap Section](03_Configure_Local_Storage_Lab_Notes.md#swap-space-management)
→ [Lab Exercise 7](Lab_Exercises.md#lab-exercise-7-swap-space-creation-and-management)
→ Commands: mkswap, swapon, free, swapon -s

### "I need to troubleshoot a mount failure"
→ Quick Ref: Troubleshooting section
→ Commands: blkid, mount -a, mount, dmesg, e2fsck

---

## Time Allocation Guide

### Total Study Time Estimate: 12-15 hours

**By Activity:**
- Reading Lab Notes: 3-4 hours
- Hands-on Lab Exercises: 6-8 hours
- Quick Reference review: 1-2 hours
- Practice scenarios: 2-3 hours

**By Topic:**
- Partitioning: 1-2 hours
- Physical Volumes: 1-2 hours
- Volume Groups: 1-2 hours
- Logical Volumes: 2-3 hours
- Mounting: 2-3 hours
- Expansion: 2-3 hours
- Swap: 1-2 hours

---

## Additional Resources

### In This Module
- **Lab Notes**: Detailed explanations with command examples
- **Quick Reference**: Command cheat sheet for quick lookup
- **Lab Exercises**: 8 progressive exercises from basic to integration
- **This INDEX**: Navigation and study guides

### External References
- `man fdisk` - Partition editor documentation
- `man lvm` - LVM overview
- `man pv/vg/lv` - LVM commands
- `man fstab` - File system table format
- `man mount` - Mount command options
- `man resize2fs` - Filesystem resize

### Related Modules
- Module 1: Essential Tools (command line)
- Module 2: Operating Systems (kernel, boot)
- Module 4: Filesystem & Storage (filesystems, SELinux)

---

## Self-Assessment Questions

**Can you explain?**
1. Why use UUID instead of device names for mounting?
2. What is the LVM hierarchy and why is it useful?
3. How do you add 50GB to a full partition without unmounting?
4. What's the difference between lvextend and resize2fs?
5. Why can XFS not be shrunk?
6. How do you move data from a failing disk?
7. What does "nofail" option in fstab do?
8. Why is swap space needed even on systems with lots of RAM?

**Can you perform?**
1. Create GPT partitions on a new disk
2. Set up LVM storage from scratch
3. Mount filesystem by UUID persistently
4. Expand LV and filesystem online
5. Create and enable swap space
6. Troubleshoot and fix fstab issues
7. Migrate data between disks
8. Design storage for multi-purpose server

---

## Glossary

| Term | Definition |
|------|-----------|
| **GPT** | GUID Partition Table - modern partitioning standard |
| **MBR** | Master Boot Record - legacy partitioning (2TB limit) |
| **PV** | Physical Volume - LVM building block |
| **VG** | Volume Group - pool of PVs |
| **LV** | Logical Volume - virtual partition on VG |
| **PE** | Physical Extent - allocation unit (usually 4MB) |
| **UUID** | Unique identifier for filesystem (reliable, persistent) |
| **fstab** | File system table - persistent mount configuration |
| **mount -a** | Test fstab entries without rebooting |
| **resize2fs** | Extend ext4 filesystem to LV size |
| **xfs_growfs** | Extend XFS filesystem to LV size |
| **nofail** | fstab option to ignore missing device |
| **swap** | Virtual memory on disk |

---

## Success Metrics

**After completing this module, you should:**

✓ Score 90%+ on practice questions
✓ Complete Lab Exercise 8 in under 30 minutes
✓ Troubleshoot any mount issue in under 10 minutes
✓ Explain LVM hierarchy without notes
✓ Create complete storage setup from scratch
✓ Know all commands without referencing notes
✓ Handle emergency storage expansion confidently
✓ Pass RHCSA Module 3 exam objectives

---

**Next Steps After This Module:**
1. Review Quick Reference daily for 1 week
2. Attempt Lab Exercise 8 (Integration) multiple times
3. Practice failure scenarios (wrong UUID, failed mount, etc.)
4. Move to Module 4: Filesystems & Storage
5. Review this module 1 week before exam

---

**Last Updated:** Module 3 Complete
**Target Proficiency:** Ready for RHCSA Exam - Configure Local Storage Objectives
**Estimated Mastery Time:** 12-15 hours of focused study

---

*End of INDEX - Module 3: Configure Local Storage*
