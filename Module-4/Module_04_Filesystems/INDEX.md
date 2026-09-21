# RHCSA Module 4: Create and Configure File Systems
## Complete Navigation & Study Guide

---

## Quick Navigation

### By Learning Path
- **[Beginner Path](#beginner-learning-path)** - Start here if new to filesystems
- **[Intermediate Path](#intermediate-learning-path)** - For familiar with Linux
- **[Advanced Path](#advanced-learning-path)** - Exam-focused speed learning

### By File Type
- **[Lab Notes](../04_Create_Configure_Filesystems_Lab_Notes.md)** - Detailed explanations
- **[Quick Reference](Quick_Reference.txt)** - Command cheat sheet
- **[Lab Exercises](Lab_Exercises.md)** - Hands-on practice

### By Topic
1. [Filesystem Fundamentals](#topic-1-filesystem-fundamentals)
2. [Creating Filesystems](#topic-2-creating-filesystems)
3. [Mounting Filesystems](#topic-3-mounting-filesystems)
4. [ext4 Filesystem](#topic-4-ext4-filesystem)
5. [XFS Filesystem](#topic-5-xfs-filesystem)
6. [VFAT Filesystem](#topic-6-vfat-filesystem)
7. [Network File Systems](#topic-7-network-file-systems-nfs)
8. [Autofs Configuration](#topic-8-autofs-configuration)
9. [Extending Logical Volumes](#topic-9-extending-logical-volumes)
10. [Permission Troubleshooting](#topic-10-file-permission-troubleshooting)

---

## Study Schedules

### Beginner Learning Path
**Duration:** 12-15 hours over 3-4 days

**Day 1 (4 hours):**
1. Read Lab Notes: Filesystem Fundamentals & Creation (1.5 hours)
2. Lab Exercise 1: Create ext4 (1.5 hours)
3. Lab Exercise 2: Create XFS (1 hour)

**Day 2 (4 hours):**
1. Read Lab Notes: Mounting & ext4 Tools (1.5 hours)
2. Lab Exercise 3: Create VFAT (1 hour)
3. Lab Exercise 4: UUID Mounting (1.5 hours)

**Day 3 (3 hours):**
1. Read Lab Notes: NFS & Autofs (1.5 hours)
2. Lab Exercise 5: LV Extension (1.5 hours)

**Day 4 (4 hours):**
1. Read Lab Notes: Permissions (1 hour)
2. Lab Exercise 6-7: Permission Fixes & NFS (2 hours)
3. Lab Exercise 8: Integration (1 hour)

### Intermediate Learning Path
**Duration:** 6-8 hours over 1-2 days

**Day 1 (4 hours):**
1. Skim Lab Notes (30 min)
2. Lab Exercises 2-5 (3.5 hours)

**Day 2 (3 hours):**
1. Lab Exercises 6-8 (2 hours)
2. Quick Reference review (1 hour)

### Advanced Learning Path (Exam Focused)
**Duration:** 2-3 hours

**Hour 1:**
1. Quick Reference scan (15 min)
2. Review key topics: ext4, XFS, NFS (45 min)

**Hour 2:**
1. Lab Exercise 4 & 5 (LV & mounting) (1 hour)
2. Lab Exercise 8 (integration) (1 hour)

**Hour 3:**
1. Focus on weak areas (1 hour)

---

## Topic Deep Dives

### Topic 1: Filesystem Fundamentals

**Key Concepts:**
- Filesystem structure and purpose
- Common Linux filesystems (ext4, xfs, btrfs, vfat)
- Inode concept
- Block sizes

**Essential Commands:**
```bash
df -h                    # Show mounted filesystems
df -T                    # Show filesystem types
lsblk -f                 # Show all filesystems
blkid                    # Show UUIDs/labels
stat /dev/sda1           # Show device details
```

**Exam Objectives:**
- Understand filesystem concepts ✓
- Know filesystem types ✓
- Understand mounting ✓

**Practice:**
- [Lab Exercise 1](Lab_Exercises.md#lab-exercise-1-create-ext4-filesystem)
- [Lab Notes Section 1](../04_Create_Configure_Filesystems_Lab_Notes.md#filesystem-fundamentals)

---

### Topic 2: Creating Filesystems

**Key Concepts:**
- mkfs command and variants
- Filesystem labels
- Verification after creation
- Warnings about data loss

**Essential Commands:**
```bash
sudo mkfs -t ext4 /dev/sdb1
sudo mkfs.xfs /dev/sdb1
sudo mkfs.vfat /dev/sdb1
blkid /dev/sdb1          # Verify creation
```

**Exam Objectives:**
- Create ext4 filesystem ✓
- Create XFS filesystem ✓
- Create VFAT filesystem ✓
- Verify filesystem creation ✓

**Practice:**
- [Lab Exercises 1-3](Lab_Exercises.md#lab-exercise-1-create-ext4-filesystem)
- [Lab Notes Section 2](../04_Create_Configure_Filesystems_Lab_Notes.md#creating-filesystems)

---

### Topic 3: Mounting Filesystems

**Key Concepts:**
- Mount points
- Mount options
- Persistent mounting with /etc/fstab
- UUID vs device names

**Essential Commands:**
```bash
sudo mount /dev/sdb1 /mnt/data
sudo mount -t ext4 /dev/sdb1 /mnt/data
sudo umount /mnt/data
sudo mount -a             # Mount all from fstab
```

**Exam Objectives:**
- Mount filesystems ✓
- Mount with specific options ✓
- Configure persistent mounts ✓
- Mount by UUID ✓

**Practice:**
- [Lab Exercise 4](Lab_Exercises.md#lab-exercise-4-mount-filesystems-by-uuid-in-fstab)
- [Lab Notes Section 3](../04_Create_Configure_Filesystems_Lab_Notes.md#mounting-filesystems)

---

### Topic 4: ext4 Filesystem

**Key Concepts:**
- ext4 features (journaling, extents)
- Labeling
- Filesystem checking
- Resizing (grow and shrink)

**Essential Commands:**
```bash
sudo tune2fs -l /dev/sdb1
sudo e2label /dev/sdb1 mydata
sudo e2fsck -n /dev/sdb1
sudo resize2fs /dev/sdb1
```

**Exam Objectives:**
- Create ext4 filesystem ✓
- Manage ext4 labels ✓
- Check ext4 filesystem ✓
- Resize ext4 filesystem ✓

**Practice:**
- [Lab Exercise 1](Lab_Exercises.md#lab-exercise-1-create-ext4-filesystem)
- [Lab Notes Section 4](../04_Create_Configure_Filesystems_Lab_Notes.md#ext4-filesystem)

---

### Topic 5: XFS Filesystem

**Key Concepts:**
- XFS features
- XFS tools (xfs_info, xfs_admin)
- XFS growth (online, no shrink)
- xfs_repair

**Essential Commands:**
```bash
sudo mkfs.xfs /dev/sdb1
sudo xfs_info /mnt/data
sudo xfs_admin -L label /dev/sdb1
sudo xfs_growfs /mnt/data
```

**Exam Objectives:**
- Create XFS filesystem ✓
- Manage XFS labels ✓
- Grow XFS filesystem ✓
- Understand XFS limitations ✓

**Practice:**
- [Lab Exercise 2](Lab_Exercises.md#lab-exercise-2-create-and-compare-xfs-filesystem)
- [Lab Notes Section 5](../04_Create_Configure_Filesystems_Lab_Notes.md#xfs-filesystem)

---

### Topic 6: VFAT Filesystem

**Key Concepts:**
- VFAT compatibility
- No permissions system
- 4GB file limit (FAT32)
- Cross-platform use

**Essential Commands:**
```bash
sudo mkfs.vfat /dev/sdb1
sudo fsck.vfat /dev/sdb1
sudo mount -o umask=0000 /dev/sdb1 /mnt/data
```

**Exam Objectives:**
- Create VFAT filesystem ✓
- Mount VFAT with options ✓
- Understand VFAT limitations ✓

**Practice:**
- [Lab Exercise 3](Lab_Exercises.md#lab-exercise-3-create-and-mount-vfat-filesystem)
- [Lab Notes Section 6](../04_Create_Configure_Filesystems_Lab_Notes.md#vfat-filesystem)

---

### Topic 7: Network File Systems (NFS)

**Key Concepts:**
- NFS mounting
- NFS versions (v3, v4)
- Mount options
- Troubleshooting NFS

**Essential Commands:**
```bash
showmount -e nfs-server
sudo mount -t nfs server:/export /mnt/data
sudo mount -t nfs -o vers=4 server:/export /mnt/data
```

**Exam Objectives:**
- Mount NFS filesystem ✓
- Understand NFS options ✓
- Troubleshoot NFS ✓

**Practice:**
- [Lab Exercise 8](Lab_Exercises.md#lab-exercise-8-configure-nfs-mount-and-autofs)
- [Lab Notes Section 7](../04_Create_Configure_Filesystems_Lab_Notes.md#network-file-systems-nfs)

---

### Topic 8: Autofs Configuration

**Key Concepts:**
- Autofs benefits
- Master and map files
- Auto-mounting
- Timeout behavior

**Essential Commands:**
```bash
sudo systemctl start autofs
sudo vim /etc/auto.master
sudo vim /etc/auto.nfs
sudo systemctl restart autofs
```

**Exam Objectives:**
- Configure autofs ✓
- Understand autofs maps ✓
- Test autofs functionality ✓

**Practice:**
- [Lab Exercise 8](Lab_Exercises.md#lab-exercise-8-configure-nfs-mount-and-autofs)
- [Lab Notes Section 8](../04_Create_Configure_Filesystems_Lab_Notes.md#autofs-configuration)

---

### Topic 9: Extending Logical Volumes

**Key Concepts:**
- LV extension workflow
- Filesystem growth
- ext4 vs XFS resizing
- Non-destructive expansion

**Essential Commands:**
```bash
sudo lvextend -L +10G /dev/vg/lv
sudo resize2fs /dev/vg/lv       # ext4
sudo xfs_growfs /mount/point    # XFS
df -h /mount/point
```

**Exam Objectives:**
- Extend logical volumes ✓
- Extend filesystems ✓
- Non-destructive expansion ✓

**Practice:**
- [Lab Exercise 5 & 6](Lab_Exercises.md#lab-exercise-5-extend-logical-volume-and-filesystem)
- [Lab Notes Section 9](../04_Create_Configure_Filesystems_Lab_Notes.md#extending-logical-volumes)

---

### Topic 10: File Permission Troubleshooting

**Key Concepts:**
- Permission notation (ugo/rwx)
- Numeric notation (755, 644, etc.)
- Ownership changes
- Directory vs file permissions

**Essential Commands:**
```bash
ls -l file.txt
chmod 644 file.txt
chown user:group file.txt
chmod -R 755 directory/
```

**Exam Objectives:**
- Diagnose permission problems ✓
- Correct permission issues ✓
- Understand permission concepts ✓

**Practice:**
- [Lab Exercise 7](Lab_Exercises.md#lab-exercise-7-fix-file-permission-problems)
- [Lab Notes Section 10](../04_Create_Configure_Filesystems_Lab_Notes.md#file-permission-troubleshooting)

---

## Key Concepts Tier List

### Tier 1 (Must Know - Exam Critical)
1. Create ext4 filesystem (mkfs.ext4)
2. Create XFS filesystem (mkfs.xfs)
3. Mount filesystems by UUID
4. Add entries to /etc/fstab
5. Extend logical volumes (lvextend)
6. Grow ext4 filesystem (resize2fs)
7. Grow XFS filesystem (xfs_growfs)
8. Diagnose permission problems
9. Fix permission issues (chmod, chown)
10. Test /etc/fstab (mount -a)

### Tier 2 (Important - Exam Likely)
1. Create VFAT filesystem
2. Mount NFS filesystems
3. Filesystem checking (e2fsck, xfs_check)
4. Setting labels (e2label, xfs_admin)
5. Getting UUIDs (blkid)
6. Mount options and syntax
7. Remounting filesystems
8. Understanding filesystem types
9. Autofs configuration basics
10. Understanding inode concept

### Tier 3 (Good to Know - Exam Possible)
1. Autofs advanced configuration
2. NFS troubleshooting
3. VFAT mounting options
4. Filesystem comparison
5. fsck variants
6. Extent vs block allocation
7. Journaling concept
8. ACLs basics
9. SELinux context
10. Swap space concepts

---

## Pre-Exam Checklist

### Knowledge Verification
- [ ] Understand filesystem concepts
- [ ] Know mkfs command variants
- [ ] Know mount command syntax
- [ ] Know fstab format
- [ ] Know UUID vs device names
- [ ] Know lvextend command
- [ ] Know resize2fs vs xfs_growfs
- [ ] Know permission notation
- [ ] Know chmod/chown commands
- [ ] Know NFS basics

### Hands-On Skills
- [ ] Create ext4 filesystem
- [ ] Create XFS filesystem
- [ ] Create VFAT filesystem
- [ ] Mount by UUID
- [ ] Extend LV and filesystem
- [ ] Fix permissions
- [ ] Configure autofs
- [ ] Mount NFS
- [ ] Test fstab
- [ ] Troubleshoot issues

---

## Time Allocation Guide

### Total Study Time: 12-15 hours

**By Activity:**
- Reading Lab Notes: 3-4 hours
- Hands-on Exercises: 7-9 hours
- Quick Reference: 1-2 hours

**By Topic:**
- Filesystem basics: 1-2 hours
- Creating filesystems: 1-2 hours
- Mounting: 2-3 hours
- ext4/XFS: 2-3 hours
- VFAT/NFS: 1-2 hours
- Autofs: 1 hour
- LV extension: 1-2 hours
- Permissions: 1-2 hours

---

## Success Metrics

**After completing this module, you should:**

✓ Create all three filesystem types confidently
✓ Mount filesystems by UUID persistently
✓ Extend filesystems without data loss
✓ Troubleshoot permission problems quickly
✓ Configure NFS mounts
✓ Setup autofs
✓ Understand filesystem concepts
✓ Pass all lab exercises

---

**Next Steps After This Module:**
1. Review Quick Reference daily for 1 week
2. Attempt Lab Exercise 8 multiple times
3. Practice on different hardware
4. Move to Module 5: Deploy & Configure Systems
5. Reference this module as needed in later modules

---

*End of INDEX - Module 4: Create and Configure File Systems*
