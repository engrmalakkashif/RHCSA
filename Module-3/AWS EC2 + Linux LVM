# AWS EC2 + Linux LVM — Simple Step-by-Step Lab Guide

**Goal:** Set up LVM storage on an Ubuntu EC2 instance, then extend it later.

---

## Before You Start

Run this command first to see your disks:
```
lsblk
```
Your root disk (usually `nvme0n1`) is where the OS lives. **Never run partition or format commands on it.** Only touch the extra disks you attach.

---

## Part 1: Set Up AWS

**Step 1 — Launch an EC2 instance**
- Go to AWS Console → EC2 → Launch Instance
- Name: `lvm-lab`
- AMI: Ubuntu Server 24.04 LTS
- Instance type: t3.micro
- Root storage: 20 GB, gp3
- Launch it

**Step 2 — Connect to the instance**
```
ssh -i my-key.pem ubuntu@<EC2-PUBLIC-IP>
```

**Step 3 — Update and install LVM tools**
```
sudo apt update
sudo apt install lvm2 -y
```

**Step 4 — Create two EBS volumes**
- EC2 → Elastic Block Store → Volumes → Create volume
- Size: 10 GiB, Type: gp3, same Availability Zone as your EC2
- Repeat to create a second 10 GiB volume

**Step 5 — Attach both volumes to your EC2 instance**
- Select each volume → Actions → Attach volume → choose your instance

---

## Part 2: Identify the Disks

**Step 6 — Check the disks**
```
lsblk
```
You should see two new disks (e.g. `nvme1n1` and `nvme2n1`) with no filesystem yet. Use your actual device names for every step below.

---

## Part 3: Create Partitions

**Step 7 — Partition each new disk**
For each disk (repeat for `nvme1n1` and `nvme2n1`):
```
sudo fdisk /dev/nvme1n1
```
Inside fdisk, type these one at a time (press Enter after each):
```
n
p
1
[Enter]
[Enter]
t
8e
w
```
If `8e` isn't accepted, type `L` to list types and pick "Linux LVM."

**Step 8 — Verify**
```
lsblk
```
You should now see `nvme1n1p1` and `nvme2n1p1`.

---

## Part 4: Build the LVM Stack

**Step 9 — Create Physical Volumes (PVs)**
```
sudo pvcreate /dev/nvme1n1p1
sudo pvcreate /dev/nvme2n1p1
sudo pvs
```

**Step 10 — Create a Volume Group (VG)**
```
sudo vgcreate vg_data /dev/nvme1n1p1 /dev/nvme2n1p1
sudo vgs
```

**Step 11 — Create a Logical Volume (LV)**
```
sudo lvcreate -L 10G -n lv_app vg_data
sudo lvs
```

**Step 12 — Format it with a filesystem**
```
sudo mkfs.ext4 /dev/vg_data/lv_app
```

---

## Part 5: Mount It

**Step 13 — Create a mount point and mount**
```
sudo mkdir /app
sudo mount /dev/vg_data/lv_app /app
df -h
```

**Step 14 — Test it**
```
echo "LVM AWS Lab" | sudo tee /app/test.txt
cat /app/test.txt
```

---

## Part 6: Make It Permanent (survive reboot)

**Step 15 — Get the UUID**
```
sudo blkid /dev/vg_data/lv_app
```
Copy the UUID value shown.

**Step 16 — Back up fstab, then edit it**
```
sudo cp /etc/fstab /etc/fstab.backup
sudo nano /etc/fstab
```
Add this line (replace with your real UUID):
```
UUID=your-uuid-here /app ext4 defaults 0 2
```

**Step 17 — Test before rebooting**
```
sudo umount /app
sudo mount -a
df -h /app
```
If `/app` mounts with no errors, it worked.

**Step 18 — Reboot and confirm**
```
sudo reboot
```
After reconnecting:
```
df -h /app
```

---

## Part 7: Extend Storage (grow the LV)

**Step 19 — Extend the LV and filesystem together (easiest method)**
```
sudo lvextend -r -L +5G /dev/vg_data/lv_app
df -h /app
```
The `-r` flag resizes the filesystem automatically — no separate `resize2fs` step needed.

---

## Part 8: Add a Third Disk (grow the whole pool)

**Step 20 — Create and attach a third 10 GB EBS volume** (same as Step 4–5)

**Step 21 — Partition it**
```
sudo fdisk /dev/nvme3n1
```
Same fdisk steps as before: `n → p → 1 → Enter → Enter → t → 8e → w`

**Step 22 — Add it to LVM**
```
sudo pvcreate /dev/nvme3n1p1
sudo vgextend vg_data /dev/nvme3n1p1
sudo vgs
```

**Step 23 — Extend the LV again**
```
sudo lvextend -r -L +10G /dev/vg_data/lv_app
df -h /app
```

---

## Quick Reference: Key Commands

| Layer | Create | View |
|---|---|---|
| Physical Volume | `pvcreate /dev/xxx` | `pvs` / `pvdisplay` |
| Volume Group | `vgcreate vg_name /dev/xxx` | `vgs` / `vgdisplay` |
| Logical Volume | `lvcreate -L 10G -n lv_name vg_name` | `lvs` / `lvdisplay` |
| Extend VG | `vgextend vg_name /dev/xxx` | — |
| Extend LV | `lvextend -r -L +5G /dev/vg_name/lv_name` | — |

**Troubleshooting commands:** `lsblk`, `lsblk -f`, `sudo blkid`, `df -h`, `sudo pvs`, `sudo vgs`, `sudo lvs`

---

## How It All Fits Together

```
AWS EBS Volume
   → Linux Partition
      → Physical Volume (PV)
         → Volume Group (VG) — the storage pool
            → Logical Volume (LV) — your allocated chunk
               → Filesystem (ext4)
                  → Mount point (e.g. /app)
```

## Checklist

- [ ] Launch Ubuntu 24.04 EC2
- [ ] Create and attach two 10 GB EBS volumes
- [ ] Partition both disks
- [ ] Create PVs, VG, and LV
- [ ] Format and mount to `/app`
- [ ] Add entry to `/etc/fstab` and test with `mount -a`
- [ ] Reboot and confirm it persists
- [ ] Extend LV by 5 GB
- [ ] Add a third EBS disk and extend the VG and LV again
