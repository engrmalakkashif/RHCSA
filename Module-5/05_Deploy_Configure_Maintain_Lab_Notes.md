# RHCSA Module 5: Deploy, Configure, and Maintain Systems
## Comprehensive Lab Notes & Reference Guide

---

## Table of Contents

1. [System Time and Date Configuration](#system-time-and-date-configuration)
2. [Hostname and Network Configuration](#hostname-and-network-configuration)
3. [Task Scheduling with at, cron, and systemd timers](#task-scheduling-with-at-cron-and-systemd-timers)
4. [Service Management and systemctl](#service-management-and-systemctl)
5. [Boot Targets and System Runlevels](#boot-targets-and-system-runlevels)
6. [Software Package Management](#software-package-management)
7. [Repository Configuration](#repository-configuration)
8. [Bootloader Configuration and GRUB](#bootloader-configuration-and-grub)
9. [System Maintenance and Updates](#system-maintenance-and-updates)

---

## 1. System Time and Date Configuration

### Introduction to System Time

System time in Linux serves multiple critical functions:
- Logging and audit trails
- File timestamps
- Scheduled task execution
- Network synchronization
- Certificate validation

### NTP and chrony

**NTP (Network Time Protocol):** Traditional time synchronization protocol
**chrony:** Modern NTP implementation preferred on RHEL 8/9

#### Installing chrony

```bash
# Install chrony package
sudo yum install chrony

# Enable and start chrony service
sudo systemctl enable chronyd
sudo systemctl start chronyd

# Verify service is running
sudo systemctl status chronyd
```

#### Configuring chrony

**Main configuration file:** `/etc/chrony.conf`

```bash
# View current configuration
sudo cat /etc/chrony.conf

# Common configuration options:
# server <hostname> iburst    - Time server to sync with
# pool <hostname> iburst      - Pool of time servers
# allow <network>             - Allow NTP queries from network
# local stratum 10            - Use system as local NTP source
```

Example configuration:

```bash
# /etc/chrony.conf example
server 0.rhel.pool.ntp.org iburst
server 1.rhel.pool.ntp.org iburst
server 2.rhel.pool.ntp.org iburst
server 3.rhel.pool.ntp.org iburst

# Allow NTP queries from local network
allow 192.168.1.0/24

# Use system as time server if no external source
local stratum 10
```

#### chronyc Command

```bash
# Show current time sources
sudo chronyc sources

# Show detailed source information
sudo chronyc sources -v

# Show system clock information
sudo chronyc tracking

# Check if time is synchronized
sudo chronyc waits

# Force time update (if needed)
sudo chronyc makestep

# Show all tracked sources with statistics
sudo chronyc sourcestats -v
```

Example output:

```bash
$ sudo chronyc sources
MS Name/IP address         Stratum Poll Reach LastRx Last sample
===============================================================
^* time.google.com               1   6    17    42   -124us[-130us] +/-   18ms
^- time.cloudflare.com           1   6    17    41   -893us[-899us] +/-   18ms
^+ time.aws.amazon.com           1   6    17    40   +421us[+415us] +/-   21ms
```

### Using timedatectl

**timedatectl:** Modern tool to manage time and date (RHEL 8/9)

```bash
# Show current time and date settings
timedatectl

# Show available timezones
timedatectl list-timezones

# Set timezone
sudo timedatectl set-timezone America/New_York

# Enable NTP synchronization
sudo timedatectl set-ntp true

# Disable NTP synchronization
sudo timedatectl set-ntp false

# Set time manually (if needed)
sudo timedatectl set-time "2024-01-15 14:30:00"

# Set date only
sudo timedatectl set-time "2024-01-15"
```

Example timedatectl output:

```bash
$ timedatectl
               Local time: Mon 2024-01-15 14:35:42 EST
           Universal time: Mon 2024-01-15 19:35:42 UTC
                 RTC time: Mon 2024-01-15 19:35:42
                Time zone: America/New_York (EST, -0500)
System clock synchronized: yes
              NTP service: active
          RTC in local TZ: no
```

### Timezone Management

```bash
# View current timezone
cat /etc/timezone

# Or using timedatectl
timedatectl | grep "Time zone"

# List available timezones
timedatectl list-timezones

# Find specific timezone
timedatectl list-timezones | grep -i "america"

# Set timezone
sudo timedatectl set-timezone America/Los_Angeles

# Verify change
timedatectl | grep "Time zone"
```

### Synchronization Verification

```bash
# Check if NTP is synchronized
timedatectl status

# Check chrony synchronization status
sudo chronyc tracking | grep "System time"

# View system clock frequency
sudo chronyc tracking | grep "Frequency"

# Monitor real-time adjustments
sudo chronyc activity
```

---

## 2. Hostname and Network Configuration

### Understanding Hostnames

**Hostname:** System's network identity
**FQDN (Fully Qualified Domain Name):** hostname.domain.com
**Static Hostname:** Permanent hostname configuration
**Transient Hostname:** Runtime hostname (lost on reboot)
**Pretty Hostname:** Human-readable description

### Using hostnamectl

```bash
# Show current hostname(s)
hostnamectl

# Show all hostname types
hostnamectl status

# Set static hostname
sudo hostnamectl set-hostname newname

# Set hostname and pretty hostname
sudo hostnamectl set-hostname "server.example.com" --static

# Set pretty hostname (human readable)
sudo hostnamectl set-hostname "Web Server 1" --pretty

# Set transient hostname (runtime only)
sudo hostnamectl set-hostname tempname --transient

# Show only specific hostname
hostnamectl --query --static
hostnamectl --query --transient
hostnamectl --query --pretty
```

Example hostnamectl output:

```bash
$ hostnamectl
   Static hostname: web-server-01
   Pretty hostname: Web Server - Production 01
Transient hostname: web-server-01
         Icon name: computer
           Machine ID: 8c0e6e6e4e6e4e6e4e6e4e6e4e6e4e
              Boot ID: 4e4e4e4e4e4e4e4e4e4e4e4e4e4e4e
       Virtualization: kvm
     Operating System: Red Hat Enterprise Linux 9.0
          CPE OS Name: cpe:/o:redhat:enterprise_linux:9
               Kernel: Linux 5.14.0-162.6.1.el9_1.x86_64
         Architecture: x86-64
```

### Network Configuration Files

**Primary configuration files:**
- `/etc/hostname` - Static hostname
- `/etc/sysconfig/network` - Network settings
- `/etc/sysconfig/network-scripts/ifcfg-*` - Interface configurations

### Using nmcli (NetworkManager)

```bash
# Show all connections
nmcli connection show

# Show all devices
nmcli device status

# Show specific connection details
nmcli connection show "System eth0"

# Add a new connection (static IP)
sudo nmcli connection add type ethernet con-name "static-eth0" ifname eth0
sudo nmcli connection modify "static-eth0" ipv4.method manual
sudo nmcli connection modify "static-eth0" ipv4.addresses "192.168.1.100/24"
sudo nmcli connection modify "static-eth0" ipv4.gateway "192.168.1.1"
sudo nmcli connection modify "static-eth0" ipv4.dns "8.8.8.8,8.8.4.4"
sudo nmcli connection up "static-eth0"

# Add DHCP connection
sudo nmcli connection add type ethernet con-name "dhcp-eth0" ifname eth0 autoconnect yes

# Modify existing connection to DHCP
sudo nmcli connection modify "static-eth0" ipv4.method auto
sudo nmcli connection up "static-eth0"

# Show connection details
nmcli connection show "static-eth0"

# Edit connection directly
sudo nmcli connection edit "static-eth0"

# Delete connection
sudo nmcli connection delete "static-eth0"

# Reload configurations
sudo nmcli connection reload

# Activate/deactivate connection
sudo nmcli connection up "static-eth0"
sudo nmcli connection down "static-eth0"
```

Example nmcli output:

```bash
$ nmcli connection show
NAME         UUID                                  TYPE      DEVICE
System eth0  5fb06bd0-0bb0-7ffb-45f1-d6edd65f3e03  ethernet  eth0
virbr0       bb6c6ce6-afdd-4bed-9b8d-e7f45e4c5d6f  bridge    virbr0
```

### DNS Configuration

```bash
# View current DNS settings
nmcli device show eth0 | grep DNS

# Set DNS servers via nmcli
sudo nmcli connection modify "System eth0" ipv4.dns "1.1.1.1 8.8.8.8"

# Apply changes
sudo nmcli connection up "System eth0"

# Verify DNS configuration
cat /etc/resolv.conf

# Test DNS resolution
nslookup google.com
dig google.com
getent hosts google.com
```

---

## 3. Task Scheduling with at, cron, and systemd timers

### The `at` Command

**Purpose:** One-time task execution at a future time

#### at Installation and Setup

```bash
# Install at daemon
sudo yum install at

# Enable and start atd service
sudo systemctl enable atd
sudo systemctl start atd

# Verify service is running
sudo systemctl status atd
```

#### Using at

```bash
# Schedule a task
at <time>
> command to run
> Ctrl+D to save

# View scheduled tasks
atq

# View details of specific job
at -c <job_id>

# Delete scheduled job
atrm <job_id>

# List all scheduled jobs for current user
at -l
```

Examples:

```bash
# Schedule backup in 2 hours
at now + 2 hours
> /usr/local/bin/backup.sh
> Ctrl+D

# Schedule task at specific time
at 3:30 PM tomorrow
> /usr/local/bin/maintenance.sh
> Ctrl+D

# Schedule task on specific date
at 10:00 AM January 20 2024
> /usr/local/bin/report.sh
> Ctrl+D

# View job details
at -c 1

# Remove job
atrm 1
```

### The `cron` Daemon

**Purpose:** Recurring task execution

#### crontab Format

```
MIN HOUR DOM MON DOW COMMAND
 |   |    |   |   |    |
 |   |    |   |   |    └─────── Command to run
 |   |    |   |   └──────────── Day of week (0-6, 0=Sunday)
 |   |    |   └───────────────── Month (1-12)
 |   |    └────────────────────── Day of month (1-31)
 |   └─────────────────────────── Hour (0-23)
 └──────────────────────────────── Minute (0-59)

Special values:
* = any value
, = list
- = range
/ = step/interval
```

#### Common cron Expressions

```bash
# Every minute
* * * * * /usr/local/bin/command.sh

# Every hour at minute 0
0 * * * * /usr/local/bin/command.sh

# At 2:30 AM every day
30 2 * * * /usr/local/bin/backup.sh

# Every Monday at 3:00 PM
0 15 * * 1 /usr/local/bin/weekly-task.sh

# Every 15 minutes
*/15 * * * * /usr/local/bin/frequent-task.sh

# At 9:00 AM on 1st and 15th of month
0 9 1,15 * * /usr/local/bin/biweekly.sh

# Every weekday at 8:00 AM
0 8 * * 1-5 /usr/local/bin/weekday-task.sh

# Every hour from 9 AM to 5 PM
0 9-17 * * * /usr/local/bin/business-hours.sh

# Every 2 hours
0 */2 * * * /usr/local/bin/command.sh

# At reboot
@reboot /usr/local/bin/startup.sh
```

#### Managing crontab

```bash
# Edit user crontab
crontab -e

# View user crontab
crontab -l

# Remove user crontab
crontab -r

# Edit other user's crontab (root only)
sudo crontab -u username -e

# View system crontab
sudo cat /etc/crontab

# Add cron job to /etc/cron.d/
sudo vi /etc/cron.d/myapp

# View cron logs
sudo tail -f /var/log/cron

# Check if cron is running
sudo systemctl status crond
```

#### cron Access Control

```bash
# Allow specific users to use cron
sudo vi /etc/cron.allow

# Deny specific users from using cron
sudo vi /etc/cron.deny

# Examples:
# /etc/cron.allow - only these users can use cron
admin
backup
monitoring

# If /etc/cron.allow exists, only users listed can use cron
# If /etc/cron.deny exists, users listed cannot use cron
```

### systemd Timer Units

**Purpose:** Modern replacement for cron with systemd integration

#### Timer Unit Files

**Location:** `/etc/systemd/system/` or `/usr/lib/systemd/system/`

Structure of a timer unit:

```bash
[Unit]
Description=Run backup daily
Requires=backup.service

[Timer]
OnBootSec=10min
OnUnitActiveSec=1d
Persistent=true

[Install]
WantedBy=timers.target
```

#### Creating a systemd Timer

1. **Create a service file** (`/etc/systemd/system/backup.service`):

```bash
[Unit]
Description=Daily Backup Service
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/backup.sh
User=backup
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
```

2. **Create a timer file** (`/etc/systemd/system/backup.timer`):

```bash
[Unit]
Description=Daily Backup Timer
Requires=backup.service

[Timer]
OnCalendar=daily
OnCalendar=*-*-* 02:00:00
Persistent=true

[Install]
WantedBy=timers.target
```

#### Timer OnCalendar Format

```bash
OnCalendar=daily           # Every day at 00:00
OnCalendar=weekly          # Every Sunday at 00:00
OnCalendar=monthly         # First day of month at 00:00
OnCalendar=yearly          # January 1st at 00:00

# Specific time format
OnCalendar=*-*-* 02:30:00  # Every day at 2:30 AM
OnCalendar=Mon *-*-* 10:00:00  # Every Monday at 10:00 AM
OnCalendar=Mon,Fri *-*-* 09:00:00  # Mon & Fri at 9:00 AM

# Recurring intervals
OnBootSec=5min             # 5 minutes after boot
OnUnitActiveSec=1h         # 1 hour after last execution
OnUnitActiveSec=30min      # 30 minutes between runs
```

#### Managing systemd Timers

```bash
# List all timers
systemctl list-timers

# List timers including inactive
systemctl list-timers --all

# Start a timer
sudo systemctl start backup.timer

# Enable timer on boot
sudo systemctl enable backup.timer

# Stop a timer
sudo systemctl stop backup.timer

# Check timer status
sudo systemctl status backup.timer

# View timer details
systemctl cat backup.timer

# Check last trigger time
systemctl list-timers backup.timer

# Reload systemd configuration
sudo systemctl daemon-reload

# Trigger timer manually
sudo systemctl start backup.service
```

Example output:

```bash
$ systemctl list-timers
NEXT                        LEFT     LAST                        PASSED UNIT                         ACTIVATES
Mon 2024-01-15 02:00:00 EST 6h left  Sun 2024-01-14 02:00:12 EST 18h ago backup.timer               backup.service
Tue 2024-01-16 02:00:00 EST 1d left  Mon 2024-01-15 02:00:15 EST 12h ago maintenance.timer        maintenance.service
```

---

## 4. Service Management and systemctl

### Understanding Services

**Service:** Background process managed by systemd
**Unit File:** Configuration file defining service behavior
**Target:** Group of units (similar to runlevels)

### Service Unit Files

**Location:** `/etc/systemd/system/` (custom) or `/usr/lib/systemd/system/` (distribution)

Basic structure:

```bash
[Unit]
Description=My Custom Service
After=network.target
Before=multi-user.target
Requires=networking.service

[Service]
Type=simple
ExecStart=/usr/local/bin/myservice
ExecStop=/usr/local/bin/myservice --stop
ExecReload=/usr/local/bin/myservice --reload
Restart=on-failure
RestartSec=10s
User=myservice
Group=myservice
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
```

### Common Service Management Commands

```bash
# Start a service
sudo systemctl start httpd

# Stop a service
sudo systemctl stop httpd

# Restart a service
sudo systemctl restart httpd

# Reload configuration (no restart)
sudo systemctl reload httpd

# Show service status
sudo systemctl status httpd

# Enable service on boot
sudo systemctl enable httpd

# Disable service on boot
sudo systemctl disable httpd

# Enable and start in one command
sudo systemctl enable --now httpd

# Check if service is enabled
sudo systemctl is-enabled httpd

# Check if service is active
sudo systemctl is-active httpd

# Show service details
systemctl show httpd

# List service dependencies
systemctl list-dependencies httpd
```

### Service Properties

```bash
# View unit file
sudo systemctl cat httpd

# Show all properties
systemctl show httpd

# Show specific property
systemctl show -p MainPID httpd
systemctl show -p ExecStart httpd
systemctl show -p Restart httpd

# List all properties
systemctl show --all httpd
```

### Troubleshooting Services

```bash
# Check service logs
sudo journalctl -u httpd

# Follow service logs in real-time
sudo journalctl -u httpd -f

# Show logs from specific time
sudo journalctl -u httpd --since "2024-01-15"

# Show service restart history
sudo journalctl -u httpd | grep Restart

# Check for errors
sudo journalctl -u httpd -p err

# View boot messages
sudo journalctl -b
```

---

## 5. Boot Targets and System Runlevels

### Understanding Targets

**Target:** Systemd concept replacing runlevels
**Similar to runlevels:** Each defines default system state

### Common Targets

```bash
# graphical.target (runlevel 5)
# GUI desktop environment, multi-user, networking

# multi-user.target (runlevel 3)
# Multi-user CLI, networking, no GUI

# rescue.target (runlevel 1 / S)
# Emergency service, minimal system, root access only

# poweroff.target (runlevel 0)
# System power-off

# reboot.target (runlevel 6)
# System reboot

# emergency.target
# Emergency shell access
```

### Managing Boot Targets

```bash
# Show current default target
sudo systemctl get-default

# Set default target
sudo systemctl set-default graphical.target
sudo systemctl set-default multi-user.target

# Switch to target immediately (no reboot)
sudo systemctl isolate graphical.target
sudo systemctl isolate multi-user.target
sudo systemctl isolate rescue.target

# List all available targets
systemctl list-units --type=target

# Show target details
sudo systemctl cat multi-user.target

# Show target dependencies
systemctl list-dependencies multi-user.target
```

### Boot into Specific Target

**At boot time via GRUB:**

```bash
# During boot, press 'e' at GRUB menu
# Find line starting with 'linux'
# Add target specification: systemd.unit=rescue.target
# Press Ctrl+X to boot

# Examples:
linux /vmlinuz-... root=... systemd.unit=rescue.target
linux /vmlinuz-... root=... systemd.unit=emergency.target
```

### Emergency and Rescue Mode

```bash
# Enter rescue mode (single-user, mostly started services)
sudo systemctl rescue

# Enter emergency mode (single-user, minimal)
sudo systemctl emergency

# Exit and return to default target
sudo systemctl isolate graphical.target
```

---

## 6. Software Package Management

### Understanding yum/dnf

**yum:** Package manager for RHEL (deprecated on RHEL 9)
**dnf:** Successor to yum, default on RHEL 8.8+ and RHEL 9

Both use same commands mostly.

### Basic yum/dnf Commands

```bash
# Update package list
sudo yum update        # or dnf update

# Upgrade all packages
sudo yum upgrade       # or dnf upgrade

# Install a package
sudo yum install httpd         # or dnf install

# Install specific version
sudo yum install httpd-2.4.37  # or dnf install

# Remove a package
sudo yum remove httpd          # or dnf remove

# Search for package
yum search postgresql          # or dnf search

# Show package information
yum info postgresql            # or dnf info

# List installed packages
yum list installed             # or dnf list installed

# List available updates
yum check-update               # or dnf check-update

# Reinstall package
sudo yum reinstall httpd       # or dnf reinstall

# Downgrade package
sudo yum downgrade httpd       # or dnf downgrade
```

### Working with Package Groups

```bash
# List available groups
yum grouplist

# Install group
sudo yum groupinstall "Development Tools"

# Remove group
sudo yum groupremove "Development Tools"

# Show group information
yum groupinfo "Development Tools"
```

### Package Information

```bash
# Show package details
yum info openssl

# List package files
yum provides /etc/httpd/conf/httpd.conf

# Find package providing command
yum provides httpd

# Show package dependencies
yum deplist httpd

# Show package history
yum history

# Show specific transaction
yum history info 5

# Undo transaction
sudo yum history undo 5

# Redo transaction
sudo yum history redo 5
```

### Local Package Installation

```bash
# Install from local file
sudo yum install /path/to/package.rpm

# Or using dnf
sudo dnf install /path/to/package.rpm

# Install local directory of packages
sudo yum install /path/to/packages/*.rpm

# Install with dependencies from internet
sudo yum install /path/to/local.rpm
```

---

## 7. Repository Configuration

### Understanding Repositories

**Repository:** Remote source of packages
**yum.repos.d:** Configuration directory for repositories

### Repository Configuration Files

**Location:** `/etc/yum.repos.d/`

Example repository file:

```bash
# /etc/yum.repos.d/rhel.repo
[rhel-baseos]
name=Red Hat Enterprise Linux BaseOS
baseurl=https://cdn.redhat.com/content/dist/rhel/server/9/$releasever/$basearch/baseos/
enabled=1
gpgcheck=1
gpgkey=https://www.redhat.com/security/fd431d51.txt

[rhel-appstream]
name=Red Hat Enterprise Linux AppStream
baseurl=https://cdn.redhat.com/content/dist/rhel/server/9/$releasever/$basearch/appstream/
enabled=1
gpgcheck=1
gpgkey=https://www.redhat.com/security/fd431d51.txt
```

### Managing Repositories with yum-config-manager

```bash
# Add repository
sudo yum-config-manager --add-repo=https://download.example.com/repo/

# Enable repository
sudo yum-config-manager --enable rhel-appstream

# Disable repository
sudo yum-config-manager --disable rhel-appstream

# Set repository option
sudo yum-config-manager --setopt=rhel-baseos.enabled=1

# Show repository configuration
yum-config-manager --dump

# Show specific repository
yum-config-manager rhel-baseos
```

### Subscription Management

```bash
# Register system
sudo subscription-manager register --username user --password pass

# Show subscription status
sudo subscription-manager status

# Attach subscription
sudo subscription-manager attach --auto

# List available subscriptions
sudo subscription-manager list --available

# Show installed subscriptions
sudo subscription-manager list --installed

# Remove subscription
sudo subscription-manager remove --all

# Unregister system
sudo subscription-manager unregister
```

---

## 8. Bootloader Configuration and GRUB

### Understanding GRUB

**GRUB2:** Grand Unified Bootloader version 2
**Boot Configuration:** `/etc/default/grub` (template)
**Compiled Config:** `/boot/grub2/grub.cfg` (generated)
**EFI Config:** `/boot/efi/EFI/redhat/grub.efi`

### GRUB Configuration File

**Location:** `/etc/default/grub`

```bash
# Important parameters
GRUB_TIMEOUT=5              # Seconds before auto-boot
GRUB_TIMEOUT_STYLE=menu     # Show menu during timeout
GRUB_DEFAULT=0              # Default menu entry (0=first)
GRUB_CMDLINE_LINUX="..."    # Kernel parameters
GRUB_DISABLE_SUBMENU=true   # Disable submenu
GRUB_GFXMODE=1024x768x24    # Graphics mode
GRUB_TERMINAL_OUTPUT=console # Terminal type
```

### Modifying GRUB Parameters

```bash
# Edit GRUB configuration
sudo vi /etc/default/grub

# Example: Increase timeout to 10 seconds
GRUB_TIMEOUT=10

# Example: Change default to 2nd entry
GRUB_DEFAULT=1

# Example: Add kernel parameter
GRUB_CMDLINE_LINUX="quiet rhgb selinux=0"

# Example: Disable graphics
GRUB_TERMINAL_OUTPUT=console
```

### Regenerating GRUB Configuration

**For BIOS Systems:**
```bash
# Regenerate grub.cfg
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

# Or using grubby
sudo grubby --update-kernel=ALL --args="parameter=value"
```

**For UEFI Systems:**
```bash
# Regenerate EFI configuration
sudo grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg

# Or
sudo grubby --update-kernel=ALL --args="parameter=value"
```

### GRUB Kernel Parameters

Common kernel parameters:

```bash
# Disable SELinux
selinux=0

# Set runlevel/target
systemd.unit=rescue.target

# Verbose boot output
debug

# Quiet boot
quiet

# Don't mask interrupts
nomask

# Set specific IP
ip=192.168.1.100::192.168.1.1:255.255.255.0:::off

# Disable certain services
nohz=off
```

### Using grubby

```bash
# List current kernel entries
sudo grubby --info=ALL

# Add kernel parameter
sudo grubby --update-kernel=ALL --args="parameter=value"

# Remove kernel parameter
sudo grubby --update-kernel=ALL --remove-args="parameter"

# Set default kernel
sudo grubby --set-default=/boot/vmlinuz-5.14.0-162.el9.x86_64

# Show default kernel
sudo grubby --default-kernel
```

### Boot Menu Options

```bash
# Access GRUB menu during boot
# Press and hold Shift (on BIOS) or Esc (on UEFI) during boot

# At GRUB menu:
# e = edit entry
# c = command line
# Esc = back to menu
```

---

## 9. System Maintenance and Updates

### Checking System Health

```bash
# Check disk usage
df -h                  # Human-readable disk space
df -i                  # Inode usage

# Check memory usage
free -h                # Human-readable memory
free -m                # Memory in MB

# Check swap usage
free -h | grep Swap

# Check system load
uptime
top
htop

# Check running processes
ps aux | wc -l

# Check system logs for errors
sudo journalctl -p err

# Check dmesg for kernel errors
sudo dmesg | grep -i error
```

### System Updates

```bash
# Check available updates
sudo yum check-update

# Update single package
sudo yum update httpd

# Update all packages
sudo yum update

# Update system
sudo yum upgrade

# Reboot after updates (if required)
sudo reboot
```

### Kernel Updates

```bash
# Check current kernel
uname -r

# Show all installed kernels
rpm -qa | grep kernel

# Update kernel
sudo yum update kernel

# Rebuild GRUB with new kernel
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

# Reboot to load new kernel
sudo reboot
```

### Security Updates

```bash
# Check for security updates
sudo yum list updates | grep -i security

# Install security updates only
sudo yum update --security

# Check security advisories
sudo yum check-update --security
```

### Automatic Updates

**Using yum-cron:**

```bash
# Install yum-cron
sudo yum install yum-cron

# Enable service
sudo systemctl enable yum-cron
sudo systemctl start yum-cron

# Configure automatic updates
sudo vi /etc/yum/yum-cron.conf

# Apply section settings:
apply_updates = yes    # Auto-apply updates
```

### System Cleanup

```bash
# Remove cached packages
sudo yum clean all

# Remove old kernels (keep 3 latest)
sudo yum remove $(yum list kernel | tail -n +2 | head -n -3 | awk '{print $1}')

# Clean temporary files
sudo rm -rf /tmp/*
sudo rm -rf /var/tmp/*

# Clear journal logs (keep 1G)
sudo journalctl --vacuum=1G

# Remove old log files
sudo find /var/log -type f -mtime +30 -delete
```

---

## Summary of Key Commands

### Time Management
- `timedatectl` - Manage time and timezone
- `chronyc` - Manage chrony NTP daemon
- `date` - Show/set system date

### Hostname and Network
- `hostnamectl` - Manage hostname
- `nmcli` - Manage network connections
- `ip` - Show/manage network interfaces

### Task Scheduling
- `at` - One-time task scheduling
- `crontab` - Recurring task scheduling
- `systemctl list-timers` - Show systemd timers

### Service Management
- `systemctl` - Manage systemd services
- `systemctl enable/disable` - Manage startup
- `systemctl start/stop/restart` - Control services

### Boot and Targets
- `systemctl get-default` - Show default target
- `systemctl set-default` - Set boot target
- `systemctl isolate` - Switch target immediately

### Package Management
- `yum/dnf install` - Install packages
- `yum/dnf remove` - Remove packages
- `yum/dnf update` - Update packages
- `yum-config-manager` - Manage repositories

### Bootloader
- `grubby` - GRUB configuration tool
- `grub2-mkconfig` - Regenerate GRUB config
- `/etc/default/grub` - GRUB configuration file

---

*End of Module 5 Lab Notes - Deploy, Configure, and Maintain Systems*
