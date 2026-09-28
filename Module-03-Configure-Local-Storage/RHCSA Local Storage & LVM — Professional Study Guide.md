# RHCSA Local Storage & LVM
## Professional Hands-On Study Guide

**Topics:** GPT Partitioning • Physical Volumes • Volume Groups • Logical Volumes • XFS • UUID • `/etc/fstab` • Persistent Mounting • Troubleshooting

---

## 1. Learning Objectives

By completing this lab, you should be able to:

- Identify disks and partitions using `lsblk`.
- Create GPT partitions using `fdisk`.
- Create and remove Physical Volumes (PV).
- Create and manage Volume Groups (VG).
- Create and manage Logical Volumes (LV).
- Create an XFS filesystem.
- Mount a filesystem manually.
- Identify a filesystem using its UUID.
- Configure persistent mounts using `/etc/fstab`.
- Validate `/etc/fstab` without rebooting.
- Troubleshoot common LVM mounting errors.

---

# 2. Understanding the LVM Architecture

The complete storage hierarchy is:

```text
Physical Disk
     │
     ▼
Partition
/dev/xvdd1
     │
     ▼
Physical Volume (PV)
     │
     ▼
Volume Group (VG)
vgdata
     │
     ▼
Logical Volume (LV)
lvdata
     │
     ▼
XFS Filesystem
     │
     ▼
Mount Point
/data
     │
     ▼
/etc/fstab
```

### Important concept

A **Physical Volume** provides storage to LVM.

A **Volume Group** combines one or more PVs into a storage pool.

A **Logical Volume** is created from free space inside a VG.

The filesystem is created **on the LV**, and the filesystem is what gets mounted.

---

# 3. Lab Environment

The original EC2 instance contained:

```text
xvda      15G  disk
├─xvda1   14G  part /
├─xvda14   4M  part
├─xvda15 106M  part /boot/efi
└─xvda16 913M  part /boot
```

A separate 5 GB EBS disk was then attached:

```text
xvdd      5G  disk
└─xvdd1   5G  part
```

### Important safety rule

Do **not** experiment on `/dev/xvda` because it contains the operating system.

The dedicated lab disk is:

```text
/dev/xvdd
```

and the LVM partition is:

```text
/dev/xvdd1
```

---

# 4. Identify Available Disks

Use:

```bash
lsblk
```

Example:

```text
NAME     MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
xvda     202:0    0   15G  0 disk
├─xvda1  202:1    0   14G  0 part /
├─xvda14 202:14   0    4M  0 part
├─xvda15 202:15   0  106M  0 part /boot/efi
└─xvda16 259:0    0  913M  0 part /boot

xvdd     202:48   0    5G  0 disk
└─xvdd1  202:49   0    5G  0 part
```

### Why `lsblk` matters

Never assume that a disk is named `/dev/sdb`.

On this EC2 instance, the additional disk appeared as:

```text
/dev/xvdd
```

Always inspect the system first.

---

# 5. Create a GPT Partition

Open the new disk:

```bash
sudo fdisk /dev/xvdd
```

Inside `fdisk`:

```text
g
```

Creates a new GPT partition table.

Then:

```text
n
```

Creates a new partition.

Select:

```text
1
```

for partition number.

Accept the default first sector:

```text
Enter
```

Accept the default last sector:

```text
Enter
```

Change the partition type:

```text
t
```

Select **Linux LVM** from the available partition types.

Finally:

```text
w
```

Write the changes to disk.

Verify:

```bash
lsblk
```

Expected:

```text
xvdd
└─xvdd1
```

---

# 6. Create the Physical Volume

Initialize the partition for LVM:

```bash
sudo pvcreate /dev/xvdd1
```

Verify:

```bash
sudo pvs
```

For detailed information:

```bash
sudo pvdisplay
```

### Important

At this stage:

```text
/dev/xvdd1
```

is a **Physical Volume**.

It is not yet a filesystem.

---

# 7. Create the Volume Group

Create a volume group called `vgdata`:

```bash
sudo vgcreate vgdata /dev/xvdd1
```

Verify:

```bash
sudo vgs
```

For detailed information:

```bash
sudo vgdisplay vgdata
```

The architecture is now:

```text
/dev/xvdd1
     │
     ▼
Physical Volume
     │
     ▼
vgdata
```

---

# 8. Create the Logical Volume

Create a 3 GB logical volume called `lvdata`:

```bash
sudo lvcreate -L 3G -n lvdata vgdata
```

Verify:

```bash
sudo lvs
```

For detailed information:

```bash
sudo lvdisplay /dev/vgdata/lvdata
```

The resulting device can be accessed as:

```text
/dev/vgdata/lvdata
```

It may also appear as:

```text
/dev/mapper/vgdata-lvdata
```

These refer to the same logical volume.

---

# 9. Create the XFS Filesystem

Create an XFS filesystem:

```bash
sudo mkfs.xfs /dev/vgdata/lvdata
```

### Important warning

`mkfs.xfs` creates a new filesystem.

It can destroy existing data on the target device.

Always verify the target before executing:

```bash
sudo mkfs.xfs ...
```

---

# 10. Create the Mount Point

Create `/data`:

```bash
sudo mkdir -p /data
```

Mount the LV:

```bash
sudo mount /dev/vgdata/lvdata /data
```

Verify:

```bash
df -h /data
```

You should see something similar to:

```text
Filesystem                 Size  Used Avail Use% Mounted on
/dev/mapper/vgdata-lvdata  3.0G   90M  2.9G   3% /data
```

You can also verify using:

```bash
findmnt /data
```

---

# 11. Test the Filesystem

Create a test file:

```bash
echo "RHCSA LVM practice" | sudo tee /data/test.txt
```

Read it:

```bash
cat /data/test.txt
```

Expected:

```text
RHCSA LVM practice
```

This confirms that the filesystem is writable.

---

# 12. Find the Filesystem UUID

Use:

```bash
sudo blkid /dev/vgdata/lvdata
```

In this lab, the UUID was:

```text
953c6707-13be-46df-88b2-7d20697e26b0
```

The filesystem information was:

```text
TYPE="xfs"
```

Complete example:

```text
/dev/vgdata/lvdata: UUID="953c6707-13be-46df-88b2-7d20697e26b0" BLOCK_SIZE="512" TYPE="xfs"
```

---

# 13. Configure Persistent Mounting

A normal `mount` command only creates a temporary mount.

To automatically mount `/data` after reboot, configure:

```text
/etc/fstab
```

Open it:

```bash
sudo vim /etc/fstab
```

Add:

```text
UUID=953c6707-13be-46df-88b2-7d20697e26b0  /data  xfs  defaults  0  0
```

---

# 14. Understanding the `/etc/fstab` Entry

The entry:

```text
UUID=953c6707-13be-46df-88b2-7d20697e26b0  /data  xfs  defaults  0  0
```

contains six fields.

| Field | Value | Purpose |
|---|---|---|
| 1 | UUID | Identifies the filesystem |
| 2 | `/data` | Mount point |
| 3 | `xfs` | Filesystem type |
| 4 | `defaults` | Default mount options |
| 5 | `0` | Dump field |
| 6 | `0` | Filesystem check order |

### Why use UUID?

Device names can vary depending on the environment.

The filesystem UUID identifies the filesystem itself.

For RHCSA, remember:

```text
UUID → mount point → filesystem → options → dump → fsck
```

---

# 15. Reload Systemd

After modifying `/etc/fstab`:

```bash
sudo systemctl daemon-reload
```

This reloads systemd's configuration.

---

# 16. Test `/etc/fstab`

Because `/data` was already mounted, first unmount it:

```bash
sudo umount /data
```

Then test all fstab entries:

```bash
sudo mount -a
```

If there is no output, that is normally a good sign.

Verify:

```bash
df -h /data
```

And:

```bash
findmnt /data
```

---

# 17. Troubleshooting the Mount Error

During this lab, the following error appeared:

```text
mount: /data: /dev/xvdd1 already mounted or mount point busy.
```

The important clue was:

```text
/dev/mapper/vgdata-lvdata  → /data
```

while the error referred to:

```text
/dev/xvdd1
```

### What was wrong?

The configuration was attempting to mount the **Physical Volume partition**:

```text
/dev/xvdd1
```

instead of the filesystem created on the **Logical Volume**:

```text
/dev/vgdata/lvdata
```

### Correct structure

```text
/dev/xvdd1
    │
    └── PV
         │
         └── vgdata
                │
                └── lvdata
                      │
                      └── XFS
                           │
                           └── /data
```

Therefore, the `/etc/fstab` entry should reference:

```text
UUID=<UUID of lvdata>
```

not:

```text
/dev/xvdd1
```

---

# 18. Final Verification Commands

Use these commands to verify every layer.

### Disk and partition

```bash
lsblk
```

### Physical Volume

```bash
sudo pvs
```

### Volume Group

```bash
sudo vgs
```

### Logical Volume

```bash
sudo lvs
```

### Filesystem UUID

```bash
sudo blkid /dev/vgdata/lvdata
```

### Mounted filesystem

```bash
df -h /data
```

### Mount source

```bash
findmnt /data
```

### Persistent configuration

```bash
cat /etc/fstab
```

---

# 19. Reboot Persistence Test

Once `/etc/fstab` has been verified:

```bash
sudo reboot
```

After reconnecting to the server:

```bash
df -h /data
```

Then:

```bash
findmnt /data
```

If `/data` is mounted automatically, your persistent mount configuration is working.

---

# 20. Complete RHCSA LVM Command Sequence

The complete workflow can be remembered as:

```bash
# 1. Identify disk
lsblk

# 2. Partition disk
sudo fdisk /dev/xvdd

# 3. Create PV
sudo pvcreate /dev/xvdd1

# 4. Verify PV
sudo pvs

# 5. Create VG
sudo vgcreate vgdata /dev/xvdd1

# 6. Verify VG
sudo vgs

# 7. Create LV
sudo lvcreate -L 3G -n lvdata vgdata

# 8. Verify LV
sudo lvs

# 9. Create filesystem
sudo mkfs.xfs /dev/vgdata/lvdata

# 10. Create mount point
sudo mkdir -p /data

# 11. Mount
sudo mount /dev/vgdata/lvdata /data

# 12. Get UUID
sudo blkid /dev/vgdata/lvdata

# 13. Configure persistent mount
sudo vim /etc/fstab

# 14. Reload systemd
sudo systemctl daemon-reload

# 15. Test
sudo umount /data
sudo mount -a

# 16. Verify
df -h /data
findmnt /data
```

---

# 21. RHCSA Storage Workflow to Memorize

Memorize this sequence:

```text
Disk
 ↓
Partition
 ↓
PV
 ↓
VG
 ↓
LV
 ↓
Filesystem
 ↓
Mount Point
 ↓
UUID
 ↓
/etc/fstab
 ↓
Persistent Mount
```

Or remember:

```text
fdisk
  ↓
pvcreate
  ↓
vgcreate
  ↓
lvcreate
  ↓
mkfs.xfs
  ↓
mount
  ↓
blkid
  ↓
fstab
```

---

# 22. Common RHCSA Mistakes

### Mistake 1 — Assuming the disk name

Wrong:

```bash
sudo fdisk /dev/sdb
```

when `/dev/sdb` does not exist.

Correct:

```bash
lsblk
```

Then identify the actual disk.

---

### Mistake 2 — Modifying the root disk

Avoid experimenting on:

```text
/dev/xvda
```

when it contains the operating system.

Use a dedicated lab disk.

---

### Mistake 3 — Mounting the PV

Do not treat:

```text
/dev/xvdd1
```

as the final filesystem.

It is the PV.

The filesystem is on:

```text
/dev/vgdata/lvdata
```

---

### Mistake 4 — Forgetting the filesystem

Creating an LV does not automatically create a filesystem.

You need:

```bash
sudo mkfs.xfs /dev/vgdata/lvdata
```

---

### Mistake 5 — Using the wrong UUID

Get the UUID from the LV:

```bash
sudo blkid /dev/vgdata/lvdata
```

Do not accidentally use the UUID of another partition.

---

### Mistake 6 — Not testing `/etc/fstab`

Before rebooting:

```bash
sudo umount /data
sudo mount -a
```

Then verify:

```bash
df -h /data
```

---

# 23. RHCSA Quick Command Reference

| Task | Command |
|---|---|
| List disks | `lsblk` |
| Partition disk | `sudo fdisk /dev/xvdd` |
| Create PV | `sudo pvcreate /dev/xvdd1` |
| Show PVs | `sudo pvs` |
| Detailed PV | `sudo pvdisplay` |
| Create VG | `sudo vgcreate vgdata /dev/xvdd1` |
| Show VGs | `sudo vgs` |
| Detailed VG | `sudo vgdisplay` |
| Create LV | `sudo lvcreate -L 3G -n lvdata vgdata` |
| Show LVs | `sudo lvs` |
| Detailed LV | `sudo lvdisplay` |
| Create XFS | `sudo mkfs.xfs /dev/vgdata/lvdata` |
| Mount | `sudo mount /dev/vgdata/lvdata /data` |
| Unmount | `sudo umount /data` |
| Get UUID | `sudo blkid /dev/vgdata/lvdata` |
| Test fstab | `sudo mount -a` |
| Reload systemd | `sudo systemctl daemon-reload` |
| Disk usage | `df -h` |
| Mount information | `findmnt` |

---

# 24. Self-Test Questions

Before moving to the next RHCSA storage topic, make sure you can answer these without looking at the commands.

1. What is a Physical Volume?
2. What is a Volume Group?
3. What is a Logical Volume?
4. What is the relationship between PV, VG, and LV?
5. Why do we create a filesystem on the LV?
6. Why is `/dev/xvdd1` not the correct filesystem mount source in this lab?
7. What command displays the filesystem UUID?
8. Why is UUID useful in `/etc/fstab`?
9. What does `mount -a` do?
10. Why should you test `/etc/fstab` before rebooting?
11. What command shows the actual filesystem mounted at `/data`?
12. What is the purpose of `systemctl daemon-reload` after changing configuration?
13. What happens if you run `mkfs.xfs` on a device containing important data?
14. How would you verify that an LV exists?
15. How would you verify that the VG has free space?

---

# 25. Final Lab Summary

This lab created a complete LVM storage stack on a dedicated 5 GB disk.

The final architecture was:

```text
/dev/xvdd
    │
    └── /dev/xvdd1
            │
            ▼
       Physical Volume
            │
            ▼
          vgdata
            │
            ▼
          lvdata
            │
            ▼
       XFS filesystem
            │
            ▼
           /data
```

The filesystem UUID used in the lab was:

```text
953c6707-13be-46df-88b2-7d20697e26b0
```

The persistent `/etc/fstab` configuration was:

```text
UUID=953c6707-13be-46df-88b2-7d20697e26b0  /data  xfs  defaults  0  0
```

The most important lesson from the troubleshooting step is:

> **Mount the filesystem on the Logical Volume, not the Physical Volume partition.**

For this lab:

```text
PV: /dev/xvdd1
VG: vgdata
LV: /dev/vgdata/lvdata
Mount: /data
```

This is the complete workflow you should be comfortable reproducing during RHCSA hands-on practice.

---

## RHCSA Memory Shortcut

```text
P → V → L → F → M → U → F

Partition
   ↓
Volume
   ↓
Logical volume
   ↓
Filesystem
   ↓
Mount
   ↓
UUID
   ↓
fstab
```

**Practice until you can build the entire chain without referring to the notes.**