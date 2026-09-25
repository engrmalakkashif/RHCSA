# NFS Server + Autofs Client Lab

## Lab Objective

In this lab:

```text
NFS SERVER
   |
   |  /share
   |  ├── f1
   |  └── f2
   |
   |  NFS
   ↓
NFS CLIENT
   |
   |  Autofs
   ↓
/auto_mount/access
   |
   ├── f1
   └── f2
```

The client will **automatically mount** `/share` when you access:

```bash
cd /auto_mount/access
```

---

# Part 1 — NFS Server

Assume the server private IP is:

```text
SERVER_IP=10.0.1.10
```

Replace `10.0.1.10` with your actual NFS server IP.

## 1. Install NFS Server

On the **NFS Server**:

```bash
sudo apt update
sudo apt install nfs-kernel-server -y
```

Check the service:

```bash
sudo systemctl status nfs-server
```

On Ubuntu, you may also see:

```bash
sudo systemctl status nfs-kernel-server
```

Enable it at boot:

```bash
sudo systemctl enable nfs-server --now
```

---

## 2. Create the NFS Shared Directory

Create `/share`:

```bash
sudo mkdir -p /share
```

Create two test files:

```bash
sudo touch /share/f1
sudo touch /share/f2
```

Check:

```bash
ls -l /share
```

Expected:

```text
f1
f2
```

---

## 3. Set Permissions

For a simple lab, you can use:

```bash
sudo chmod 777 /share
```

Check:

```bash
ls -ld /share
```

Expected similar to:

```text
drwxrwxrwx ... /share
```

> `777` is convenient for a lab. In production, use appropriate ownership and permissions instead.

---

## 4. Configure NFS Export

Edit:

```bash
sudo vim /etc/exports
```

Add:

```text
/share 10.0.1.20(rw,sync,no_subtree_check)
```

Here:

```text
/share
```

is the directory being shared.

```text
10.0.1.20
```

is the **NFS Client IP**.

```text
rw
```

allows read/write access.

```text
sync
```

writes data synchronously.

```text
no_subtree_check
```

avoids subtree checking issues.

### Allow an entire subnet

For example, if your clients are in:

```text
10.0.1.0/24
```

you can use:

```text
/share 10.0.1.0/24(rw,sync,no_subtree_check)
```

---

## 5. Apply the Export

Run:

```bash
sudo exportfs -rav
```

Expected output:

```text
exporting 10.0.1.20:/share
```

Check exports:

```bash
sudo exportfs -v
```

You should see `/share`.

---

## 6. Restart NFS

```bash
sudo systemctl restart nfs-server
```

Check:

```bash
sudo systemctl status nfs-server
```

---

## 7. Verify Server Files

Run:

```bash
ls -l /share
```

Expected:

```text
f1
f2
```

At this point the **NFS Server is ready**.

---

# Part 2 — AWS Security Group

If you are doing this on **AWS EC2**, make sure the NFS Client can communicate with the NFS Server.

For a basic lab, allow traffic from the **client security group/IP** to the server.

Typical NFS traffic includes:

```text
TCP 2049
TCP/UDP 111
```

For an NFSv3-style `showmount` lab, RPC-related ports may also be involved.

For learning, the safest approach is to allow the required NFS/RPC traffic **only from the client private IP or client security group**, not from the entire internet.

Do not use:

```text
0.0.0.0/0
```

for NFS access.

---

# Part 3 — NFS Client

Now connect to the **NFS Client** EC2 instance.

Assume:

```text
SERVER_IP=10.0.1.10
```

---

## 1. Install NFS Client and Autofs

Because this is Ubuntu/Debian, use:

```bash
sudo apt update
sudo apt install nfs-common autofs -y
```

### Important

You wrote:

```bash
apt install nfs-utils autofs
```

`nfs-utils` is normally used on **RHEL/CentOS/Rocky/AlmaLinux** systems.

For Ubuntu:

```bash
nfs-common
```

is the correct NFS client package.

---

# Part 4 — Test NFS Server From Client

## 1. Check Available Exports

Run:

```bash
showmount -e 10.0.1.10
```

Expected:

```text
Export list for 10.0.1.10:
/share 10.0.1.20
```

Or if you exported a subnet:

```text
Export list for 10.0.1.10:
/share 10.0.1.0/24
```

This confirms the client can see the NFS export.

---

# Part 5 — Configure Autofs

Autofs automatically mounts the NFS share when you access the configured directory.

## 1. Edit `/etc/auto.master`

Open:

```bash
sudo vim /etc/auto.master
```

Find:

```text
/misc   /etc/auto.misc
```

Comment it:

```text
#/misc   /etc/auto.misc
```

Then add:

```text
/auto_mount     /etc/auto.misc
```

Your configuration should look similar to:

```text
#/misc   /etc/auto.misc

/auto_mount     /etc/auto.misc
```

Save and exit.

---

# Part 6 — Configure `/etc/auto.misc`

Open:

```bash
sudo vim /etc/auto.misc
```

Go to the end and add:

```text
access    -rw,soft,intr    10.0.1.10:/share
```

So the important entry is:

```text
access    -rw,soft,intr    SERVER_IP:/share
```

For example:

```text
access    -rw,soft,intr    10.0.1.10:/share
```

### Meaning

```text
access
```

This becomes the directory name.

```text
-rw
```

Mount read/write.

```text
soft
```

Uses a soft timeout behavior.

```text
intr
```

Historically allowed interruption of NFS requests.

```text
10.0.1.10:/share
```

NFS server IP and exported directory.

> For modern production NFS configurations, `hard` is generally preferred over `soft` because `soft` can lead to incomplete I/O behavior. `intr` is also largely obsolete on modern Linux. Keep these options for this learning exercise because they are part of your requested lab.

---

# Part 7 — Enable Autofs

Run:

```bash
sudo systemctl enable autofs --now
```

Check:

```bash
sudo systemctl status autofs
```

You should see:

```text
Active: active (running)
```

---

# Part 8 — Test Automatic Mounting

First check the root directory:

```bash
ls /
```

You should see:

```text
auto_mount
```

Now:

```bash
cd /auto_mount
```

Check:

```bash
ls
```

You should see:

```text
access
```

Now enter:

```bash
cd access
```

Check:

```bash
ls
```

Expected:

```text
f1
f2
```

Congratulations — the NFS share is being automatically mounted by **Autofs**.

---

# Part 9 — Verify the Mount

Run:

```bash
mount | grep /auto_mount
```

You should see an NFS mount similar to:

```text
10.0.1.10:/share on /auto_mount/access type nfs
```

You can also use:

```bash
df -hT
```

Look for the NFS filesystem.

---

# Part 10 — Test From Client

Try:

```bash
cat /auto_mount/access/f1
```

Since `f1` is currently empty, there may be no output.

Create some test content:

```bash
sudo sh -c 'echo "Hello from NFS Server" > /auto_mount/access/f1'
```

Then:

```bash
cat /auto_mount/access/f1
```

Expected:

```text
Hello from NFS Server
```

Now go to the NFS Server:

```bash
cat /share/f1
```

You should see:

```text
Hello from NFS Server
```

This proves the client is writing to the **NFS server's `/share` directory**.

---

# Part 11 — Understand the Directory Mapping

The configuration creates this relationship:

```text
/etc/auto.master

/auto_mount  →  /etc/auto.misc
```

Then `/etc/auto.misc` says:

```text
access  →  SERVER_IP:/share
```

Therefore:

```text
/auto_mount/access
        |
        ↓
SERVER_IP:/share
```

So:

```text
/auto_mount/access/f1
```

actually comes from:

```text
SERVER_IP:/share/f1
```

---

# Part 12 — Complete Configuration

## NFS Server

### Install

```bash
sudo apt update
sudo apt install nfs-kernel-server -y
```

### Create share

```bash
sudo mkdir -p /share
sudo touch /share/f1
sudo touch /share/f2
sudo chmod 777 /share
```

### Configure export

```bash
sudo vim /etc/exports
```

Add:

```text
/share CLIENT_IP(rw,sync,no_subtree_check)
```

Example:

```text
/share 10.0.1.20(rw,sync,no_subtree_check)
```

### Apply

```bash
sudo exportfs -rav
sudo systemctl restart nfs-server
sudo systemctl enable nfs-server --now
```

### Verify

```bash
sudo exportfs -v
ls -l /share
```

---

# NFS Client

### Install

```bash
sudo apt update
sudo apt install nfs-common autofs -y
```

### Test server

```bash
showmount -e SERVER_IP
```

Example:

```bash
showmount -e 10.0.1.10
```

### Edit Autofs master

```bash
sudo vim /etc/auto.master
```

Comment:

```text
#/misc   /etc/auto.misc
```

Add:

```text
/auto_mount     /etc/auto.misc
```

### Edit map

```bash
sudo vim /etc/auto.misc
```

Add:

```text
access    -rw,soft,intr    SERVER_IP:/share
```

Example:

```text
access    -rw,soft,intr    10.0.1.10:/share
```

### Start Autofs

```bash
sudo systemctl enable autofs --now
```

### Test

```bash
ls /
cd /auto_mount
ls
cd access
ls
```

Expected:

```text
f1
f2
```

---

# Final Architecture

```text
                 AWS VPC
        ┌─────────────────────────────┐
        │                             │
        │   NFS SERVER                │
        │   10.0.1.10                │
        │                             │
        │   /share                    │
        │    ├── f1                   │
        │    └── f2                   │
        │         │                   │
        └─────────┼───────────────────┘
                  │
                  │ NFS
                  │
                  ▼
        ┌─────────────────────────────┐
        │   NFS CLIENT                │
        │   10.0.1.20                │
        │                             │
        │   Autofs                    │
        │                             │
        │   /etc/auto.master          │
        │        │                    │
        │        ▼                    │
        │   /etc/auto.misc            │
        │        │                    │
        │        ▼                    │
        │   /auto_mount/access        │
        │        │                    │
        │        ▼                    │
        │       f1 f2                 │
        │                             │
        └─────────────────────────────┘
```

## Commands to Remember

```bash
showmount -e SERVER_IP
```

```bash
sudo exportfs -rav
```

```bash
sudo exportfs -v
```

```bash
sudo systemctl enable autofs --now
```

```bash
mount | grep nfs
```

```bash
df -hT
```

```bash
cd /auto_mount/access
```

The key concept is:

```text
NFS Server:
 /share

        ↓

Autofs Client:
 /auto_mount/access

        ↓

Actual files:
 f1
 f2
```

Autofs does **not permanently mount the share at boot like `/etc/fstab`**. It mounts it on demand when you access `/auto_mount/access`.