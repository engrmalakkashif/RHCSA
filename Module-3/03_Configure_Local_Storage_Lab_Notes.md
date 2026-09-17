# RHCSA Exam Preparation: Configure Local Storage
## Detailed Lab Notes & Study Guide
## Module 3

---

## Table of Contents

1. [List, Create, and Delete Partitions on GPT Disks](#list-create-and-delete-partitions-on-gpt-disks)
2. [Create and Remove Physical Volumes](#create-and-remove-physical-volumes)
3. [Assign Physical Volumes to Volume Groups](#assign-physical-volumes-to-volume-groups)
4. [Create and Delete Logical Volumes](#create-and-delete-logical-volumes)
5. [Configure Mount Points with UUID/Label](#configure-mount-points-with-uuidlabel)
6. [Add New Storage Non-Destructively](#add-new-storage-non-destructively)
7. [Swap Space Management](#swap-space-management)
8. [Lab Exercises & Practice](#lab-exercises--practice)

---

## List, Create, and Delete Partitions on GPT Disks

### Understanding Disk Architecture

#### MBR vs GPT

```
MBR (Master Boot Record):
├── Size: Maximum 2TB
├── Partitions: Maximum 4 primary
├── Used by: Older BIOS systems
└── Status: Legacy, becoming obsolete

GPT (GUID Partition Table):
├── Size: Maximum 9.4 zettabytes
├── Partitions: Practical unlimited
├── Used by: UEFI systems (modern)
└── Status: Industry standard for new systems
```

### Viewing Disk Information

#### Using `lsblk` Command

```bash
# List all block devices
lsblk
# Output shows: NAME, MAJ:MIN, RM, SIZE, RO, TYPE, MOUNTPOINT

# Example output:
# NAME            MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT
# sda               8:0    0  100G  0 disk
# ├─sda1            8:1    0    1G  0 part  /boot
# ├─sda2            8:2    0   99G  0 part
# │ ├─cl-root     253:0    0   50G  0 lvm   /
# │ └─cl-swap     253:1    0    4G  0 lvm   [SWAP]
# sdb               8:16   0  200G  0 disk

# Show partition types
lsblk -o NAME,SIZE,TYPE,PARTTYPE
lsblk --fs                      # Show filesystems

# Show all details
lsblk -a                        # Include empty devices
lsblk -i                        # Tree view
lsblk -S                        # SCSI attributes
```

#### Using `fdisk` Command

```bash
# View disk information
sudo fdisk -l                   # List all disks

# View specific disk
sudo fdisk -l /dev/sda

# Output shows:
# Disk /dev/sda: 100 GiB, 107374182400 bytes, 209715200 sectors
# Disk model: QEMU HARDDISK
# Units: sectors of 1 * 512 = 512 bytes
# Sector size (logical/physical): 512 bytes / 512 bytes
# I/O size (minimum/optimal): 512 bytes / 512 bytes

# Interactive mode (for GPT disks)
sudo fdisk /dev/sda
# Commands: n(ew), d(elete), p(rint), w(rite), q(uit)
```

#### Using `parted` Command

```bash
# View disk information
sudo parted -l                  # List all disks

# View specific disk
sudo parted /dev/sda print

# Output shows:
# Model: QEMU HARDDISK (scsi)
# Disk /dev/sda: 107GB
# Sector size (logical/physical): 512B/512B
# Partition Table: gpt
# Disk Flags: pmbr_boot
# Number  Start   End     Size   File system  Name  Flags
#  1      1049kB  1075MB  1074MB ext4         boot  boot, esp
#  2      1075MB  107GB   106GB

# Interactive mode
sudo parted /dev/sda
# Commands: print, mkpart, rm, help, quit
```

### Creating Partitions with `fdisk`

#### GPT Partition Creation

```bash
# Enter interactive mode
sudo fdisk /dev/sda

# Inside fdisk prompt (fdisk>):
g                               # Create new GPT partition table
# Creates GPT table, WARNING: Erases all partitions!

n                               # Add new partition
# Partition number: 1
# First sector: (press Enter for default)
# Last sector: +50G (for 50GB partition)
# Or: +50% (for 50% of remaining space)
# Or: (press Enter for all remaining)

# Create another partition
n
# Partition number: 2
# Use remaining space
# Last sector: (press Enter)

# View partitions
p                               # Print partition table

# Write changes (IRREVERSIBLE)
w                               # Write and exit

# Or exit without saving
q                               # Quit without saving
```

#### Practical Examples

```bash
# Example 1: Create two equal partitions on new disk
sudo fdisk /dev/sdb

g                               # Create GPT table
n                               # Partition 1
# Accept defaults until "Last sector"
+50%                            # 50% of disk
n                               # Partition 2
# Press Enter for all remaining
p                               # Print to verify
w                               # Write changes

# Verify
sudo lsblk /dev/sdb
sudo fdisk -l /dev/sdb
```

### Creating Partitions with `parted`

#### Interactive Mode

```bash
# Start parted
sudo parted /dev/sdb

# Create GPT partition table
mklabel gpt
# Warning: This will erase all data. Proceed? yes

# Create partitions
mkpart primary 0% 50%           # 50% of disk
mkpart primary 50% 100%         # Rest of disk

# View partitions
print

# Exit
quit
```

#### Command Line Mode

```bash
# Create GPT without entering interactive mode
sudo parted -s /dev/sdb mklabel gpt

# Create partition directly
sudo parted -s /dev/sdb mkpart primary 0% 50%
sudo parted -s /dev/sdb mkpart primary 50% 100%

# Verify
sudo parted -l /dev/sdb
sudo lsblk /dev/sdb
```

### Deleting Partitions

#### Using `fdisk`

```bash
# Delete partition with fdisk
sudo fdisk /dev/sda

d                               # Delete partition
# Which partition to delete? 3  # Choose partition number

p                               # Print to verify deletion
w                               # Write changes
```

#### Using `parted`

```bash
# Delete partition with parted
sudo parted /dev/sda

rm 3                            # Remove partition 3
# This will destroy all data on partition 3. Proceed? yes

print                           # Verify
quit                            # Exit
```

#### Using `partprobe` to Notify Kernel

```bash
# After creating/deleting partitions, inform kernel
sudo partprobe /dev/sda
# Or: sudo partprobe -s      # Show partitions

# Or reboot system
sudo reboot

# Or rescan with:
echo "1" | sudo tee /sys/class/scsi_host/host0/scan
```

---

## Create and Remove Physical Volumes

### Understanding LVM (Logical Volume Manager)

```
Physical Volumes (PV)
        ↓
    Volume Groups (VG)
        ↓
    Logical Volumes (LV)
        ↓
    Mount Points
```

**Benefits of LVM:**
- Flexible partition sizing
- Easy expansion
- Snapshots capability
- Device mapping
- Non-destructive resizing

### Creating Physical Volumes

#### Using `pvcreate`

```bash
# Create physical volume from partition
sudo pvcreate /dev/sda3
# Physical volume "/dev/sda3" successfully created.

# Create from multiple partitions
sudo pvcreate /dev/sda3 /dev/sdb1 /dev/sdb2

# Create with options
sudo pvcreate --metadatasize 30m /dev/sda3
# Set metadata size

# Create with specific data alignment
sudo pvcreate --dataalignment 1m /dev/sda3
```

#### Viewing Physical Volumes

```bash
# List all physical volumes
sudo pvs
# Output: PV         VG     Fmt  Attr PSize  PFree
#         /dev/sda3  cl     lvm2 a--  46.51g     0
#         /dev/sdb1  vg_data lvm2 a-- 100.00g 50.00g

# Detailed view
sudo pvdisplay
# Shows: PV Name, VG Name, PV Size, PE Size, Total PE, Free PE, etc.

# Show specific PV
sudo pvdisplay /dev/sda3

# Show allocation
sudo pvs -o +pv_used,pv_free
```

### Removing Physical Volumes

#### Cautions Before Removal

```bash
# Check if PV is in use
sudo pvs                        # Verify which VGs use the PV
sudo lvs -o +devices            # Show which LVs use which devices

# Move data if necessary
sudo pvmove /dev/sda3
# Moves all LV data from /dev/sda3 to other PVs (if space available)

# Reduce LV if necessary
sudo lvresize -L -20G /dev/vg_name/lv_name
# Reduces logical volume to free space
```

#### Removing Physical Volume

```bash
# Remove PV from volume group first
sudo vgreduce vg_name /dev/sda3
# Removed "/dev/sda3" from volume group "vg_name"

# Remove physical volume
sudo pvremove /dev/sda3
# Labels on physical volume "/dev/sda3" successfully wiped

# Verify removal
sudo pvs                        # Should not show /dev/sda3
```

### Practical Scenarios

```bash
# Scenario 1: Add new disk as physical volume
# 1. Partition the disk
sudo fdisk /dev/sdb
# (create one large partition /dev/sdb1)

# 2. Create physical volume
sudo pvcreate /dev/sdb1

# 3. Verify
sudo pvs
sudo pvdisplay /dev/sdb1

# Scenario 2: Replace failed PV
# 1. Move data from failing PV
sudo pvmove /dev/sda3 /dev/sdb1

# 2. Remove from VG
sudo vgreduce vg_name /dev/sda3

# 3. Remove PV
sudo pvremove /dev/sda3

# 4. Replace physical disk
# (Physical replacement of hardware)

# 5. Create new PV
sudo pvcreate /dev/sda3

# 6. Add to VG
sudo vgextend vg_name /dev/sda3
```

---

## Assign Physical Volumes to Volume Groups

### Creating Volume Groups

#### Using `vgcreate`

```bash
# Create new volume group
sudo vgcreate vg_storage /dev/sdb1
# Volume group "vg_storage" successfully created

# Create with multiple physical volumes
sudo vgcreate vg_data /dev/sdb1 /dev/sdb2 /dev/sdb3

# Specify extent size (default 4MB)
sudo vgcreate -s 8m vg_storage /dev/sdb1
# -s: Specify extent (Physical Extent) size
# Valid sizes: 1MB, 2MB, 4MB, 8MB, 16MB, 32MB, 64MB, 128MB, 256MB, 512MB, 1GB

# Useful for performance tuning:
# Larger extents: More space per extent, faster allocation, less overhead
# Smaller extents: Finer granularity, more flexibility, more overhead
```

### Viewing Volume Groups

```bash
# List all volume groups
sudo vgs
# Output: VG      #PV #LV #SN Attr   VSize  VFree
#         cl        1   2   0 wz--n- 46.51g     0
#         vg_data   2   0   0 wz--n-100.00g 100.00g

# Detailed view
sudo vgdisplay
# Shows: VG Name, System ID, Format, Metadata Areas, PE Size, Total PE, Free PE, etc.

# Show specific VG
sudo vgdisplay vg_storage

# Show allocation details
sudo vgs -o name,size,free,pv_count,lv_count
```

### Adding Physical Volumes to Existing Volume Group

#### Using `vgextend`

```bash
# Extend existing VG with new PV
sudo vgextend vg_storage /dev/sdb2
# Volume group "vg_storage" successfully extended

# Extend with multiple PVs
sudo vgextend vg_storage /dev/sdc1 /dev/sdc2

# Verify extension
sudo vgs vg_storage             # Shows increased size
sudo vgdisplay vg_storage       # Detailed info

# Show PVs in VG
sudo vgdisplay -m vg_storage    # Shows PE allocation map
```

### Removing Physical Volumes from Volume Group

#### Using `vgreduce`

```bash
# Remove PV from VG
sudo vgreduce vg_storage /dev/sdb2
# Removed "/dev/sdb2" from volume group "vg_storage"

# Conditions:
# - All LVs must have space on remaining PVs
# - Can use pvmove to migrate data first

# Example: Migrate and remove
sudo pvmove /dev/sdb2          # Moves data to other PVs
sudo vgreduce vg_storage /dev/sdb2
sudo pvremove /dev/sdb2
```

### Removing Volume Groups

#### Using `vgremove`

```bash
# Remove entire volume group (must be inactive)
sudo vgremove vg_storage
# Volume group "vg_storage" successfully removed

# Remove with confirmation
sudo vgremove -f vg_storage    # -f: Force (no confirmation)

# Note: All LVs must be removed first
# To force remove LVs:
sudo vgremove -f -ff vg_storage  # -ff: Force remove LVs too
```

### Practical Workflow

```bash
# Complete workflow: Create and manage VG

# 1. Create physical volumes
sudo pvcreate /dev/sdb1 /dev/sdb2

# 2. Create volume group
sudo vgcreate vg_storage /dev/sdb1

# 3. Verify VG
sudo vgs
sudo vgdisplay vg_storage

# 4. Add second PV to VG
sudo vgextend vg_storage /dev/sdb2

# 5. Verify extended VG
sudo vgdisplay vg_storage
# Shows total size increased

# 6. Later, remove one PV
sudo pvmove /dev/sdb2
sudo vgreduce vg_storage /dev/sdb2

# 7. Finally, remove entire VG
sudo vgremove vg_storage
```

---

## Create and Delete Logical Volumes

### Creating Logical Volumes

#### Using `lvcreate`

```bash
# Create logical volume (specified size)
sudo lvcreate -L 20G -n lv_home vg_storage
# -L: Specify size
# -n: Logical volume name
# Last parameter: Volume group name

# Create LV using percentage of VG
sudo lvcreate -l 50%VG -n lv_var vg_storage
# Uses 50% of VG free space

# Create using percentage of remaining
sudo lvcreate -l 100%FREE -n lv_data vg_storage
# Uses all remaining free space in VG

# Create LV with specific extents
sudo lvcreate -l 2560 -n lv_backup vg_storage
# 2560 extents (multiply by PE size for total size)
# If PE size is 4MB: 2560 * 4MB = 10.24GB

# Create striped logical volume (RAID 0)
sudo lvcreate -L 50G -i 2 -I 64 -n lv_striped vg_storage
# -i 2: Stripe across 2 physical volumes
# -I 64: Stripe size 64KB (must be power of 2)

# Create mirrored logical volume (RAID 1)
sudo lvcreate -L 50G -m 1 -n lv_mirror vg_storage
# -m 1: One mirror (creates 2 copies total)
```

### Viewing Logical Volumes

```bash
# List all logical volumes
sudo lvs
# Output: LV       VG        Attr       LSize  Pool Origin Data%  Meta%
#         home     vg_storage -wi-ao---- 20.00g
#         var      vg_storage -wi-ao---- 50.00g
#         data     vg_storage -wi-ao---- 30.00g

# Detailed view
sudo lvdisplay
# Shows: LV Path, LV Name, VG Name, LV Size, LV Status, Open count, etc.

# Show specific LV
sudo lvdisplay /dev/vg_storage/lv_home
sudo lvdisplay -m vg_storage/lv_home     # Show mapping

# Show LV with devices
sudo lvs -o +devices
```

### Resizing Logical Volumes

#### Growing a Logical Volume

```bash
# Extend logical volume (add 10GB)
sudo lvextend -L +10G /dev/vg_storage/lv_home
# Size of logical volume vg_storage/lv_home changed from 20.00 GiB to 30.00 GiB.

# Extend to specific size
sudo lvextend -L 50G /dev/vg_storage/lv_home
# Resizes to exactly 50GB

# Extend using percentage
sudo lvextend -l +50%VG /dev/vg_storage/lv_home
# Add 50% of VG free space

# Extend to use all available space
sudo lvextend -l +100%FREE /dev/vg_storage/lv_home

# Extend across multiple devices
sudo lvextend -L +20G /dev/vg_storage/lv_data /dev/sdb3 /dev/sdc1

# Note: After extending LV, must extend filesystem too
# For ext4:
sudo resize2fs /dev/vg_storage/lv_home
# For xfs:
sudo xfs_growfs /mount/point
```

#### Reducing a Logical Volume

```bash
# CAUTION: Reducing LV risks data loss - backup first!

# Check if filesystem supports shrinking
# ext4: Yes (with resize2fs)
# xfs: No (cannot shrink)
# btrfs: Experimental

# Steps to reduce ext4 LV:
# 1. Unmount filesystem
sudo umount /home

# 2. Check and resize filesystem (smaller than target LV size)
sudo e2fsck -f /dev/vg_storage/lv_home
sudo resize2fs /dev/vg_storage/lv_home 15G

# 3. Reduce logical volume
sudo lvreduce -L 15G /dev/vg_storage/lv_home
# Size of logical volume vg_storage/lv_home changed from 30.00 GiB to 15.00 GiB.

# 4. Remount filesystem
sudo mount /dev/vg_storage/lv_home /home

# Verify
df -h /home
sudo lvs
```

### Deleting Logical Volumes

#### Using `lvremove`

```bash
# Remove logical volume
sudo lvremove /dev/vg_storage/lv_backup
# Do you really want to remove active logical volume vg_storage/lv_backup? [y/n]: y
# Logical volume "lv_backup" successfully removed

# Force removal (no confirmation)
sudo lvremove -f /dev/vg_storage/lv_backup

# Remove multiple LVs
sudo lvremove /dev/vg_storage/lv_temp /dev/vg_storage/lv_test

# Remove all LVs in VG (be careful!)
sudo lvremove vg_storage
```

---

## Configure Mount Points with UUID/Label

### Understanding Mounting

```
Partition/LV ↓
Filesystem Created ↓
Mount Point Assigned ↓
Files Accessible
```

### Finding UUID and Labels

#### Using `blkid`

```bash
# Show all devices with UUID and labels
sudo blkid
# Output:
# /dev/sda1: UUID="abc123" TYPE="ext4" PARTUUID="xyz789"
# /dev/sda2: UUID="def456" TYPE="lvm2_member" PARTUUID="abc456"
# /dev/mapper/vg_storage-lv_home: UUID="789abc" TYPE="ext4"

# Show specific device
sudo blkid /dev/vg_storage/lv_home
# /dev/mapper/vg_storage-lv_home: UUID="789abc" TYPE="ext4"

# Show only UUIDs
sudo blkid -o value -s UUID /dev/vg_storage/lv_home
# 789abc
```

#### Using `lsblk`

```bash
# Show block devices with UUIDs
lsblk -f
# Output:
# NAME                  FSTYPE      LABEL UUID
# sda
# ├─sda1                ext4        boot  abc123
# ├─sda2                lvm2_member       def456
# │ ├─vg_storage-lv_home ext4              789abc
# │ └─vg_storage-lv_data ext4              xyz789

# Show just UUID
lsblk -o name,uuid /dev/sda
```

#### Using `tune2fs` (for ext4)

```bash
# Show ext4 filesystem UUID
sudo tune2fs -l /dev/vg_storage/lv_home | grep UUID
# UUID:                 789abc

# Change UUID
sudo tune2fs -U random /dev/vg_storage/lv_home
# New UUID assigned
```

#### Using `xfs_admin` (for XFS)

```bash
# Show XFS filesystem UUID
sudo xfs_admin -u /dev/vg_storage/lv_data
# UUID = xyz789

# Change UUID
sudo xfs_admin -U ffffffff /dev/vg_storage/lv_data
```

### Setting Labels

#### Ext4 Filesystems

```bash
# Set label on ext4
sudo e2label /dev/vg_storage/lv_home home_data
# Change label to "home_data"

# Show label
sudo e2label /dev/vg_storage/lv_home
# home_data

# Remove label (set empty)
sudo e2label /dev/vg_storage/lv_home ""
```

#### XFS Filesystems

```bash
# Set label on XFS
sudo xfs_admin -L backup /dev/vg_storage/lv_data
# Label set to "backup"

# Show label
sudo xfs_admin -L /dev/vg_storage/lv_data
# label = "backup"

# Remove label
sudo xfs_admin -L "" /dev/vg_storage/lv_data
```

### Mounting with UUID or Label

#### Manual Mount

```bash
# Mount using UUID
sudo mount UUID=789abc /home
# Mounts filesystem with UUID 789abc to /home

# Mount using label
sudo mount LABEL=home_data /home
# Mounts filesystem labeled "home_data" to /home

# Verify mount
mount | grep /home
df -h /home
```

#### Permanent Mount with /etc/fstab

```bash
# Edit /etc/fstab
sudo vi /etc/fstab

# Add entry using UUID
UUID=789abc /home ext4 defaults,nofail 0 2
# Columns: UUID/Device MountPoint FSType Options DumpFreq PassNum

# Add entry using label
LABEL=home_data /home ext4 defaults,nofail 0 2

# Common options:
# defaults: rw, suid, dev, exec, auto, nouser, async
# nofail: Don't fail boot if mount fails
# nouser: Can't be mounted by non-root users
# ro: Read-only
# acl: Enable POSIX ACLs
# errors=remount-ro: Remount as read-only on error
```

#### Applying fstab Changes

```bash
# Test fstab syntax
sudo mount -a
# Attempts to mount all in fstab (check for errors)

# Verify specific mount
mount | grep /home

# Check fstab for errors
sudo mount -t ext4 UUID=789abc /mnt/test
# Temporary mount to test
sudo umount /mnt/test
```

---

## Add New Storage Non-Destructively

### Workflow for Adding Storage

```
1. Identify unused disk/partition
   ↓
2. Create physical volume
   ↓
3. Create or extend volume group
   ↓
4. Create or extend logical volume
   ↓
5. Create filesystem
   ↓
6. Mount filesystem
   ↓
7. Update /etc/fstab for persistence
```

### Practical Example: Add 50GB Storage

```bash
# Step 1: Identify available disk
lsblk
# Find /dev/sdb (new 50GB disk)

# Step 2: Partition new disk
sudo fdisk /dev/sdb
g               # Create GPT partition table
n               # New partition
# Accept all defaults for entire disk
w               # Write

# Verify
sudo lsblk /dev/sdb
# /dev/sdb1 should appear (50GB)

# Step 3: Create physical volume
sudo pvcreate /dev/sdb1

# Step 4a: Create new VG (if no existing VG)
sudo vgcreate vg_storage /dev/sdb1

# Step 4b: OR extend existing VG
sudo vgextend vg_storage /dev/sdb1

# Step 5: Create logical volume
sudo lvcreate -l 100%FREE -n lv_data vg_storage

# Step 6: Create filesystem
sudo mkfs.ext4 /dev/vg_storage/lv_data

# Step 7: Mount filesystem
sudo mkdir -p /data
sudo mount /dev/vg_storage/lv_data /data

# Step 8: Get UUID
UUID=$(sudo blkid -s UUID -o value /dev/vg_storage/lv_data)
echo $UUID

# Step 9: Add to /etc/fstab
echo "UUID=$UUID /data ext4 defaults,nofail 0 2" | sudo tee -a /etc/fstab

# Step 10: Verify
sudo mount -a
df -h /data
```

### Growing Existing Logical Volume

```bash
# Scenario: /home is full, need to add 20GB

# Step 1: Verify free space in VG
sudo vgs vg_storage
# Shows: VFree

# Step 2: Extend logical volume
sudo lvextend -L +20G /dev/vg_storage/lv_home

# Step 3: Extend filesystem
# For ext4:
sudo resize2fs /dev/vg_storage/lv_home
# For xfs:
sudo xfs_growfs /home

# Step 4: Verify
df -h /home
sudo lvs /dev/vg_storage/lv_home
```

### Adding to Existing Mount Point

```bash
# Scenario: /var needs more space, but can't expand current LV

# Step 1: Create new LV
sudo lvcreate -L 50G -n lv_var_new vg_storage

# Step 2: Create filesystem
sudo mkfs.ext4 /dev/vg_storage/lv_var_new

# Step 3: Mount temporarily
sudo mount /dev/vg_storage/lv_var_new /mnt/var_new

# Step 4: Copy existing data
sudo cp -a /var/* /mnt/var_new/

# Step 5: Unmount both
sudo umount /var
sudo umount /mnt/var_new

# Step 6: Remove old LV
sudo lvremove /dev/vg_storage/lv_var

# Step 7: Rename new LV
sudo lvrename vg_storage/lv_var_new vg_storage/lv_var

# Step 8: Mount new LV
sudo mount /dev/vg_storage/lv_var /var

# Step 9: Update /etc/fstab UUID
```

---

## Swap Space Management

### Understanding Swap

```
Swap: Virtual memory on disk
├── Used when: Physical RAM full
├── Speed: Slower than RAM
├── Purpose: Prevent out-of-memory errors
└── Typical size: 0.5x to 2x physical RAM
```

### Creating Swap

#### On Partition

```bash
# Step 1: Create partition (at least 1GB recommended)
sudo fdisk /dev/sdb
n               # New partition
# Size: +8G

# Step 2: Change partition type to swap
t               # Type
# Hex code: 8200 (for GPT) or 82 (for MBR)

# Step 3: Format partition as swap
sudo mkswap /dev/sdb2

# Step 4: Enable swap
sudo swapon /dev/sdb2

# Step 5: Verify
swapon -s                       # Show active swap
sudo swapon -v                  # Verbose output

# Step 6: Add to /etc/fstab
echo "/dev/sdb2 none swap sw 0 0" | sudo tee -a /etc/fstab
```

#### On Logical Volume

```bash
# Step 1: Create logical volume
sudo lvcreate -L 8G -n lv_swap vg_storage

# Step 2: Format as swap
sudo mkswap /dev/vg_storage/lv_swap

# Step 3: Enable swap
sudo swapon /dev/vg_storage/lv_swap

# Step 4: Get UUID
UUID=$(sudo blkid -s UUID -o value /dev/vg_storage/lv_swap)

# Step 5: Add to /etc/fstab
echo "UUID=$UUID none swap sw 0 0" | sudo tee -a /etc/fstab

# Step 6: Verify
free -h                        # Show RAM and swap
swapon -s
```

#### On File

```bash
# Create swap file (without partitioning)
# Step 1: Create 4GB file
sudo fallocate -l 4G /swapfile
# OR: sudo dd if=/dev/zero of=/swapfile bs=1M count=4096

# Step 2: Set permissions
sudo chmod 600 /swapfile

# Step 3: Format as swap
sudo mkswap /swapfile

# Step 4: Enable swap
sudo swapon /swapfile

# Step 5: Add to /etc/fstab
echo "/swapfile none swap sw 0 0" | sudo tee -a /etc/fstab

# Step 6: Verify
free -h
swapon -s
```

### Managing Swap

```bash
# Show current swap usage
free -h
# Output: Mem:  7.7G ... Swap:  8.0G  0B  8.0G

# Show all swap areas
swapon -s
# Output: Filename, Type, Size, Used, Priority

# Show detailed swap info
sudo swapon -v

# Disable swap area
sudo swapoff /dev/sdb2
# Or: sudo swapoff /swapfile

# Change swap priority
sudo swapon -p 100 /dev/sdb2
# -p: Priority (higher = prefer this swap)

# Temporarily free swap
# (Requires enough RAM!)
# sudo swapoff -a                 # Disable all swap
# sudo swapon -a                  # Re-enable all swap
```

---

## Lab Exercises & Practice

### Exercise 1: Partition Disks

```bash
# 1.1 - View existing disks
lsblk
sudo fdisk -l

# 1.2 - Identify new disk
lsblk | grep sdb
# Should show new unpartitioned disk

# 1.3 - Create partitions
sudo fdisk /dev/sdb
g                   # GPT table
n                   # Partition 1 (10GB)
+10G
n                   # Partition 2 (20GB)
+20G
n                   # Partition 3 (rest)

p                   # Print
w                   # Write

# 1.4 - Verify partitions
lsblk /dev/sdb
sudo fdisk -l /dev/sdb
```

### Exercise 2: LVM Physical Volumes

```bash
# 2.1 - Create physical volumes
sudo pvcreate /dev/sdb1 /dev/sdb2 /dev/sdb3

# 2.2 - View PVs
sudo pvs
sudo pvdisplay

# 2.3 - Show specific PV info
sudo pvdisplay /dev/sdb1

# 2.4 - Show PV sizes
sudo pvs -o +pv_used,pv_free
```

### Exercise 3: LVM Volume Groups

```bash
# 3.1 - Create volume group
sudo vgcreate vg_mydata /dev/sdb1 /dev/sdb2

# 3.2 - View volume group
sudo vgs vg_mydata
sudo vgdisplay vg_mydata

# 3.3 - Extend volume group
sudo vgextend vg_mydata /dev/sdb3

# 3.4 - Verify extension
sudo vgs vg_mydata
```

### Exercise 4: LVM Logical Volumes

```bash
# 4.1 - Create logical volumes
sudo lvcreate -L 15G -n lv_data vg_mydata
sudo lvcreate -l 50%VG -n lv_backup vg_mydata
sudo lvcreate -l 100%FREE -n lv_archive vg_mydata

# 4.2 - View logical volumes
sudo lvs
sudo lvdisplay vg_mydata

# 4.3 - Extend logical volume
sudo lvextend -L +5G /dev/vg_mydata/lv_data

# 4.4 - Show LV mapping
sudo lvdisplay -m vg_mydata/lv_data
```

### Exercise 5: Mount with UUID

```bash
# 5.1 - Create filesystems
sudo mkfs.ext4 /dev/vg_mydata/lv_data
sudo mkfs.ext4 /dev/vg_mydata/lv_backup

# 5.2 - Get UUIDs
sudo blkid /dev/vg_mydata/lv_data
sudo blkid /dev/vg_mydata/lv_backup

# 5.3 - Create mount points
sudo mkdir -p /mnt/data /mnt/backup

# 5.4 - Mount using UUID
UUID_DATA=$(sudo blkid -s UUID -o value /dev/vg_mydata/lv_data)
UUID_BACKUP=$(sudo blkid -s UUID -o value /dev/vg_mydata/lv_backup)

sudo mount UUID=$UUID_DATA /mnt/data
sudo mount UUID=$UUID_BACKUP /mnt/backup

# 5.5 - Verify mounts
mount | grep /mnt
df -h /mnt/data
df -h /mnt/backup
```

### Exercise 6: Add Swap

```bash
# 6.1 - Create swap LV
sudo lvcreate -L 4G -n lv_swap vg_mydata

# 6.2 - Format as swap
sudo mkswap /dev/vg_mydata/lv_swap

# 6.3 - Enable swap
sudo swapon /dev/vg_mydata/lv_swap

# 6.4 - Verify swap
free -h
swapon -s

# 6.5 - Get UUID and add to fstab
UUID_SWAP=$(sudo blkid -s UUID -o value /dev/vg_mydata/lv_swap)
echo "UUID=$UUID_SWAP none swap sw 0 0" | sudo tee -a /etc/fstab
```

### Integration Exercise: Complete Setup

```bash
# Complete scenario: Build storage from scratch

# 1. Partition
sudo fdisk /dev/sdb
# (create 3 partitions: 10GB, 20GB, rest)

# 2. Create PVs
sudo pvcreate /dev/sdb1 /dev/sdb2 /dev/sdb3

# 3. Create VG
sudo vgcreate vg_production /dev/sdb1 /dev/sdb2

# 4. Create LVs
sudo lvcreate -L 15G -n lv_database vg_production
sudo lvcreate -L 20G -n lv_files vg_production
sudo lvcreate -l 100%FREE -n lv_backup vg_production

# 5. Add third PV to VG
sudo vgextend vg_production /dev/sdb3

# 6. Extend backup LV with new PV space
sudo lvextend -l +100%FREE /dev/vg_production/lv_backup

# 7. Create filesystems
sudo mkfs.ext4 /dev/vg_production/lv_database
sudo mkfs.ext4 /dev/vg_production/lv_files
sudo mkfs.ext4 /dev/vg_production/lv_backup

# 8. Mount filesystems
sudo mkdir -p /database /files /backup
sudo mount /dev/vg_production/lv_database /database
sudo mount /dev/vg_production/lv_files /files
sudo mount /dev/vg_production/lv_backup /backup

# 9. Set labels and get UUIDs
for LV in lv_database lv_files lv_backup; do
    DEV="/dev/vg_production/$LV"
    sudo e2label $DEV $LV
    UUID=$(sudo blkid -s UUID -o value $DEV)
    echo "UUID=$UUID /$(echo $LV | sed 's/lv_//') ext4 defaults,nofail 0 2" | \
        sudo tee -a /etc/fstab
done

# 10. Create swap
sudo lvcreate -L 4G -n lv_swap vg_production
sudo mkswap /dev/vg_production/lv_swap
sudo swapon /dev/vg_production/lv_swap
UUID_SWAP=$(sudo blkid -s UUID -o value /dev/vg_production/lv_swap)
echo "UUID=$UUID_SWAP none swap sw 0 0" | sudo tee -a /etc/fstab

# 11. Verify all
lsblk
sudo vgs
sudo lvs
mount | grep /database
free -h
swapon -s
```

---

## Summary & Key Commands

### Storage Management Commands

```bash
# Partitioning
fdisk /dev/sda                  # MBR/GPT partition editor
parted /dev/sda                 # Advanced partition editor
lsblk                           # List block devices
blkid                           # Show UUIDs and labels

# Physical Volumes
pvcreate /dev/sdaX              # Create PV
pvs / pvdisplay                 # View PVs
pvremove /dev/sdaX              # Remove PV
pvmove /dev/sdaX                # Move data

# Volume Groups
vgcreate vg_name /dev/sdaX      # Create VG
vgs / vgdisplay                 # View VGs
vgextend vg_name /dev/sdaX      # Add PV to VG
vgreduce vg_name /dev/sdaX      # Remove PV from VG
vgremove vg_name                # Remove VG

# Logical Volumes
lvcreate -L 20G -n lv_name vg_name  # Create LV
lvs / lvdisplay                 # View LVs
lvextend -L +10G /dev/vg/lv     # Extend LV
lvreduce -L 10G /dev/vg/lv      # Reduce LV
lvremove /dev/vg/lv             # Remove LV

# Mounting
mount UUID=... /mount/point     # Mount by UUID
mount LABEL=... /mount/point    # Mount by label
umount /mount/point             # Unmount

# Swap
mkswap /dev/sdaX                # Create swap
swapon /dev/sdaX                # Enable swap
swapoff /dev/sdaX               # Disable swap
free -h                         # Show swap usage
```

---

## Exam Tips

1. **Understand LVM hierarchy** - PV → VG → LV
2. **Use UUIDs not device names** - More reliable
3. **Test fstab** - Always run `mount -a` before reboot
4. **Backup before shrinking** - Data loss risk
5. **Know the tools** - fdisk, parted, lvm commands
6. **Practice non-destructively** - Use virtual machines
7. **Remember extents** - LVM uses extents for allocation
8. **Verify all steps** - Use lsblk, mount, df to check

---

**End of Module 3: Configure Local Storage**

*Complete this module before moving to Module 4*
