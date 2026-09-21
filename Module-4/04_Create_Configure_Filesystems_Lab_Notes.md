# RHCSA Exam Preparation: Create and Configure File Systems
## Comprehensive Lab Notes & Study Guide

---

## Table of Contents
1. [Filesystem Fundamentals](#filesystem-fundamentals)
2. [Creating Filesystems](#creating-filesystems)
3. [Mounting Filesystems](#mounting-filesystems)
4. [ext4 Filesystem](#ext4-filesystem)
5. [XFS Filesystem](#xfs-filesystem)
6. [VFAT Filesystem](#vfat-filesystem)
7. [Network File Systems (NFS)](#network-file-systems-nfs)
8. [Autofs Configuration](#autofs-configuration)
9. [Extending Logical Volumes](#extending-logical-volumes)
10. [File Permission Troubleshooting](#file-permission-troubleshooting)
11. [Lab Exercises & Practice](#lab-exercises--practice)

---

## Filesystem Fundamentals

### What is a Filesystem?

A filesystem is the organizational structure that stores files and directories on a storage device. It manages how data is stored, retrieved, and organized.

```bash
# Common Linux filesystems
ext4        # Extended filesystem 4 (modern ext filesystem)
xfs         # eXtensible filesystem (high-performance)
btrfs       # B-tree filesystem (advanced features)
vfat        # FAT32 (Windows compatible)
ntfs        # NTFS (Windows modern)
iso9660     # CD/DVD standard
ext3        # Extended filesystem 3 (journaling)
```

### Filesystem Hierarchy

```
Partition (e.g., /dev/sda1)
    ↓
Filesystem (ext4, xfs, etc.)
    ↓
Mount Point (e.g., /home)
    ↓
Files & Directories
```

### Key Filesystem Components

```bash
# Superblock
├─ Contains filesystem metadata
├─ Size information
├─ Block size
└─ Inode count

# Inode Table
├─ Tracks individual files
├─ File permissions
├─ File size
├─ File timestamps
└─ Block locations

# Data Blocks
├─ Actual file content
├─ Directory listings
└─ Block allocation
```

### Viewing Filesystem Information

```bash
# List all filesystems
df -h
# Output:
# Filesystem      Size  Used Avail Use% Mounted on
# /dev/sda1        20G   10G   10G  50% /
# /dev/sdb1        50G   25G   25G  50% /home

# Show filesystem type
df -T
# Output:
# Filesystem     Type 1K-blocks    Used Available Use% Mounted on
# /dev/sda1      ext4  20971520 10485760 10485760  50% /

# Get detailed info on filesystem
stat /dev/sda1
# Shows: Access, Modify, Change times

# Show disk usage by directory
du -sh /home
# 8.5G    /home

# Find filesystem type
lsblk -f
# Shows filesystem types for all block devices
```

---

## Creating Filesystems

### mkfs Command Overview

The `mkfs` command creates a filesystem on a block device.

```bash
# Basic syntax
sudo mkfs -t [TYPE] [DEVICE]
sudo mkfs.[TYPE] [DEVICE]

# Supported types
-t ext4              # Create ext4 filesystem
-t xfs               # Create XFS filesystem
-t vfat              # Create VFAT filesystem
-t btrfs             # Create Btrfs filesystem
```

### Warning: Data Destruction

```bash
# ⚠️ CRITICAL WARNING ⚠️
# mkfs DESTROYS all data on the device!
# Always verify device name before running:

# WRONG - destroys entire disk
sudo mkfs -t ext4 /dev/sda   # ← WRONG! This is the whole disk

# CORRECT - formats partition only
sudo mkfs -t ext4 /dev/sda1  # ← CORRECT! This is a partition

# Verify device before running
lsblk
fdisk -l
```

### Creating ext4 Filesystem

```bash
# Basic ext4 creation
sudo mkfs -t ext4 /dev/sdb1
# Output:
# mke2fs 1.45.6 (20-May-2021)
# Creating filesystem with 26214400 4k blocks and 6553600 inodes
# Filesystem UUID: a1b2c3d4-e5f6-7890-abcd-ef1234567890
# Superblock backups stored on blocks:
#     32768, 98304, 163840, 229376, 294912, ...

# Create with custom label
sudo mkfs.ext4 -L mydata /dev/sdb1
# Label: mydata

# Create with custom block size (advanced)
sudo mkfs.ext4 -b 4096 /dev/sdb1
# Block size: 4096 bytes (default)

# Create with custom inode ratio (advanced)
sudo mkfs.ext4 -i 16384 /dev/sdb1
# One inode per 16384 bytes

# Force creation (bypass safety checks)
sudo mkfs.ext4 -F /dev/sdb1
# ⚠️ Use with caution
```

### Creating XFS Filesystem

```bash
# Basic XFS creation
sudo mkfs -t xfs /dev/sdb1
# Output:
# meta-data=/dev/sdb1 isize=512 agcount=4, agsize=6553600 blks
# data     = bsize=4096 blocks=26214400, imaxpct=25
# naming   = version 2 bsize=4096 ascii-ci=0 ftype=1
# log      = internal log bsize=4096 blocks=12800, version=2

# Create with label
sudo mkfs.xfs -L mydata /dev/sdb1
# Label: mydata

# Create with sector size (for special devices)
sudo mkfs.xfs -s size=4096 /dev/sdb1
# Sector size: 4096

# Force creation
sudo mkfs.xfs -f /dev/sdb1
# ⚠️ Use with caution
```

### Creating VFAT Filesystem

```bash
# Basic VFAT creation
sudo mkfs -t vfat /dev/sdb1
# Output:
# mkfs.fat 4.1 (2017-01-24)

# Create with label
sudo mkfs.vfat -n MYDATA /dev/sdb1
# Label: MYDATA

# Create FAT32 (standard)
sudo mkfs.vfat -F 32 /dev/sdb1
# Fat type: 32

# Create FAT16 (older)
sudo mkfs.vfat -F 16 /dev/sdb1
# Fat type: 16

# Verify filesystem
fsck.vfat /dev/sdb1
```

### Verification After Creation

```bash
# Check filesystem was created
blkid /dev/sdb1
# /dev/sdb1: UUID="abc123..." TYPE="ext4" LABEL="mydata"

# Check with lsblk
lsblk -f /dev/sdb1
# NAME FSTYPE LABEL UUID
# sdb1 ext4   mydata abc123...

# Verify with file command
file -s /dev/sdb1
# /dev/sdb1: Linux rev 1.0 ext4 filesystem data...
```

---

## Mounting Filesystems

### Mount Basics

Mounting makes a filesystem accessible at a directory (mount point).

```bash
# Basic mount syntax
sudo mount [OPTIONS] [DEVICE] [MOUNT_POINT]

# Mount with specific type
sudo mount -t ext4 /dev/sdb1 /mnt/data

# Mount read-only
sudo mount -r /dev/sdb1 /mnt/data

# Mount read-write (default)
sudo mount -w /dev/sdb1 /mnt/data

# Mount with options
sudo mount -o noexec,nosuid /dev/sdb1 /mnt/data
```

### Mount Point Preparation

```bash
# Create mount point directory
sudo mkdir -p /mnt/data
# Creates directory and parent directories if needed

# Verify directory exists
ls -ld /mnt/data
# drwxr-xr-x. 2 root root 6 Sep 17 10:00 /mnt/data

# Mount point should be empty (unless mounting over existing)
sudo ls -la /mnt/data
# total 0
```

### Mounting Filesystems

```bash
# Mount ext4 filesystem
sudo mount /dev/sdb1 /mnt/data
# Mounts at /mnt/data

# Verify mount
mount | grep /mnt/data
# /dev/sdb1 on /mnt/data type ext4 (rw,relatime)

# Show all mounts
mount
# Lists all currently mounted filesystems

# Mount specific filesystem type
sudo mount -t xfs /dev/sdb2 /mnt/backup

# Mount with specific options
sudo mount -o defaults /dev/sdb1 /mnt/data
# defaults = rw, suid, dev, exec, auto, nouser, async
```

### Common Mount Options

```bash
# Read-write permissions
rw              # Read-write (default)
ro              # Read-only

# Execution permissions
exec            # Allow execution (default)
noexec          # Prevent execution

# Device files
dev             # Allow device files (default)
nodev           # Block device files

# SUID/SGID bits
suid            # Allow setuid/setgid (default)
nosuid          # Block setuid/setgid

# User mounting
user            # Allow user unmount
users           # Allow any user unmount
nouser          # Only root can unmount (default)

# Auto-mounting
auto            # Auto-mount at boot (default)
noauto          # Don't auto-mount

# Synchronous I/O
sync            # Synchronous I/O
async           # Asynchronous I/O (default)

# Other options
defaults        # Default options (rw,suid,dev,exec,auto,nouser,async)
remount         # Remount existing filesystem
```

### Unmounting Filesystems

```bash
# Basic unmount
sudo umount /mnt/data
# Unmounts filesystem

# Unmount by device
sudo umount /dev/sdb1
# Unmounts device

# Lazy unmount (when in use)
sudo umount -l /mnt/data
# Lazy: unmounts when filesystem is no longer busy

# Force unmount (dangerous)
sudo umount -f /mnt/data
# Force: forcefully unmounts (can cause data loss)

# Verify unmount
mount | grep /mnt/data
# (no output = unmounted successfully)
```

### Troubleshooting Mount Issues

```bash
# Mount point in use
sudo umount /mnt/data
# umount: /mnt/data: target is busy

# Solution 1: Find what's using it
sudo lsof /mnt/data
# Shows processes using the mount point

# Solution 2: Close applications and try again
sudo kill -9 [PID]      # Force kill process
sudo umount /mnt/data   # Try unmounting again

# Solution 3: Use lazy unmount
sudo umount -l /mnt/data

# Device already mounted
sudo mount /dev/sdb1 /mnt/data
# mount: /mnt/data: /dev/sdb1 already mounted on /mnt/backup.

# Solution: Find current mount point
mount | grep /dev/sdb1
# /dev/sdb1 on /mnt/backup type ext4 (rw,relatime)

# Solution: Unmount from current location first
sudo umount /mnt/backup
sudo mount /dev/sdb1 /mnt/data
```

---

## ext4 Filesystem

### ext4 Overview

ext4 (Fourth Extended Filesystem) is the modern standard Linux filesystem with journaling, large file support, and performance improvements.

**Features:**
- Journaling (prevents corruption on unclean shutdown)
- Large file support (16 TB files)
- Extents (contiguous block allocation)
- Backward compatible with ext3/ext2
- Efficient inode allocation

### ext4 Specific Features

```bash
# Create ext4 with verbose output
sudo mkfs.ext4 -v /dev/sdb1
# Shows detailed creation information

# ext4 with specific features
sudo mkfs.ext4 -O extent /dev/sdb1
# Enable extents (default, improves performance)

# ext4 with 64-bit support (advanced)
sudo mkfs.ext4 -O 64bit /dev/sdb1
# Enable 64-bit mode
```

### ext4 Tuning

```bash
# Check current ext4 settings
sudo tune2fs -l /dev/sdb1
# Output:
# Filesystem created:    2024-09-17
# Last mount time:       n/a
# Last write time:       2024-09-17
# Mount count:           0
# Maximum mount count:   -1
# Reserved block count:  262144
# Reserved blocks %:     5
# First block:           0
# Block size:            4096
# Fragment size:         4096
# Blocks per group:      32768
# Fragments per group:   32768
# Inodes per group:      8192

# Set filesystem label
sudo e2label /dev/sdb1 mydata
# Sets label to "mydata"

# Change reserved blocks (usually 5%)
sudo tune2fs -m 1 /dev/sdb1
# Reduces reserved blocks to 1%

# Disable filesystem checking on mount count
sudo tune2fs -c -1 /dev/sdb1
# Disables mount-based checking
```

### ext4 Checking and Repair

```bash
# Check filesystem (read-only, safe)
sudo e2fsck -n /dev/sdb1
# -n = no changes, just report

# Check and repair filesystem
# ⚠️ IMPORTANT: Must unmount first
sudo umount /dev/sdb1
sudo e2fsck -y /dev/sdb1
# -y = automatically repair

# Check and report errors
sudo e2fsck -c /dev/sdb1
# -c = read-only check

# Force check even if marked clean
sudo e2fsck -f /dev/sdb1
# -f = force check
```

### ext4 Resizing

```bash
# Resize ext4 filesystem (grow only)
# First grow the underlying LV
sudo lvextend -L +10G /dev/vg_name/lv_name

# Then grow the filesystem
sudo resize2fs /dev/vg_name/lv_name
# Grows filesystem to fill LV

# Resize to specific size
sudo resize2fs /dev/sdb1 20G
# Resizes filesystem to exactly 20GB

# Check new size
df -h /mnt/data
# Should show new size

# Verify with dumpe2fs
sudo dumpe2fs -h /dev/sdb1 | grep "Block count"
# Shows block count
```

---

## XFS Filesystem

### XFS Overview

XFS (eXtensible Filesystem) is a high-performance filesystem designed for large files and parallel I/O operations.

**Features:**
- Extents (similar to ext4)
- Journaling (metadata journaling)
- Large file support (16 EB files)
- Dynamic inode allocation
- Online defragmentation
- No filesystem check on boot (fast boot)

### XFS Specific Features

```bash
# Create XFS with specific options
sudo mkfs.xfs /dev/sdb1

# XFS with data section (default)
sudo mkfs.xfs -d crc=1 /dev/sdb1
# Enable CRC checksums (default in newer RHEL)

# XFS with log section
sudo mkfs.xfs -l internal /dev/sdb1
# Internal log (default)

# XFS with metadata
sudo mkfs.xfs -m crc=1 /dev/sdb1
# Enable CRC on metadata
```

### XFS Admin Tools

```bash
# Get XFS filesystem information
sudo xfs_info /mnt/data
# Output:
# meta-data=/dev/sdb1 isize=512 agcount=4, agsize=6553600 blks
# data = bsize=4096 blocks=26214400, imaxpct=25
# naming = version 2 bsize=4096 ascii-ci=0 ftype=1
# log = internal bsize=4096 blocks=12800, version=2

# Get XFS label
sudo xfs_admin -l /dev/sdb1
# Label: "mydata"

# Set XFS label
sudo xfs_admin -L mydata /dev/sdb1
# Sets label to "mydata"

# UUID information
sudo xfs_admin -u /dev/sdb1
# Shows UUID
```

### XFS Checking and Repair

```bash
# Check XFS filesystem (read-only)
sudo xfs_check /dev/sdb1
# Read-only check

# Repair XFS filesystem
# ⚠️ IMPORTANT: Must unmount first
sudo umount /dev/sdb1
sudo xfs_repair /dev/sdb1
# Repairs filesystem

# Verbose repair
sudo xfs_repair -v /dev/sdb1
# Verbose output

# Dry-run (no changes)
sudo xfs_repair -n /dev/sdb1
# -n = no changes
```

### XFS Growing

```bash
# Grow XFS filesystem (online, mounted)
# First grow underlying LV
sudo lvextend -L +10G /dev/vg_name/lv_name

# Then grow filesystem (online)
sudo xfs_growfs /mnt/data
# Grows filesystem to fill LV

# Specify size
sudo xfs_growfs -D 20G /mnt/data
# Grows to exactly 20GB

# Verify size
df -h /mnt/data
# Should show new size

# Check with xfs_info
sudo xfs_info /mnt/data | grep "blocks"
# Shows block count
```

### Important XFS Note

```bash
# ⚠️ XFS CANNOT SHRINK
# Unlike ext4, XFS filesystems cannot be reduced in size
# You can only grow XFS filesystems

# ext4 CAN shrink (but risky)
# xfs CANNOT shrink (no resize2fs equivalent for shrinking)
```

---

## VFAT Filesystem

### VFAT Overview

VFAT (Virtual FAT) is a filesystem compatible with Windows/DOS systems, useful for USB drives and cross-platform storage.

**Features:**
- Windows compatible
- Simple structure
- No permission system
- Case-insensitive filenames
- 4GB file size limit (FAT32)

### VFAT Creation

```bash
# Create VFAT filesystem
sudo mkfs.vfat /dev/sdb1

# Create VFAT with label
sudo mkfs.vfat -n MYDATA /dev/sdb1

# Specify FAT type
sudo mkfs.vfat -F 32 /dev/sdb1    # FAT32 (standard)
sudo mkfs.vfat -F 16 /dev/sdb1    # FAT16 (older)

# Check parameters
sudo fatscan /dev/sdb1
```

### VFAT Specific Characteristics

```bash
# Mount with umask (permission override)
sudo mount -o umask=0000 /dev/sdb1 /mnt/data
# All users can read/write

# Mount with specific codepage
sudo mount -o codepage=cp437 /dev/sdb1 /mnt/data
# Use DOS codepage

# Mount as read-only
sudo mount -r /dev/sdb1 /mnt/data
```

### VFAT Checking and Repair

```bash
# Check VFAT filesystem
sudo fsck.vfat /dev/sdb1

# Repair VFAT filesystem
sudo fsck.vfat -r /dev/sdb1
# Interactively repair

# Auto-repair
sudo fsck.vfat -y /dev/sdb1
# Automatically fix issues
```

---

## Network File Systems (NFS)

### NFS Overview

NFS (Network File System) allows mounting remote filesystems over a network.

**Versions:**
- NFSv3: Traditional, stateless
- NFSv4: Modern, with security improvements
- NFSv4.1/4.2: Latest versions with clustering support

### NFS Server Setup (Optional Exam Knowledge)

```bash
# NFS server configuration
sudo vim /etc/exports
# Add export lines:
# /export/data    192.168.1.0/24(rw,sync,no_root_squash)
# /export/shared  *(ro)

# Start NFS service
sudo systemctl start nfs-server
sudo systemctl enable nfs-server

# Reload exports
sudo exportfs -r

# List exports
sudo exportfs -v
# Shows currently exported filesystems
```

### NFS Client Mounting

```bash
# List available NFS exports
showmount -e nfs-server.example.com
# Output:
# Export list for nfs-server.example.com:
# /export/shared          *
# /export/data            192.168.1.0/24

# Mount NFS filesystem
sudo mount -t nfs nfs-server.example.com:/export/data /mnt/data
# Mounts remote /export/data to /mnt/data

# Mount with specific NFS version
sudo mount -t nfs -o vers=4 nfs-server.example.com:/export/data /mnt/data
# Use NFSv4

# Mount with NFSv3
sudo mount -t nfs -o vers=3 nfs-server.example.com:/export/data /mnt/data
# Use NFSv3

# Mount with options
sudo mount -t nfs -o rw,hard,intr nfs-server.example.com:/export/data /mnt/data
```

### NFS Mount Options

```bash
# Connection options
hard            # Retry indefinitely if server unavailable (default)
soft            # Give up after retries (not recommended)
intr            # Allow interruption of hard mounts

# Performance options
async           # Asynchronous writes (default, faster)
sync            # Synchronous writes (safer, slower)

# Version and protocol
vers=3          # NFSv3
vers=4          # NFSv4

# Permission options
rw              # Read-write
ro              # Read-only

# Example: Safe mount
sudo mount -t nfs -o hard,intr,rsize=8192,wsize=8192 \
  nfs-server.example.com:/export/data /mnt/data
```

### NFS in /etc/fstab

```bash
# Add to /etc/fstab for persistent mounting
nfs-server.example.com:/export/data /mnt/data nfs defaults,hard,intr 0 0

# Mount with automount options
nfs-server.example.com:/export/data /mnt/data nfs defaults,x-systemd.automount 0 0
```

### Troubleshooting NFS

```bash
# Check if NFS server is accessible
ping nfs-server.example.com
# Should respond

# Check port availability
sudo nmap -p 111,2049 nfs-server.example.com
# NFS uses ports 111 (rpcbind) and 2049 (nfs)

# Mount with verbose output
sudo mount -v -t nfs nfs-server.example.com:/export/data /mnt/data

# Check NFS mount status
mount | grep nfs
# Shows all NFS mounts

# View NFS connection details
sudo cat /proc/mounts | grep nfs
```

---

## Autofs Configuration

### Autofs Overview

Autofs automatically mounts filesystems (usually NFS) when accessed, and unmounts them when idle.

**Benefits:**
- On-demand mounting
- Automatic unmounting
- Reduced network traffic
- Cleaner mount management

### Autofs Installation and Setup

```bash
# Install autofs package
sudo yum install autofs
# or
sudo dnf install autofs

# Start autofs service
sudo systemctl start autofs
sudo systemctl enable autofs

# Check service status
sudo systemctl status autofs
```

### Autofs Configuration

```bash
# Main autofs configuration
sudo vim /etc/auto.master
# Add entries:
# /mnt/auto    /etc/auto.nfs    --timeout=300
# /home        /etc/auto.home   --timeout=600

# Create NFS autofs map
sudo vim /etc/auto.nfs
# Add entries:
# data    -rw,hard,intr    nfs-server.example.com:/export/data
# backup  -ro              nfs-server.example.com:/export/backup

# Verify syntax
sudo automount -f
# Tests configuration

# Reload autofs
sudo systemctl restart autofs
```

### Using Autofs

```bash
# Access autofs mount point
cd /mnt/auto/data
# Automatically mounts when accessed

# Check active mounts
mount | grep autofs
# /etc/auto.nfs on /mnt/auto type autofs (...)

# Monitor autofs activity
sudo tail -f /var/log/messages | grep autofs
# Shows autofs activity

# Check unmount timeout
ls -l /mnt/auto/
# Unmounts after timeout
```

### Autofs Troubleshooting

```bash
# Check autofs service
sudo systemctl status autofs

# View autofs logs
sudo journalctl -u autofs -f
# Follow autofs logs

# Test autofs map
sudo automount -v -f -M

# Reload maps
sudo systemctl reload autofs
```

---

## Extending Logical Volumes

### LV Extension Overview

Extending LVs allows adding space to filesystems non-destructively.

**Process:**
1. Extend the LV (lvextend)
2. Extend the filesystem (resize2fs for ext4, xfs_growfs for xfs)
3. Verify the change (df -h)

### Extending Logical Volumes

```bash
# Check current LV size
sudo lvs /dev/vg_name/lv_name
# LV   VG      Attr LSize
# lv_data vg_prod -wi-ao---- 30.00g

# Extend LV by specific amount
sudo lvextend -L +10G /dev/vg_name/lv_name
# Size of logical volume vg_prod/lv_data changed from 30.00 GiB to 40.00 GiB.

# Extend LV to specific size
sudo lvextend -L 50G /dev/vg_name/lv_name
# Size of logical volume vg_prod/lv_data changed from 40.00 GiB to 50.00 GiB.

# Extend LV to fill VG free space
sudo lvextend -l +100%FREE /dev/vg_name/lv_name
# Size of logical volume changed to use all free space

# Check new size
sudo lvs /dev/vg_name/lv_name
```

### Extending Filesystems

```bash
# For ext4: Use resize2fs
# First, extend LV
sudo lvextend -L +10G /dev/vg_name/lv_name

# Then extend filesystem
sudo resize2fs /dev/vg_name/lv_name
# Filesystem at /dev/vg_name/lv_name is mounted on /data; on-line resizing required
# The filesystem on /dev/vg_name/lv_name is now 10485760 (4k) blocks long.

# Verify with df
df -h /data
# /dev/mapper/vg_prod-lv_data   50G   25G   25G  50% /data

# For XFS: Use xfs_growfs
# First, extend LV
sudo lvextend -L +10G /dev/vg_name/lv_name

# Then grow filesystem
sudo xfs_growfs /data
# meta-data=/dev/mapper/vg_prod-lv_data isize=512 agcount=4, agsize=3276800 blks
# data     = bsize=4096 blocks=13107200, imaxpct=25
# data     = agcount=5, agsize=2621440 blks, more agcount than before

# Verify
df -h /data
```

### Complete Expansion Workflow

```bash
# Step 1: Verify current state
df -h /data
# Filesystem     Size  Used Avail Use% Mounted on
# /dev/mapper/vg_prod-lv_data   30G   15G   15G  50% /data

# Step 2: Check VG free space
sudo vgs vg_prod
# VG   #PV #LV #SN Attr   VSize  VFree
# vg_prod   2   3   0 wz--n- 100.00g 20.00g

# Step 3: Extend LV
sudo lvextend -L +10G /dev/vg_prod/lv_data
# Size of logical volume vg_prod/lv_data changed from 30.00 GiB to 40.00 GiB.

# Step 4: Extend filesystem (identify type first)
df -T /data
# Filesystem     Type  1K-blocks    Used Available Use%
# /dev/mapper/vg_prod-lv_data ext4  30734400 15367200 15367200  50%

# If ext4:
sudo resize2fs /dev/vg_prod/lv_data

# If XFS:
sudo xfs_growfs /data

# Step 5: Verify
df -h /data
# Should show new size (40G)

# Step 6: Verify filesystem integrity
sudo e2fsck -n /dev/vg_prod/lv_data  # ext4
# or
sudo xfs_check /data                  # XFS
```

---

## File Permission Troubleshooting

### Permission Basics Review

```bash
# Permission notation: rwxrwxrwx
#                     ugo
# Where:
# u = user (owner)
# g = group
# o = other

# Numeric representation
r = 4 (read)
w = 2 (write)
x = 1 (execute)

# Example: 755
7 = 4+2+1 = rwx (user)
5 = 4+0+1 = r-x (group)
5 = 4+0+1 = r-x (other)
```

### Common Permission Problems

```bash
# Problem: Cannot read file
-rw------- file.txt
# Only owner can read

# Solution: Add read for group
sudo chmod g+r file.txt
# or
sudo chmod 644 file.txt
# Becomes: -rw-r--r--

# Problem: Cannot execute script
-rw-r--r-- script.sh
# Execute bit not set

# Solution: Add execute permission
sudo chmod +x script.sh
# or
sudo chmod 755 script.sh
# Becomes: -rwxr-xr-x

# Problem: Cannot write to directory
drwxr-xr-x /data
# Non-owner cannot write

# Solution: Add write permission
sudo chmod g+w /data
# or
sudo chmod 775 /data
# Becomes: drwxrwxr-x
```

### Permission Diagnosis

```bash
# Check file permissions
ls -l file.txt
# -rw-r--r-- 1 user group 1024 Sep 17 10:00 file.txt

# Check directory permissions
ls -ld /data
# drwxr-xr-x 5 user group 4096 Sep 17 10:00 /data/

# Check current user
whoami
# user

# Check user groups
id user
# uid=1000(user) gid=1000(group) groups=1000(group),4(adm)

# Check file owner
stat file.txt
# Access: (0644/-rw-r--r--)  Uid: ( 1000/user)   Gid: ( 1000/group)
```

### Fixing Permission Issues

```bash
# Change file permissions (symbolic)
sudo chmod u+w,g+r,o-r file.txt
# Add write for user, read for group, remove read from other

# Change file permissions (numeric)
sudo chmod 644 file.txt
# Set to rw-r--r--

# Change recursively for directory
sudo chmod -R 755 /data
# Changes directory and all contents

# Change only directories (not files)
sudo find /data -type d -exec chmod 755 {} \;

# Change only files (not directories)
sudo find /data -type f -exec chmod 644 {} \;

# Change ownership
sudo chown user:group file.txt
# Changes owner to user, group to group

# Change only owner
sudo chown user file.txt

# Change only group
sudo chgrp group file.txt

# Change recursively
sudo chown -R user:group /data
```

### Advanced Permission Issues

```bash
# Problem: SUID bit set incorrectly
-rwsr-xr-x script.sh
# SUID bit set (s instead of x for owner)

# Check SUID
stat script.sh
# Access: (4755/-rwsr-xr-x)

# Remove SUID (for scripts, usually not needed)
sudo chmod u-s script.sh
# Becomes: -rwxr-xr-x

# Problem: Sticky bit preventing deletion
drwxrwxrwt /tmp
# Sticky bit (t at end)

# Files in sticky bit directory can only be deleted by owner
# Normally correct for /tmp

# Problem: Directory lacks execute permission
drw-r--r-- /data
# No execute permission

# Users cannot enter directory
cd /data
# Permission denied

# Solution: Add execute
sudo chmod u+x /data
# Becomes: drwxr--r--
```

### Permission Troubleshooting Checklist

```bash
# 1. Verify you're correct user
whoami

# 2. Check file/directory ownership
ls -l file.txt

# 3. Check your groups
id

# 4. Verify required permission (read/write/execute)
stat file.txt

# 5. Check parent directory permissions
ls -ld $(dirname file.txt)

# 6. Verify filesystem permissions aren't overriding
mount | grep partition

# 7. Check SELinux context (if applicable)
ls -Z file.txt

# 8. Make required changes
sudo chmod/chown
```

---

## Lab Exercises & Practice

### Quick Command Reference

**Filesystem Creation:**
```bash
sudo mkfs -t ext4 /dev/sdb1
sudo mkfs.xfs /dev/sdb1
sudo mkfs.vfat /dev/sdb1
```

**Mounting:**
```bash
sudo mount /dev/sdb1 /mnt/data
sudo umount /mnt/data
mount -o remount,ro /mnt/data     # Remount read-only
```

**ext4 Tuning:**
```bash
sudo tune2fs -l /dev/sdb1          # List settings
sudo e2label /dev/sdb1 label       # Set label
sudo resize2fs /dev/sdb1           # Grow filesystem
```

**XFS Tools:**
```bash
sudo xfs_info /mnt/data            # Get info
sudo xfs_admin -L label /dev/sdb1  # Set label
sudo xfs_growfs /mnt/data          # Grow filesystem
```

**NFS:**
```bash
mount -t nfs server:/path /mnt/point
showmount -e nfs-server
```

**Autofs:**
```bash
sudo systemctl start autofs
sudo vim /etc/auto.master
sudo vim /etc/auto.nfs
```

**LV Extension:**
```bash
sudo lvextend -L +10G /dev/vg/lv
sudo resize2fs /dev/vg/lv          # For ext4
sudo xfs_growfs /mnt/point         # For XFS
```

**Permissions:**
```bash
chmod 644 file.txt
chown user:group file.txt
chmod -R 755 /directory
```

---

**End of Lab Notes - Module 4: Create and Configure File Systems**

*These notes cover all RHCSA exam objectives for this module. Complete the lab exercises for hands-on practice.*
