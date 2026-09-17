# RHCSA Module 3: Configure Local Storage
## Hands-On Lab Exercises

---

## Lab Exercise 1: Disk Partitioning with GPT

**Objective:** Learn to partition a disk using GPT format

**Prerequisites:**
- New 100GB disk attached as `/dev/sdb`
- Root/sudo access
- Understanding of GPT vs MBR

### Scenario:
You have a new 100GB disk that needs to be partitioned for a production storage server. Create three partitions: 20GB for database, 50GB for files, and 30GB for backups.

### Step-by-Step Instructions:

```bash
# Step 1: Verify the new disk exists
lsblk
# Expected output should show /dev/sdb (100GB) unpartitioned

# Step 2: Start fdisk on the new disk
sudo fdisk /dev/sdb

# Inside fdisk (fdisk> prompt):
# Step 3: Create GPT partition table (WARNING: Destroys existing data)
g
# Response: Created a new GPT disklabel (name: default).

# Step 4: Create first partition (20GB for database)
n
# Partition number: 1
# First sector: (press Enter for default: 2048)
# Last sector: +20G
# Created a new partition 1 of type 'Linux filesystem' and of size 20 GiB.

# Step 5: Create second partition (50GB for files)
n
# Partition number: 2
# First sector: (press Enter)
# Last sector: +50G
# Created a new partition 2 of type 'Linux filesystem' and of size 50 GiB.

# Step 6: Create third partition (remaining 30GB)
n
# Partition number: 3
# First sector: (press Enter)
# Last sector: (press Enter for all remaining)
# Created a new partition 3 of type 'Linux filesystem' and of size 30 GiB.

# Step 7: Verify partitions before writing
p
# Expected output:
# Device       Start       End    Sectors  Size Type
# /dev/sdb1     2048  41945087   41943040   20G Linux filesystem
# /dev/sdb2 41945088 146801151  104856064   50G Linux filesystem
# /dev/sdb3 146801152 209715166   62914015   30G Linux filesystem

# Step 8: Write changes to disk
w
# The partition table has been altered.
# Calling ioctl() to re-read partition table (or reboot).
# The new raw disklabel will be installed when you reboot or after you run partprobe.

# Step 9: Notify kernel of changes (outside fdisk)
sudo partprobe /dev/sdb

# Or use:
sudo fdisk -l /dev/sdb
# Wait a moment for /dev/sdb1, /dev/sdb2, /dev/sdb3 to appear

# Step 10: Verify partitions were created
lsblk /dev/sdb
# Expected:
# NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
# sdb      8:16   0  100G  0 disk
# ├─sdb1   8:17   0   20G  0 part
# ├─sdb2   8:18   0   50G  0 part
# └─sdb3   8:19   0   30G  0 part

sudo fdisk -l /dev/sdb
# Should show all three partitions with correct sizes
```

### Verification Checklist:
- [ ] All three partitions visible with `lsblk`
- [ ] Partition sizes correct (20G, 50G, 30G)
- [ ] GPT partition table confirmed with `fdisk -l`
- [ ] No errors in `dmesg` output

### Troubleshooting:
**Problem:** Partitions not showing up
```bash
# Solution: Run partprobe again
sudo partprobe /dev/sdb

# Or rescan SCSI bus
echo "1" | sudo tee /sys/class/scsi_host/host0/scan

# Or reboot
sudo reboot
```

**Problem:** "Device already contains a recognized partition table"
```bash
# Solution: Use -s flag to suppress confirmation
sudo partprobe -s /dev/sdb

# Or use parted to wipe labels
sudo parted -s /dev/sdb mklabel gpt
```

---

## Lab Exercise 2: Create Physical Volumes

**Objective:** Convert partitions to LVM physical volumes

**Prerequisites:**
- Completed Lab 1 (three partitions on /dev/sdb)
- Understanding of LVM components

### Scenario:
The three partitions must be prepared for LVM. Convert each partition to a physical volume for use in volume groups.

### Step-by-Step Instructions:

```bash
# Step 1: List current partitions
lsblk /dev/sdb
# Shows: /dev/sdb1, /dev/sdb2, /dev/sdb3

# Step 2: Create physical volume on first partition
sudo pvcreate /dev/sdb1
# Physical volume "/dev/sdb1" successfully created.

# Step 3: Create physical volumes on other partitions
sudo pvcreate /dev/sdb2
# Physical volume "/dev/sdb2" successfully created.

sudo pvcreate /dev/sdb3
# Physical volume "/dev/sdb3" successfully created.

# Step 4: View all physical volumes
sudo pvs
# Output:
# PV         VG Fmt  Attr PSize  PFree
# /dev/sdb1     lvm2 ---  20.00g 20.00g
# /dev/sdb2     lvm2 ---  50.00g 50.00g
# /dev/sdb3     lvm2 ---  30.00g 30.00g

# Step 5: Get detailed information on physical volumes
sudo pvdisplay
# Output includes:
# --- Physical volume ---
# PV Name               /dev/sdb1
# VG Name
# PV Size               20.00 GiB / not usable 2.00 MiB
# Allocatable           yes
# PE Size               4.00 MiB
# Total PE              5119
# Free PE               5119
# Allocated PE          0
# PV UUID               xxxx-xxxx-xxxx-xxxx

# Step 6: Show specific PV information
sudo pvdisplay /dev/sdb2
# Shows detailed info for /dev/sdb2 only

# Step 7: Show allocation status
sudo pvs -o +pv_used,pv_free
# Output:
# PV         VG Fmt  Attr PSize  PFree  Used
# /dev/sdb1     lvm2 ---  20.00g 20.00g   0
# /dev/sdb2     lvm2 ---  50.00g 50.00g   0
# /dev/sdb3     lvm2 ---  30.00g 30.00g   0
```

### Verification Checklist:
- [ ] All three PVs created successfully with `pvs`
- [ ] Each PV shows correct size
- [ ] All PV space is "Free" (not allocated yet)
- [ ] `pvdisplay` shows detailed PE information

### Cleanup (if needed):
```bash
# To remove PVs and start over:
sudo pvremove /dev/sdb1 /dev/sdb2 /dev/sdb3
# Labels on physical volume "/dev/sdb1" successfully wiped.
# (Repeat for each PV)
```

---

## Lab Exercise 3: Create and Extend Volume Groups

**Objective:** Combine physical volumes into a volume group

**Prerequisites:**
- Completed Lab 2 (three PVs created)
- Understanding of VG as aggregated storage

### Scenario:
Create a volume group called `vg_production` using the first two partitions (20GB + 50GB = 70GB). Later, add the third partition to expand the VG to 100GB.

### Step-by-Step Instructions:

```bash
# Step 1: Create volume group with first two PVs
sudo vgcreate vg_production /dev/sdb1 /dev/sdb2
# Volume group "vg_production" successfully created

# Step 2: View volume group
sudo vgs vg_production
# Output:
# VG           #PV #LV #SN Attr   VSize  VFree
# vg_production   2   0   0 wz--n- 70.00g 70.00g

# Step 3: Get detailed VG information
sudo vgdisplay vg_production
# Output includes:
# --- Volume group ---
# VG Name               vg_production
# System ID
# Format                lvm2
# Metadata Areas        2
# Metadata Sequence No  1
# VG Access             read/write
# VG Status             resizable
# Allocatable           yes
# Extent Size           4.00 MiB
# PE Size               4.00 MiB
# Total PE              17920
# Alloc PE / Size       0 / 0
# Free  PE / Size       17920 / 70.00 GiB
# VG UUID               xxxx-xxxx-xxxx-xxxx

# Step 4: Show mapping of PVs to VG
sudo vgdisplay -m vg_production
# Shows PE allocation map

# Step 5: Later - verify VG before extending
sudo vgs
# Shows vg_production with 70GB total

# Step 6: Extend VG by adding third PV
sudo vgextend vg_production /dev/sdb3
# Volume group "vg_production" successfully extended

# Step 7: Verify VG size increased
sudo vgs vg_production
# Output:
# VG           #PV #LV #SN Attr   VSize  VFree
# vg_production   3   0   0 wz--n-100.00g 100.00g

# Step 8: Show all PVs in VG
sudo vgdisplay vg_production | grep "PV Name"
# Expected output shows all three PV names

# Step 9: Custom view of VG details
sudo vgs -o name,size,free,pv_count,lv_count vg_production
# Output:
# VG           VSize  VFree    #PV #LV
# vg_production 100.00g 100.00g   3   0
```

### Verification Checklist:
- [ ] VG `vg_production` created with 70GB (from 2 PVs)
- [ ] VG extended to 100GB after adding 3rd PV
- [ ] All three PVs associated with VG
- [ ] `#PV` column shows 3, `#LV` shows 0

### Troubleshooting:
**Problem:** "Physical volume already allocated"
```bash
# Solution: PV might already be in different VG
sudo pvs
# Check which VG owns the PV, vgreduce if needed
```

---

## Lab Exercise 4: Create and Manage Logical Volumes

**Objective:** Create logical volumes for various purposes

**Prerequisites:**
- Completed Lab 3 (VG with 100GB created)
- Understanding of LV allocation

### Scenario:
Create three logical volumes in the production VG:
- 30GB for database files
- 40GB for user data
- 20GB for backups
- Use remaining space for expandable archive

### Step-by-Step Instructions:

```bash
# Step 1: Create first LV (30GB for database)
sudo lvcreate -L 30G -n lv_database vg_production
# Logical volume "lv_database" created.

# Step 2: Create second LV (40GB for data)
sudo lvcreate -L 40G -n lv_data vg_production
# Logical volume "lv_data" created.

# Step 3: Create third LV (20GB for backups)
sudo lvcreate -L 20G -n lv_backup vg_production
# Logical volume "lv_backup" created.

# Step 4: Create fourth LV using all remaining free space
sudo lvcreate -l 100%FREE -n lv_archive vg_production
# Logical volume "lv_archive" created.

# Step 5: List all logical volumes
sudo lvs
# Output:
# LV         VG           Attr       LSize  Pool Origin Data%  Meta%
# lv_archive vg_production -wi-a----- 10.00g
# lv_backup  vg_production -wi-a----- 20.00g
# lv_database vg_production -wi-a----- 30.00g
# lv_data    vg_production -wi-a----- 40.00g

# Step 6: Get detailed LV information
sudo lvdisplay vg_production/lv_database
# Shows:
# --- Logical volume ---
# LV Path                /dev/vg_production/lv_database
# LV Name                lv_database
# VG Name                vg_production
# LV UUID                xxxx-xxxx-xxxx-xxxx
# LV Write Access        read/write
# LV Creation host, time ..., ...
# LV Status              available
# # open                 0
# LV Size                30.00 GiB
# Current LE             7680
# Segments               1
# Allocation             inherit
# Read ahead sectors     auto
# - currently set to     256
# Block device           253:0

# Step 7: Show LV mapping to PVs
sudo lvdisplay -m vg_production/lv_database
# Shows how extents are distributed across PVs

# Step 8: Show which devices hold each LV
sudo lvs -o +devices
# Output shows device mapping for each LV

# Step 9: Extend a logical volume (add 5GB to database)
sudo lvextend -L +5G /dev/vg_production/lv_database
# Size of logical volume vg_production/lv_database changed from 30.00 GiB to 35.00 GiB.

# Step 10: Verify extension
sudo lvs vg_production/lv_database
# Output shows:
# LV         VG           Attr       LSize
# lv_database vg_production -wi-a----- 35.00g

# Step 11: Check remaining free space in VG
sudo vgs vg_production
# Output:
# VG           VSize  VFree
# vg_production 100.00g 5.00g
# (Only 5GB remaining: 100 - 35 - 40 - 20)
```

### Verification Checklist:
- [ ] Four LVs created with correct sizes
- [ ] `lvs` shows all logical volumes
- [ ] LV extended by 5GB successfully
- [ ] Remaining free space in VG matches expectations
- [ ] LV mapping shows distribution across PVs

### Troubleshooting:
**Problem:** "Insufficient space"
```bash
# Solution: Check free space in VG
sudo vgs vg_production
# Ensure enough space available before creating LV
```

---

## Lab Exercise 5: Create Filesystems and Mount by UUID

**Objective:** Format LVs and mount persistently using UUIDs

**Prerequisites:**
- Completed Lab 4 (four LVs created)
- Understanding of filesystems and mounting

### Scenario:
Create ext4 filesystems on all four LVs, get their UUIDs, create mount points, and add persistent entries to /etc/fstab.

### Step-by-Step Instructions:

```bash
# Step 1: Create ext4 filesystems on all LVs
sudo mkfs.ext4 /dev/vg_production/lv_database
# mke2fs 1.45.6 (20-May-2021)
# Filesystem UUID: abc123def456...

sudo mkfs.ext4 /dev/vg_production/lv_data
sudo mkfs.ext4 /dev/vg_production/lv_backup
sudo mkfs.ext4 /dev/vg_production/lv_archive

# Step 2: Get UUID for each filesystem
sudo blkid
# Output:
# /dev/vg_production/lv_database: UUID="abc123" TYPE="ext4"
# /dev/vg_production/lv_data: UUID="def456" TYPE="ext4"
# /dev/vg_production/lv_backup: UUID="ghi789" TYPE="ext4"
# /dev/vg_production/lv_archive: UUID="jkl012" TYPE="ext4"

# Step 3: Alternative - get UUID using tune2fs
sudo tune2fs -l /dev/vg_production/lv_database | grep UUID
# UUID:                 abc123def456...

# Step 4: Extract just UUID values for easier use
UUID_DB=$(sudo blkid -s UUID -o value /dev/vg_production/lv_database)
UUID_DATA=$(sudo blkid -s UUID -o value /dev/vg_production/lv_data)
UUID_BACKUP=$(sudo blkid -s UUID -o value /dev/vg_production/lv_backup)
UUID_ARCHIVE=$(sudo blkid -s UUID -o value /dev/vg_production/lv_archive)

# Step 5: Verify UUIDs captured
echo "Database: $UUID_DB"
echo "Data: $UUID_DATA"
echo "Backup: $UUID_BACKUP"
echo "Archive: $UUID_ARCHIVE"

# Step 6: Create mount points (as root)
sudo mkdir -p /database
sudo mkdir -p /data
sudo mkdir -p /backup
sudo mkdir -p /archive

# Step 7: Manually mount filesystems
sudo mount /dev/vg_production/lv_database /database
sudo mount /dev/vg_production/lv_data /data
sudo mount /dev/vg_production/lv_backup /backup
sudo mount /dev/vg_production/lv_archive /archive

# Step 8: Verify mounts
mount | grep vg_production
# Output shows all four mount points

# Step 9: Check disk usage
df -h /database /data /backup /archive
# Shows mount point sizes

# Step 10: Add entries to /etc/fstab
sudo vi /etc/fstab

# Add these lines (or use echo and tee):
sudo tee -a /etc/fstab << EOF
UUID=$UUID_DB /database ext4 defaults,nofail 0 2
UUID=$UUID_DATA /data ext4 defaults,nofail 0 2
UUID=$UUID_BACKUP /backup ext4 defaults,nofail 0 2
UUID=$UUID_ARCHIVE /archive ext4 defaults,nofail 0 2
EOF

# Step 11: Verify /etc/fstab entries
sudo grep vg_production /etc/fstab
# Shows all four UUID entries

# Step 12: Test fstab for errors
sudo umount /database /data /backup /archive

# Step 13: Mount using fstab
sudo mount -a
# Attempts to mount all in fstab

# Step 14: Verify all mounts from fstab
mount | grep vg_production
df -h /database /data /backup /archive

# Step 15: Verify filesystem integrity (optional)
sudo e2fsck -n /dev/vg_production/lv_database
# (-n flag: read-only check, don't modify)
```

### Verification Checklist:
- [ ] All four filesystems created successfully
- [ ] UUID extracted for each filesystem
- [ ] Mount points created
- [ ] Filesystems mounted manually
- [ ] /etc/fstab entries added with UUIDs
- [ ] `mount -a` succeeds without errors
- [ ] All mounts persistent after reboot (test with reboot or recreate)

### Troubleshooting:
**Problem:** Mount fails after boot
```bash
# Solution: Check fstab syntax
sudo mount -a

# Get detailed error
sudo mount UUID=abc123 /database

# Check if UUID is correct
sudo blkid /dev/vg_production/lv_database
```

**Problem:** "Device UUID does not match /etc/fstab"
```bash
# Solution: Run fsck to update UUID record
sudo umount /database
sudo e2fsck /dev/vg_production/lv_database
```

---

## Lab Exercise 6: Non-Destructive Storage Expansion

**Objective:** Add capacity to existing filesystem without data loss

**Prerequisites:**
- Completed Lab 5 (filesystems mounted)
- Understanding of expansion process

### Scenario:
The `/data` filesystem is running low on space (40GB almost full). Add a new 30GB disk and expand the VG, then grow the `lv_data` logical volume by 20GB without unmounting.

### Step-by-Step Instructions:

```bash
# Step 1: Check current usage
df -h /data
# Output shows /data is 40GB, mostly full

sudo lvs /dev/vg_production/lv_data
# Shows: LSize 40.00g

# Step 2: Partition new disk (simulate with /dev/sdc)
sudo fdisk /dev/sdc
# g (create GPT)
# n (create partition, accept all defaults)
# w (write)

sudo partprobe /dev/sdc

# Step 3: Create physical volume on new partition
sudo pvcreate /dev/sdc1
# Physical volume "/dev/sdc1" successfully created.

# Step 4: Verify new PV
sudo pvs /dev/sdc1

# Step 5: Extend volume group with new PV
sudo vgextend vg_production /dev/sdc1
# Volume group "vg_production" successfully extended

# Step 6: Verify VG size increased
sudo vgs vg_production
# Output shows VFree now includes 30GB from new PV

# Step 7: Extend logical volume by 20GB
sudo lvextend -L +20G /dev/vg_production/lv_data
# Size of logical volume vg_production/lv_data changed from 40.00 GiB to 60.00 GiB.

# Step 8: Verify LV size
sudo lvs /dev/vg_production/lv_data
# Shows: LSize 60.00g

# Step 9: IMPORTANT - Extend the filesystem to use new LV space
sudo resize2fs /dev/vg_production/lv_data
# resize2fs 1.45.6 (20-May-2021)
# Filesystem at /dev/vg_production/lv_data is mounted on /data; on-line resizing required
# old_desc_blocks = 5, new_desc_blocks = 8
# The filesystem on /dev/vg_production/lv_data is now 15728640 (4k) blocks long.

# Step 10: Verify filesystem size increased
df -h /data
# Output shows /data is now 60GB

# Step 11: Verify data is still accessible
ls -la /data
# Verify no data loss

# Step 12: Check free space
sudo vgs vg_production
# Shows remaining free space in VG
```

### Advanced Scenario: Migrate LV to New Disk

```bash
# Alternative: Move data from old disk to new
# (Useful if old disk is failing)

# 1. Move data from /dev/sdb2 to new /dev/sdc1
sudo pvmove /dev/sdb2 /dev/sdc1
# Evacuating logical volumes in 5 steps for VG vg_production
# /dev/vg_production/lv_data: Moved 3 out of 10 extents

# 2. Remove old PV from VG
sudo vgreduce vg_production /dev/sdb2
# Removed "/dev/sdb2" from volume group "vg_production"

# 3. Remove PV metadata
sudo pvremove /dev/sdb2
# Labels on physical volume "/dev/sdb2" successfully wiped
```

### Verification Checklist:
- [ ] New disk partitioned and PV created
- [ ] VG extended with new PV
- [ ] LV extended by 20GB
- [ ] Filesystem extended with resize2fs
- [ ] `df -h` shows new 60GB size
- [ ] All data still accessible
- [ ] No downtime during expansion

### Troubleshooting:
**Problem:** resize2fs hangs
```bash
# Solution: Might need fsck first
sudo umount /data
sudo e2fsck /dev/vg_production/lv_data
sudo mount /dev/vg_production/lv_data /data
sudo resize2fs /dev/vg_production/lv_data
```

---

## Lab Exercise 7: Swap Space Creation and Management

**Objective:** Create and manage swap space

**Prerequisites:**
- Access to volume group with free space

### Scenario:
Create a 4GB swap space on a logical volume, enable it, and add it to /etc/fstab for persistence.

### Step-by-Step Instructions:

```bash
# Step 1: Verify available space in VG
sudo vgs vg_production
# Check VFree (should have at least 4GB)

# Step 2: Create logical volume for swap
sudo lvcreate -L 4G -n lv_swap vg_production
# Logical volume "lv_swap" successfully created

# Step 3: Verify swap LV created
sudo lvs vg_production/lv_swap
# Shows: LV Size 4.00g

# Step 4: Initialize swap on LV
sudo mkswap /dev/vg_production/lv_swap
# Setting up swapspace version 1, size = 4 GiB (4294967296 bytes)
# Label:
# UUID: swap-uuid-1234-5678

# Step 5: Enable swap
sudo swapon /dev/vg_production/lv_swap

# Step 6: Verify swap is active
swapon -s
# Output shows /dev/mapper/vg_production-lv_swap is active

# Step 7: Check total swap
free -h
# Output shows 4.0G in Swap column

# Step 8: Get UUID for swap LV
SWAP_UUID=$(sudo blkid -s UUID -o value /dev/vg_production/lv_swap)
echo "Swap UUID: $SWAP_UUID"

# Step 9: Add to /etc/fstab for persistence
echo "UUID=$SWAP_UUID none swap sw 0 0" | sudo tee -a /etc/fstab

# Step 10: Verify /etc/fstab entry
sudo grep swap /etc/fstab
# Shows swap entry

# Step 11: Test by disabling and re-enabling swap
sudo swapoff /dev/vg_production/lv_swap
swapon -s
# Swap should not appear

# Step 12: Re-enable swap
swapon -a
# Enables all swap from /etc/fstab

# Step 13: Verify swap re-enabled
free -h
swapon -s
```

### Swap File Alternative (if needed):

```bash
# If you don't want to use LV for swap:

# Step 1: Create swap file
sudo fallocate -l 4G /swapfile
# Or: sudo dd if=/dev/zero of=/swapfile bs=1M count=4096

# Step 2: Set permissions
sudo chmod 600 /swapfile

# Step 3: Initialize swap
sudo mkswap /swapfile

# Step 4: Enable swap
sudo swapon /swapfile

# Step 5: Add to /etc/fstab
echo "/swapfile none swap sw 0 0" | sudo tee -a /etc/fstab

# Step 6: Verify
free -h
swapon -s
```

### Verification Checklist:
- [ ] Swap LV created (4GB)
- [ ] Swap initialized with mkswap
- [ ] Swap enabled with swapon
- [ ] `free -h` shows 4GB swap
- [ ] UUID extracted for fstab
- [ ] /etc/fstab entry added
- [ ] Swap persists after reboot

### Monitoring Swap Usage:

```bash
# Check swap usage
free -h
# Shows used and available swap

# Detailed swap info
swapon -s
# Shows swap devices/files and usage

# Verbose output
sudo swapon -v

# Show by device
swapon -v

# Check what's using swap
# (Requires specialized tools like 'ps' or 'smem')
ps aux | sort -k6 -rn | head
```

### Troubleshooting:
**Problem:** "swapon: /dev/vg_production/lv_swap: insecure permissions"
```bash
# Solution: Might be after creating with lvextend
# Try disabling and re-enabling
sudo swapoff /dev/vg_production/lv_swap
sudo swapon /dev/vg_production/lv_swap
```

**Problem:** "Cannot allocate memory" when swap full
```bash
# Solution: Create additional swap space
sudo lvcreate -L 2G -n lv_swap2 vg_production
sudo mkswap /dev/vg_production/lv_swap2
sudo swapon /dev/vg_production/lv_swap2
```

---

## Lab Exercise 8: Integration Lab - Complete Storage Setup

**Objective:** Combine all concepts into a complete real-world scenario

**Prerequisites:**
- All previous labs completed OR
- Fresh disk for complete exercise

### Scenario:
A new production server arrives with three 100GB disks. You need to set up:
- Partitioned storage with GPT
- LVM for flexibility
- Multiple filesystems for organization
- Swap space for stability
- Persistent mounting with UUIDs

### Complete Workflow:

```bash
# ============================================================================
# PHASE 1: PARTITIONING
# ============================================================================

# Step 1: Identify three new disks
lsblk | grep -E "^sd[bc]"
# Should show /dev/sdb, /dev/sdc, /dev/sdd (each 100GB)

# Step 2: Partition each disk
for DISK in /dev/sdb /dev/sdc /dev/sdd; do
  sudo fdisk $DISK << EOF
g
n


+90G

n



w
EOF
  sudo partprobe $DISK
done

# Wait for partitions to appear
sleep 2

# Verify partitions
lsblk | grep -E "sd[bcd][0-9]"
# Should show: sdb1 (90GB), sdb2 (10GB), sdc1 (90GB), etc.

# ============================================================================
# PHASE 2: PHYSICAL VOLUMES
# ============================================================================

# Step 3: Create PVs on first partition of each disk (90GB each)
sudo pvcreate /dev/sdb1 /dev/sdc1 /dev/sdd1

# Verify
sudo pvs
# Should show 3 PVs, each 90GB

# Step 4: Create PVs on second partitions (10GB each, for swap)
sudo pvcreate /dev/sdb2 /dev/sdc2 /dev/sdd2

# ============================================================================
# PHASE 3: VOLUME GROUPS
# ============================================================================

# Step 5: Create main VG with first PVs (270GB total)
sudo vgcreate vg_main /dev/sdb1 /dev/sdc1 /dev/sdd1

# Verify
sudo vgs vg_main
# Should show 270GB total

# Step 6: Create swap VG
sudo vgcreate vg_swap /dev/sdb2 /dev/sdc2 /dev/sdd2

# ============================================================================
# PHASE 4: LOGICAL VOLUMES
# ============================================================================

# Step 7: Create LVs in main VG
sudo lvcreate -L 50G -n lv_root vg_main
sudo lvcreate -L 80G -n lv_var vg_main
sudo lvcreate -L 50G -n lv_home vg_main
sudo lvcreate -L 50G -n lv_database vg_main
sudo lvcreate -l 100%FREE -n lv_backup vg_main

# Verify
sudo lvs vg_main
# Should show 5 LVs totaling 270GB

# Step 8: Create swap LV
sudo lvcreate -l 100%FREE -n lv_swap vg_swap

# ============================================================================
# PHASE 5: FILESYSTEMS
# ============================================================================

# Step 9: Create filesystems
sudo mkfs.ext4 /dev/vg_main/lv_root
sudo mkfs.ext4 /dev/vg_main/lv_var
sudo mkfs.ext4 /dev/vg_main/lv_home
sudo mkfs.ext4 /dev/vg_main/lv_database
sudo mkfs.ext4 /dev/vg_main/lv_backup

# Step 10: Format swap
sudo mkswap /dev/vg_swap/lv_swap

# ============================================================================
# PHASE 6: MOUNTING
# ============================================================================

# Step 11: Create mount points
for MP in /root /var /home /database /backup; do
  sudo mkdir -p $MP
done

# Step 12: Mount filesystems
sudo mount /dev/vg_main/lv_root /root
sudo mount /dev/vg_main/lv_var /var
sudo mount /dev/vg_main/lv_home /home
sudo mount /dev/vg_main/lv_database /database
sudo mount /dev/vg_main/lv_backup /backup

# Step 13: Enable swap
sudo swapon /dev/vg_swap/lv_swap

# ============================================================================
# PHASE 7: PERSISTENT CONFIGURATION
# ============================================================================

# Step 14: Extract UUIDs
declare -A UUIDs
for LV in lv_root lv_var lv_home lv_database lv_backup; do
  UUIDs[$LV]=$(sudo blkid -s UUID -o value /dev/vg_main/$LV)
done

SWAP_UUID=$(sudo blkid -s UUID -o value /dev/vg_swap/lv_swap)

# Step 15: Add to /etc/fstab
sudo tee -a /etc/fstab << EOF
UUID=${UUIDs[lv_root]} / ext4 defaults,nofail 0 1
UUID=${UUIDs[lv_var]} /var ext4 defaults,nofail 0 2
UUID=${UUIDs[lv_home]} /home ext4 defaults,nofail 0 2
UUID=${UUIDs[lv_database]} /database ext4 defaults,nofail 0 2
UUID=${UUIDs[lv_backup]} /backup ext4 defaults,nofail 0 2
UUID=$SWAP_UUID none swap sw 0 0
EOF

# ============================================================================
# PHASE 8: VERIFICATION
# ============================================================================

# Step 16: Comprehensive verification
echo "=== Block Devices ==="
lsblk | head -20

echo -e "\n=== Physical Volumes ==="
sudo pvs

echo -e "\n=== Volume Groups ==="
sudo vgs

echo -e "\n=== Logical Volumes ==="
sudo lvs

echo -e "\n=== Mounts ==="
mount | grep vg_

echo -e "\n=== Disk Usage ==="
df -h /root /var /home /database /backup

echo -e "\n=== Swap ==="
free -h
swapon -s

echo -e "\n=== fstab Entries ==="
sudo grep -E "vg_(main|swap)" /etc/fstab

# Step 17: Test fstab
echo "Testing /etc/fstab..."
for MP in /var /home /database /backup; do
  sudo umount $MP || true
done

echo "Mounting all from fstab..."
sudo mount -a

# Verify all mounts
echo "Final verification:"
mount | grep vg_

# ============================================================================
# FINAL CHECKLIST
# ============================================================================

echo -e "\n=== FINAL CHECKLIST ==="
echo "✓ 3 disks partitioned with GPT"
echo "✓ 6 physical volumes created"
echo "✓ 2 volume groups created (main + swap)"
echo "✓ 6 logical volumes created"
echo "✓ 5 filesystems mounted"
echo "✓ 1 swap space enabled"
echo "✓ All entries in /etc/fstab with UUIDs"
echo "✓ Total capacity: 270GB data + 30GB swap"
echo -e "\n=== Setup Complete ==="
```

### Verification Summary:

```bash
# Quick verification commands:

# 1. Storage hierarchy
sudo vgdisplay -v

# 2. LV to device mapping
sudo lvdisplay -m

# 3. All mounts
mount | grep vg_

# 4. Capacity summary
df -h | grep -E "(Filesystem|/root|/var|/home|/database|/backup)"

# 5. Swap status
free -h

# 6. fstab entries
sudo grep UUID /etc/fstab | grep -E "(vg_main|vg_swap)"

# 7. Filesystem integrity
for FS in /root /var /home /database /backup; do
  echo "=== $FS ===" 
  sudo e2fsck -n /dev/vg_main/$(basename $FS | sed 's/^/lv_/')
done
```

---

## Troubleshooting Quick Reference

### Common Issues:

| Problem | Solution |
|---------|----------|
| Partition not visible | Run `sudo partprobe /dev/sda` |
| PV already exists | Use `sudo pvremove /dev/sdaX` first |
| Can't extend LV | Check `sudo vgs` for free space |
| Mount fails at boot | Test with `sudo mount -a` and check UUID |
| Swap not working | Verify with `swapon -s` and check /etc/fstab |
| LV resize2fs fails | Unmount, run `e2fsck`, then resize |
| Out of free extents | Extend VG by adding new PV with `vgextend` |

### Diagnostic Commands:

```bash
# 1. Full storage status
lsblk
sudo pvs -v
sudo vgs -v
sudo lvs -v
mount

# 2. Check for errors
sudo dmesg | tail -20
sudo e2fsck -n /dev/vg/lv   # (Read-only check)

# 3. Verify configuration
sudo mount -a               # Test fstab
sudo swapon -a             # Test swap

# 4. Cleanup if needed
sudo lvremove -f /dev/vg/lv
sudo vgremove -f vg_name
sudo pvremove /dev/sdaX
```

---

**End of Lab Exercises - Module 3: Configure Local Storage**

*Complete these labs before attempting the RHCSA exam*
