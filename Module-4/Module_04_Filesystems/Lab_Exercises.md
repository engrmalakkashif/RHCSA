# RHCSA Module 4: Create and Configure File Systems
## Hands-On Lab Exercises

---

## Lab Exercise 1: Create ext4 Filesystem

**Objective:** Create and verify an ext4 filesystem

**Prerequisites:**
- Partition available (e.g., /dev/sdb1)
- Root/sudo access

### Scenario:
Create an ext4 filesystem on a partition with a label, then verify it was created correctly.

### Step-by-Step Instructions:

```bash
# Step 1: Verify partition exists and is unformatted
sudo lsblk /dev/sdb
# Expected output shows /dev/sdb1 partition

# Step 2: Create ext4 filesystem with label
sudo mkfs.ext4 -L production /dev/sdb1
# Output:
# mke2fs 1.45.6 (20-May-2021)
# Creating filesystem with 26214400 4k blocks and 6553600 inodes
# Allocating group tables: done
# Writing inode tables: done
# Creating journal (65536 blocks): done
# Writing superblocks and filesystem accounting information: done

# Step 3: Verify filesystem was created
blkid /dev/sdb1
# Output:
# /dev/sdb1: UUID="a1b2c3d4-e5f6-7890-abcd-ef1234567890" TYPE="ext4" LABEL="production"

# Step 4: Show filesystem information
sudo tune2fs -l /dev/sdb1 | head -20
# Output shows:
# Filesystem UUID: a1b2c3d4-e5f6-7890-abcd-ef1234567890
# Filesystem magic number: 0xef53
# Filesystem revision #: 1 (dynamic)
# Filesystem features: has_journal ext_attr resize_inode dir_index filetype needs_recovery extent 64bit flex_bg sparse_super large_file huge_file
# Filesystem flags: signed_dir_index
# Default mount options: user_xattr acl
# Filesystem state: clean

# Step 5: Create mount point
sudo mkdir -p /mnt/production

# Step 6: Mount filesystem
sudo mount /dev/sdb1 /mnt/production

# Step 7: Verify mount
mount | grep /dev/sdb1
# Output:
# /dev/sdb1 on /mnt/production type ext4 (rw,relatime)

# Step 8: Verify with df
df -h /mnt/production
# Output:
# Filesystem      Size  Used Avail Use% Mounted on
# /dev/sdb1       100G  100M   95G   1% /mnt/production
```

### Verification Checklist:
- [ ] Filesystem created with ext4 type
- [ ] Label is "production"
- [ ] UUID displayed with blkid
- [ ] Successfully mounted at /mnt/production
- [ ] df -h shows correct size

---

## Lab Exercise 2: Create and Compare XFS Filesystem

**Objective:** Create XFS filesystem and compare with ext4

**Prerequisites:**
- Partition available (e.g., /dev/sdb2)
- Previous exercise completed

### Scenario:
Create an XFS filesystem and compare its characteristics with ext4.

### Step-by-Step Instructions:

```bash
# Step 1: Create XFS filesystem
sudo mkfs.xfs -L backups /dev/sdb2
# Output:
# meta-data=/dev/sdb2 isize=512 agcount=4, agsize=6553600 blks
# data = bsize=4096 blocks=26214400, imaxpct=25
# naming = version 2 bsize=4096 ascii-ci=0 ftype=1
# log = internal log bsize=4096 blocks=12800, version=2
# realtime = none extsz=4096 blocks=0, rtextents=0

# Step 2: Verify XFS filesystem
blkid /dev/sdb2
# Output:
# /dev/sdb2: UUID="xyz789-abc123-..." TYPE="xfs" LABEL="backups"

# Step 3: Get XFS information
sudo xfs_admin -l /dev/sdb2
# Output:
# label = "backups"

# Step 4: Mount XFS filesystem
sudo mkdir -p /mnt/backups
sudo mount /dev/sdb2 /mnt/backups

# Step 5: Compare filesystems
echo "=== ext4 ===" && sudo tune2fs -l /dev/sdb1 | grep "Filesystem UUID"
echo "=== XFS ===" && sudo xfs_admin -u /dev/sdb2

# Step 6: Verify both mounted
mount | grep -E "/dev/sdb[12]"
# Output shows both mounts

# Step 7: Compare with df
df -T /mnt/production /mnt/backups
# Output:
# Filesystem     Type  1K-blocks     Used Available Use%
# /dev/sdb1      ext4 104857600   102400  99351552   1%
# /dev/sdb2      xfs  104857600   33088  104824512   1%
```

### Verification Checklist:
- [ ] XFS filesystem created successfully
- [ ] Label is "backups"
- [ ] XFS filesystem mounted at /mnt/backups
- [ ] Both ext4 and XFS mounted correctly
- [ ] df -T shows different types

---

## Lab Exercise 3: Create and Mount VFAT Filesystem

**Objective:** Create VFAT filesystem for cross-platform compatibility

**Prerequisites:**
- Partition available (e.g., /dev/sdb3)
- Previous exercises completed

### Scenario:
Create a VFAT filesystem for USB drive compatibility.

### Step-by-Step Instructions:

```bash
# Step 1: Create VFAT filesystem
sudo mkfs.vfat -n SHARED /dev/sdb3
# Output:
# mkfs.fat 4.1 (2017-01-24)

# Step 2: Verify VFAT filesystem
blkid /dev/sdb3
# Output:
# /dev/sdb3: UUID="1234-5678" TYPE="vfat" LABEL="SHARED"

# Step 3: Create mount point
sudo mkdir -p /mnt/shared

# Step 4: Mount VFAT with appropriate options
sudo mount -o umask=0000 /dev/sdb3 /mnt/shared
# umask=0000 allows all users read/write

# Step 5: Verify mount
mount | grep /dev/sdb3
# Output:
# /dev/sdb3 on /mnt/shared type vfat (rw,relatime,fmask=0000,dmask=0000,...)

# Step 6: Test VFAT functionality
sudo touch /mnt/shared/testfile.txt
ls -l /mnt/shared/testfile.txt
# Output shows file created

# Step 7: Verify all filesystems
mount | grep -E "/dev/sdb[123]"
# Shows all three filesystems mounted
```

### Verification Checklist:
- [ ] VFAT filesystem created
- [ ] Label is "SHARED"
- [ ] Mounted with umask=0000
- [ ] Users can read/write files
- [ ] All three filesystems mounted

---

## Lab Exercise 4: Mount Filesystems by UUID in fstab

**Objective:** Add persistent mount entries using UUID

**Prerequisites:**
- Three filesystems created (ext4, xfs, vfat)
- All currently mounted

### Scenario:
Add permanent mount entries to /etc/fstab using UUID references.

### Step-by-Step Instructions:

```bash
# Step 1: Get UUIDs for all filesystems
echo "ext4 UUID:" && sudo blkid -s UUID -o value /dev/sdb1
echo "xfs UUID:" && sudo blkid -s UUID -o value /dev/sdb2
echo "vfat UUID:" && sudo blkid -s UUID -o value /dev/sdb3

# Store UUIDs
UUID_EXT4=$(sudo blkid -s UUID -o value /dev/sdb1)
UUID_XFS=$(sudo blkid -s UUID -o value /dev/sdb2)
UUID_VFAT=$(sudo blkid -s UUID -o value /dev/sdb3)

# Step 2: View current /etc/fstab
sudo tail -10 /etc/fstab

# Step 3: Add entries to /etc/fstab
sudo tee -a /etc/fstab << EOF

# Module 4 Lab Filesystems
UUID=$UUID_EXT4 /mnt/production ext4 defaults,nofail 0 2
UUID=$UUID_XFS /mnt/backups xfs defaults,nofail 0 2
UUID=$UUID_VFAT /mnt/shared vfat defaults,nofail 0 0
EOF

# Step 4: Verify entries were added
sudo tail -10 /etc/fstab
# Output shows three new entries

# Step 5: Unmount all filesystems
sudo umount /mnt/production
sudo umount /mnt/backups
sudo umount /mnt/shared

# Step 6: Verify they're unmounted
mount | grep "/mnt"
# Should be empty

# Step 7: Test fstab by mounting all
sudo mount -a
# Should mount all three filesystems

# Step 8: Verify all mounted
mount | grep "/mnt"
# Should show all three mounted

# Step 9: Verify with df
df -h /mnt/production /mnt/backups /mnt/shared
# Should show all three filesystems
```

### Verification Checklist:
- [ ] UUIDs retrieved correctly
- [ ] fstab entries added with UUIDs
- [ ] Filesystems unmounted successfully
- [ ] mount -a succeeded
- [ ] All filesystems remounted correctly
- [ ] df shows all three filesystems

---

## Lab Exercise 5: Extend Logical Volume and Filesystem

**Objective:** Grow LV and ext4 filesystem non-destructively

**Prerequisites:**
- LVM setup from Module 3
- ext4 filesystem on LV

### Scenario:
Extend an existing LV by 10GB and grow the ext4 filesystem to use the new space.

### Step-by-Step Instructions:

```bash
# Step 1: Check current status
df -h /data
# Shows current size

sudo lvs /dev/vg_prod/lv_data
# LV   VG      Attr LSize
# lv_data vg_prod -wi-ao---- 30.00g

# Step 2: Verify VG free space
sudo vgs vg_prod
# VG      VFree
# vg_prod  20.00g

# Step 3: Extend logical volume by 10GB
sudo lvextend -L +10G /dev/vg_prod/lv_data
# Size of logical volume vg_prod/lv_data changed from 30.00 GiB to 40.00 GiB.

# Step 4: Verify LV extension
sudo lvs /dev/vg_prod/lv_data
# LSize should now be 40.00g

# Step 5: Extend ext4 filesystem
sudo resize2fs /dev/vg_prod/lv_data
# Output:
# The filesystem on /dev/vg_prod/lv_data is mounted on /data; on-line resizing required
# old_desc_blocks = 4, new_desc_blocks = 5
# The filesystem on /dev/vg_prod/lv_data is now 10485760 (4k) blocks long.

# Step 6: Verify filesystem size with df
df -h /data
# Should show 40GB now (was 30GB)

# Step 7: Verify with dumpe2fs
sudo dumpe2fs -h /dev/vg_prod/lv_data | grep "Block count"
# Shows new block count

# Step 8: Test data still accessible
ls -la /data
# Verify files still exist

# Step 9: Verify free space decreased in VG
sudo vgs vg_prod
# VFree should now be 10.00g (was 20.00g)
```

### Verification Checklist:
- [ ] LV extended from 30GB to 40GB
- [ ] Filesystem extended successfully
- [ ] df -h shows 40GB on /data
- [ ] All data still accessible
- [ ] VG free space decreased by 10GB

---

## Lab Exercise 6: Extend XFS Filesystem

**Objective:** Grow XFS filesystem (which can be extended online)

**Prerequisites:**
- XFS filesystem on LV
- LVM setup

### Scenario:
Extend an XFS filesystem using xfs_growfs.

### Step-by-Step Instructions:

```bash
# Step 1: Check current XFS status
df -h /backups
# Shows current size

sudo xfs_info /backups
# Shows filesystem details

# Step 2: Verify VG free space
sudo vgs vg_prod
# Check available space

# Step 3: Extend LV (assuming LV for XFS)
sudo lvextend -L +5G /dev/vg_prod/lv_backups
# Size of logical volume changed to X GiB.

# Step 4: Grow XFS filesystem (online)
sudo xfs_growfs /backups
# Output:
# meta-data=/dev/mapper/vg_prod-lv_backups isize=512 agcount=4, agsize=2621440 blks
# data = bsize=4096 blocks=10485760, imaxpct=25
# Grows filesystem without unmounting

# Step 5: Verify with xfs_info
sudo xfs_info /backups
# Block count should increase

# Step 6: Verify with df
df -h /backups
# Should show new size

# Important: XFS cannot shrink, only grow
# Unlike ext4 which has resize2fs for both grow/shrink
```

### Verification Checklist:
- [ ] LV extended successfully
- [ ] xfs_growfs executed without errors
- [ ] df shows new size
- [ ] xfs_info shows updated block count

---

## Lab Exercise 7: Fix File Permission Problems

**Objective:** Diagnose and correct permission issues

**Prerequisites:**
- Mounted filesystems with files

### Scenario:
Identify and fix various permission problems.

### Step-by-Step Instructions:

```bash
# Step 1: Create test files with various permissions
sudo touch /mnt/production/file1.txt
sudo touch /mnt/production/file2.txt
sudo touch /mnt/production/script.sh

# Step 2: Set various permission problems
sudo chmod 000 /mnt/production/file1.txt    # No permissions
sudo chmod 600 /mnt/production/file2.txt    # Only owner read/write
sudo chmod 644 /mnt/production/script.sh    # Not executable

# Step 3: Try to access files as regular user
cd /mnt/production
cat file1.txt
# Permission denied

cat file2.txt
# Permission denied (even owner group)

./script.sh
# Permission denied

# Step 4: Diagnose permissions
echo "=== Current permissions ===" && ls -l /mnt/production/file*.txt
echo "=== My user ===" && whoami
echo "=== My groups ===" && id

# Step 5: Fix file1.txt (make readable by all)
sudo chmod 644 /mnt/production/file1.txt
# Now owner can read/write, others read-only

# Step 6: Fix file2.txt (make readable by group)
sudo chmod 640 /mnt/production/file2.txt
# Now owner rw, group r, others none

# Step 7: Fix script.sh (make executable)
sudo chmod 755 /mnt/production/script.sh
# Now executable by all

# Step 8: Verify fixes
ls -l /mnt/production/
# Check permissions

# Step 9: Test access
cat /mnt/production/file1.txt
# Should work

cat /mnt/production/file2.txt
# Depends on group membership

# Step 10: Fix directory permissions (if needed)
sudo chmod 755 /mnt/production
# Allows others to enter directory
```

### Verification Checklist:
- [ ] Permissions diagnosed correctly
- [ ] Files accessible after fixes
- [ ] Permissions match intended use (644/755/600)
- [ ] Directory permissions allow navigation

---

## Lab Exercise 8: Configure NFS Mount and Autofs

**Objective:** Set up NFS mount with autofs automation

**Prerequisites:**
- NFS server configured (can be same system)
- autofs installed

### Scenario:
Mount NFS export and configure autofs for automatic mounting.

### Step-by-Step Instructions:

```bash
# Step 1: Install autofs
sudo yum install autofs

# Step 2: Check available NFS exports
showmount -e localhost
# Shows available exports (if NFS server configured)

# Step 3: Create mount point for manual NFS mount
sudo mkdir -p /mnt/nfs-manual
sudo mkdir -p /mnt/nfs-auto

# Step 4: Mount NFS manually (for testing)
sudo mount -t nfs -o hard,intr localhost:/export/data /mnt/nfs-manual
# Test connection

# Step 5: Verify NFS mount
mount | grep nfs
# Should show manual mount

# Step 6: Configure autofs master map
sudo tee /etc/auto.master << EOF
/mnt/nfs-auto    /etc/auto.nfs    --timeout=300
EOF

# Step 7: Create NFS autofs map
sudo tee /etc/auto.nfs << EOF
data    -rw,hard,intr    localhost:/export/data
backup  -ro              localhost:/export/backup
EOF

# Step 8: Start autofs service
sudo systemctl enable autofs
sudo systemctl start autofs

# Step 9: Test autofs access
ls /mnt/nfs-auto/data
# Should auto-mount on access

# Step 10: Verify autofs mount
mount | grep autofs
# Shows autofs mount

# Step 11: Check what's mounted
mount | grep nfs
# Should show both manual and autofs mounts

# Step 12: Add to fstab for manual NFS (if desired)
echo "localhost:/export/data /mnt/nfs-manual nfs defaults,hard,intr 0 0" | sudo tee -a /etc/fstab
```

### Verification Checklist:
- [ ] autofs installed and running
- [ ] Manual NFS mount successful
- [ ] autofs maps configured
- [ ] autofs auto-mounts on access
- [ ] mount shows both mounts
- [ ] Timeout works (auto-unmount after inactivity)

---

## Integration Lab: Complete Filesystem Setup

**Objective:** Combine all concepts into complete setup

**Scenario:**
Set up a complete filesystem infrastructure with multiple types and mounting methods.

### Complete Workflow:

```bash
# Part 1: Create Filesystems
echo "=== Creating filesystems ===" 
sudo mkfs.ext4 -L data /dev/sdb1
sudo mkfs.xfs -L logs /dev/sdb2
sudo mkfs.vfat -n backup /dev/sdb3

# Part 2: Create mount points
sudo mkdir -p /data /logs /backup

# Part 3: Mount filesystems
sudo mount /dev/sdb1 /data
sudo mount /dev/sdb2 /logs
sudo mount -o umask=0000 /dev/sdb3 /backup

# Part 4: Add to fstab with UUIDs
UUID_1=$(sudo blkid -s UUID -o value /dev/sdb1)
UUID_2=$(sudo blkid -s UUID -o value /dev/sdb2)
UUID_3=$(sudo blkid -s UUID -o value /dev/sdb3)

echo "UUID=$UUID_1 /data ext4 defaults,nofail 0 2" | sudo tee -a /etc/fstab
echo "UUID=$UUID_2 /logs xfs defaults,nofail 0 2" | sudo tee -a /etc/fstab
echo "UUID=$UUID_3 /backup vfat defaults,nofail 0 0" | sudo tee -a /etc/fstab

# Part 5: Test fstab
sudo umount /data /logs /backup
sudo mount -a

# Part 6: Verify
echo "=== Verification ===" 
df -T /data /logs /backup
mount | grep -E "/data|/logs|/backup"

# Part 7: Extend data filesystem (if using LVM)
# sudo lvextend -L +5G /dev/vg/lv_data
# sudo resize2fs /dev/vg/lv_data

# Part 8: Fix any permission issues
sudo chmod 755 /data /logs /backup

# Part 9: Final verification
ls -ld /data /logs /backup
df -h /data /logs /backup
```

### Verification Checklist:
- [ ] All three filesystems created
- [ ] All mounted successfully
- [ ] Entries in /etc/fstab using UUIDs
- [ ] mount -a succeeds
- [ ] Permissions correct
- [ ] df shows all filesystems

---

**End of Lab Exercises - Module 4: Create and Configure File Systems**

*Complete these exercises before attempting the RHCSA exam. Practice each exercise multiple times until comfortable.*
