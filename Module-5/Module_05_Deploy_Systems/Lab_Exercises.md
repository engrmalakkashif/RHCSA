# RHCSA Module 5: Deploy, Configure, and Maintain Systems
## Lab Exercises (8 Hands-On Practice Tasks)

---

## Lab Exercise 1: Configure System Time and Timezone

**Objective:** Configure system time synchronization and set correct timezone

**Difficulty:** Beginner | **Time:** 30-45 minutes | **Command Count:** 10+

### Exercise Description

You need to configure a system to use proper time synchronization and set it to the correct timezone. This is critical for log accuracy, scheduled tasks, and security.

### Requirements

1. Set timezone to `America/Chicago`
2. Enable NTP synchronization (chrony)
3. Verify time is synchronized
4. Check current time and date

### Step-by-Step Instructions

**Step 1: Check Current Time Settings**

```bash
# Check current timezone
timedatectl

# Note the current time and timezone
```

**Step 2: View Available Timezones**

```bash
# List all timezones containing "America"
timedatectl list-timezones | grep "America/"

# You should see America/Chicago in the list
```

**Step 3: Set Timezone**

```bash
# Set timezone to America/Chicago
sudo timedatectl set-timezone America/Chicago

# Verify the change
timedatectl
```

**Step 4: Enable NTP Synchronization**

```bash
# Enable NTP
sudo timedatectl set-ntp true

# Verify NTP is enabled
timedatectl | grep "NTP"
```

**Step 5: Check Chrony Status**

```bash
# Start chrony service (if not already running)
sudo systemctl start chronyd
sudo systemctl enable chronyd

# Check service status
sudo systemctl status chronyd

# Show time sources
sudo chronyc sources

# Show tracking info
sudo chronyc tracking
```

**Step 6: Verify Synchronization**

```bash
# Check if system is synchronized
timedatectl | grep "System clock synchronized"

# Check current date and time
date

# Should show "synchronized: yes" and correct timezone
```

### Verification Checklist

- [ ] Timezone changed to America/Chicago
- [ ] NTP enabled and synchronization active
- [ ] chrony service running
- [ ] System clock synchronized
- [ ] Date and time correct
- [ ] `timedatectl` shows all settings correct

### Expected Output Examples

```bash
$ timedatectl
               Local time: Mon 2024-01-15 14:35:42 CST
           Universal time: Mon 2024-01-15 20:35:42 UTC
                 RTC time: Mon 2024-01-15 20:35:42
                Time zone: America/Chicago (CST, -0600)
System clock synchronized: yes
              NTP service: active

$ sudo chronyc sources
MS Name/IP address         Stratum Poll Reach LastRx Last sample
===============================================================
^* time.google.com               1   6    17    42   -124us[-130us] +/-   18ms
```

### Troubleshooting Tips

- If chrony won't start: `sudo systemctl restart chronyd`
- If NTP shows inactive: `sudo timedatectl set-ntp true`
- To force time update: `sudo chronyc makestep`

---

## Lab Exercise 2: Configure Hostname and Network

**Objective:** Set hostname and configure network connection

**Difficulty:** Beginner | **Time:** 30-45 minutes | **Command Count:** 15+

### Exercise Description

Configure system hostname and set up a static IP address using NetworkManager.

### Requirements

1. Set hostname to `webserver.example.com`
2. Create or modify network connection with static IP
3. Set DNS servers
4. Verify network connectivity

### Step-by-Step Instructions

**Step 1: Check Current Hostname**

```bash
# View current hostname
hostnamectl

# Show only static hostname
hostnamectl --query --static
```

**Step 2: Set Hostname**

```bash
# Set static hostname
sudo hostnamectl set-hostname webserver.example.com

# Verify
hostnamectl

# Also check the file
cat /etc/hostname
```

**Step 3: View Network Connections**

```bash
# List all connections
nmcli connection show

# Show active devices
nmcli device status

# Show specific device details
nmcli device show eth0
```

**Step 4: Configure Static IP Connection**

```bash
# Create new connection (if needed) or modify existing
# Option A: Modify existing connection
sudo nmcli connection modify "System eth0" ipv4.method manual
sudo nmcli connection modify "System eth0" ipv4.addresses "192.168.1.100/24"
sudo nmcli connection modify "System eth0" ipv4.gateway "192.168.1.1"
sudo nmcli connection modify "System eth0" ipv4.dns "8.8.8.8 8.8.4.4"

# Option B: Create new connection
sudo nmcli connection add type ethernet con-name static-eth0 ifname eth0
sudo nmcli connection modify static-eth0 ipv4.method manual
sudo nmcli connection modify static-eth0 ipv4.addresses "192.168.1.100/24"
sudo nmcli connection modify static-eth0 ipv4.gateway "192.168.1.1"
sudo nmcli connection modify static-eth0 ipv4.dns "8.8.8.8 8.8.4.4"
```

**Step 5: Activate Connection**

```bash
# Bring up the connection
sudo nmcli connection up "System eth0"

# Or if created new connection
sudo nmcli connection up static-eth0

# Verify it's active
nmcli connection show
```

**Step 6: Verify Network Configuration**

```bash
# Show IP address
ip addr show eth0

# Show DNS configuration
nmcli device show eth0 | grep DNS

# Test connectivity
ping 8.8.8.8

# Test DNS resolution
nslookup google.com

# Show all network info
nmcli device show eth0
```

### Verification Checklist

- [ ] Hostname set to webserver.example.com
- [ ] Static IP address configured (192.168.1.100)
- [ ] DNS servers set (8.8.8.8, 8.8.4.4)
- [ ] Connection activated and active
- [ ] `ip addr show` displays correct IP
- [ ] Ping to gateway works
- [ ] DNS resolution works

### Expected Output Examples

```bash
$ hostnamectl
   Static hostname: webserver.example.com
   
$ ip addr show eth0
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP>
    inet 192.168.1.100/24 brd 192.168.1.255 scope global eth0
    
$ nmcli device show eth0 | grep DNS
IP4.DNS[1]: 8.8.8.8
IP4.DNS[2]: 8.8.4.4
```

---

## Lab Exercise 3: Schedule Tasks with crontab and at

**Objective:** Create recurring and one-time scheduled tasks

**Difficulty:** Intermediate | **Time:** 45-60 minutes | **Command Count:** 12+

### Exercise Description

Set up both recurring cron jobs and one-time at jobs for system administration tasks.

### Requirements

1. Create a cron job to run daily at 2 AM
2. Create a cron job every 30 minutes
3. Schedule a one-time task with `at`
4. Verify all scheduled tasks

### Step-by-Step Instructions

**Step 1: Create a Test Script**

```bash
# Create backup script
mkdir -p /usr/local/scripts
sudo tee /usr/local/scripts/backup.sh > /dev/null <<'EOF'
#!/bin/bash
echo "Backup started at $(date)" >> /var/log/backup.log
# Backup commands would go here
echo "Backup completed at $(date)" >> /var/log/backup.log
EOF

# Make executable
sudo chmod +x /usr/local/scripts/backup.sh

# Create log file
sudo touch /var/log/backup.log
sudo chmod 666 /var/log/backup.log
```

**Step 2: Open crontab Editor**

```bash
# Edit your crontab
crontab -e

# (This opens in vi or your default editor)
```

**Step 3: Add Daily Cron Job**

```bash
# In the editor, add:
# Run backup daily at 2:00 AM
0 2 * * * /usr/local/scripts/backup.sh

# Save and exit (:wq in vi)
```

**Step 4: Add Recurring Every 30 Minutes**

```bash
# Edit crontab again
crontab -e

# Add another line:
# Run monitoring every 30 minutes
*/30 * * * * /usr/local/scripts/backup.sh

# Save and exit
```

**Step 5: Verify Crontab Entries**

```bash
# View current crontab
crontab -l

# Should show both entries
```

**Step 6: Schedule One-Time Task with at**

```bash
# Install at if needed
sudo yum install at

# Start at daemon
sudo systemctl enable atd
sudo systemctl start atd

# Schedule a task for 2 minutes from now
at now + 2 minutes
/usr/local/scripts/backup.sh
Ctrl+D

# Or schedule for specific time
at 3:30 PM today
/usr/local/scripts/backup.sh
Ctrl+D
```

**Step 7: List Scheduled Tasks**

```bash
# List at jobs
atq

# List cron jobs
crontab -l

# Check cron logs
sudo tail -f /var/log/cron
```

### Verification Checklist

- [ ] Backup script created and executable
- [ ] Daily cron job at 2 AM configured
- [ ] Every-30-minutes cron job configured
- [ ] `crontab -l` shows both entries
- [ ] at job scheduled successfully
- [ ] `atq` shows scheduled at job
- [ ] Cron logs show job execution

### Expected Output Examples

```bash
$ crontab -l
0 2 * * * /usr/local/scripts/backup.sh
*/30 * * * * /usr/local/scripts/backup.sh

$ atq
1       Mon Jan 15 15:32:00 2024 a username

$ tail /var/log/cron
Jan 15 14:30:01 server CROND[12345]: (username) CMD (/usr/local/scripts/backup.sh)
```

---

## Lab Exercise 4: Manage Services and Enable on Boot

**Objective:** Control services and configure automatic startup

**Difficulty:** Intermediate | **Time:** 45-60 minutes | **Command Count:** 15+

### Exercise Description

Manage services using systemctl, enable/disable services, and troubleshoot service issues.

### Requirements

1. Start and stop a service (httpd)
2. Enable service on boot
3. Check service status and logs
4. Reload and restart services

### Step-by-Step Instructions

**Step 1: Install a Service (if not already installed)**

```bash
# Install Apache web server
sudo yum install httpd

# Verify installation
rpm -q httpd
```

**Step 2: Start the Service**

```bash
# Start httpd service
sudo systemctl start httpd

# Check if it's running
sudo systemctl is-active httpd

# Show status
sudo systemctl status httpd
```

**Step 3: Enable Service on Boot**

```bash
# Enable service to start on boot
sudo systemctl enable httpd

# Verify it's enabled
sudo systemctl is-enabled httpd

# Or enable and start together
sudo systemctl enable --now httpd
```

**Step 4: Check Service Details**

```bash
# View the service unit file
systemctl cat httpd

# Show all service properties
systemctl show httpd

# Show specific property (main PID)
systemctl show -p MainPID httpd

# Show process ID
systemctl show -p MainPID httpd | grep -oP '(?<==)[0-9]+'
```

**Step 5: View Service Logs**

```bash
# Show recent logs
sudo journalctl -u httpd

# Follow logs in real-time
sudo journalctl -u httpd -f

# Show errors only
sudo journalctl -u httpd -p err

# Show last 20 lines
sudo journalctl -u httpd -n 20

# Show logs from specific time
sudo journalctl -u httpd --since "2024-01-15"
```

**Step 6: Reload Service Configuration**

```bash
# Reload configuration (no restart)
sudo systemctl reload httpd

# Restart service (full restart)
sudo systemctl restart httpd

# Stop service
sudo systemctl stop httpd

# Verify it's stopped
sudo systemctl is-active httpd
```

**Step 7: Disable Service**

```bash
# Disable service on boot
sudo systemctl disable httpd

# Verify it's disabled
sudo systemctl is-enabled httpd

# But service can still be started manually
sudo systemctl start httpd
sudo systemctl stop httpd
```

### Verification Checklist

- [ ] httpd installed successfully
- [ ] httpd service started and active
- [ ] Service enabled for boot
- [ ] `systemctl status` shows active
- [ ] `systemctl is-enabled` returns enabled
- [ ] Service logs show activity
- [ ] Service reloads without errors
- [ ] Service can be stopped and restarted

### Expected Output Examples

```bash
$ systemctl is-active httpd
active

$ systemctl is-enabled httpd
enabled

$ systemctl status httpd
● httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; enabled)
   Active: active (running) since Mon 2024-01-15 14:35:42 CST
```

---

## Lab Exercise 5: Configure Boot Target

**Objective:** Set and change boot targets (runlevels)

**Difficulty:** Intermediate | **Time:** 30-45 minutes | **Command Count:** 8+

### Exercise Description

Configure the system to boot into a specific target and practice switching between targets.

### Requirements

1. Check current default target
2. Switch to multi-user (CLI) target
3. Switch back to graphical target
4. Set default target to multi-user

### Step-by-Step Instructions

**Step 1: Check Current Target**

```bash
# Show default target
sudo systemctl get-default

# Show current target
sudo systemctl status graphical.target | head -5

# List all targets
systemctl list-units --type=target
```

**Step 2: List Available Targets**

```bash
# Show all targets
systemctl list-units --type=target --all

# You should see:
# graphical.target (like runlevel 5 - GUI)
# multi-user.target (like runlevel 3 - CLI)
# rescue.target (emergency mode)
# emergency.target (minimal)
```

**Step 3: Switch to Multi-User Target**

```bash
# Switch immediately (no reboot)
sudo systemctl isolate multi-user.target

# Note: If running GUI, it will exit to CLI
# Log back in at CLI prompt
```

**Step 4: Verify Target Switched**

```bash
# Check current target
sudo systemctl get-default

# Show running services (fewer in multi-user)
systemctl list-units --type=service --state=running | wc -l

# Show target details
systemctl show multi-user.target
```

**Step 5: Switch Back to Graphical**

```bash
# Switch back to graphical (if in CLI)
sudo systemctl isolate graphical.target

# Note: This will start the GUI if available
```

**Step 6: Set Default Target**

```bash
# Set default to multi-user (CLI boot)
sudo systemctl set-default multi-user.target

# Verify change
sudo systemctl get-default

# To change back to graphical
sudo systemctl set-default graphical.target
sudo systemctl get-default
```

**Step 7: Verify Default Target**

```bash
# Check the symbolic link
ls -la /etc/systemd/system/default.target

# Show target content
systemctl cat multi-user.target | head -10
```

### Verification Checklist

- [ ] Can view current default target
- [ ] Can switch to multi-user target
- [ ] Multi-user target displays CLI prompt
- [ ] Can switch back to graphical
- [ ] Can set default target to multi-user
- [ ] Default target persists (shown on next reboot)
- [ ] `/etc/systemd/system/default.target` is correct symlink

### Expected Output Examples

```bash
$ sudo systemctl get-default
graphical.target

$ sudo systemctl set-default multi-user.target
$ sudo systemctl get-default
multi-user.target

$ ls -la /etc/systemd/system/default.target
lrwxrwxrwx /etc/systemd/system/default.target -> /usr/lib/systemd/system/multi-user.target
```

---

## Lab Exercise 6: Install and Update Packages

**Objective:** Install, update, remove, and manage software packages

**Difficulty:** Beginner-Intermediate | **Time:** 45-60 minutes | **Command Count:** 15+

### Exercise Description

Use yum to install, search, update, and remove packages.

### Requirements

1. Search for a package
2. Install a package
3. Check for updates
4. Update packages
5. Remove a package

### Step-by-Step Instructions

**Step 1: Search for Packages**

```bash
# Search for git package
yum search git

# You'll see various git-related packages

# Get more specific
yum search git | grep "^git"

# Show only git package
yum search "^git$"
```

**Step 2: Get Package Information**

```bash
# Show detailed info about git
yum info git

# Shows: Name, Arch, Version, Release, Size, Repo, Summary, URL, License, etc.
```

**Step 3: Install a Package**

```bash
# Install git
sudo yum install git

# Type 'y' to confirm installation

# Verify installation
rpm -q git

# Which will show: git-2.31.1-2.el9.x86_64
```

**Step 4: Check for Updates**

```bash
# Check which packages have updates
yum check-update

# You might see several packages with newer versions
```

**Step 5: Update Packages**

```bash
# Update all packages
sudo yum update

# Type 'y' to confirm

# Or update specific package
sudo yum update git

# Check for security updates only
yum list updates | grep -i security
```

**Step 6: List Installed Packages**

```bash
# List all installed packages
yum list installed

# Filter for git
yum list installed | grep git

# Show package size and version
rpm -qa | grep git
rpm -qi git
```

**Step 7: Remove a Package**

```bash
# Remove git package
sudo yum remove git

# Type 'y' to confirm

# Verify removal
rpm -q git

# Should show: package git is not installed
```

### Verification Checklist

- [ ] Successfully searched for packages
- [ ] Package information displayed correctly
- [ ] Package installed successfully
- [ ] `rpm -q` confirms installation
- [ ] Identified packages with updates
- [ ] Updated packages successfully
- [ ] Listed installed packages
- [ ] Removed package successfully
- [ ] `rpm -q` confirms removal

### Expected Output Examples

```bash
$ yum search git | head -20
git.x86_64 : Fast Version Control System
git-daemon.x86_64 : Git protocol server
git-email.x86_64 : Git tools for emailing

$ yum info git
Name         : git
Arch         : x86_64
Version      : 2.31.1
Release      : 2.el9

$ rpm -q git
git-2.31.1-2.el9.x86_64
```

---

## Lab Exercise 7: Configure Repository and Subscription

**Objective:** Add repositories and manage subscriptions

**Difficulty:** Intermediate | **Time:** 30-45 minutes | **Command Count:** 10+

### Exercise Description

Configure package repositories and manage Red Hat subscriptions.

### Requirements

1. View current repositories
2. Enable/disable repository
3. Show repository configuration
4. (Optional) Register system for subscription

### Step-by-Step Instructions

**Step 1: View Current Repositories**

```bash
# List all enabled repositories
yum repolist

# Show all repositories (enabled and disabled)
yum repolist all

# Show only enabled
yum repolist enabled
```

**Step 2: Use yum-config-manager**

```bash
# Install yum-utils if needed
sudo yum install yum-utils

# Show all repository configurations
yum-config-manager --dump

# Show specific repository
yum-config-manager rhel-baseos
```

**Step 3: Enable a Repository**

```bash
# List disabled repositories
yum repolist disabled

# Enable a repository (example)
sudo yum-config-manager --enable rhel-appstream

# Verify it's enabled
yum repolist enabled | grep appstream
```

**Step 4: Disable a Repository**

```bash
# Disable a repository
sudo yum-config-manager --disable rhel-appstream

# Verify it's disabled
yum repolist disabled | grep appstream
```

**Step 5: View Repository Configuration Files**

```bash
# List repository configuration directory
ls -la /etc/yum.repos.d/

# View a repository configuration
cat /etc/yum.repos.d/rhel.repo | head -20

# Edit repository configuration
sudo vi /etc/yum.repos.d/rhel.repo
```

**Step 6: (Optional) Subscription Management**

```bash
# Show subscription status
sudo subscription-manager status

# If not registered, register with:
# sudo subscription-manager register --username USER --password PASS

# Show registered system
sudo subscription-manager identity

# List available subscriptions
sudo subscription-manager list --available

# Auto-attach subscriptions
sudo subscription-manager attach --auto
```

### Verification Checklist

- [ ] Listed all available repositories
- [ ] Viewed enabled and disabled repos
- [ ] Used yum-config-manager successfully
- [ ] Enabled a disabled repository
- [ ] Verified repository is now enabled
- [ ] Disabled the repository again
- [ ] Viewed repository configuration files
- [ ] (Optional) Subscription status checked

### Expected Output Examples

```bash
$ yum repolist
repo id                repo name
rhel-baseos            Red Hat Enterprise Linux BaseOS (RPMs)
rhel-appstream         Red Hat Enterprise Linux AppStream (RPMs)

$ sudo yum-config-manager rhel-baseos | grep enabled
enabled = 1
```

---

## Lab Exercise 8: GRUB Configuration and Boot Parameters (Integration Lab)

**Objective:** Modify GRUB configuration and kernel parameters

**Difficulty:** Advanced | **Time:** 60-90 minutes | **Command Count:** 15+

### Exercise Description

Configure GRUB bootloader settings, modify kernel parameters, and regenerate GRUB configuration.

### Requirements

1. View current GRUB configuration
2. Modify GRUB parameters
3. Use grubby to manage kernel parameters
4. Regenerate GRUB configuration
5. Verify all changes persist

### Step-by-Step Instructions

**Step 1: View Current GRUB Configuration**

```bash
# View GRUB configuration file
cat /etc/default/grub

# Important lines:
# GRUB_TIMEOUT=5
# GRUB_DEFAULT=0
# GRUB_CMDLINE_LINUX="quiet rhgb"
```

**Step 2: Backup GRUB Configuration**

```bash
# Always backup before making changes
sudo cp /etc/default/grub /etc/default/grub.bak

# Verify backup
ls -la /etc/default/grub*
```

**Step 3: Modify GRUB Parameters**

```bash
# Edit GRUB configuration
sudo vi /etc/default/grub

# Modify GRUB_TIMEOUT (increase to 10 seconds)
GRUB_TIMEOUT=10

# Modify GRUB_DEFAULT (set to 1)
GRUB_DEFAULT=1

# Add kernel parameter (disable SELinux for testing)
GRUB_CMDLINE_LINUX="quiet rhgb selinux=0"

# Save and exit
```

**Step 4: Regenerate GRUB Configuration**

```bash
# For BIOS systems
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

# For UEFI systems
sudo grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg

# Should show "Generating grub configuration from /etc/default/grub..."
```

**Step 5: Verify GRUB Configuration Generated**

```bash
# Check if new config contains our changes
sudo grep -i "selinux" /boot/grub2/grub.cfg

# Check timeout setting
sudo grep "timeout" /boot/grub2/grub.cfg
```

**Step 6: View Kernel Entries with grubby**

```bash
# List all kernel entries
sudo grubby --info=ALL

# Show default kernel
sudo grubby --default-kernel

# Show details of default kernel
sudo grubby --info=/boot/vmlinuz-$(uname -r)
```

**Step 7: Modify Kernel Parameters with grubby**

```bash
# Add kernel parameter to all kernels
sudo grubby --update-kernel=ALL --args="systemd.log_level=debug"

# Verify parameter added
sudo grubby --info=ALL | grep "debug"

# Remove kernel parameter
sudo grubby --update-kernel=ALL --remove-args="systemd.log_level=debug"

# Verify parameter removed
sudo grubby --info=ALL | grep -c "debug"
```

**Step 8: View Final GRUB Configuration**

```bash
# Show first 50 lines of generated config
head -50 /boot/grub2/grub.cfg

# Search for specific parameters
grep -i "selinux" /boot/grub2/grub.cfg

# Count number of menu entries
sudo grubby --info=ALL | grep "title" | wc -l
```

### Verification Checklist

- [ ] Original GRUB config backed up
- [ ] GRUB configuration file modified correctly
- [ ] Kernel parameters added (selinux=0)
- [ ] GRUB config regenerated
- [ ] New config contains changes
- [ ] grubby shows kernel entries
- [ ] Kernel parameters modifiable with grubby
- [ ] Changes verified in final configuration

### Expected Output Examples

```bash
$ cat /etc/default/grub
GRUB_TIMEOUT=10
GRUB_DEFAULT=1
GRUB_CMDLINE_LINUX="quiet rhgb selinux=0"

$ sudo grubby --info=ALL | head -5
index=0
kernel=/boot/vmlinuz-5.14.0-162.el9.x86_64
args="selinux=0 quiet rhgb"
```

### Integration Lab Extension

After completing all 8 exercises, create a system that:
1. Boots to multi-user target (Exercise 5)
2. Runs daily backup at 2 AM (Exercise 3)
3. Has httpd service enabled (Exercise 4)
4. Has time synchronized (Exercise 1)
5. Has proper hostname and network config (Exercise 2)
6. Has all security packages updated (Exercise 6)
7. Has correct repositories enabled (Exercise 7)
8. Has kernel parameters configured (Exercise 8)

---

**End of Module 5 Lab Exercises**
