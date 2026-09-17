# RHCSA Exam Preparation: Operate Running Systems
## Detailed Lab Notes & Study Guide
## Module 2

---

## Table of Contents

1. [Boot, Reboot, and Shutdown Systems](#boot-reboot-and-shutdown-systems)
2. [Boot Systems into Different Targets](#boot-systems-into-different-targets)
3. [Interrupt Boot Process for System Access](#interrupt-boot-process-for-system-access)
4. [Identify and Kill CPU/Memory Intensive Processes](#identify-and-kill-cpumemory-intensive-processes)
5. [Adjust Process Scheduling](#adjust-process-scheduling)
6. [Manage Tuning Profiles](#manage-tuning-profiles)
7. [Locate and Interpret System Logs](#locate-and-interpret-system-logs)
8. [Preserve System Journals](#preserve-system-journals)
9. [Manage Network Services](#manage-network-services)
10. [Securely Transfer Files](#securely-transfer-files)
11. [Lab Exercises & Practice](#lab-exercises--practice)

---

## Boot, Reboot, and Shutdown Systems

### Understanding the Boot Process

Linux boot sequence:
```
1. BIOS/UEFI POST (Power-On Self-Test)
2. Bootloader (GRUB2) loads kernel
3. Kernel initializes hardware
4. systemd (PID 1) starts as init process
5. systemd reads target and executes units
6. System reaches desired target state
7. Login prompt or graphical interface
```

### Shutdown Commands

#### Normal Shutdown

```bash
# Immediate shutdown (power off now)
shutdown -h now
# -h: halt (power off)
# now: immediate

# Shutdown in 5 minutes
shutdown -h +5

# Shutdown at specific time
shutdown -h 20:30                   # Shutdown at 8:30 PM
shutdown -h "2024-01-15 22:00"      # Shutdown at specific date/time

# Broadcast message before shutdown
shutdown -h +2 "System maintenance in 2 minutes"

# Cancel pending shutdown
shutdown -c
# -c: cancel

# Power off (same as shutdown -h now)
poweroff

# Halt system (stops but doesn't power off)
halt

# Reboot system
shutdown -r now
# -r: reboot instead of halt

# Reboot in 10 minutes
shutdown -r +10

# Emergency poweroff
emergency poweroff                  # Immediate without notification

# Get countdown to scheduled shutdown
shutdown -h 21:00 "Maintenance window"
```

### Reboot Commands

```bash
# Standard reboot
reboot

# Reboot with delay
shutdown -r now

# Reboot and verify timing
systemctl reboot

# Reboot immediately
systemctl reboot --no-wall          # No message broadcast

# Reboot with specific target
systemctl reboot --firmware-setup   # Reboot to BIOS/UEFI
```

### Halt vs Shutdown vs Poweroff

```bash
# halt - Stops all processes, keeps power on
halt
halt -p                            # Also power off

# shutdown - Graceful shutdown with warning
shutdown -h now                    # Most common, safest

# poweroff - Power off immediately
poweroff
poweroff -f                        # Force immediate poweroff

# systemctl - Modern method
systemctl halt                     # Stop system
systemctl poweroff                 # Power off
systemctl reboot                   # Reboot

# Emergency scenarios
systemctl emergency                # Emergency mode
systemctl rescue                   # Rescue mode
```

### Checking Scheduled Shutdown

```bash
# View scheduled shutdown
shutdown --show
# Shows: wall time, countdown, who scheduled

# System uptime (shows when system was last booted)
uptime
# Output: 14:32:15 up 45 days, 3:21, 2 users, load average: 0.15, 0.12, 0.09

# When was system booted
who -b
# Last boot time

# System logs showing shutdown
journalctl -b -1                   # Previous boot logs
journalctl --list-boots            # All boot records
```

### System States and Boot Targets

```bash
# Current system state
systemctl get-default              # Current default target

# Change default boot target
sudo systemctl set-default multi-user.target
sudo systemctl set-default graphical.target

# Immediate target change (temporary)
sudo systemctl isolate multi-user.target
sudo systemctl isolate graphical.target
sudo systemctl isolate rescue.target
sudo systemctl isolate emergency.target

# List available targets
systemctl list-units --type=target
systemctl list-units --type=target --all
```

### Practical Boot/Shutdown Scenarios

```bash
# 1. Graceful system maintenance shutdown (safest)
sudo shutdown -h +30 "System maintenance starting in 30 minutes"
# Check status: shutdown --show
# Broadcast message appears on all terminals
# Users can save work
# After 30 min: system powers off gracefully

# 2. Emergency poweroff (data loss risk)
sudo poweroff -f
# Immediate: no warning, no graceful shutdown
# Use only if necessary (system hung, critical security)

# 3. Reboot for kernel update
sudo shutdown -r +5 "Rebooting for kernel update"
# 5-minute warning
# Services shut down gracefully
# Kernel loads on reboot

# 4. Prevent accidental shutdown
sudo shutdown -c                   # Cancel scheduled shutdown

# 5. Multiple reboot cycles (installation)
sudo reboot
# System reboots automatically

# 6. Shutdown on specific time
sudo shutdown -h 23:00             # Shutdown at 11 PM
```

---

## Boot Systems into Different Targets Manually

### Understanding systemd Targets

systemd targets are groupings of units that define system states. Common targets:

```
graphical.target        - Graphical interface with network (runlevel 5)
multi-user.target       - CLI with network, no GUI (runlevel 3)
rescue.target           - Single-user, limited services (runlevel 1)
emergency.target        - Minimal rescue environment
poweroff.target         - System poweroff
reboot.target           - System reboot
```

### Viewing Current Target

```bash
# Show current default target
systemctl get-default
# Output: graphical.target (or multi-user.target)

# Show current target
systemctl status graphical.target
systemctl status multi-user.target

# List all available targets
systemctl list-units --type=target
systemctl list-units --type=target --all

# Show dependencies of target
systemctl list-dependencies graphical.target
systemctl list-dependencies multi-user.target

# Show which target is currently active
systemctl list-units --type=target --state=active
```

### Changing Default Target at Boot

#### Method 1: During Boot (GRUB Menu)

```bash
# At GRUB menu (when system boots):
1. Press 'e' to edit GRUB entry
2. Find line starting with "linux"
3. Go to end of line
4. Add: systemd.unit=rescue.target (or other target)
5. Press Ctrl+X to boot with new target

# Example:
linux /vmlinuz-5.10.0-8-generic root=/dev/mapper/cl-root ro systemd.unit=multi-user.target

# Common targets to use:
systemd.unit=graphical.target      # Graphical mode
systemd.unit=multi-user.target     # Command line
systemd.unit=rescue.target         # Rescue mode
systemd.unit=emergency.target      # Emergency mode
```

#### Method 2: Change Default Target Permanently

```bash
# Set default to graphical (with GUI)
sudo systemctl set-default graphical.target

# Set default to multi-user (CLI only)
sudo systemctl set-default multi-user.target

# Verify change
systemctl get-default
# Output: multi-user.target

# Effects take place on next boot
```

#### Method 3: Switch Target Immediately (No Reboot)

```bash
# Switch to multi-user target
sudo systemctl isolate multi-user.target
# Stops graphical interface immediately
# Drops to command line

# Switch back to graphical
sudo systemctl isolate graphical.target
# Starts graphical interface

# Switch to rescue mode
sudo systemctl isolate rescue.target
# Minimal environment for troubleshooting

# Switch to emergency mode
sudo systemctl isolate emergency.target
# Bare minimum - even filesystem may be read-only
```

### Target-Specific Commands

```bash
# Boot to multi-user target (next boot)
# Edit GRUB or:
sudo systemctl set-default multi-user.target
sudo reboot

# Boot to graphical target (next boot)
sudo systemctl set-default graphical.target
sudo reboot

# Temporary target switch (current boot only)
sudo systemctl isolate multi-user.target

# Show what will happen when switching targets
systemctl list-dependencies multi-user.target

# Rescue mode (press 'r' during reboot or...)
sudo systemctl rescue

# Emergency mode
sudo systemctl emergency
```

### GRUB Configuration for Default Target

GRUB configuration file: `/etc/default/grub`

```bash
# View GRUB defaults
cat /etc/default/grub

# Common parameters:
GRUB_CMDLINE_LINUX="systemd.unit=multi-user.target"
GRUB_TIMEOUT=5
GRUB_DEFAULT=0

# After editing /etc/default/grub, regenerate GRUB config:
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

# Or on UEFI systems:
sudo grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg
```

---

## Interrupt Boot Process for System Access

### Accessing the System When Locked Out

#### Scenario: Forgotten Root Password

```bash
# Step 1: At GRUB menu (during boot)
# Press 'e' to edit

# Step 2: Find the 'linux' line
# Look for: linux /vmlinuz-... root=/dev/mapper/... ro

# Step 3: Add 'rd.break' to kernel parameters
# Change:
linux /vmlinuz root=/dev/mapper/vg0-root ro
# To:
linux /vmlinuz root=/dev/mapper/vg0-root ro rd.break

# Step 4: Press Ctrl+X to boot

# Step 5: System stops at initramfs prompt (dracut>)
# Mount root filesystem read-write:
mount -o remount,rw /sysroot

# Step 6: Change root to actual root filesystem
chroot /sysroot

# Step 7: Reset root password
passwd root
# Enter new password twice

# Step 8: Exit chroot
exit

# Step 9: Reboot (will mount SELinux context)
# Type: exit or reboot
```

### GRUB Password Protection (Advanced)

```bash
# Create password for GRUB
grub2-setpassword

# Prompt for password, enter twice
# Stores encrypted password in /boot/grub2/user.cfg

# Regenerate GRUB config
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

# Now GRUB is password protected
# To edit entries at boot, must provide password
```

### Single-User/Rescue Mode Access

```bash
# Method 1: GRUB menu - add emergency parameter
# At GRUB edit: add 'single' or 'systemd.unit=rescue.target'
linux /vmlinuz root=... ro single

# Method 2: From running system
sudo systemctl rescue
# Switches to rescue target
# Single-user, limited services

# Method 3: Emergency mode (even more minimal)
sudo systemctl emergency
# Bare minimum environment
```

### Interrupt Boot with 'rd.break'

```bash
# Complete procedure to boot into minimal environment:

1. Boot system (or reboot)
2. At GRUB menu, press 'e'
3. Find 'linux' line
4. Add 'rd.break' parameter before 'ro'
5. Press Ctrl+X to boot

# System boots into initramfs (early boot environment)
# Prompt: dracut>

# Mount root as writable:
dracut> mount -o remount,rw /sysroot

# Enter the root filesystem:
dracut> chroot /sysroot

# Now you can:
# - Reset passwords: passwd root
# - Fix configuration
# - Troubleshoot boot issues

# Exit when done:
exit           # Leave chroot
exit           # Leave dracut

# System continues boot or reboots
```

### Emergency Mode Features

```bash
# Boot to emergency mode (minimal)
# GRUB menu: add 'systemd.unit=emergency.target'

# In emergency mode:
# - Filesystem mounted read-only
# - Network disabled
# - Minimal services
# - Root shell available

# Mount filesystem as writable:
mount -o remount,rw /

# Enable network if needed:
systemctl start network

# Check system issues:
journalctl
dmesg                              # Kernel messages
systemctl status
```

### SELinux Considerations

```bash
# When changing root password via rd.break:
# SELinux may prevent boot because context is wrong

# Disable SELinux temporarily:
# In GRUB edit line, add: selinux=0

# Or use enforcing parameter:
# linux ... selinux=0 rd.break

# After fixing and rebooting:
# SELinux will relabel filesystem automatically
# System may take longer to boot on first reboot
```

---

## Identify and Kill CPU/Memory Intensive Processes

### Viewing Process Information

#### Using `ps` Command

```bash
# Basic process list
ps                                  # Current shell processes
ps aux                              # All processes with details

# Format of ps aux output:
# USER PID %CPU %MEM VSZ RSS TTY STAT START TIME COMMAND

# Important columns:
# %CPU - CPU percentage used
# %MEM - Memory percentage used
# VSZ - Virtual memory size (KB)
# RSS - Resident set size (KB)
# PID - Process ID

# Examples:
ps aux | head -10                   # First 10 processes
ps aux | grep httpd                 # Find httpd processes
ps -ef                              # Extended format
ps -eo pid,user,cpu,mem,comm        # Select specific columns

# Show processes in tree format
ps auxf
# Shows parent-child relationships

# Show only user processes
ps -u username

# Show by CPU usage (descending)
ps aux --sort=-%cpu | head -10

# Show by memory usage (descending)
ps aux --sort=-%mem | head -10

# Show specific user
ps -u root
ps -u www-data
```

#### Using `top` Command

```bash
# Real-time process viewer
top
# Refreshes every 3 seconds

# Key information displayed:
# Top section: System load, memory, CPU usage
# Process section: PID, user, CPU%, MEM%, command

# Top interactive commands (press while running):
q                                   # Quit
h or ?                              # Help
P                                   # Sort by CPU usage
M                                   # Sort by memory usage
R                                   # Reverse sort order
x                                   # Highlight sort column
k                                   # Kill process (prompt for PID)
r                                   # Renice process (change priority)

# Batch mode (non-interactive)
top -b -n 1                         # One snapshot to stdout
top -b -n 1 -p 1234                # Monitor specific PID
top -b -n 1 | head -30              # First 30 lines

# Monitor with refresh
top -d 2                            # Refresh every 2 seconds

# Show specific user
top -u username

# Show processes sorted by memory
top -b -n 1 -o %MEM | head -20
```

#### Using `htop` (Enhanced top)

```bash
# More user-friendly than top
htop
# Shows color-coded system info
# Similar commands to top
# More intuitive interface

# Often needs to be installed:
sudo yum install htop
sudo apt install htop
```

### Identifying CPU-Intensive Processes

```bash
# Show top CPU consumers
ps aux --sort=-%cpu | head -11        # First 10 processes (skip header)

# Show with more details
ps aux --sort=-%cpu | awk '{print $1, $3, $11}' | head

# Monitor in real-time (top shows CPU% in real-time)
top
# Press 'P' to sort by CPU

# Find specific process consuming CPU
ps -eo pid,user,%cpu,command --sort=-%cpu | grep mysql

# Process tree showing CPU usage
ps auxf --sort=-%cpu

# Find processes using more than 50% CPU
ps aux | awk '$3 > 50 {print $0}'
```

### Identifying Memory-Intensive Processes

```bash
# Show top memory consumers
ps aux --sort=-%mem | head -11       # First 10 (skip header)

# Show with memory details
ps aux --sort=-%mem | awk '{print $1, $4, $6, $11}' | head

# Monitor with top
top
# Press 'M' to sort by memory

# Find processes using more than 10% memory
ps aux | awk '$4 > 10 {print $0}'

# Show RSS (resident set size - actual memory used)
ps auxr --sort=-rss
# RSS is more accurate than VSZ

# Memory usage summary
free -h                             # System memory overview
ps aux | awk '{sum+=$6} END {print sum " KB"}'  # Total processes
```

### Process Information Details

```bash
# Get detailed info on specific process
ps -fp 1234                        # Detailed info on PID 1234

# Show all environment variables
cat /proc/1234/environ | tr '\0' '\n'

# Show working directory
ls -la /proc/1234/cwd
pwdx 1234                          # Show working directory of process

# Show file descriptors
ls -la /proc/1234/fd                # Open files

# Show memory map
cat /proc/1234/maps

# Show I/O statistics
cat /proc/1234/io

# Real-time I/O monitoring
iotop
```

### Killing Processes

#### Kill by Process ID (PID)

```bash
# Basic kill
kill 1234                           # Send SIGTERM (graceful)

# Different signals
kill -9 1234                        # SIGKILL (force kill)
kill -15 1234                       # SIGTERM (default, graceful)
kill -2 1234                        # SIGINT (Ctrl+C equivalent)
kill -3 1234                        # SIGQUIT
kill -19 1234                       # SIGSTOP (pause)
kill -18 1234                       # SIGCONT (resume)

# Kill with signal name
kill -TERM 1234                     # SIGTERM
kill -KILL 1234                     # SIGKILL
kill -STOP 1234                     # SIGSTOP

# Verify process is killed
ps -p 1234                          # Check if still running
kill -0 1234 && echo "Running" || echo "Dead"
```

#### Kill by Process Name

```bash
# Kill all processes with name
pkill processname
pkill httpd                         # Kill all Apache processes

# Kill with signal
pkill -9 nginx                      # Force kill all nginx
pkill -TERM mysql                   # Graceful shutdown

# Kill by pattern
pgrep -f "pattern"                  # Find PIDs matching pattern
pkill -f "pattern"                  # Kill matching processes

# Kill with confirmation
pkill -i chrome                     # Case-insensitive
```

#### Kill Process Group

```bash
# Kill entire process group
kill -- -12345                      # Kill group 12345

# Kill processes by user
killall -u username                # Kill all processes by user
killall -u www-data                # Kill all Apache processes

# Kill by terminal
killall -t pts/1
# Kill all processes on terminal pts/1
```

### Safe Process Termination

```bash
# 1. First attempt: Graceful shutdown (SIGTERM)
kill -TERM 1234
sleep 2                             # Wait for graceful shutdown

# 2. Check if process died
ps -p 1234 && echo "Still running" || echo "Killed"

# 3. If still running: Force kill (SIGKILL)
kill -KILL 1234

# Safer alternative (single command)
kill -TERM 1234 || kill -KILL 1234

# For process name
pkill -TERM processname
sleep 1
pgrep processname && pkill -KILL processname
```

### Practical Scenarios

```bash
# 1. Runaway process consuming 100% CPU
ps aux --sort=-%cpu | head -2       # Find process
kill -9 PID                         # Force kill

# 2. Memory leak - process growing
ps aux --sort=-%mem | head -2       # Check memory
kill -TERM PID                      # Graceful
kill -9 PID                         # If needed

# 3. Database hung
pkill -TERM mysqld                  # Try graceful
ps aux | grep mysql                # Check
pkill -9 mysqld                     # Force if needed

# 4. Web server stuck
systemctl restart apache2           # Cleaner way
# Or:
pkill -TERM httpd
pkill -KILL httpd
systemctl restart httpd
```

---

## Adjust Process Scheduling

### Process Priority with `nice` and `renice`

#### Understanding Nice Values

```
Nice value range: -20 (highest priority) to +19 (lowest priority)
Default: 0
- Negative = higher priority (gets more CPU time)
- Positive = lower priority (gets less CPU time)
- Root can set any value
- Regular users can only increase (make less favored)
```

#### Starting Process with Nice

```bash
# Start process with specific nice value
nice -n 10 long_running_command     # Priority +10 (lower priority)

# Very low priority (useful for background tasks)
nice -n 19 backup_script.sh         # Lowest priority

# High priority (root only)
sudo nice -n -10 critical_task      # Higher priority

# Default nice (no priority change)
nice command                        # Same as nice -n 0

# View default nice value
nice                                # Shows 0
```

#### Changing Priority with `renice`

```bash
# Change priority of running process
renice -n 10 -p 1234                # Increase nice of PID 1234
renice -n -5 -p 1234                # Decrease nice (higher priority, root only)

# Change priority for all processes by user
renice -n 5 -u username

# Change priority for all processes in group
renice -n 5 -g groupname

# View current nice value
ps -o pid,user,nice,cmd | head

# Examples
renice -n 15 -p 5678                # Background task
sudo renice -n -5 -p 1234           # Boost priority
renice -n 10 -u www-data            # Lower priority for web server

# Check if renice succeeded
ps -p 1234 -o pid,nice,cmd
```

### CPU Affinity - Bind Process to CPU

```bash
# Show available CPUs
nproc                               # Number of CPUs
cat /proc/cpuinfo | grep processor   # CPU details

# Run process on specific CPU core
taskset -c 0 command                # Use CPU 0 only
taskset -c 0,1 command              # Use CPUs 0 and 1
taskset -c 0-3 command              # Use CPUs 0 through 3

# Change affinity of running process
taskset -cp 0 1234                  # Bind PID 1234 to CPU 0
taskset -cp 0,1 1234                # Bind to CPUs 0 and 1

# View current CPU affinity
taskset -cp 1234                    # Show CPU affinity of PID
ps -eo pid,psr,cmd | head           # PSR column shows CPU

# Practical example: Run CPU-intensive task on specific core
taskset -c 2 python process.py      # Use only CPU core 2
```

### I/O Scheduling Priority

```bash
# View current I/O scheduler
cat /sys/block/sda/queue/scheduler
# Output: [noop] deadline cfq

# Ionice - set I/O priority and class
ionice -c 1 -n 0 command            # Realtime, highest priority
ionice -c 2 -n 7 command            # Best-effort, lower priority
ionice -c 3 command                 # Idle - only when system idle

# Change I/O priority of running process
ionice -c 2 -n 5 -p 1234            # Best-effort class, priority 5

# View current I/O class
ionice -p 1234
```

### Cgroups - Control Groups

Cgroups limit resource usage by process groups.

```bash
# View cgroups
cat /proc/1234/cgroup               # Show cgroups for PID

# List available cgroups
ls -la /sys/fs/cgroup/

# CPU limitation (systemd manages this)
# Use systemctl commands

# Memory limiting
# For services: /etc/systemd/system/service.conf
# [Service]
# MemoryLimit=512M

# CPU shares
# [Service]
# CPUShares=1024
```

### Practical Priority Scenarios

```bash
# 1. Lower priority for background backup
nice -n 15 tar -czf backup.tar.gz /data

# 2. Boost web server priority
sudo renice -n -5 -u www-data

# 3. Prevent runaway from using CPU 0
taskset -c 1-3 runaway_process

# 4. Idle I/O for maintenance
ionice -c 3 -n 0 maintenance_job.sh

# 5. Real-time priority for critical task
nice -n -19 critical_calculation
```

---

## Manage Tuning Profiles

### tuned Daemon

Tuned automatically optimizes system performance based on workload.

#### Installation and Status

```bash
# Check if tuned is installed
rpm -q tuned
systemctl status tuned

# Install tuned
sudo yum install tuned

# Enable and start tuned
sudo systemctl enable tuned
sudo systemctl start tuned
sudo systemctl status tuned
```

#### Available Profiles

```bash
# List available profiles
tuned-adm list
# Output shows available profiles with description

# Common profiles:
# balanced       - Default, balance performance/power
# powersave      - Minimize energy consumption
# performance    - Maximum performance
# latency-performance - Low latency for gaming/audio
# throughput-performance - Optimize throughput
# virtual-guest  - VM optimization
# virtual-host   - Host system for VMs
# desktop        - Desktop optimization
# server-profile - Server optimization
```

#### Checking Current Profile

```bash
# Show current profile
tuned-adm active
# Output: Current active profile: balanced

# Show profile details
tuned-adm profile_info balanced

# Show profile recommendations
tuned-adm recommend
```

#### Switching Profiles

```bash
# Switch to different profile
sudo tuned-adm profile performance
# Activates performance profile

# Switch to power-saving
sudo tuned-adm profile powersave

# Switch to virtual-guest
sudo tuned-adm profile virtual-guest

# Verify change
tuned-adm active
```

#### Custom Profiles

```bash
# Profile location
ls -la /usr/lib/tuned/

# Create custom profile
sudo mkdir -p /etc/tuned/my-profile
sudo cat > /etc/tuned/my-profile/tuned.conf << 'EOF'
[main]
summary = My Custom Profile
include = balanced

[cpu]
governor = performance
scaling_min_freq = 800000

[sysctl]
kernel.sched_migration_cost_ns = 5000000
EOF

# Apply custom profile
sudo tuned-adm profile my-profile
tuned-adm active
```

#### Tuned Configuration

```bash
# Main config file
sudo cat /etc/tuned/tuned-main.conf

# View active profile config
tuned-adm profile_info
cat /etc/tuned/active_profile/tuned.conf

# Disable tuned temporarily
sudo tuned-adm off
# Profile deactivated but tuned service still running

# Enable tuned again
sudo tuned-adm profile balanced
```

### Performance Monitoring with tuned

```bash
# Monitor tuned status
systemctl status tuned

# Show active profile info
tuned-adm active
tuned-adm profile_info

# Check CPU governor (if using performance profile)
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

# Show frequency scaling info
cat /proc/cpuinfo | grep "model name"
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq

# View power settings in performance profile
tuned-adm profile_info performance
```

### Practical Tuning Scenarios

```bash
# 1. Server with high throughput needs
sudo tuned-adm profile throughput-performance

# 2. Desktop user wants power saving
sudo tuned-adm profile powersave

# 3. Gaming/audio workstation
sudo tuned-adm profile latency-performance

# 4. Virtual machine running on host
sudo tuned-adm profile virtual-guest

# 5. Database server (custom optimization)
sudo tuned-adm profile my-database-profile
```

---

## Locate and Interpret System Logs

### System Log Locations

```bash
# Main system logs
/var/log/messages                   # General system log (RHEL)
/var/log/syslog                     # General system log (Debian)
/var/log/audit/audit.log            # Audit logs
/var/log/auth.log                   # Authentication logs
/var/log/secure                     # Secure authentication (RHEL)
/var/log/boot.log                   # Boot messages
/var/log/cron                       # Cron job logs
/var/log/maillog                    # Mail server logs
/var/log/kernel                     # Kernel messages
/var/log/yum.log                    # Package manager logs (RHEL)
/var/log/apt/                       # Package manager logs (Debian)

# Application logs
/var/log/apache2/                   # Apache web server
/var/log/httpd/                     # Apache (RHEL)
/var/log/nginx/                     # Nginx web server
/var/log/mysql/                     # MySQL database
/var/log/postgresql/                # PostgreSQL database
/var/log/samba/                     # Samba file sharing
/var/log/cups/                      # Printer logs

# System services
/var/log/systemd/                   # systemd logs
/var/log/upstart/                   # Upstart logs (older systems)
```

### Viewing Log Files

#### Basic Viewing

```bash
# View entire log (usually very long)
cat /var/log/messages
less /var/log/messages              # Page through
more /var/log/messages

# View last 20 lines
tail -20 /var/log/messages

# View first 10 lines
head -10 /var/log/messages

# View in real-time (follow)
tail -f /var/log/messages           # Ctrl+C to exit
tail -f /var/log/auth.log

# View multiple lines of context
tail -n 50 /var/log/messages        # Last 50 lines
head -n 30 /var/log/messages        # First 30 lines

# View and follow specific service
tail -f /var/log/httpd/error_log
```

#### Searching Logs

```bash
# Search for specific text
grep "error" /var/log/messages
grep "ERROR" /var/log/messages

# Case-insensitive search
grep -i "error" /var/log/messages

# Count occurrences
grep -c "error" /var/log/messages

# Show line numbers
grep -n "error" /var/log/messages

# Show lines NOT containing pattern
grep -v "informational" /var/log/messages

# Search multiple files
grep "error" /var/log/messages /var/log/secure

# Recent errors with timestamp
grep "error" /var/log/messages | tail -20

# Authentication failures
grep "Failed password" /var/log/auth.log
grep "authentication failure" /var/log/secure

# Kernel errors
grep "kernel" /var/log/messages | grep -i error
```

#### Filtering and Parsing Logs

```bash
# Parse specific fields
awk '{print $1, $2, $3, $NF}' /var/log/messages
# Show date, time, hostname, message

# Count log entries by hour
grep "2024-01-15 14:" /var/log/messages | wc -l

# Show unique error messages
grep "error" /var/log/messages | cut -d' ' -f5- | sort | uniq

# Find most common errors
grep "error" /var/log/messages | awk '{print $(NF-1), $NF}' | sort | uniq -c | sort -rn

# Extract IP addresses
grep "connection from" /var/log/auth.log | grep -o "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}" | sort | uniq -c
```

### Log Rotation with logrotate

```bash
# View logrotate configuration
cat /etc/logrotate.conf

# Specific application configs
ls -la /etc/logrotate.d/
cat /etc/logrotate.d/httpd
cat /etc/logrotate.d/syslog

# Example logrotate config
/var/log/httpd/*log {
    daily                           # Rotate daily
    rotate 7                        # Keep 7 rotated files
    compress                        # Compress old logs
    delaycompress                   # Delay compression
    notifempty                      # Don't rotate if empty
    create 0640 root root           # Create with these permissions
    sharedscripts                   # Run scripts once
    postrotate                      # Script after rotation
        systemctl reload httpd
    endscript
}

# Manually rotate logs
sudo logrotate -f /etc/logrotate.conf

# Test logrotate (dry run)
sudo logrotate -d /etc/logrotate.conf

# Rotate specific application
sudo logrotate -f /etc/logrotate.d/httpd
```

### Log Analysis Tools

```bash
# Show authentication attempts
sudo tail -f /var/log/auth.log | grep -i "password"

# Monitor system errors
tail -f /var/log/messages | grep -i "error"

# Watch boot sequence
tail -f /var/log/boot.log

# Monitor kernel messages
tail -f /var/log/kernel

# Failed login attempts
grep "Failed password" /var/log/auth.log | wc -l

# Successful logins
grep "session opened" /var/log/auth.log

# Sudo usage
grep "sudo:" /var/log/auth.log

# User login history
grep "sshd.*session opened" /var/log/auth.log
```

---

## Preserve System Journals

### Journalctl and systemd Journal

#### Viewing Journal

```bash
# View entire journal
journalctl
# Paged view (press 'q' to quit, Space for next page)

# View recent entries
journalctl -n 20                    # Last 20 entries
journalctl --lines=50               # Last 50 entries

# Follow journal (real-time)
journalctl -f                       # Press Ctrl+C to exit
journalctl -f -n 10                 # Last 10, then follow

# View specific time range
journalctl --since "2 hours ago"
journalctl --since "2024-01-15 10:00:00"
journalctl --since "2024-01-15" --until "2024-01-16"
journalctl --since today

# View by priority
journalctl -p err                   # Error and higher
journalctl -p warn                  # Warning and higher
journalctl -p info                  # Info and higher
journalctl -p debug                 # Debug and higher

# Priorities: emerg, alert, crit, err, warning, notice, info, debug
```

#### Filtering Journal

```bash
# By unit (service)
journalctl -u httpd
journalctl -u httpd -n 20
journalctl -u httpd --since "1 hour ago"

# By executable
journalctl /usr/sbin/httpd

# By process ID
journalctl _PID=1234

# By user
journalctl _UID=1000

# By hostname
journalctl -h hostname

# Multiple units
journalctl -u httpd -u nginx

# Reverse order (newest first, default is oldest first)
journalctl --reverse
```

#### Journal Output Formats

```bash
# Short format (default)
journalctl -n 5
# Shows: date time hostname process: message

# Verbose format
journalctl -n 5 -o verbose
# Shows all journal fields

# JSON format (machine readable)
journalctl -n 5 -o json

# JSON pretty format
journalctl -n 5 -o json-pretty

# Short-iso format
journalctl -n 5 -o short-iso
# ISO 8601 timestamp format

# Cat format (just messages)
journalctl -n 5 -o cat
```

#### Searching Specific Services

```bash
# Apache errors
journalctl -u httpd -p err
journalctl -u apache2 --since "30 minutes ago"

# SSH login attempts
journalctl -u sshd | grep "password"

# Failed logins
journalctl SYSLOG_IDENTIFIER=sshd | grep "Failed"

# System startup
journalctl -b                       # Current boot
journalctl -b -1                    # Previous boot
journalctl -b -p err                # Errors this boot

# Boot messages
journalctl -b 0 -p notice
```

### Persistent Journal Storage

By default, journal is stored in `/run/log/journal/` (temporary, cleared on reboot).

#### Enable Persistent Storage

```bash
# Create persistent journal directory
sudo mkdir -p /var/log/journal

# Set proper permissions
sudo chmod 2755 /var/log/journal

# Restart systemd-journald
sudo systemctl restart systemd-journald

# Verify journal is persistent
ls -la /var/log/journal/
journalctl --disk-usage

# Journal will now survive reboot
```

#### Journal Configuration

```bash
# Journal configuration file
sudo cat /etc/systemd/journald.conf

# Edit configuration
sudo vi /etc/systemd/journald.conf

# Important settings:
# [Journal]
# Storage=persistent              # Enable persistent storage
# Compress=yes                    # Compress old journals
# Seal=yes                        # Enable FSS for tamper protection
# RateLimitBurst=10000           # Max entries per interval
# RateLimitIntervalSec=30s        # Rate limit interval
# MaxRetentionSec=30day           # Keep journals for 30 days
# SystemMaxFileSize=100M          # Max size per journal file
# SystemMaxUse=1G                 # Total journal size limit

# Reload configuration
sudo systemctl restart systemd-journald
```

### Journal Maintenance

```bash
# Show disk usage
journalctl --disk-usage
# Output: Archived and active journals take up 250.0M

# Vacuum journal size
journalctl --vacuum-size=100M       # Limit to 100MB
journalctl --vacuum-time=30d        # Keep 30 days
journalctl --vacuum-files=10        # Keep 10 journal files

# Mark journal as sealed (tamper-proof)
journalctl --setup-keys
# Generates FSS (Forward Secure Sealing) keys

# Verify journal integrity
journalctl --verify

# Rotate journal
sudo systemctl rotate-journals
```

### Exporting Journal

```bash
# Export to text file
journalctl > journal_export.txt

# Export specific range
journalctl --since "2024-01-15" --until "2024-01-16" > daily_journal.txt

# Export in JSON format
journalctl -o json > journal.json

# Export specific service
journalctl -u httpd > httpd_journal.txt
```

### Practical Journal Usage

```bash
# 1. Troubleshoot failed service
systemctl status httpd              # Shows brief error
journalctl -u httpd -n 30          # Show recent journal entries
journalctl -u httpd -p err         # Show errors only

# 2. Check failed SSH logins
journalctl -u sshd | grep "Failed password"
journalctl -u sshd --since "1 hour ago"

# 3. Investigate boot failure
journalctl -b -1                   # Previous boot messages
journalctl -b -1 -p err            # Errors from previous boot

# 4. Monitor system in real-time
journalctl -f                      # Follow journal

# 5. Export logs for analysis
journalctl --since "1 week ago" -o json > weekly_logs.json

# 6. Check resource usage
journalctl --vacuum-size=500M      # Limit journal size
journalctl --disk-usage            # Show current size
```

---

## Manage Network Services

### Service Management with systemctl

#### Starting and Stopping Services

```bash
# Start a service
sudo systemctl start httpd

# Stop a service
sudo systemctl stop httpd

# Restart a service
sudo systemctl restart httpd
# Stops then starts (new config reload required)

# Reload service (reload config without stopping)
sudo systemctl reload httpd
# Service continues running, config reloaded

# Conditional restart (restart if running)
sudo systemctl condrestart httpd

# Soft reboot of service
sudo systemctl try-restart httpd
```

#### Checking Service Status

```bash
# Check if service is running
sudo systemctl status httpd
# Shows: active (running), enabled, recent logs

# Check if enabled
sudo systemctl is-enabled httpd
# Output: enabled or disabled

# Check if running
sudo systemctl is-active httpd
# Output: active or inactive

# Check if failed
sudo systemctl is-failed httpd
# Output: active (running) or failed
```

#### Enabling and Disabling Services

```bash
# Enable service (start on boot)
sudo systemctl enable httpd

# Disable service (don't start on boot)
sudo systemctl disable httpd

# Check if enabled
sudo systemctl is-enabled httpd

# Enable and start in one command
sudo systemctl enable --now httpd

# Disable and stop in one command
sudo systemctl disable --now httpd

# View enabled services
systemctl list-unit-files --type=service --state=enabled

# View disabled services
systemctl list-unit-files --type=service --state=disabled
```

#### Service Dependencies

```bash
# Show dependencies
systemctl list-dependencies httpd
# What does httpd need to start?

# Show reverse dependencies
systemctl list-dependencies --reverse httpd
# What services depend on httpd?

# Requisites (hard dependencies)
systemctl list-dependencies --all httpd

# Show conflicts
systemctl list-dependencies --conflicts httpd
```

### Common Network Services

```bash
# Web server
sudo systemctl start httpd
sudo systemctl start nginx

# SSH server
sudo systemctl start sshd
sudo systemctl status sshd

# FTP server
sudo systemctl start vsftpd
sudo systemctl stop vsftpd

# DNS service
sudo systemctl start bind
sudo systemctl status named

# Mail server
sudo systemctl start postfix
sudo systemctl status postfix

# Database
sudo systemctl start mysqld
sudo systemctl status mysql

# NFS server
sudo systemctl start nfs-server
sudo systemctl status nfs

# Samba (file sharing)
sudo systemctl start smb
sudo systemctl start nmb

# Network Manager
sudo systemctl status NetworkManager
```

### Service Unit Files

```bash
# Unit file location
/usr/lib/systemd/system/              # System services
/etc/systemd/system/                  # Custom/overrides

# Example unit file location
ls /usr/lib/systemd/system/httpd.service
cat /usr/lib/systemd/system/httpd.service

# Create custom unit file
sudo cat > /etc/systemd/system/myservice.service << 'EOF'
[Unit]
Description=My Custom Service
After=network.target

[Service]
Type=simple
User=myuser
ExecStart=/usr/local/bin/myservice
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Load new unit file
sudo systemctl daemon-reload

# Enable and start custom service
sudo systemctl enable --now myservice
```

### Masking and Unmasking Services

```bash
# Mask a service (prevent any startup)
sudo systemctl mask httpd
# Service cannot be started even by dependencies

# Unmask a service
sudo systemctl unmask httpd
# Service can be started normally

# Check if masked
systemctl is-enabled httpd
# Output: masked or enabled

# Show masked services
systemctl list-unit-files | grep masked
```

### Port Management for Services

```bash
# Check if port is listening
sudo netstat -tlnp | grep :80
sudo ss -tlnp | grep :80

# Service listening on port 80
sudo lsof -i :80

# SSH on standard port 22
sudo ss -tlnp | grep sshd

# Find service by port
sudo ss -tlnp | grep :3306          # MySQL port 3306
```

### Firewall Integration with Services

```bash
# Allow service through firewall
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --permanent --add-service=ssh

# Allow port through firewall
sudo firewall-cmd --permanent --add-port=8080/tcp

# Reload firewall
sudo firewall-cmd --reload

# Check service firewall rules
sudo firewall-cmd --list-services
sudo firewall-cmd --list-ports
```

### Practical Service Management

```bash
# 1. Start web server for development
sudo systemctl start httpd
sudo systemctl status httpd

# 2. Restart service after config change
sudo vi /etc/httpd/conf/httpd.conf
sudo systemctl restart httpd

# 3. Reload only (no service restart)
# After minor config change:
sudo systemctl reload httpd

# 4. Enable service on boot
sudo systemctl enable httpd

# 5. Disable service temporarily
sudo systemctl disable httpd
sudo systemctl stop httpd

# 6. Check SSH is running and enabled
sudo systemctl is-active sshd       # active
sudo systemctl is-enabled sshd      # enabled

# 7. Restart database
sudo systemctl restart mysql
sudo systemctl status mysql
```

---

## Securely Transfer Files Between Systems

### SSH-based File Transfer

#### SCP - Secure Copy Protocol

```bash
# Copy file to remote system
scp localfile user@host:/remote/path/
scp myfile.txt admin@192.168.1.100:/tmp/

# Copy file from remote system
scp user@host:/remote/file.txt ./local/path/
scp admin@server.com:/etc/hosts ./

# Copy directory (recursive)
scp -r /local/directory user@host:/remote/path/
scp -r ~/documents admin@server.com:/home/admin/

# Specify SSH port
scp -P 2222 file.txt user@host:/path/
# Note: capital -P (not lowercase)

# Preserve file attributes
scp -p file.txt user@host:/path/
# Preserves permissions, timestamps

# Verbose output
scp -v file.txt user@host:/path/

# Specify SSH key
scp -i ~/.ssh/mykey.pem file.txt user@host:/path/

# Copy between two remote systems
scp -3 user1@host1:/path/file user2@host2:/path/
# -3: routes through local machine
```

#### SFTP - Secure File Transfer Protocol

```bash
# Start SFTP session
sftp user@host
sftp -P 2222 user@host              # Non-standard port

# SFTP commands (inside sftp session)
ls                                  # List remote files
lls                                 # List local files
pwd                                 # Remote working directory
lpwd                                # Local working directory
cd /path                            # Change remote directory
lcd /path                           # Change local directory

# Upload files
put localfile                       # Upload one file
mput *.txt                          # Upload multiple
put -r localdir                     # Upload directory

# Download files
get remotefile                      # Download one file
mget *.txt                          # Download multiple
get -r remotedir                    # Download directory

# File operations
mkdir newdir                        # Create remote directory
rename oldname newname              # Rename remote file
rm file.txt                         # Delete remote file
chmod 755 file.txt                  # Change permissions

# Exit SFTP
exit
bye
quit
```

#### RSYNC - Synchronization

```bash
# Copy with synchronization
rsync -av source/ destination/
# -a: archive mode
# -v: verbose

# Copy to remote
rsync -av /local/path/ user@host:/remote/path/

# Copy from remote
rsync -av user@host:/remote/path/ /local/path/

# Exclude files
rsync -av --exclude='*.log' /source/ /dest/

# Dry run (test before actual copy)
rsync -avn /source/ /dest/

# Delete files not in source
rsync -av --delete /source/ /dest/

# Preserve hard links
rsync -av -H /source/ /dest/

# Compression
rsync -avz /source/ user@host:/dest/

# Bandwidth limit
rsync -av --bwlimit=1000 /source/ /dest/
# Limit to 1000 KB/s
```

### SSH Public Key for Passwordless Transfer

```bash
# Generate SSH key (if not already done)
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa

# Copy public key to remote
ssh-copy-id -i ~/.ssh/id_rsa.pub user@host

# Now SCP works without password
scp file.txt user@host:/path/

# For SFTP
sftp user@host
# No password required
```

### Secure Transfer Scenarios

```bash
# 1. Backup important file to server
scp -p config.conf admin@backup-server:/backups/

# 2. Retrieve log file for analysis
scp user@production:/var/log/app.log ./

# 3. Synchronize project directory
rsync -avz --delete ~/project/ user@deployment:/var/app/

# 4. Copy multiple files efficiently
scp file1.txt file2.txt user@host:/path/

# 5. Interactive file transfer
sftp user@host
# Use SFTP commands

# 6. Batch file transfer
for file in *.log; do
    scp "$file" user@host:/var/log/
done

# 7. Copy preserving permissions
scp -p * user@host:/backup/
```

### Troubleshooting File Transfer

```bash
# Check SSH connectivity
ssh -v user@host
# Verbose output shows connection process

# Verify SSH key
ssh -vv user@host 2>&1 | grep -i key

# Check remote path permissions
ssh user@host ls -la /remote/path/

# Test SCP with verbose
scp -v file.txt user@host:/path/

# Check file permissions after transfer
ssh user@host ls -la /path/file.txt

# Verify SSH port
ssh -p 2222 -v user@host

# Use specific key
scp -i ~/.ssh/special_key file.txt user@host:/path/
```

---

## Lab Exercises & Practice

### Exercise 1: Boot, Reboot, and Shutdown

#### Objectives
- Practice system shutdown and reboot
- Schedule shutdown
- Use boot parameters

#### Tasks

```bash
# 1.1 - Check current system state
uptime                              # Show uptime
systemctl get-default               # Current target
who -b                              # Last boot time

# 1.2 - Schedule shutdown (don't actually do it!)
sudo shutdown -h +10 "System will shutdown in 10 minutes"
# Check status: shutdown --show
# Cancel: sudo shutdown -c

# 1.3 - Verify reboot safety
ps aux | head -5                    # Check processes
journalctl -b | head -10            # Check boot messages

# 1.4 - Perform graceful reboot
# In TEST environment only:
sudo shutdown -r +2 "System rebooting for maintenance"
# Or: sudo reboot
```

---

### Exercise 2: Target and Runlevel Management

#### Objectives
- Switch between targets
- Set default boot target
- Understand target dependencies

#### Tasks

```bash
# 2.1 - View available targets
systemctl list-units --type=target --all
tuned-adm list                      # Different concept but useful

# 2.2 - Check current target
systemctl get-default
systemctl status graphical.target

# 2.3 - Set default target
# Change to multi-user (CLI only)
sudo systemctl set-default multi-user.target

# Verify change
systemctl get-default
# Reboot to apply: sudo reboot

# 2.4 - Switch target temporarily (no reboot)
sudo systemctl isolate multi-user.target
# GUI stops, system goes to CLI
# Switch back:
sudo systemctl isolate graphical.target

# 2.5 - Show target dependencies
systemctl list-dependencies graphical.target
```

---

### Exercise 3: Process Management

#### Objectives
- Monitor CPU and memory usage
- Identify intensive processes
- Adjust process priority
- Kill processes

#### Tasks

```bash
# 3.1 - Monitor processes
ps aux | head -10
ps aux --sort=-%cpu | head -5       # Top CPU users
ps aux --sort=-%mem | head -5       # Top memory users

# 3.2 - Real-time monitoring
top
# Press P (CPU), M (memory), q (quit)

# 3.3 - Start process with nice
nice -n 15 sleep 300 &              # Start background task with low priority

# 3.4 - Check nice value
ps -o pid,nice,cmd | grep sleep

# 3.5 - Adjust priority
# Find the PID from step 3.3
renice -n 5 -p <PID>                # Change priority

# 3.6 - Kill process
kill <PID>                          # Graceful
kill -9 <PID>                       # Force
ps -p <PID> && echo "Running" || echo "Killed"
```

---

### Exercise 4: Service Management

#### Objectives
- Start, stop, enable services
- Check service status
- Understand service dependencies

#### Tasks

```bash
# 4.1 - Check SSH service
sudo systemctl status sshd
sudo systemctl is-active sshd
sudo systemctl is-enabled sshd

# 4.2 - Stop and start service
sudo systemctl stop sshd
sudo systemctl status sshd
# Can't SSH now!

# 4.3 - Start service again
sudo systemctl start sshd
sudo systemctl status sshd

# 4.4 - Enable/disable on boot
sudo systemctl enable httpd         # Start on boot
sudo systemctl disable httpd        # Don't start on boot
systemctl is-enabled httpd

# 4.5 - Service dependencies
systemctl list-dependencies sshd
systemctl list-dependencies --reverse sshd
```

---

### Exercise 5: System Logs and Journalctl

#### Objectives
- View and filter journal logs
- Search for specific events
- Enable persistent journal storage

#### Tasks

```bash
# 5.1 - View journal
journalctl -n 20                    # Last 20 entries
journalctl -f                       # Follow in real-time (Ctrl+C to exit)

# 5.2 - Filter by service
journalctl -u sshd -n 10
journalctl -u httpd --since "1 hour ago"

# 5.3 - Filter by priority
journalctl -p err                   # Error messages only
journalctl -p warning               # Warning and above

# 5.4 - Check boot messages
journalctl -b                       # Current boot
journalctl -b -1                    # Previous boot

# 5.5 - Enable persistent journal
sudo mkdir -p /var/log/journal
sudo chmod 2755 /var/log/journal
sudo systemctl restart systemd-journald

# Verify:
journalctl --disk-usage
ls /var/log/journal/

# 5.6 - Search for events
journalctl | grep "failed"
journalctl -u sshd | grep "Failed password"
```

---

### Exercise 6: Tuning Profiles

#### Objectives
- View available profiles
- Switch profiles
- Understand performance impact

#### Tasks

```bash
# 6.1 - Check tuned status
sudo systemctl status tuned
tuned-adm active

# 6.2 - List available profiles
tuned-adm list

# 6.3 - Get profile information
tuned-adm profile_info balanced
tuned-adm profile_info performance

# 6.4 - Switch profiles
sudo tuned-adm profile performance
tuned-adm active                    # Verify change

# 6.5 - Monitor CPU frequency
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

# 6.6 - Switch back to balanced
sudo tuned-adm profile balanced
tuned-adm active
```

---

### Exercise 7: Secure File Transfer

#### Objectives
- Transfer files with SCP
- Use RSYNC for synchronization
- Verify file integrity

#### Tasks

```bash
# 7.1 - Setup (if not already done)
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa
ssh-copy-id -i ~/.ssh/id_rsa.pub user@remote-host

# 7.2 - Copy file via SCP (adjust hostname)
scp localfile.txt user@remote-host:/tmp/
# Verify: ssh user@remote-host ls -la /tmp/localfile.txt

# 7.3 - Copy directory
mkdir test_dir
touch test_dir/file1.txt test_dir/file2.txt
scp -r test_dir user@remote-host:/tmp/

# 7.4 - Copy FROM remote
# Create file on remote first
ssh user@remote-host touch /tmp/remote_file.txt
scp user@remote-host:/tmp/remote_file.txt ./

# 7.5 - Synchronize directories
mkdir source dest
touch source/file1.txt source/file2.txt
rsync -av source/ dest/
ls -la dest/

# 7.6 - RSYNC with exclusions
rsync -av --exclude='*.log' /source/ /dest/
```

---

## Summary & Key Commands

### Essential Commands

```bash
# Shutdown/Reboot
shutdown -h now
shutdown -r +5 "message"
systemctl reboot
systemctl poweroff

# Targets
systemctl get-default
systemctl set-default multi-user.target
systemctl isolate graphical.target

# Processes
ps aux
top
kill -9 PID
pkill processname
nice -n 10 command
renice -n 5 -p PID

# Services
systemctl start service
systemctl enable service
systemctl status service
systemctl restart service

# Logs
journalctl
journalctl -u service -n 20
journalctl -f
journalctl --since "1 hour ago"

# File Transfer
scp file user@host:/path/
rsync -av /source/ /dest/
sftp user@host

# Tuning
tuned-adm list
sudo tuned-adm profile performance
tuned-adm active
```

---

## Exam Tips

1. **Know targets**: Memorize graphical.target and multi-user.target
2. **Service management**: Practice systemctl commands
3. **Journal queries**: Learn filtering options
4. **Process priorities**: Understand nice and renice
5. **Secure transfer**: SCP is simpler than RSYNC for exam
6. **Boot interruption**: Practice rd.break and rd.recovery
7. **Log locations**: Know /var/log/ structure
8. **Shutdown scenarios**: Practice graceful vs forced shutdown

---

## Next Steps

1. Complete all exercises in test environment
2. Practice each command 3+ times
3. Understand error messages
4. Create your own scenarios
5. Test in real system (if possible)
6. Review weak areas daily
7. Combine topics in integration labs

---

**Good luck with Module 2! Move to Module 3 when confident.**

---

*End of Module 2: Operate Running Systems*
