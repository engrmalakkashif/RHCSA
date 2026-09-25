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

For a single client, use the client's IP:

```text
/share 10.0.1.20(rw,sync,no_subtree_check)
```

If you want to allow the whole subnet, use the **network address**, not an arbitrary host IP with `/20`.

For example:

```text
/share 10.0.1.0/24(rw,sync,no_subtree_check)
```

For a `/20` subnet such as `172.31.16.0/20`, use:

```text
/share 172.31.16.0/20(rw,sync,no_subtree_check)
```

> Important: `172.31.21.116/20` describes a host address with a prefix length. The corresponding `/20` network is `172.31.16.0/20`.

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

## 8. Verify RPC and NFS Services

Before troubleshooting the client, verify that the NFS server is listening.

Check `rpcbind`:

```bash
sudo systemctl status rpcbind
```

If necessary:

```bash
sudo systemctl enable --now rpcbind
```

Check registered RPC services:

```bash
sudo rpcinfo -p
```

You should see services such as:

```text
100000 ... 111    portmapper
100005 ... ...    mountd
100003 ... 2049   nfs
```

Check listening ports:

```bash
sudo ss -lntup | grep -E '2049|111'
```

You should see TCP port `111` and NFS port `2049` listening.

---

## 9. AWS Security Group for NFS

For an AWS EC2 lab, the NFS server's Security Group must allow the required traffic from the client.

At minimum, allow:

```text
TCP 2049  - NFS
TCP 111   - rpcbind
UDP 111   - rpcbind
```

For `showmount`/NFSv3, `mountd` may use a dynamic port. This can cause:

```bash
showmount -e SERVER_IP
```

to hang even when TCP 111 and TCP 2049 work.

For a predictable lab configuration, pin `mountd` to a fixed port.

Edit:

```bash
sudo vim /etc/nfs.conf
```

Add:

```ini
[mountd]
port=20048
```

Restart NFS:

```bash
sudo systemctl restart nfs-server
```

Verify:

```bash
sudo rpcinfo -p | grep mountd
```

Then allow:

```text
TCP 20048
UDP 20048
```

from the client subnet/security group.

> Restrict NFS/RPC rules to the client private IP, client subnet, or client Security Group. Do not expose NFS to `0.0.0.0/0` in a real environment.

---

## 10. Test Connectivity From the NFS Client

Do these tests **from the NFS client**, not from the NFS server itself.

Test the server IP:

```bash
ping SERVER_IP
```

Ping may fail on AWS because ICMP is not necessarily allowed by the Security Group. That does not by itself mean NFS is broken.

Test NFS:

```bash
nc -zv SERVER_IP 2049
```

Test RPC:

```bash
nc -zv SERVER_IP 111
```

If `mountd` was configured to use port `20048`:

```bash
nc -zv SERVER_IP 20048
```

A successful TCP test to `2049` and `111` is more useful for NFS troubleshooting than ping alone.

---

## 11. Test RPC From the Client

Run:

```bash
rpcinfo -p SERVER_IP
```

You should see the NFS and RPC services registered by the server.

Then test the exported filesystem:

```bash
showmount -e SERVER_IP
```

Expected:

```text
Export list for SERVER_IP:
/share CLIENT_IP
```

or:

```text
Export list for SERVER_IP:
/share CLIENT_SUBNET
```

If `showmount` hangs while ports `111` and `2049` are reachable, check the `mountd` port and its Security Group rule.


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

Create some test content.

First check the file ownership and permissions on the NFS server:

```bash
ls -ln /share/f1
```

On the client, check the current user's UID/GID:

```bash
id
```

NFS uses numeric UID/GID values to enforce normal filesystem permissions.

If the exported filesystem uses the default:

```text
root_squash
```

then `sudo`/root on the client is **not treated as root on the NFS server**. Therefore this may fail:

```bash
sudo sh -c 'echo "Hello from NFS Client" > /auto_mount/access/f1'
```

with:

```text
Permission denied
```

This is expected when the server-side file permissions do not allow the squashed identity to write.

For a simple lab, one option is to make the test file writable:

```bash
# Run on NFS Server
sudo chmod 666 /share/f1
```

Then on the client:

```bash
echo "Hello from NFS Client" > /auto_mount/access/f1
```

Read it:

```bash
cat /auto_mount/access/f1
```

Expected:

```text
Hello from NFS Client
```

Now verify on the NFS Server:

```bash
cat /share/f1
```

You should see:

```text
Hello from NFS Client
```

### Better approach: match UID/GID

For a more realistic setup, use consistent UID/GID ownership instead of making files world-writable.

On the NFS server:

```bash
sudo chown ubuntu:ubuntu /share/f1
sudo chmod 644 /share/f1
```

On the client:

```bash
id ubuntu
```

Make sure the numeric UID/GID matches the server's ownership:

```bash
ls -ln /share/f1
```

> Do not disable `root_squash` just to solve a normal permissions problem. `root_squash` is a security feature that prevents root on the NFS client from automatically becoming root on the NFS server.

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

# Troubleshooting Checklist

## `showmount -e SERVER_IP` hangs

Check on the server:

```bash
sudo rpcinfo -p
```

Look for `mountd`.

If `mountd` is using a dynamic port, configure:

```ini
[mountd]
port=20048
```

in `/etc/nfs.conf`, restart NFS, and allow TCP/UDP `20048` in the AWS Security Group.

Then from the client:

```bash
nc -zv SERVER_IP 111
nc -zv SERVER_IP 2049
nc -zv SERVER_IP 20048
showmount -e SERVER_IP
```

## `ping SERVER_IP` fails

On AWS, ICMP may simply not be allowed by the Security Group. If:

```bash
nc -zv SERVER_IP 111
nc -zv SERVER_IP 2049
```

succeed, NFS network connectivity may still be fine.

## `/auto_mount` does not appear

Check `/etc/auto.master`:

```text
/auto_mount     /etc/auto.misc
```

Then restart:

```bash
sudo systemctl restart autofs
```

Check:

```bash
sudo systemctl status autofs
ls /
```

## `/auto_mount/access` is empty or does not mount

Check `/etc/auto.misc`:

```text
access    -rw,soft,intr    SERVER_IP:/share
```

Make sure the exported path exactly matches `showmount -e SERVER_IP`.

Then access the directory:

```bash
cd /auto_mount/access
ls
```

Autofs mounts the filesystem on demand.

## NFS write gives `Permission denied`

Check server-side permissions:

```bash
ls -ln /share/f1
```

Check the client identity:

```bash
id
```

Remember that NFS uses numeric UID/GID values and that `root_squash` prevents client root from being treated as server root.

---

# Useful Verification Commands

### NFS Server

```bash
sudo exportfs -v
sudo exportfs -s
sudo rpcinfo -p
sudo ss -lntup | grep -E '111|2049|20048'
sudo systemctl status rpcbind
sudo systemctl status nfs-server
ls -ln /share
```

### NFS Client

```bash
showmount -e SERVER_IP
rpcinfo -p SERVER_IP
nc -zv SERVER_IP 111
nc -zv SERVER_IP 2049
nc -zv SERVER_IP 20048
sudo systemctl status autofs
ls /
ls /auto_mount
cd /auto_mount/access
ls
mount | grep nfs
df -hT
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